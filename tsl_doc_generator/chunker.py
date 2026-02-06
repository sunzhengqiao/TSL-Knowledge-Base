"""
TSL Code Chunker - Split large TSL files by #region markers

For files that exceed the context limit even after compression,
this module splits them into logical chunks based on #region/#endregion markers.

Chunking Strategy:
1. Parse file structure to identify #region markers
2. Create chunks: header (metadata + constants), each major region, footer
3. Each chunk includes necessary context (imports, constants)
4. Chunks are processed through the 6-pass pipeline independently
5. Results are merged with deduplication
"""
import re
from dataclasses import dataclass, field
from typing import List, Optional, Dict, Any


@dataclass
class TSLChunk:
    """A logical chunk of TSL code"""
    name: str                    # Chunk identifier (e.g., "region_Functions")
    content: str                 # The code content
    start_line: int              # Original line number where chunk starts
    end_line: int                # Original line number where chunk ends
    region_name: Optional[str]   # Original #region name if applicable
    includes_header: bool = False  # Whether this chunk includes file header
    includes_footer: bool = False  # Whether this chunk includes file footer

    @property
    def size(self) -> int:
        return len(self.content)

    @property
    def line_count(self) -> int:
        return self.content.count('\n') + 1


@dataclass
class ChunkingResult:
    """Result of chunking operation"""
    chunks: List[TSLChunk]
    original_size: int
    total_chunks: int
    requires_chunking: bool
    header_content: str = ""     # Shared header content (metadata, constants)

    def __str__(self) -> str:
        chunks_info = '\n'.join(
            f"  - {c.name}: {c.size:,} chars, {c.line_count} lines"
            for c in self.chunks
        )
        return (
            f"Chunking Result:\n"
            f"  Original size: {self.original_size:,} chars\n"
            f"  Total chunks: {self.total_chunks}\n"
            f"  Requires chunking: {self.requires_chunking}\n"
            f"Chunks:\n{chunks_info}"
        )


class TSLChunker:
    """
    Split large TSL files into logical chunks based on #region markers
    """

    def __init__(self, max_chunk_size: int = 100000):
        """
        Args:
            max_chunk_size: Maximum characters per chunk (default 100K)
        """
        self.max_chunk_size = max_chunk_size

    def chunk(self, code: str, filename: str = "unknown") -> ChunkingResult:
        """
        Split TSL code into chunks based on #region markers

        Args:
            code: The TSL code to chunk
            filename: Filename for reference

        Returns:
            ChunkingResult with list of chunks
        """
        original_size = len(code)

        # Check if chunking is needed
        if original_size <= self.max_chunk_size:
            return ChunkingResult(
                chunks=[TSLChunk(
                    name="full",
                    content=code,
                    start_line=1,
                    end_line=code.count('\n') + 1,
                    region_name=None,
                    includes_header=True,
                    includes_footer=True
                )],
                original_size=original_size,
                total_chunks=1,
                requires_chunking=False
            )

        # Parse regions
        regions = self._parse_regions(code)

        # Extract shared header (everything before first major region)
        header_content = self._extract_header(code, regions)

        # Create chunks from regions
        chunks = self._create_chunks(code, regions, header_content, filename)

        return ChunkingResult(
            chunks=chunks,
            original_size=original_size,
            total_chunks=len(chunks),
            requires_chunking=True,
            header_content=header_content
        )

    def _parse_regions(self, code: str) -> List[Dict[str, Any]]:
        """
        Parse #region/#endregion markers and return region info

        Returns list of dicts with:
            - name: region name
            - start: character position
            - end: character position
            - start_line: line number
            - end_line: line number
        """
        regions = []
        lines = code.split('\n')

        region_stack = []  # Stack for nested regions

        for i, line in enumerate(lines):
            stripped = line.strip()

            # Match //region or #region
            region_match = re.match(r'^(?://|#)region\s*(.*?)$', stripped, re.IGNORECASE)
            if region_match:
                region_name = region_match.group(1).strip()
                # Clean up region name (remove <>, quotes, etc.)
                region_name = re.sub(r'[<>"\'#]', '', region_name).strip()
                region_stack.append({
                    'name': region_name or f'region_{len(regions)}',
                    'start_line': i + 1,
                    'start_char': sum(len(lines[j]) + 1 for j in range(i)),
                    'depth': len(region_stack)
                })
                continue

            # Match //endregion or #endregion
            endregion_match = re.match(r'^(?://|#)endregion', stripped, re.IGNORECASE)
            if endregion_match and region_stack:
                region_info = region_stack.pop()
                region_info['end_line'] = i + 1
                region_info['end_char'] = sum(len(lines[j]) + 1 for j in range(i + 1))

                # Only track top-level regions for chunking
                if region_info['depth'] == 0:
                    regions.append(region_info)

        return regions

    def _extract_header(self, code: str, regions: List[Dict[str, Any]]) -> str:
        """
        Extract the file header content:
        - #Version, #BeginDescription...#End
        - #BeginContents marker
        - Constants region (if exists and is reasonable size)
        """
        header_parts = []

        # Find #BeginContents position
        contents_match = re.search(r'#BeginContents\s*\n', code)
        if contents_match:
            # Include everything from start to just after #BeginContents
            header_parts.append(code[:contents_match.end()])
        else:
            # Take first 2000 chars as header approximation
            header_parts.append(code[:2000])

        # Find and include Constants region if small enough
        for region in regions:
            if 'constant' in region['name'].lower():
                region_content = code[region['start_char']:region['end_char']]
                if len(region_content) < 10000:  # Only include if reasonable size
                    header_parts.append(f"\n// [INCLUDED FROM CONSTANTS REGION]\n{region_content}")
                break

        return '\n'.join(header_parts)

    def _create_chunks(
        self,
        code: str,
        regions: List[Dict[str, Any]],
        header_content: str,
        filename: str
    ) -> List[TSLChunk]:
        """
        Create chunks from parsed regions
        """
        chunks = []

        # Filter to major regions (Functions, Main, UI, etc.)
        major_region_keywords = [
            'function', 'main', 'ui', 'propert', 'command', 'grip',
            'display', 'execution', 'calculation', 'helper'
        ]

        major_regions = []
        for region in regions:
            name_lower = region['name'].lower()
            # Include if it's a major region or is large enough
            is_major = any(kw in name_lower for kw in major_region_keywords)
            region_size = region['end_char'] - region['start_char']

            if is_major or region_size > 5000:
                major_regions.append(region)

        # If no major regions found, chunk by size
        if not major_regions:
            return self._chunk_by_size(code, header_content, filename)

        # Create chunk for each major region
        for i, region in enumerate(major_regions):
            region_content = code[region['start_char']:region['end_char']]

            # Prepend header context to each chunk
            chunk_content = (
                f"// === CHUNK {i+1}/{len(major_regions)}: {region['name']} ===\n"
                f"// (From {filename}, lines {region['start_line']}-{region['end_line']})\n\n"
                f"// --- SHARED CONTEXT (header/constants) ---\n"
                f"{header_content}\n\n"
                f"// --- REGION CONTENT: {region['name']} ---\n"
                f"{region_content}"
            )

            # If chunk is still too large, split it further
            if len(chunk_content) > self.max_chunk_size:
                sub_chunks = self._split_large_region(
                    region_content, region['name'], header_content, filename
                )
                chunks.extend(sub_chunks)
            else:
                chunks.append(TSLChunk(
                    name=f"region_{self._sanitize_name(region['name'])}",
                    content=chunk_content,
                    start_line=region['start_line'],
                    end_line=region['end_line'],
                    region_name=region['name']
                ))

        return chunks

    def _chunk_by_size(
        self,
        code: str,
        header_content: str,
        filename: str
    ) -> List[TSLChunk]:
        """
        Fallback: chunk by character count when no regions found
        """
        chunks = []
        lines = code.split('\n')

        # Reserve space for header in each chunk
        header_size = len(header_content)
        content_limit = self.max_chunk_size - header_size - 500  # Buffer

        current_chunk_lines = []
        current_size = 0
        chunk_num = 0

        for i, line in enumerate(lines):
            line_size = len(line) + 1

            if current_size + line_size > content_limit and current_chunk_lines:
                # Flush current chunk
                chunk_num += 1
                chunk_content = (
                    f"// === CHUNK {chunk_num} (by size) ===\n"
                    f"// (From {filename})\n\n"
                    f"// --- SHARED CONTEXT ---\n"
                    f"{header_content}\n\n"
                    f"// --- CONTENT ---\n"
                    + '\n'.join(current_chunk_lines)
                )
                chunks.append(TSLChunk(
                    name=f"chunk_{chunk_num}",
                    content=chunk_content,
                    start_line=i - len(current_chunk_lines) + 1,
                    end_line=i,
                    region_name=None
                ))
                current_chunk_lines = []
                current_size = 0

            current_chunk_lines.append(line)
            current_size += line_size

        # Final chunk
        if current_chunk_lines:
            chunk_num += 1
            chunk_content = (
                f"// === CHUNK {chunk_num} (by size) ===\n"
                f"// (From {filename})\n\n"
                f"// --- SHARED CONTEXT ---\n"
                f"{header_content}\n\n"
                f"// --- CONTENT ---\n"
                + '\n'.join(current_chunk_lines)
            )
            chunks.append(TSLChunk(
                name=f"chunk_{chunk_num}",
                content=chunk_content,
                start_line=len(lines) - len(current_chunk_lines) + 1,
                end_line=len(lines),
                region_name=None,
                includes_footer=True
            ))

        return chunks

    def _split_large_region(
        self,
        region_content: str,
        region_name: str,
        header_content: str,
        filename: str
    ) -> List[TSLChunk]:
        """
        Split a region that's still too large into sub-chunks
        Try to split at function boundaries or logical breaks
        """
        chunks = []
        lines = region_content.split('\n')

        header_size = len(header_content)
        content_limit = self.max_chunk_size - header_size - 500

        current_chunk_lines = []
        current_size = 0
        sub_chunk_num = 0

        # Look for function-like boundaries
        func_pattern = re.compile(r'^\s*(void|int|double|String|Map|Body|Point3d|Vector3d)\s+\w+\s*\(')

        for i, line in enumerate(lines):
            line_size = len(line) + 1

            # Check for natural break point
            is_func_start = func_pattern.match(line)

            if current_size + line_size > content_limit and current_chunk_lines:
                # If we're at a function boundary, this is a good place to split
                sub_chunk_num += 1
                chunk_content = (
                    f"// === {region_name} - Part {sub_chunk_num} ===\n"
                    f"// (From {filename})\n\n"
                    f"// --- SHARED CONTEXT ---\n"
                    f"{header_content}\n\n"
                    f"// --- CONTENT ---\n"
                    + '\n'.join(current_chunk_lines)
                )
                chunks.append(TSLChunk(
                    name=f"region_{self._sanitize_name(region_name)}_part{sub_chunk_num}",
                    content=chunk_content,
                    start_line=i - len(current_chunk_lines) + 1,
                    end_line=i,
                    region_name=f"{region_name} (Part {sub_chunk_num})"
                ))
                current_chunk_lines = []
                current_size = 0

            current_chunk_lines.append(line)
            current_size += line_size

        # Final sub-chunk
        if current_chunk_lines:
            sub_chunk_num += 1
            chunk_content = (
                f"// === {region_name} - Part {sub_chunk_num} ===\n"
                f"// (From {filename})\n\n"
                f"// --- SHARED CONTEXT ---\n"
                f"{header_content}\n\n"
                f"// --- CONTENT ---\n"
                + '\n'.join(current_chunk_lines)
            )
            chunks.append(TSLChunk(
                name=f"region_{self._sanitize_name(region_name)}_part{sub_chunk_num}",
                content=chunk_content,
                start_line=len(lines) - len(current_chunk_lines) + 1,
                end_line=len(lines),
                region_name=f"{region_name} (Part {sub_chunk_num})"
            ))

        return chunks

    def _sanitize_name(self, name: str) -> str:
        """Sanitize region name for use as identifier"""
        # Remove special characters, replace spaces with underscores
        name = re.sub(r'[^a-zA-Z0-9_]', '_', name)
        name = re.sub(r'_+', '_', name)
        return name.strip('_').lower()


def chunk_tsl(code: str, filename: str = "unknown", max_chunk_size: int = 100000) -> ChunkingResult:
    """
    Convenience function to chunk TSL code

    Args:
        code: TSL code to chunk
        filename: Filename for reference
        max_chunk_size: Maximum chars per chunk

    Returns:
        ChunkingResult with chunks
    """
    chunker = TSLChunker(max_chunk_size=max_chunk_size)
    return chunker.chunk(code, filename)


def test_chunker():
    """Test the chunker"""
    sample = '''#Version 8
#BeginDescription
Test script
#End
#BeginContents

//region Constants
    int n = 1;
//endregion

//region Functions
    void func1() { }
    void func2() { }
    void func3() { }
//endregion

//region Main
    int main() {
        func1();
        func2();
        func3();
        return 0;
    }
//endregion
'''

    result = chunk_tsl(sample, "test.mcr", max_chunk_size=500)
    print(result)

    for chunk in result.chunks:
        print(f"\n=== {chunk.name} ===")
        print(chunk.content[:200] + "..." if len(chunk.content) > 200 else chunk.content)


if __name__ == "__main__":
    test_chunker()
