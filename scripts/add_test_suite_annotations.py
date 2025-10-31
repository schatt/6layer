#!/usr/bin/env python3
"""
Add @Suite annotations to Swift Testing test classes/structs.

This script:
1. Finds all test files (*Tests.swift)
2. Identifies test classes/structs that contain @Test functions
3. Adds @Suite annotations with meaningful names
4. Preserves existing @Suite annotations
"""

import re
import os
import sys
from pathlib import Path

def extract_suite_name(class_name: str) -> str:
    """Extract a readable suite name from a class/struct name."""
    # Remove common suffixes
    name = class_name.replace("Tests", "").replace("Test", "")
    
    # Convert CamelCase to readable format
    # Split on capital letters
    words = re.findall(r'[A-Z][a-z]*|[a-z]+', name)
    return " ".join(words)

def has_test_functions(content: str) -> bool:
    """Check if the file contains @Test functions."""
    return "@Test" in content or "@Test(" in content

def find_test_class_or_struct(lines: list[str]) -> tuple[int, str, bool] | None:
    """
    Find the first test class or struct definition.
    Returns: (line_index, class_name, is_class) or None
    """
    for i, line in enumerate(lines):
        # Match: open class ClassName: BaseClass
        # Match: class ClassName: BaseClass  
        # Match: struct StructName {
        match = re.search(r'(?:open\s+)?(class|struct)\s+(\w+Tests?)(?:\s*[:{])', line)
        if match:
            is_class = match.group(1) == "class"
            class_name = match.group(2)
            return (i, class_name, is_class)
    return None

def already_has_suite(lines: list[str], class_line: int) -> bool:
    """Check if class already has @Suite annotation."""
    # Look at lines before the class declaration (up to 10 lines back)
    start = max(0, class_line - 10)
    for line in lines[start:class_line]:
        stripped = line.strip()
        # Check for @Suite but not as part of a comment
        if "@Suite" in stripped and not stripped.startswith("//"):
            return True
    return False

def add_suite_annotation(lines: list[str], class_line: int, suite_name: str) -> list[str]:
    """Add @Suite annotation before the class declaration."""
    # Find where to insert: right before the class/struct or before @MainActor/@available
    insert_line = class_line
    
    # Walk backwards looking ONLY for Swift attributes (@MainActor, @available, etc.)
    # or comments, stopping at first non-empty, non-comment, non-attribute line
    for i in range(class_line - 1, max(-1, class_line - 15), -1):
        if i < 0:
            break
        line = lines[i]
        stripped = line.strip()
        
        # Skip empty lines and comments
        if not stripped or stripped.startswith("//") or stripped.startswith("/*") or stripped.startswith("*"):
            continue
        
        # If it's a Swift attribute, we want to insert before it
        if stripped.startswith("@") and not stripped.startswith("@testable"):
            # Found an attribute like @MainActor, @available, etc.
            insert_line = i
            break
        
        # If we hit something that's not an attribute, comment, or empty line,
        # stop here - we'll insert right before the class
        if not stripped.startswith("import") and not stripped.startswith("@"):
            break
    
    # Don't insert before import statements - if we ended up before imports, use class_line
    for i in range(max(0, insert_line - 1), class_line):
        if i >= len(lines):
            break
        if lines[i].strip().startswith("import"):
            insert_line = class_line
            break
    
    # Insert the @Suite annotation
    suite_annotation = f'@Suite("{suite_name}")\n'
    
    # Insert at the calculated position
    lines.insert(insert_line, suite_annotation)
    
    return lines

def process_file(file_path: Path) -> bool:
    """Process a single test file. Returns True if modified."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            lines = f.readlines()
    except Exception as e:
        print(f"Error reading {file_path}: {e}", file=sys.stderr)
        return False
    
    # Only process files with test functions
    if not has_test_functions(content):
        return False
    
    # Reset file pointer
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = list(f)
    
    result = find_test_class_or_struct(lines)
    if not result:
        return False
    
    class_line, class_name, is_class = result
    
    # Skip if already has @Suite
    if already_has_suite(lines, class_line):
        return False
    
    # Generate suite name
    suite_name = extract_suite_name(class_name)
    
    # Add the annotation
    lines = add_suite_annotation(lines, class_line, suite_name)
    
    # Write back
    try:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.writelines(lines)
        print(f"✓ Added @Suite to {file_path.name}: '{suite_name}'")
        return True
    except Exception as e:
        print(f"Error writing {file_path}: {e}", file=sys.stderr)
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
    
    print(f"Found {len(test_files)} test files")
    print("Processing files...\n")
    
    modified_count = 0
    for test_file in sorted(test_files):
        if process_file(test_file):
            modified_count += 1
    
    print(f"\n✓ Processed {modified_count} files")
    print(f"  {len(test_files) - modified_count} files already had @Suite or no test classes found")

if __name__ == "__main__":
    main()

