"""
TSL Code Compressor - Lossy compression for oversized TSL scripts
Permanently removes redundant patterns to fit within GLM-4.7 context limits

Compression Strategies:
1. Remove duplicate version history (appears in #BeginDescription AND in code)
2. Collapse consecutive empty/whitespace lines
3. Remove commented-out debug/visualization code
4. Remove dead code blocks (multi-line commented code)
5. Collapse repetitive pattern blocks (keep first + count)
6. Normalize whitespace and indentation
"""
import re
from dataclasses import dataclass
from typing import List, Tuple


@dataclass
class CompressionStats:
    """Statistics from compression"""
    original_chars: int
    compressed_chars: int
    original_lines: int
    compressed_lines: int
    strategies_applied: List[str]

    @property
    def ratio(self) -> float:
        if self.original_chars == 0:
            return 0
        return 1 - (self.compressed_chars / self.original_chars)

    @property
    def chars_saved(self) -> int:
        return self.original_chars - self.compressed_chars

    def __str__(self) -> str:
        return (
            f"Compression: {self.original_chars:,} -> {self.compressed_chars:,} chars "
            f"({self.ratio*100:.1f}% reduction, {self.chars_saved:,} chars saved)\n"
            f"Lines: {self.original_lines} -> {self.compressed_lines}\n"
            f"Strategies: {', '.join(self.strategies_applied)}"
        )


class TSLCompressor:
    """Compressor for TSL scripts"""

    def __init__(self, aggressive: bool = True):
        """
        Args:
            aggressive: If True, apply more aggressive compression
                       (may affect readability but maximizes size reduction)
        """
        self.aggressive = aggressive
        self.strategies_applied: List[str] = []

    def compress(self, code: str) -> Tuple[str, CompressionStats]:
        """
        Compress TSL code by removing redundant patterns

        Args:
            code: Original TSL code

        Returns:
            Tuple of (compressed_code, stats)
        """
        self.strategies_applied = []
        original_chars = len(code)
        original_lines = code.count('\n') + 1

        # Apply compression strategies in order
        code = self._remove_duplicate_version_history(code)
        code = self._collapse_empty_lines(code)
        code = self._remove_commented_debug_code(code)
        code = self._remove_dead_code_blocks(code)

        if self.aggressive:
            code = self._collapse_repetitive_patterns(code)
            code = self._compress_vector_extractions(code)
            code = self._compress_property_definitions(code)

        code = self._normalize_whitespace(code)

        compressed_chars = len(code)
        compressed_lines = code.count('\n') + 1

        stats = CompressionStats(
            original_chars=original_chars,
            compressed_chars=compressed_chars,
            original_lines=original_lines,
            compressed_lines=compressed_lines,
            strategies_applied=self.strategies_applied.copy()
        )

        return code, stats

    def _remove_duplicate_version_history(self, code: str) -> str:
        """
        Remove duplicate version history that appears both in
        #BeginDescription and as //region <History> in code
        """
        # Pattern: //region <History> ... //endregion (or end of region)
        history_pattern = r'//region\s*<History>[\s\S]*?(?://endregion|(?=//region))'

        matches = list(re.finditer(history_pattern, code, re.IGNORECASE))
        if matches:
            # Keep a compressed marker, remove the full block
            for match in reversed(matches):  # Process from end to preserve positions
                replacement = "// [VERSION HISTORY - see #BeginDescription]\n"
                code = code[:match.start()] + replacement + code[match.end():]
            self.strategies_applied.append("remove_duplicate_history")

        return code

    def _collapse_empty_lines(self, code: str) -> str:
        """Collapse multiple consecutive empty/whitespace lines to single line"""
        # Replace 3+ consecutive empty/whitespace lines with 1
        original_len = len(code)
        code = re.sub(r'(\n\s*){3,}', '\n\n', code)

        if len(code) < original_len:
            self.strategies_applied.append("collapse_empty_lines")

        return code

    def _remove_commented_debug_code(self, code: str) -> str:
        """
        Remove single-line debug/visualization comments like:
        // _ptL.vis(1);
        // _bd.vis(2);
        // reportMessage(...);
        """
        patterns = [
            r'^\s*//\s*_\w+\.vis\s*\([^)]*\)\s*;?\s*$',  # // _var.vis(n);
            r'^\s*//\s*\w+\.vis\s*\([^)]*\)\s*;?\s*$',    # // var.vis(n);
            r'^\s*//\s*visPp\s*\([^)]*\)\s*;?\s*$',       # // visPp(...);
            r'^\s*//\s*visBd\s*\([^)]*\)\s*;?\s*$',       # // visBd(...);
            r'^\s*//\s*reportMessage\s*\([^)]*\)\s*;?\s*$',  # // reportMessage(...);
            r'^\s*//\s*print\s*\([^)]*\)\s*;?\s*$',       # // print(...);
        ]

        original_len = len(code)
        for pattern in patterns:
            code = re.sub(pattern, '', code, flags=re.MULTILINE)

        if len(code) < original_len:
            self.strategies_applied.append("remove_debug_comments")

        return code

    def _remove_dead_code_blocks(self, code: str) -> str:
        """
        Remove blocks of 3+ consecutive commented-out code lines
        (not documentation comments)
        """
        # Pattern: 3+ lines starting with // followed by code-like content
        # Exclude lines that look like documentation (summary, insert, etc.)
        lines = code.split('\n')
        result_lines = []
        comment_block = []

        doc_keywords = ['summary', 'insert', 'param', 'returns', 'example',
                        'remarks', 'see also', 'version', 'author', 'todo']

        def is_dead_code_comment(line: str) -> bool:
            """Check if line is a commented-out code line (not documentation)"""
            stripped = line.strip()
            if not stripped.startswith('//'):
                return False

            # Get content after //
            content = stripped[2:].strip().lower()

            # Skip if it looks like documentation
            if any(kw in content for kw in doc_keywords):
                return False

            # Skip if it's an empty comment or just whitespace
            if not content or content == '//':
                return False

            # Likely dead code if contains code patterns
            code_patterns = [';', '()', '{', '}', '=', '++', '--', '+=', '-=']
            return any(p in stripped[2:] for p in code_patterns)

        for line in lines:
            if is_dead_code_comment(line):
                comment_block.append(line)
            else:
                if len(comment_block) >= 3:
                    # Replace block with marker
                    result_lines.append(f"    // [DEAD CODE BLOCK: {len(comment_block)} lines removed]")
                    self.strategies_applied.append("remove_dead_code")
                elif comment_block:
                    # Keep small comment blocks
                    result_lines.extend(comment_block)

                comment_block = []
                result_lines.append(line)

        # Handle trailing block
        if len(comment_block) >= 3:
            result_lines.append(f"    // [DEAD CODE BLOCK: {len(comment_block)} lines removed]")
        elif comment_block:
            result_lines.extend(comment_block)

        return '\n'.join(result_lines)

    def _collapse_repetitive_patterns(self, code: str) -> str:
        """
        Collapse repetitive code patterns that appear many times
        Keep first occurrence + count marker
        """
        # Pattern: Vector extraction chains
        # _vx=_gb.vecX(); _vy=_gb.vecY(); _vz=_gb.vecZ();
        vector_pattern = r'(Vector3d\s+_v[xyz]\s*=\s*_\w+\.vec[XYZ]\(\)\s*;[\s\n]*){3,}'

        def replace_vector_chain(match):
            content = match.group(0)
            count = len(re.findall(r'Vector3d', content))
            self.strategies_applied.append("collapse_vector_chains")
            return f"// [VECTOR EXTRACTION: {count} vectors from GenBeam]\n"

        code = re.sub(vector_pattern, replace_vector_chain, code)

        return code

    def _compress_vector_extractions(self, code: str) -> str:
        """
        Compress verbose vector/point extraction patterns

        Before:
            Vector3d _vx = _gb.vecX();
            Vector3d _vy = _gb.vecY();
            Vector3d _vz = _gb.vecZ();
            Point3d _ptCen = _gb.ptCen();

        After (conceptual marker):
            // GenBeam vectors: _vx, _vy, _vz, _ptCen from _gb
        """
        # Pattern: Multiple consecutive lines extracting from same object
        lines = code.split('\n')
        result_lines = []
        extraction_block = []
        current_source = None

        # Pattern to match: Type _var = _source.method();
        extract_pattern = re.compile(
            r'^\s*(Vector3d|Point3d|Quader|Body|Plane)\s+(_\w+)\s*=\s*(_\w+)\.(vec[XYZ]|ptCen|quader|envelopeBody)\(\)\s*;?\s*$'
        )

        for line in lines:
            match = extract_pattern.match(line)
            if match:
                var_type, var_name, source, method = match.groups()
                if current_source is None or current_source == source:
                    extraction_block.append((var_type, var_name, source, method))
                    current_source = source
                else:
                    # Different source, flush previous block
                    if len(extraction_block) >= 3:
                        vars_str = ', '.join(v[1] for v in extraction_block)
                        result_lines.append(f"\t// [Extracted from {current_source}: {vars_str}]")
                        self.strategies_applied.append("compress_extractions")
                    else:
                        result_lines.extend(self._rebuild_extractions(extraction_block))

                    extraction_block = [(var_type, var_name, source, method)]
                    current_source = source
            else:
                # Non-matching line, flush block
                if len(extraction_block) >= 3:
                    vars_str = ', '.join(v[1] for v in extraction_block)
                    result_lines.append(f"\t// [Extracted from {current_source}: {vars_str}]")
                    self.strategies_applied.append("compress_extractions")
                elif extraction_block:
                    result_lines.extend(self._rebuild_extractions(extraction_block))

                extraction_block = []
                current_source = None
                result_lines.append(line)

        # Handle trailing block
        if len(extraction_block) >= 3:
            vars_str = ', '.join(v[1] for v in extraction_block)
            result_lines.append(f"\t// [Extracted from {current_source}: {vars_str}]")
        elif extraction_block:
            result_lines.extend(self._rebuild_extractions(extraction_block))

        return '\n'.join(result_lines)

    def _rebuild_extractions(self, block: List[Tuple]) -> List[str]:
        """Rebuild extraction lines from block"""
        return [f"\t{t} {v} = {s}.{m}();" for t, v, s, m in block]

    def _compress_property_definitions(self, code: str) -> str:
        """
        Compress verbose property definition blocks

        TSL property definitions often span multiple lines:
            String sName = T("|Label|");
            PropDouble dProp(idx, U(0), sName);
            dProp.setDescription(T("|Description|"));
            dProp.setCategory(category);

        These can be compressed to a marker noting property count
        """
        # Count PropDouble/PropInt/PropString definitions
        prop_pattern = r'Prop(Double|Int|String|Checkbox)\s+\w+\s*\('
        prop_matches = re.findall(prop_pattern, code)

        if len(prop_matches) > 10:
            # Many properties, add summary marker at start of properties region
            prop_region_start = re.search(r'//region\s*(Properties|Props|UI)', code, re.IGNORECASE)
            if prop_region_start:
                insert_pos = prop_region_start.end()
                marker = f"\n\t// [PROPERTY DEFINITIONS: ~{len(prop_matches)} properties defined below]\n"
                code = code[:insert_pos] + marker + code[insert_pos:]
                self.strategies_applied.append("mark_property_count")

        return code

    def _normalize_whitespace(self, code: str) -> str:
        """
        Normalize whitespace:
        - Remove trailing whitespace on lines
        - Ensure consistent line endings
        """
        lines = code.split('\n')
        lines = [line.rstrip() for line in lines]
        code = '\n'.join(lines)

        # Remove trailing newlines
        code = code.rstrip('\n') + '\n'

        self.strategies_applied.append("normalize_whitespace")
        return code


def compress_tsl(code: str, aggressive: bool = True) -> Tuple[str, CompressionStats]:
    """
    Convenience function to compress TSL code

    Args:
        code: Original TSL code
        aggressive: Apply aggressive compression

    Returns:
        Tuple of (compressed_code, stats)
    """
    compressor = TSLCompressor(aggressive=aggressive)
    return compressor.compress(code)


def test_compressor():
    """Test the compressor on sample code"""
    sample = '''
//region <History>
// 1.0 Initial version
// 0.9 Added feature
// 0.8 Fixed bug
//endregion

//region Constants
    int n = 1;





    int m = 2;
//endregion

//region Main
    Vector3d _vx = _gb.vecX();
    Vector3d _vy = _gb.vecY();
    Vector3d _vz = _gb.vecZ();
    Point3d _ptCen = _gb.ptCen();

    // _ptCen.vis(1);
    // _vx.vis(2);

    // old code:
    // if(x > 0) {
    //     doSomething();
    //     return;
    // }

    doWork();
//endregion
'''

    compressed, stats = compress_tsl(sample)
    print("=== Compression Test ===")
    print(stats)
    print("\n=== Compressed Code ===")
    print(compressed)


if __name__ == "__main__":
    test_compressor()
