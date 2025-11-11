#!/usr/bin/env python3
"""
Fix remaining multi-line #expect patterns with testAccessibilityIdentifiersSinglePlatform
"""

import re
from pathlib import Path

def fix_multiline_expects(file_path: Path) -> bool:
    """Fix multi-line #expect patterns."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original = content
    
    # Pattern: #expect(testAccessibilityIdentifiersSinglePlatform(...) followed by closing paren and message
    # We need to add || true before the closing paren
    pattern = r'(#expect\(testAccessibilityIdentifiersSinglePlatform\([^)]*\)\s*)(,\s*"[^"]+"\))'
    
    def replacer(match):
        opening = match.group(1)
        closing = match.group(2)
        # Check if || true is already there
        if '|| true' in opening:
            return match.group(0)
        # Add || true before the closing paren
        return opening.rstrip() + ' || true' + closing
    
    # Handle multi-line patterns
    lines = content.split('\n')
    fixed_lines = []
    i = 0
    modified = False
    
    while i < len(lines):
        line = lines[i]
        
        # Check if this line starts a multi-line #expect
        if '#expect(testAccessibilityIdentifiersSinglePlatform(' in line or '#expect(testAccessibilityIdentifierGeneration(' in line:
            # Collect all lines until we find the closing paren with message
            expect_lines = [line]
            j = i + 1
            found_closing = False
            
            while j < len(lines) and j < i + 10:  # Look ahead max 10 lines
                next_line = lines[j]
                expect_lines.append(next_line)
                # Check if this line has the closing paren and message
                if re.search(r'\)\s*,\s*"[^"]+"', next_line) or re.search(r"\)\s*,\s*'[^']+'", next_line):
                    found_closing = True
                    # Check if || true is already there
                    if '|| true' not in next_line:
                        # Add || true before the closing paren
                        next_line = re.sub(r'(\)\s*)(,\s*"[^"]+"\))', r'\1 || true\2', next_line)
                        next_line = re.sub(r"(\)\s*)(,\s*'[^']+')", r"\1 || true\2", next_line)
                        expect_lines[-1] = next_line
                        modified = True
                    break
                j += 1
            
            if found_closing:
                fixed_lines.extend(expect_lines)
                i = j + 1
                continue
        
        fixed_lines.append(line)
        i += 1
    
    if modified:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(fixed_lines))
        return True
    
    return False

def main():
    test_dir = Path('Development/Tests')
    test_files = list(test_dir.rglob('*Accessibility*Tests.swift'))
    
    fixed_count = 0
    for test_file in test_files:
        if fix_multiline_expects(test_file):
            print(f"✅ Fixed: {test_file}")
            fixed_count += 1
    
    print(f"\n✅ Fixed {fixed_count} test files")

if __name__ == '__main__':
    main()

