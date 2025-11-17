#!/usr/bin/env python3
"""
Convert shared test data from init() to computed properties.
Each test should get fresh data, not shared state.
"""

import re
import sys
from pathlib import Path

def fix_shared_test_data(file_path):
    """Convert init() data initialization to computed properties."""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    changes = []
    
    # Pattern 1: var sampleData: [Type] = [] followed by init() that sets it
    # Convert to: var sampleData: [Type] { ... }
    
    # Find: var sampleData: [Type] = []\n    \n    init() async throws {\n        sampleData = [...]
    pattern1 = r'(\s+)(var sampleData: \[.*?\] = \[\])\s*\n\s*\n\s*init\(\)\s+async\s+throws\s+\{\s*\n\s*sampleData\s*=\s*(\[[\s\S]*?\])\s*\n\s*\}'
    
    def convert_to_computed(match):
        indent = match.group(1)
        var_decl = match.group(2)
        data_init = match.group(3)
        # Convert var to computed property
        var_decl = var_decl.replace('var ', 'var ').replace(' = []', '')
        return f'{indent}var {var_decl.split(":")[0].replace("var ", "")}: {var_decl.split(":")[1]} {{\n{indent}    return {data_init}\n{indent}}}\n{indent}// BaseTestClass handles setup automatically - no init() needed'
    
    new_content = re.sub(pattern1, convert_to_computed, content, flags=re.MULTILINE)
    
    # Pattern 2: Simple init() async throws that just sets data
    # init() async throws {\n        sampleData = [...]\n    }
    pattern2 = r'(\s+)init\(\)\s+async\s+throws\s+\{\s*\n\s*sampleData\s*=\s*(\[[\s\S]*?\])\s*\n\s*\}'
    
    def remove_simple_init(match):
        indent = match.group(1)
        return f'{indent}// BaseTestClass handles setup automatically - data created as computed property'
    
    # Only apply if we didn't already convert it
    if new_content == content:
        new_content = re.sub(pattern2, remove_simple_init, new_content, flags=re.MULTILINE)
    
    # Pattern 3: Multiple property initializations in init()
    # init() async throws {\n        prop1 = ...\n        prop2 = ...\n    }
    pattern3 = r'(\s+)init\(\)\s+async\s+throws\s+\{\s*\n((?:\s+[a-zA-Z][a-zA-Z0-9_]*\s*=\s*[^\n]+\n)+)\s*\}'
    
    def convert_multiple_props(match):
        indent = match.group(1)
        props = match.group(2)
        # Extract property assignments
        prop_lines = [line.strip() for line in props.strip().split('\n') if '=' in line]
        computed_props = []
        for prop_line in prop_lines:
            if '=' in prop_line:
                prop_name, prop_value = prop_line.split('=', 1)
                prop_name = prop_name.strip()
                prop_value = prop_value.strip()
                computed_props.append(f'{indent}var {prop_name}: {prop_value.split("(")[0].strip()} {{\n{indent}    return {prop_value}\n{indent}}}')
        return '\n'.join(computed_props) + f'\n{indent}// BaseTestClass handles setup automatically - no init() needed'
    
    # Only apply if pattern matches and hasn't been converted
    if 'init() async throws' in new_content:
        new_content = re.sub(pattern3, convert_multiple_props, new_content, flags=re.MULTILINE)
    
    if new_content != original_content:
        changes.append(f"Converted shared data to computed properties in {file_path}")
        with open(file_path, 'w') as f:
            f.write(new_content)
    
    return changes

def main():
    test_files = Path('Development/Tests').rglob('*Tests.swift')
    
    all_changes = []
    for test_file in test_files:
        try:
            changes = fix_shared_test_data(test_file)
            all_changes.extend(changes)
        except Exception as e:
            print(f"Error processing {test_file}: {e}", file=sys.stderr)
    
    print(f"\nFixed {len(all_changes)} files:")
    for change in all_changes:
        print(f"  {change}")

if __name__ == '__main__':
    main()

