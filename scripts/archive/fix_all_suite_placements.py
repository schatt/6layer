#!/usr/bin/env python3
"""
Comprehensive fix for @Suite annotation placement.
Moves all @Suite annotations to the correct location (before class/struct, after imports).
"""

import re
import sys
from pathlib import Path

def extract_suite_name(class_name: str) -> str:
    """Extract a readable suite name from a class/struct name."""
    name = class_name.replace("Tests", "").replace("Test", "")
    words = re.findall(r'[A-Z][a-z]*|[a-z]+', name)
    return " ".join(words)

def fix_file(file_path: Path) -> bool:
    """Fix @Suite annotations in a file. Returns True if modified."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = list(f)
    except Exception as e:
        print(f"Error reading {file_path}: {e}", file=sys.stderr)
        return False
    
    # Step 1: Find all @Suite annotations and their names, remove them
    suite_names = {}
    new_lines = []
    
    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith("@Suite") and not stripped.startswith("//"):
            match = re.search(r'@Suite\("([^"]+)"\)', stripped)
            if match:
                suite_name = match.group(1)
                # Store it, we'll add it back later
                continue  # Skip this line
        
        new_lines.append(line)
    
    # Step 2: Find class/struct declarations and add @Suite before them
    final_lines = []
    i = 0
    
    while i < len(new_lines):
        line = new_lines[i]
        stripped = line.strip()
        
        # Find class/struct declarations
        match = re.search(r'(?:open\s+)?(class|struct)\s+(\w+Tests?)(?:\s*[:{])', line)
        if match:
            class_name = match.group(2)
            class_line_idx = i
            
            # Check if there's already a @Suite before this class (within 15 lines)
            has_suite = False
            for j in range(max(0, len(final_lines) - 15), len(final_lines)):
                check_line = final_lines[j].strip()
                if check_line.startswith("@Suite") and not check_line.startswith("//"):
                    has_suite = True
                    break
            
            if not has_suite:
                # Determine suite name
                suite_name = extract_suite_name(class_name)
                
                # Find insertion point: before @MainActor/@available, or before class
                insert_idx = len(final_lines)
                
                # Walk backwards from current position
                for j in range(len(final_lines) - 1, max(-1, len(final_lines) - 15), -1):
                    if j < 0:
                        break
                    check_line = final_lines[j].strip()
                    
                    # Skip empty lines and comments
                    if not check_line or check_line.startswith("//") or check_line.startswith("/*"):
                        continue
                    
                    # Found an attribute - insert before it
                    if check_line.startswith("@MainActor") or check_line.startswith("@available"):
                        insert_idx = j
                        break
                    
                    # Hit something that's not an attribute, comment, or import
                    if not check_line.startswith("import") and not check_line.startswith("@testable") and not check_line.startswith("@"):
                        break
                
                # Safety check: don't insert before imports
                for j in range(max(0, insert_idx - 5), min(insert_idx, len(final_lines))):
                    if j < len(final_lines):
                        check_line = final_lines[j].strip()
                        if check_line.startswith("import") or check_line.startswith("@testable"):
                            # We're too close to imports, use class line position
                            insert_idx = len(final_lines)
                            break
                
                # Insert the @Suite annotation
                final_lines.insert(insert_idx, f'@Suite("{suite_name}")\n')
        
        final_lines.append(line)
        i += 1
    
    # Check if we made changes
    if final_lines != lines:
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.writelines(final_lines)
            print(f"✓ Fixed {file_path.name}")
            return True
        except Exception as e:
            print(f"Error writing {file_path}: {e}", file=sys.stderr)
            return False
    
    return False

def main():
    """Main script entry point."""
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    test_dir = project_root / "Development" / "Tests" / "SixLayerFrameworkTests"
    
    if not test_dir.exists():
        print(f"Error: Test directory not found: {test_dir}", file=sys.stderr)
        sys.exit(1)
    
    # Find all test files
    test_files = list(test_dir.rglob("*Tests.swift"))
    
    print(f"Fixing @Suite annotations in {len(test_files)} files...\n")
    
    modified_count = 0
    for test_file in sorted(test_files):
        if fix_file(test_file):
            modified_count += 1
    
    print(f"\n✓ Fixed {modified_count} files")

if __name__ == "__main__":
    main()

