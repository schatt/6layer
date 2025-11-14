#!/usr/bin/env python3
"""
Script to update deprecated .automaticAccessibilityIdentifiers() calls to .automaticCompliance()

Replaces:
- .automaticAccessibilityIdentifiers() → .automaticCompliance()
- .automaticAccessibilityIdentifiers(named: "...") → .automaticCompliance(named: "...")
- .enableGlobalAutomaticAccessibilityIdentifiers() → .enableGlobalAutomaticCompliance()
"""

import os
import re
import sys
from pathlib import Path

def update_file(file_path: Path) -> int:
    """Update deprecated calls in a single file. Returns number of replacements made."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading {file_path}: {e}", file=sys.stderr)
        return 0
    
    original_content = content
    replacements = 0
    
    # Pattern 1: .automaticAccessibilityIdentifiers() - no parameters
    pattern1 = r'\.automaticAccessibilityIdentifiers\(\)'
    matches1 = re.findall(pattern1, content)
    if matches1:
        content = re.sub(pattern1, '.automaticCompliance()', content)
        replacements += len(matches1)
    
    # Pattern 2: .automaticAccessibilityIdentifiers(named: "...")
    # This is more complex - need to match the named parameter with its value
    pattern2 = r'\.automaticAccessibilityIdentifiers\(named:\s*([^)]+)\)'
    matches2 = list(re.finditer(pattern2, content))
    if matches2:
        for match in reversed(matches2):  # Reverse to maintain positions
            named_value = match.group(1)
            replacement = f'.automaticCompliance(named: {named_value})'
            content = content[:match.start()] + replacement + content[match.end():]
            replacements += 1
    
    # Pattern 3: .enableGlobalAutomaticAccessibilityIdentifiers()
    pattern3 = r'\.enableGlobalAutomaticAccessibilityIdentifiers\(\)'
    matches3 = re.findall(pattern3, content)
    if matches3:
        content = re.sub(pattern3, '.enableGlobalAutomaticCompliance()', content)
        replacements += len(matches3)
    
    # Only write if changes were made
    if content != original_content:
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return replacements
        except Exception as e:
            print(f"Error writing {file_path}: {e}", file=sys.stderr)
            return 0
    
    return 0

def main():
    """Main function to update all Swift files."""
    # Get the project root (assuming script is in project root)
    project_root = Path(__file__).parent
    
    # Directories to search
    search_dirs = [
        project_root / 'Framework' / 'Sources',
        project_root / 'Development' / 'Tests',
    ]
    
    total_replacements = 0
    total_files_changed = 0
    
    for search_dir in search_dirs:
        if not search_dir.exists():
            print(f"Warning: Directory {search_dir} does not exist, skipping...", file=sys.stderr)
            continue
        
        # Find all Swift files
        swift_files = list(search_dir.rglob('*.swift'))
        
        for swift_file in swift_files:
            replacements = update_file(swift_file)
            if replacements > 0:
                total_replacements += replacements
                total_files_changed += 1
                print(f"Updated {swift_file.relative_to(project_root)}: {replacements} replacement(s)")
    
    print(f"\nSummary:")
    print(f"  Files changed: {total_files_changed}")
    print(f"  Total replacements: {total_replacements}")

if __name__ == '__main__':
    main()

