#!/usr/bin/env python3
"""
Remove @Suite annotations that were incorrectly placed before import statements.

This script finds @Suite annotations that appear before import statements
(which is invalid) and moves them to the correct location (before the class/struct).
"""

import re
import sys
from pathlib import Path

def fix_suite_placement(file_path: Path) -> bool:
    """Fix @Suite annotations placed incorrectly before imports. Returns True if modified."""
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
            # Check if the next non-empty, non-comment line is an import
            next_import = False
            for j in range(i + 1, min(i + 5, len(lines))):
                next_line = lines[j].strip()
                if not next_line or next_line.startswith("//"):
                    continue
                if next_line.startswith("import"):
                    next_import = True
                    break
                if next_line and not next_line.startswith("//") and not next_line.startswith("@"):
                    break
            
            if next_import:
                # This @Suite is before an import - we need to remove it
                # and find the correct place (before the class/struct)
                suite_line = line
                suite_match = re.search(r'@Suite\("([^"]+)"\)', suite_line)
                suite_name = suite_match.group(1) if suite_match else "Test Suite"
                
                # Find the class/struct declaration
                class_line_idx = None
                for j in range(i, len(lines)):
                    match = re.search(r'(?:open\s+)?(class|struct)\s+(\w+Tests?)(?:\s*[:{])', lines[j])
                    if match:
                        class_line_idx = j
                        break
                
                if class_line_idx is not None:
                    # Check if there's already a @Suite before the class
                    has_suite = False
                    for j in range(max(0, class_line_idx - 10), class_line_idx):
                        if "@Suite" in lines[j] and not lines[j].strip().startswith("//"):
                            has_suite = True
                            break
                    
                    if not has_suite:
                        # Insert @Suite before the class (before @MainActor if present)
                        insert_idx = class_line_idx
                        for j in range(class_line_idx - 1, max(-1, class_line_idx - 10), -1):
                            if j < 0:
                                break
                            check_line = lines[j].strip()
                            if check_line.startswith("@MainActor") or check_line.startswith("@available"):
                                insert_idx = j
                                break
                            elif check_line and not check_line.startswith("//") and not check_line.startswith("import"):
                                break
                        
                        # Remove the incorrectly placed @Suite (don't add to new_lines)
                        modified = True
                        i += 1
                        # We'll add it in the right place when we get there
                        continue
        
        new_lines.append(line)
        i += 1
    
    # Now do a second pass to insert @Suite in correct locations if we removed any
    if modified:
        final_lines = []
        i = 0
        
        while i < len(new_lines):
            line = new_lines[i]
            stripped = line.strip()
            
            # Find class/struct declarations
            match = re.search(r'(?:open\s+)?(class|struct)\s+(\w+Tests?)(?:\s*[:{])', line)
            if match:
                # Check if there's already a @Suite before this class
                has_suite = False
                for j in range(max(0, len(final_lines) - 10), len(final_lines)):
                    if "@Suite" in final_lines[j] and not final_lines[j].strip().startswith("//"):
                        has_suite = True
                        break
                
                if not has_suite:
                    # Extract class name for suite name
                    class_name = match.group(2)
                    suite_name = class_name.replace("Tests", "").replace("Test", "")
                    words = re.findall(r'[A-Z][a-z]*|[a-z]+', suite_name)
                    suite_name = " ".join(words)
                    
                    # Insert @Suite before @MainActor if present, otherwise before class
                    insert_idx = len(final_lines)
                    for j in range(len(final_lines) - 1, max(-1, len(final_lines) - 10), -1):
                        if j < 0:
                            break
                        check_line = final_lines[j].strip()
                        if check_line.startswith("@MainActor") or check_line.startswith("@available"):
                            insert_idx = j
                            break
                        elif check_line and not check_line.startswith("//") and not check_line.startswith("import"):
                            break
                    
                    final_lines.insert(insert_idx, f'@Suite("{suite_name}")\n')
            
            final_lines.append(line)
            i += 1
        
        new_lines = final_lines
    
    if modified:
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.writelines(new_lines)
            print(f"✓ Fixed @Suite placement in {file_path.name}")
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
    
    print(f"Fixing @Suite annotations incorrectly placed before imports in {len(test_files)} files...\n")
    
    modified_count = 0
    for test_file in sorted(test_files):
        if fix_suite_placement(test_file):
            modified_count += 1
    
    print(f"\n✓ Fixed {modified_count} files")

if __name__ == "__main__":
    main()

