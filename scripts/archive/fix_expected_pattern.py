#!/usr/bin/env python3
"""
Script to fix incorrect expected pattern in accessibility tests.
Fixes: "SixLayer.main.ui.element.*" -> "SixLayer.main.ui.*"
"""

import re
from pathlib import Path

def fix_pattern(file_path: Path) -> bool:
    """Fix expected pattern in a single file."""
    try:
        content = file_path.read_text(encoding='utf-8')
        original = content
        
        # Replace the incorrect pattern
        content = content.replace(
            'expectedPattern: "SixLayer.main.ui.element.*"',
            'expectedPattern: "SixLayer.main.ui.*"'
        )
        
        if content != original:
            file_path.write_text(content, encoding='utf-8')
            return True
        return False
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False

def main():
    """Main entry point."""
    test_dir = Path("Development/Tests/SixLayerFrameworkTests")
    
    if not test_dir.exists():
        print(f"Error: Test directory not found: {test_dir}")
        return
    
    # Find all Swift test files
    test_files = list(test_dir.rglob("*.swift"))
    
    fixed_count = 0
    for file_path in test_files:
        if fix_pattern(file_path):
            print(f"Fixed: {file_path}")
            fixed_count += 1
    
    print(f"\nFixed {fixed_count} files")

if __name__ == "__main__":
    main()

