#!/usr/bin/env python3
"""
Remove @Suite annotations that appear between or before import statements,
and re-add them in the correct location (before the class/struct declaration).
"""

import re
import sys
from pathlib import Path

def extract_suite_name(class_name: str) -> str:
    """Extract a readable suite name from a class/struct name."""
    name = class_name.replace("Tests", "").replace("Test", "")
    words = re.findall(r'[A-Z][a-z]*|[a-z]+', name)
    return " ".join(words)

def fix_suite_placement(file_path: Path) -> bool:
    """Fix @Suite annotations incorrectly placed. Returns True if modified."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = list(f)
    except Exception as e:
        print(f"Error reading {file_path}: {e}", file=sys.stderr)
        return False
    
    # First pass: remove all @Suite annotations that are between imports or before imports
    new_lines = []
    removed_suites = []
    
    for i, line in enumerate(lines):
        stripped = line.strip()
        
        # If this is a @Suite, check if it's incorrectly placed
        if stripped.startswith("@Suite") and not stripped.startswith("//"):
            # Check if next non-empty line is an import
            next_is_import = False
            for j in range(i + 1, min(i + 5, len(lines))):
                next_stripped = lines[j].strip()
                if not next_stripped or next_stripped.startswith("//"):
                    continue
                if next_stripped.startswith("import"):
                    next_is_import = True
                    break
                if next_stripped:  # Hit a non-empty, non-comment line
                    break
            
            # Also check if previous line was an import or @testable
            prev_is_import = False
            if i > 0:
                prev_stripped = lines[i - 1].strip()
                if prev_stripped.startswith("import") or prev_stripped.startswith("@testable"):
                    prev_is_import = True
            
            # If @Suite is between imports or right after imports, remove it
            if prev_is_import or next_is_import:
                # Extract suite name
                match = re.search(r'@Suite\("([^"]+)"\)', stripped)
                if match:
                    removed_suites.append(match.group(1))
                # Don't add this line - skip it
                continue
        
        new_lines.append(line)
    
    # Second pass: find class/struct declarations and add @Suite if missing
    final_lines = []
    i = 0
    
    while i < len(new_lines):
        line = new_lines[i]
        stripped = line.strip()
        
        # Find class/struct declarations
        match = re.search(r'(?:open\s+)?(class|struct)\s+(\w+Tests?)(?:\s*[:{])', line)
        if match:
            class_line_idx = i
            
            # Check if there's already a @Suite before this class (within 10 lines)
            has_suite = False
            for j in range(max(0, len(final_lines) - 10), len(final_lines)):
                check_line = final_lines[j].strip()
                if check_line.startswith("@Suite") and not check_line.startswith("//"):
                    has_suite = True
                    break
            
            if not has_suite:
                # Determine suite name
                if removed_suites:
                    suite_name = removed_suites.pop(0)
                else:
                    class_name = match.group(2)
                    suite_name = extract_suite_name(class_name)
                
                # Find insertion point: before @MainActor/@available, or before class
                insert_idx = len(final_lines)
                for j in range(len(final_lines) - 1, max(-1, len(final_lines) - 10), -1):
                    if j < 0:
                        break
                    check_line = final_lines[j].strip()
                    if check_line.startswith("@MainActor") or check_line.startswith("@available"):
                        insert_idx = j
                        break
                    elif check_line and not check_line.startswith("//") and not check_line.startswith("import"):
                        # Don't go past non-comment, non-import lines
                        break
                
                # Make sure we're not inserting before imports
                for j in range(max(0, insert_idx - 5), min(insert_idx, len(final_lines))):
                    if j < len(final_lines) and final_lines[j].strip().startswith("import"):
                        insert_idx = len(final_lines)  # Insert right before current line (class)
                        break
                
                final_lines.insert(insert_idx, f'@Suite("{suite_name}")\n')
        
        final_lines.append(line)
        i += 1
    
    # Check if we made changes
    if len(final_lines) != len(lines):
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.writelines(final_lines)
            print(f"✓ Fixed {file_path.name}")
            return True
        except Exception as e:
            print(f"Error writing {file_path}: {e}", file=sys.stderr)
            return False
    
    # Also check if content changed (removed and re-added in same place)
    if removed_suites:
        # Content might have changed
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
        if fix_suite_placement(test_file):
            modified_count += 1
    
    print(f"\n✓ Fixed {modified_count} files")

if __name__ == "__main__":
    main()

