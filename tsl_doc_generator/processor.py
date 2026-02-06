"""
TSL Script Processor - 6-Pass Analysis Pipeline
With rate limiting, checkpoint/resume, and error handling
Supports concurrent processing of multiple scripts
"""
import json
import re
import time
import threading
from pathlib import Path
from typing import Optional, Dict, Any, List
from dataclasses import dataclass, field, asdict
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor, as_completed

from config import (
    TSL_DIR, PASS_RESULTS_DIR, DOCS_DIR,
    SAVE_INTERVAL, LOG_FILE, CHECKPOINT_FILE,
    REQUEST_DELAY, RATE_LIMIT_WAIT, CONCURRENT_SCRIPTS,
    MAX_CODE_CHARS, MAX_CODE_CHARS_UNCOMPRESSED, CHUNK_THRESHOLD,
    ENABLE_COMPRESSION, COMPRESSION_AGGRESSIVE,
    MAX_OUTPUT_TOKENS, MAX_OUTPUT_TOKENS_FINAL
)
from glm_client import GLMClient, GLMResponse
from prompts import SYSTEM_PROMPT, format_prompt
from compressor import TSLCompressor, CompressionStats
from chunker import TSLChunker, ChunkingResult


@dataclass
class PassResult:
    """Result from a single analysis pass"""
    pass_number: int
    success: bool
    data: Dict[str, Any]
    tokens_used: int
    error: Optional[str] = None
    reasoning: Optional[str] = None


@dataclass
class ScriptAnalysis:
    """Complete analysis results for a TSL script"""
    filename: str
    filepath: str
    passes: Dict[int, PassResult] = field(default_factory=dict)
    final_doc: str = ""
    total_tokens: int = 0
    processing_time: float = 0
    status: str = "pending"
    error: Optional[str] = None
    compression_stats: Optional[Dict[str, Any]] = None
    chunking_info: Optional[Dict[str, Any]] = None


@dataclass
class Checkpoint:
    """Checkpoint for resume functionality"""
    last_processed_index: int = -1
    completed_scripts: List[str] = field(default_factory=list)
    failed_scripts: List[str] = field(default_factory=list)
    total_tokens_used: int = 0
    total_requests: int = 0
    last_update: str = ""

    def to_dict(self) -> dict:
        return {
            "last_processed_index": self.last_processed_index,
            "completed_scripts": self.completed_scripts,
            "failed_scripts": self.failed_scripts,
            "total_tokens_used": self.total_tokens_used,
            "total_requests": self.total_requests,
            "last_update": self.last_update
        }

    @classmethod
    def from_dict(cls, data: dict) -> "Checkpoint":
        return cls(
            last_processed_index=data.get("last_processed_index", -1),
            completed_scripts=data.get("completed_scripts", []),
            failed_scripts=data.get("failed_scripts", []),
            total_tokens_used=data.get("total_tokens_used", 0),
            total_requests=data.get("total_requests", 0),
            last_update=data.get("last_update", "")
        )


class TSLProcessor:
    """Process TSL scripts through 6-pass analysis"""

    def __init__(self, concurrent_scripts: int = CONCURRENT_SCRIPTS):
        self.concurrent_scripts = concurrent_scripts
        self.results: Dict[str, ScriptAnalysis] = {}
        self.checkpoint = Checkpoint()
        self.log_file = open(LOG_FILE, "a", encoding="utf-8", errors="replace")
        self.rate_limited = False
        self.rate_limit_until = 0

        # Thread-local storage for GLM clients
        self._thread_local = threading.local()
        # Lock for thread-safe operations
        self._lock = threading.Lock()
        self._checkpoint_lock = threading.Lock()

        # Initialize compressor and chunker
        self.compressor = TSLCompressor(aggressive=COMPRESSION_AGGRESSIVE)
        self.chunker = TSLChunker(max_chunk_size=MAX_CODE_CHARS)

        # Load existing checkpoint if available
        self._load_checkpoint()

    def _get_client(self) -> GLMClient:
        """Get thread-local GLM client"""
        if not hasattr(self._thread_local, 'client'):
            self._thread_local.client = GLMClient()
        return self._thread_local.client

    def _load_checkpoint(self):
        """Load checkpoint from file if exists"""
        if CHECKPOINT_FILE.exists():
            try:
                with open(CHECKPOINT_FILE, "r", encoding="utf-8") as f:
                    data = json.load(f)
                    self.checkpoint = Checkpoint.from_dict(data)
                    self.log(f"Loaded checkpoint: {len(self.checkpoint.completed_scripts)} completed, {len(self.checkpoint.failed_scripts)} failed")
            except Exception as e:
                self.log(f"Warning: Could not load checkpoint: {e}")

    def _save_checkpoint(self):
        """Save current checkpoint to file (thread-safe)"""
        with self._checkpoint_lock:
            try:
                self.checkpoint.last_update = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                # Aggregate tokens from checkpoint (updated per script)
                with open(CHECKPOINT_FILE, "w", encoding="utf-8") as f:
                    json.dump(self.checkpoint.to_dict(), f, indent=2, ensure_ascii=False)
            except Exception as e:
                self.log(f"Warning: Could not save checkpoint: {e}")

    def log(self, message: str):
        """Log message to file and console (thread-safe)"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_line = f"[{timestamp}] {message}"
        with self._lock:
            try:
                print(log_line)
            except UnicodeEncodeError:
                print(log_line.encode('ascii', 'replace').decode('ascii'))
            self.log_file.write(log_line + "\n")
            self.log_file.flush()

    def read_script(self, filepath: Path) -> str:
        """Read TSL script content"""
        try:
            with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
                return f.read()
        except Exception as e:
            self.log(f"Error reading {filepath}: {e}")
            return ""

    def extract_code_section(self, content: str) -> str:
        """Extract the main code section from TSL file"""
        match = re.search(r'#BeginContents\s*(.*?)\s*#End', content, re.DOTALL)
        if match:
            return match.group(1)
        return content

    def prepare_code(self, code: str, filename: str = "unknown") -> tuple:
        """
        Prepare code for processing: compress, then chunk if needed

        Returns:
            Tuple of (chunks_list, compression_stats, chunking_info)
            - chunks_list: List of code chunks to process (usually 1, more for large files)
            - compression_stats: Compression statistics or None
            - chunking_info: Chunking info or None
        """
        original_size = len(code)
        compression_stats = None
        chunking_info = None
        chunks_list = []

        # Step 1: Apply compression if enabled and code is large enough
        if ENABLE_COMPRESSION and original_size > MAX_CODE_CHARS:
            code, stats = self.compressor.compress(code)
            compression_stats = {
                "original_chars": stats.original_chars,
                "compressed_chars": stats.compressed_chars,
                "ratio": stats.ratio,
                "strategies": stats.strategies_applied
            }
            self.log(f"  Compressed: {stats.original_chars:,} -> {stats.compressed_chars:,} chars ({stats.ratio*100:.1f}% reduction)")

        # Step 2: Check if chunking is needed
        if len(code) > CHUNK_THRESHOLD:
            result = self.chunker.chunk(code, filename)
            if result.requires_chunking:
                chunking_info = {
                    "total_chunks": result.total_chunks,
                    "chunk_names": [c.name for c in result.chunks]
                }
                self.log(f"  Chunked into {result.total_chunks} parts for multi-chunk processing")
                # Return all chunks for processing
                for chunk in result.chunks:
                    chunk_code = chunk.content
                    # Truncate individual chunks if still too large
                    if len(chunk_code) > MAX_CODE_CHARS:
                        first_part = int(MAX_CODE_CHARS * 0.6)
                        last_part = MAX_CODE_CHARS - first_part - 200
                        chunk_code = chunk_code[:first_part] + "\n\n... [CHUNK TRUNCATED] ...\n\n" + chunk_code[-last_part:]
                    chunks_list.append({
                        "name": chunk.name,
                        "content": chunk_code,
                        "region": chunk.region_name
                    })
                return chunks_list, compression_stats, chunking_info

        # No chunking needed - single chunk
        # Step 3: Final truncation as safety net
        if len(code) > MAX_CODE_CHARS:
            self.log(f"  Warning: Code still too large after compression ({len(code):,} chars), truncating...")
            first_part = int(MAX_CODE_CHARS * 0.6)
            last_part = MAX_CODE_CHARS - first_part - 200
            code = code[:first_part] + "\n\n... [CODE TRUNCATED] ...\n\n" + code[-last_part:]

        chunks_list.append({
            "name": "full",
            "content": code,
            "region": None
        })
        return chunks_list, compression_stats, chunking_info

    def truncate_code(self, code: str, max_chars: int = None) -> str:
        """
        Legacy truncate method - kept for compatibility
        Use prepare_code() for full compression+chunking pipeline
        """
        if max_chars is None:
            max_chars = MAX_CODE_CHARS

        if len(code) <= max_chars:
            return code
        first_part = int(max_chars * 0.6)
        last_part = max_chars - first_part - 100
        return code[:first_part] + "\n\n... [CODE TRUNCATED] ...\n\n" + code[-last_part:]

    def parse_json_response(self, content: str) -> Dict[str, Any]:
        """Parse JSON from LLM response, handling common issues"""
        if not content:
            return {}

        try:
            return json.loads(content)
        except:
            pass

        json_match = re.search(r'```(?:json)?\s*([\s\S]*?)\s*```', content)
        if json_match:
            try:
                return json.loads(json_match.group(1))
            except:
                pass

        brace_match = re.search(r'\{[\s\S]*\}', content)
        if brace_match:
            try:
                return json.loads(brace_match.group())
            except:
                pass

        return {"raw_content": content}

    def handle_rate_limit(self, error_msg: str) -> bool:
        """Handle rate limit error, return True if should retry"""
        if "429" in error_msg or "rate" in error_msg.lower():
            self.rate_limited = True
            wait_time = RATE_LIMIT_WAIT
            self.log(f"  Rate limited! Waiting {wait_time} seconds...")

            # Save checkpoint before waiting
            self._save_checkpoint()

            # Wait with progress indicator
            for i in range(wait_time // 60):
                time.sleep(60)
                remaining = wait_time - (i + 1) * 60
                self.log(f"  ... {remaining} seconds remaining")

            time.sleep(wait_time % 60)
            self.rate_limited = False
            return True
        return False

    def run_pass(
        self,
        pass_number: int,
        filename: str,
        code: str,
        previous_results: Dict[int, PassResult]
    ) -> PassResult:
        """Run a single analysis pass with rate limiting"""
        self.log(f"  Pass {pass_number} for {filename}...")

        # Add delay between requests to avoid rate limits
        time.sleep(REQUEST_DELAY)

        # Build prompt based on pass number
        if pass_number == 1:
            prompt = format_prompt(pass_number, filename=filename, code=code)
        elif pass_number == 2:
            pass1_json = json.dumps(previous_results[1].data, indent=2, ensure_ascii=False)
            prompt = format_prompt(
                pass_number,
                filename=filename,
                code=code,
                pass1_results=pass1_json
            )
        elif pass_number in [3, 4, 5]:
            prev_json = json.dumps({
                f"pass{k}": v.data for k, v in previous_results.items()
            }, indent=2, ensure_ascii=False)
            prompt = format_prompt(
                pass_number,
                filename=filename,
                code=code,
                previous_results=prev_json
            )
        elif pass_number == 6:
            all_json = json.dumps({
                f"pass{k}": v.data for k, v in previous_results.items()
            }, indent=2, ensure_ascii=False)
            prompt = format_prompt(
                pass_number,
                filename=filename,
                all_results=all_json
            )
        else:
            return PassResult(
                pass_number=pass_number,
                success=False,
                data={},
                tokens_used=0,
                error=f"Invalid pass number: {pass_number}"
            )

        # Get thread-local client
        client = self._get_client()

        # Call GLM API with retry on rate limit
        max_rate_limit_retries = 3
        for retry in range(max_rate_limit_retries):
            response = client.chat(
                user_message=prompt,
                system_message=SYSTEM_PROMPT,
                max_tokens=MAX_OUTPUT_TOKENS if pass_number < 6 else MAX_OUTPUT_TOKENS_FINAL,
                temperature=0.3 if pass_number < 6 else 0.5
            )

            if response.success:
                break
            elif response.error and self.handle_rate_limit(response.error):
                self.log(f"  Retrying pass {pass_number} after rate limit...")
                continue
            else:
                return PassResult(
                    pass_number=pass_number,
                    success=False,
                    data={},
                    tokens_used=0,
                    error=response.error
                )

        if not response.success:
            return PassResult(
                pass_number=pass_number,
                success=False,
                data={},
                tokens_used=0,
                error=response.error
            )

        # Parse response
        if pass_number == 6:
            data = {"markdown": response.content}
        else:
            data = self.parse_json_response(response.content)

        return PassResult(
            pass_number=pass_number,
            success=True,
            data=data,
            tokens_used=response.total_tokens,
            reasoning=response.reasoning_content
        )

    def process_script(self, filepath: Path) -> ScriptAnalysis:
        """Process a single TSL script through all 6 passes (with multi-chunk support)"""
        filename = filepath.name
        self.log(f"Processing: {filename}")
        start_time = time.time()

        analysis = ScriptAnalysis(
            filename=filename,
            filepath=str(filepath)
        )

        # Read and prepare code
        content = self.read_script(filepath)
        if not content:
            analysis.status = "error"
            analysis.error = "Failed to read file"
            return analysis

        code = self.extract_code_section(content)

        # Use new compression + chunking pipeline
        chunks_list, compression_stats, chunking_info = self.prepare_code(code, filename)
        analysis.compression_stats = compression_stats
        analysis.chunking_info = chunking_info

        # Process chunks
        if len(chunks_list) == 1:
            # Single chunk - standard processing
            chunk_code = chunks_list[0]["content"]
            for pass_num in range(1, 7):
                result = self.run_pass(pass_num, filename, chunk_code, analysis.passes)
                analysis.passes[pass_num] = result
                analysis.total_tokens += result.tokens_used

                if not result.success:
                    self.log(f"  [WARN] Pass {pass_num} failed: {result.error}")

            # Extract final documentation
            if 6 in analysis.passes and analysis.passes[6].success:
                analysis.final_doc = analysis.passes[6].data.get("markdown", "")
                analysis.status = "completed"
            else:
                analysis.status = "partial"
        else:
            # Multi-chunk processing
            self.log(f"  Processing {len(chunks_list)} chunks...")
            chunk_docs = []

            for i, chunk in enumerate(chunks_list):
                chunk_name = chunk["name"]
                chunk_code = chunk["content"]
                self.log(f"  [Chunk {i+1}/{len(chunks_list)}] {chunk_name}")

                chunk_passes = {}
                for pass_num in range(1, 7):
                    result = self.run_pass(
                        pass_num,
                        f"{filename} (Chunk {i+1}: {chunk_name})",
                        chunk_code,
                        chunk_passes
                    )
                    chunk_passes[pass_num] = result
                    analysis.total_tokens += result.tokens_used

                    if not result.success:
                        self.log(f"    [WARN] Pass {pass_num} failed: {result.error}")

                # Store chunk results
                analysis.passes[f"chunk_{i+1}"] = chunk_passes

                # Extract chunk documentation
                if 6 in chunk_passes and chunk_passes[6].success:
                    chunk_doc = chunk_passes[6].data.get("markdown", "")
                    if chunk_doc:
                        chunk_docs.append({
                            "name": chunk_name,
                            "doc": chunk_doc
                        })

            # Merge all chunk documentations
            if chunk_docs:
                analysis.final_doc = self._merge_chunk_docs(filename, chunk_docs)
                analysis.status = "completed"
            else:
                analysis.status = "partial"

        analysis.processing_time = time.time() - start_time
        self.results[filename] = analysis

        self.log(f"  [OK] Completed in {analysis.processing_time:.1f}s, {analysis.total_tokens} tokens")
        return analysis

    def _merge_chunk_docs(self, filename: str, chunk_docs: List[Dict]) -> str:
        """Merge documentation from multiple chunks into a single document"""
        if len(chunk_docs) == 1:
            return chunk_docs[0]["doc"]

        # Parse and merge sections from all chunks
        merged_sections = {}
        section_order = []

        for chunk in chunk_docs:
            doc = chunk["doc"]
            current_section = None
            current_content = []

            for line in doc.split('\n'):
                # Detect section headers (## Header)
                if line.startswith('## '):
                    # Save previous section
                    if current_section:
                        if current_section not in merged_sections:
                            merged_sections[current_section] = []
                            section_order.append(current_section)
                        merged_sections[current_section].append('\n'.join(current_content))

                    current_section = line
                    current_content = []
                elif line.startswith('# ') and not line.startswith('## '):
                    # Main title - skip duplicates
                    if "title" not in merged_sections:
                        merged_sections["title"] = [line]
                        section_order.insert(0, "title")
                else:
                    current_content.append(line)

            # Save last section
            if current_section:
                if current_section not in merged_sections:
                    merged_sections[current_section] = []
                    section_order.append(current_section)
                merged_sections[current_section].append('\n'.join(current_content))

        # Build merged document
        merged_doc = []

        for section in section_order:
            if section == "title":
                merged_doc.append(merged_sections[section][0])
                merged_doc.append("")
            else:
                merged_doc.append(section)
                # Combine content from all chunks, removing duplicates
                all_content = []
                seen_lines = set()
                for content in merged_sections[section]:
                    for line in content.split('\n'):
                        line_stripped = line.strip()
                        # Skip empty lines at boundaries and exact duplicates
                        if line_stripped and line_stripped not in seen_lines:
                            all_content.append(line)
                            if len(line_stripped) > 20:  # Only track substantial lines
                                seen_lines.add(line_stripped)
                        elif not line_stripped and all_content and all_content[-1].strip():
                            all_content.append(line)  # Keep single empty lines

                merged_doc.append('\n'.join(all_content))
                merged_doc.append("")

        return '\n'.join(merged_doc)

    def save_results(self, analysis: ScriptAnalysis):
        """Save analysis results to files"""
        try:
            base_name = Path(analysis.filename).stem

            # Save pass results as JSON
            pass_results_file = PASS_RESULTS_DIR / f"{base_name}_passes.json"

            # Handle both single-chunk and multi-chunk pass data
            def serialize_passes(passes_dict):
                result = {}
                for k, v in passes_dict.items():
                    if isinstance(v, dict):
                        # Multi-chunk: v is a dict of {pass_num: PassResult}
                        result[str(k)] = {
                            str(pk): {
                                "success": pv.success,
                                "data": pv.data,
                                "tokens_used": pv.tokens_used,
                                "error": pv.error
                            }
                            for pk, pv in v.items()
                        }
                    else:
                        # Single-chunk: v is a PassResult
                        result[str(k)] = {
                            "success": v.success,
                            "data": v.data,
                            "tokens_used": v.tokens_used,
                            "error": v.error
                        }
                return result

            pass_data = {
                "filename": analysis.filename,
                "status": analysis.status,
                "total_tokens": analysis.total_tokens,
                "processing_time": analysis.processing_time,
                "compression": analysis.compression_stats,
                "chunking": analysis.chunking_info,
                "passes": serialize_passes(analysis.passes)
            }
            with open(pass_results_file, "w", encoding="utf-8") as f:
                json.dump(pass_data, f, indent=2, ensure_ascii=False)

            # Save final documentation
            if analysis.final_doc:
                doc_file = DOCS_DIR / f"{base_name}.md"
                with open(doc_file, "w", encoding="utf-8") as f:
                    f.write(analysis.final_doc)

            self.log(f"  Saved: {base_name}")
        except Exception as e:
            self.log(f"  Error saving {analysis.filename}: {e}")

    def _process_single_script(self, script: Path) -> tuple:
        """Process a single script (for concurrent execution)"""
        try:
            analysis = self.process_script(script)
            self.save_results(analysis)
            return (script.name, analysis.status, analysis.total_tokens, None)
        except Exception as e:
            return (script.name, "error", 0, str(e))

    def process_batch(
        self,
        scripts: List[Path],
        start_index: int = 0,
        save_interval: int = SAVE_INTERVAL
    ):
        """Process a batch of scripts with checkpoint/resume and concurrent execution"""
        total_original = len(scripts)

        # Determine starting point based on checkpoint
        if start_index == 0 and self.checkpoint.completed_scripts:
            # Find scripts not yet completed
            completed_set = set(self.checkpoint.completed_scripts)
            scripts = [s for s in scripts if s.name not in completed_set]
            self.log(f"Resuming: {len(self.checkpoint.completed_scripts)} already done, {len(scripts)} remaining")

        total = len(scripts)
        if total == 0:
            self.log("No scripts to process")
            return

        self.log(f"Starting batch processing: {total} scripts (concurrent: {self.concurrent_scripts})")

        # Track total tokens across all threads
        total_tokens_used = 0
        processed_count = 0
        stop_flag = threading.Event()

        try:
            with ThreadPoolExecutor(max_workers=self.concurrent_scripts) as executor:
                # Submit all scripts
                future_to_script = {
                    executor.submit(self._process_single_script, script): script
                    for script in scripts
                    if script.name not in self.checkpoint.completed_scripts
                }

                for future in as_completed(future_to_script):
                    if stop_flag.is_set():
                        break

                    script = future_to_script[future]
                    try:
                        script_name, status, tokens, error = future.result()

                        # Thread-safe checkpoint update
                        with self._checkpoint_lock:
                            if status == "completed":
                                self.checkpoint.completed_scripts.append(script_name)
                            else:
                                self.checkpoint.failed_scripts.append(script_name)
                                if error:
                                    self.log(f"  Error processing {script_name}: {error}")

                            total_tokens_used += tokens
                            self.checkpoint.total_tokens_used = total_tokens_used
                            self.checkpoint.total_requests += 6  # 6 passes per script

                        # Save checkpoint after every script
                        self._save_checkpoint()

                        # Progress report
                        processed_count += 1
                        completed = len(self.checkpoint.completed_scripts)
                        self.log(f"Progress: {completed}/{total_original} scripts | Tokens: {total_tokens_used:,}")

                    except Exception as e:
                        self.log(f"Error processing {script}: {e}")
                        with self._checkpoint_lock:
                            self.checkpoint.failed_scripts.append(script.name)
                        self._save_checkpoint()

        except KeyboardInterrupt:
            self.log(f"Interrupted! Saving checkpoint...")
            stop_flag.set()
            self._save_checkpoint()
            self.log(f"Checkpoint saved. Run with --resume to continue.")

        # Final summary
        self.log(f"\n=== Processing Complete ===")
        self.log(f"Completed: {len(self.checkpoint.completed_scripts)}")
        self.log(f"Failed: {len(self.checkpoint.failed_scripts)}")
        self.log(f"Total tokens used: {total_tokens_used:,}")
        self.log(f"Checkpoint saved to: {CHECKPOINT_FILE}")

    def retry_failed(self, scripts: List[Path]):
        """Retry processing failed scripts"""
        failed_set = set(self.checkpoint.failed_scripts)
        failed_scripts = [s for s in scripts if s.name in failed_set]

        if not failed_scripts:
            self.log("No failed scripts to retry")
            return

        self.log(f"Retrying {len(failed_scripts)} failed scripts...")

        # Clear failed list for retry
        self.checkpoint.failed_scripts = []
        self._save_checkpoint()

        self.process_batch(failed_scripts)

    def get_all_scripts(self) -> List[Path]:
        """Get all TSL scripts to process"""
        return sorted(TSL_DIR.glob("*.mcr"))

    def close(self):
        """Clean up resources"""
        self._save_checkpoint()
        self.log_file.close()


def main():
    """Main entry point"""
    processor = TSLProcessor()

    try:
        scripts = processor.get_all_scripts()
        print(f"Found {len(scripts)} TSL scripts")
        processor.process_batch(scripts[:5])
    finally:
        processor.close()


if __name__ == "__main__":
    main()
