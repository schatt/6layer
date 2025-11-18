#!/usr/bin/env python3
"""
Fix duplicate 'let' statements created by the MainActor.run removal script.
Pattern: let hasAccessibilityID = let view = ...
Should be: let view = ...; let hasAccessibilityID = ...
"""

import re
from pathlib import Path

def fix_file(file_path: Path) -> bool:
    """Fix duplicate let statements in a file."""
    try:
        content = file_path.read_text(encoding='utf-8')
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return False
    
    if 'let hasAccessibilityID =         let view =' not in content:
        return False
    
    original = content
    
    # Pattern: let hasAccessibilityID =         let view = ... (with return statement)
    # Replace with: let view = ...; let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform(...)
    
    # First, fix the pattern where there's a return statement
    pattern1 = r'let hasAccessibilityID =         let view = ([^=]+?)\n(\s+)return testAccessibilityIdentifiersSinglePlatform\('
    def replace1(match):
        view_creation = match.group(1).strip()
        indent = match.group(2)
        return f'let view = {view_creation}\n{indent}let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform('
    
    content = re.sub(pattern1, replace1, content, flags=re.MULTILINE | re.DOTALL)
    
    # Pattern: let hasAccessibilityID =         let view = ... (without return, just continuation)
    pattern2 = r'let hasAccessibilityID =         let view = ([^=]+?)\n(\s+)//'
    def replace2(match):
        view_creation = match.group(1).strip()
        indent = match.group(2)
        return f'let view = {view_creation}\n{indent}//'
    
    content = re.sub(pattern2, replace2, content, flags=re.MULTILINE | re.DOTALL)
    
    # More general pattern - find the duplicate let and fix it
    lines = content.split('\n')
    new_lines = []
    i = 0
    
    while i < len(lines):
        line = lines[i]
        
        # Check for the duplicate let pattern
        if 'let hasAccessibilityID =         let view =' in line:
            # Extract the view creation part
            match = re.match(r'(\s+)let hasAccessibilityID =         let view = (.+)', line)
            if match:
                indent = match.group(1)
                view_creation = match.group(2)
                
                # Find where the view creation ends (next line that's not indented more)
                view_lines = [f"{indent}let view = {view_creation}"]
                i += 1
                
                # Collect continuation lines for view creation
                while i < len(lines) and (lines[i].strip().startswith('(') or 
                                         lines[i].strip().startswith(',') or
                                         (lines[i].strip() and len(lines[i]) - len(lines[i].lstrip()) > len(indent))):
                    view_lines.append(lines[i])
                    i += 1
                
                # Now find the return/testAccessibilityIdentifiersSinglePlatform line
                if i < len(lines):
                    next_line = lines[i]
                    if 'return testAccessibilityIdentifiersSinglePlatform' in next_line:
                        # Replace return with let hasAccessibilityID =
                        next_line = next_line.replace('return testAccessibilityIdentifiersSinglePlatform', 
                                                       'let hasAccessibilityID = testAccessibilityIdentifiersSinglePlatform')
                        new_lines.extend(view_lines)
                        new_lines.append(next_line)
                        i += 1
                        continue
                    elif 'testAccessibilityIdentifiersSinglePlatform' in next_line:
                        # Add let hasAccessibilityID = before it
                        indent_level = len(next_line) - len(next_line.lstrip())
                        next_line = ' ' * indent_level + 'let hasAccessibilityID = ' + next_line.lstrip()
                        new_lines.extend(view_lines)
                        new_lines.append(next_line)
                        i += 1
                        continue
                
                new_lines.extend(view_lines)
            else:
                new_lines.append(line)
                i += 1
        else:
            new_lines.append(line)
            i += 1
    
    content = '\n'.join(new_lines)
    
    if content != original:
        try:
            file_path.write_text(content, encoding='utf-8')
            print(f"Fixed {file_path}")
            return True
        except Exception as e:
            print(f"Error writing {file_path}: {e}")
            return False
    
    return False

def main():
    """Fix all files with duplicate let statements."""
    test_dir = Path('Development/Tests')
    fixed_count = 0
    
    for swift_file in test_dir.rglob('*.swift'):
        if fix_file(swift_file):
            fixed_count += 1
    
    print(f"\nFixed {fixed_count} files")

if __name__ == '__main__':
    main()


