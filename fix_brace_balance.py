#!/usr/bin/env python3
"""
Fix brace balance in Swift test files
Following TDD, DRY, DTRT, and epistemological principles
"""

import os
import re
from pathlib import Path

def fix_brace_balance(file_path):
    """Fix brace balance in a Swift test file"""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    
    # Count braces more carefully
    lines = content.split('\n')
    brace_count = 0
    fixed_lines = []
    
    for line in lines:
        # Count opening and closing braces in this line
        open_braces = line.count('{')
        close_braces = line.count('}')
        
        # Update the running count
        brace_count += open_braces - close_braces
        
        # If we have negative brace count, it means we have too many closing braces
        if brace_count < 0:
            # Remove excess closing braces
            excess_braces = -brace_count
            line = line.replace('}', '', excess_braces)
            brace_count = 0
        
        fixed_lines.append(line)
    
    # If we still have positive brace count, add the missing closing braces at the end
    if brace_count > 0:
        # Add the missing closing braces at the end
        fixed_lines.append('}' * brace_count)
    
    fixed_content = '\n'.join(fixed_lines)
    
    if fixed_content != original_content:
        with open(file_path, 'w') as f:
            f.write(fixed_content)
        return True
    return False

def main():
    """Main function to fix brace balance"""
    test_dir = "/Users/schatt/code/github/6layer/Development/Tests"
    
    print("Fixing brace balance...")
    
    swift_files = list(Path(test_dir).rglob("*.swift"))
    fixed_files = 0
    
    for file_path in swift_files:
        try:
            if fix_brace_balance(file_path):
                fixed_files += 1
                print(f"Fixed: {file_path}")
        except Exception as e:
            print(f"Error fixing {file_path}: {e}")
    
    print(f"Fixed {fixed_files} files with brace balance issues")

if __name__ == "__main__":
    main()
