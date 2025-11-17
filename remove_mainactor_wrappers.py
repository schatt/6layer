#!/usr/bin/env python3
"""
Remove unnecessary await MainActor.run { } wrappers from tests.
Test classes that inherit from BaseTestClass are already @MainActor, 
so these wrappers are unnecessary and cause 4-second timeouts.
"""

import re
from pathlib import Path

def remove_mainactor_wrapper(content: str) -> tuple[str, int]:
    """
    Remove await MainActor.run { } wrappers from test code.
    Returns (fixed_content, number_of_fixes)
    """
    fixes = 0
    lines = content.split('\n')
    new_lines = []
    i = 0
    
    while i < len(lines):
        line = lines[i]
        
        # Check if this line starts an await MainActor.run { } block
        if re.match(r'(\s+)await MainActor\.run\s*\{', line):
            indent = len(line) - len(line.lstrip())
            opening_indent = indent
            brace_count = 1
            start_line = i
            i += 1
            
            # Collect all lines inside the block
            block_lines = []
            while i < len(lines) and brace_count > 0:
                current_line = lines[i]
                # Count braces (simple approach - may not handle strings with braces)
                brace_count += current_line.count('{') - current_line.count('}')
                
                if brace_count > 0:
                    block_lines.append(current_line)
                i += 1
            
            # Remove one level of indentation from block lines (4 spaces)
            fixed_block_lines = []
            for block_line in block_lines:
                if block_line.strip():  # Non-empty line
                    # Remove 4 spaces of indentation
                    if block_line.startswith(' ' * (indent + 4)):
                        fixed_block_lines.append(block_line[4:])
                    elif block_line.startswith(' ' * indent):
                        # Already at correct indentation (might be a comment or empty)
                        fixed_block_lines.append(block_line)
                    else:
                        fixed_block_lines.append(block_line)
                else:
                    fixed_block_lines.append('')
            
            # Add the fixed block lines
            new_lines.extend(fixed_block_lines)
            fixes += 1
        else:
            new_lines.append(line)
            i += 1
    
    return '\n'.join(new_lines), fixes

def fix_file(file_path: Path) -> bool:
    """Fix a single test file. Returns True if changes were made."""
    try:
        content = file_path.read_text(encoding='utf-8')
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return False
    
    # Only process files that inherit from BaseTestClass
    if 'BaseTestClass' not in content:
        return False
    
    # Check if file has await MainActor.run patterns
    if 'await MainActor.run' not in content:
        return False
    
    original_content = content
    
    # Remove the wrappers
    fixed_content, fixes = remove_mainactor_wrapper(content)
    
    if fixes > 0 and fixed_content != original_content:
        try:
            file_path.write_text(fixed_content, encoding='utf-8')
            print(f"Fixed {file_path}: removed {fixes} MainActor.run wrapper(s)")
            return True
        except Exception as e:
            print(f"Error writing {file_path}: {e}")
            return False
    
    return False

def main():
    """Find and fix all test files with unnecessary MainActor.run wrappers."""
    test_dir = Path('Development/Tests')
    
    if not test_dir.exists():
        print(f"Test directory not found: {test_dir}")
        return
    
    fixed_count = 0
    file_count = 0
    
    for swift_file in test_dir.rglob('*.swift'):
        file_count += 1
        if fix_file(swift_file):
            fixed_count += 1
    
    print(f"\nProcessed {file_count} files, fixed {fixed_count} files")

if __name__ == '__main__':
    main()

