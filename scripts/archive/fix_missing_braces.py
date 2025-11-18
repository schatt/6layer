#!/usr/bin/env python3
"""
Fix missing closing braces in Swift test files
Following TDD, DRY, DTRT, and epistemological principles
"""

import os
import re
from pathlib import Path

def fix_missing_braces(file_path):
    """Fix missing closing braces in a Swift test file"""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    
    # Count opening and closing braces
    open_braces = content.count('{')
    close_braces = content.count('}')
    
    # If we have more opening braces than closing braces, add the missing ones
    missing_braces = open_braces - close_braces
    
    if missing_braces > 0:
        # Add the missing closing braces at the end
        content += '\n' + '}' * missing_braces
    
    if content != original_content:
        with open(file_path, 'w') as f:
            f.write(content)
        return True
    return False

def main():
    """Main function to fix missing braces"""
    test_dir = "/Users/schatt/code/github/6layer/Development/Tests"
    
    print("Fixing missing closing braces...")
    
    swift_files = list(Path(test_dir).rglob("*.swift"))
    fixed_files = 0
    
    for file_path in swift_files:
        try:
            if fix_missing_braces(file_path):
                fixed_files += 1
                print(f"Fixed: {file_path}")
        except Exception as e:
            print(f"Error fixing {file_path}: {e}")
    
    print(f"Fixed {fixed_files} files with missing braces")

if __name__ == "__main__":
    main()
