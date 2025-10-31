#!/usr/bin/env python3
"""Add missing 'import Testing' to files that use @Suite but don't import Testing."""

import re
import sys
from pathlib import Path

def fix_file(file_path: Path) -> bool:
    """Add import Testing if missing. Returns True if modified."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = list(f)
    except Exception as e:
        print(f"Error reading {file_path}: {e}", file=sys.stderr)
        return False
    
    # Check if file has @Suite but no import Testing
    has_suite = any('@Suite' in line and not line.strip().startswith('//') for line in lines)
    has_import_testing = any('import Testing' in line for line in lines)
    
    if not has_suite or has_import_testing:
        return False
    
    # Find where to insert import Testing (after other imports)
    insert_idx = 0
    for i, line in enumerate(lines):
        stripped = line.strip()
        # Skip comments and empty lines at start
        if not stripped or stripped.startswith('//') or stripped.startswith('/*'):
            continue
        # If we hit an import, find the last import line
        if stripped.startswith('import ') or stripped.startswith('@testable'):
            insert_idx = i + 1
        elif stripped.startswith('@') and not stripped.startswith('@testable'):
            # Hit something like @preconcurrency, insert before it
            break
        else:
            # Hit non-import, non-comment line - insert before it
            break
    
    # Insert import Testing
    lines.insert(insert_idx, 'import Testing\n')
    
    try:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.writelines(lines)
        print(f"✓ Added import Testing to {file_path.name}")
        return True
    except Exception as e:
        print(f"Error writing {file_path}: {e}", file=sys.stderr)
        return False

def main():
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    test_dir = project_root / "Development" / "Tests" / "SixLayerFrameworkTests"
    
    test_files = list(test_dir.rglob("*Tests.swift"))
    
    print(f"Checking {len(test_files)} files for missing 'import Testing'...\n")
    
    modified_count = 0
    for test_file in sorted(test_files):
        if fix_file(test_file):
            modified_count += 1
    
    print(f"\n✓ Fixed {modified_count} files")

if __name__ == "__main__":
    main()

