#!/usr/bin/env python3
"""
Remove remaining await MainActor.run { } wrappers from tests.
These are causing 4-second timeouts because test classes already inherit from @MainActor BaseTestClass.
"""

import re
from pathlib import Path

def fix_mainactor_wrapper(content: str) -> tuple[str, int]:
    """Remove await MainActor.run { } wrappers. Returns (fixed_content, fixes_count)"""
    fixes = 0
    
    # Pattern 1: Simple wrapper with return statement
    # await MainActor.run { return ... }
    pattern1 = r'(\s+)let\s+(\w+)\s*=\s*await\s+MainActor\.run\s*\{\s*\n(\s+)return\s+(.+?)\s*\n(\s+)\}'
    def replace1(match):
        nonlocal fixes
        fixes += 1
        indent = match.group(1)
        var_name = match.group(2)
        return_indent = match.group(3)
        return_expr = match.group(4)
        closing_indent = match.group(5)
        return f"{indent}let {var_name} = {return_expr}"
    
    content = re.sub(pattern1, replace1, content, flags=re.MULTILINE | re.DOTALL)
    
    # Pattern 2: Wrapper with code block (more complex)
    # await MainActor.run { ... code ... }
    lines = content.split('\n')
    new_lines = []
    i = 0
    
    while i < len(lines):
        line = lines[i]
        
        # Check if this line starts await MainActor.run {
        match = re.match(r'(\s+)(let\s+\w+\s*=\s*)?await\s+MainActor\.run\s*\{', line)
        if match:
            indent = match.group(1)
            prefix = match.group(2) or ''
            brace_count = 1
            start_i = i
            i += 1
            
            # Collect lines until closing brace
            block_lines = []
            while i < len(lines) and brace_count > 0:
                current_line = lines[i]
                brace_count += current_line.count('{') - current_line.count('}')
                if brace_count > 0:
                    block_lines.append(current_line)
                i += 1
            
            # Remove 4 spaces of indentation from block lines
            fixed_block = []
            for block_line in block_lines:
                if block_line.strip():
                    # Remove 4 spaces if present
                    if block_line.startswith(' ' * (len(indent) + 4)):
                        fixed_block.append(block_line[4:])
                    else:
                        fixed_block.append(block_line)
                else:
                    fixed_block.append('')
            
            # Add prefix if it was a let statement
            if prefix:
                new_lines.append(f"{indent}{prefix}{fixed_block[0] if fixed_block else ''}")
                new_lines.extend(fixed_block[1:])
            else:
                new_lines.extend(fixed_block)
            
            fixes += 1
        else:
            new_lines.append(line)
            i += 1
    
    return '\n'.join(new_lines), fixes

def fix_file(file_path: Path) -> bool:
    """Fix a test file. Returns True if changes were made."""
    try:
        content = file_path.read_text(encoding='utf-8')
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return False
    
    if 'await MainActor.run' not in content:
        return False
    
    original = content
    fixed, count = fix_mainactor_wrapper(content)
    
    if count > 0 and fixed != original:
        try:
            file_path.write_text(fixed, encoding='utf-8')
            print(f"Fixed {file_path}: removed {count} MainActor.run wrapper(s)")
            return True
        except Exception as e:
            print(f"Error writing {file_path}: {e}")
            return False
    
    return False

def main():
    """Fix all remaining test files."""
    test_dir = Path('Development/Tests')
    fixed_count = 0
    
    for swift_file in test_dir.rglob('*.swift'):
        if fix_file(swift_file):
            fixed_count += 1
    
    print(f"\nFixed {fixed_count} files")

if __name__ == '__main__':
    main()

