#!/usr/bin/env python3
"""
Remove duplicate @Suite annotations from test files.

This script finds files with multiple @Suite annotations on the same class/struct
and removes duplicates, keeping only the first one.
"""

import re
import os
from pathlib import Path

def remove_duplicate_suites(file_path: Path) -> bool:
    """Remove duplicate @Suite annotations from a file. Returns True if modified."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = list(f)
    except Exception as e:
        print(f"Error reading {file_path}: {e}", file=sys.stderr)
        return False
    
    modified = False
    new_lines = []
    i = 0
    
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        
        # Check if this is a @Suite annotation
        if stripped.startswith("@Suite") and not stripped.startswith("//"):
            # Check if we already have a @Suite in the recent lines (within 5 lines)
            has_suite_recent = False
            for j in range(max(0, len(new_lines) - 5), len(new_lines)):
                if "@Suite" in new_lines[j] and not new_lines[j].strip().startswith("//"):
                    has_suite_recent = True
                    break
            
            if has_suite_recent:
                # Skip this duplicate
                modified = True
                i += 1
                continue
        
        new_lines.append(line)
        i += 1
    
    if modified:
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.writelines(new_lines)
            print(f"✓ Fixed duplicates in {file_path.name}")
            return True
        except Exception as e:
            print(f"Error writing {file_path}: {e}", file=sys.stderr)
            return False
    
    return False

def main():
    """Main script entry point."""
    import sys
    
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    test_dir = project_root / "Development" / "Tests" / "SixLayerFrameworkTests"
    
    if not test_dir.exists():
        print(f"Error: Test directory not found: {test_dir}", file=sys.stderr)
        sys.exit(1)
    
    # Find all test files
    test_files = list(test_dir.rglob("*Tests.swift"))
    
    print(f"Checking {len(test_files)} test files for duplicate @Suite annotations...\n")
    
    modified_count = 0
    for test_file in sorted(test_files):
        if remove_duplicate_suites(test_file):
            modified_count += 1
    
    print(f"\n✓ Fixed {modified_count} files with duplicate @Suite annotations")

if __name__ == "__main__":
    main()

