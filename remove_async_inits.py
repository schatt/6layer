#!/usr/bin/env python3
"""
Remove all init() async throws that create data and convert to helper methods.
Tests should call helpers to create data, not use init().
"""

import re
import sys
from pathlib import Path

def remove_async_inits(file_path):
    """Remove init() async throws and convert data creation to helper methods."""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    
    # Pattern 1: Empty init() async throws - just remove
    empty_init = r'(\s+)init\(\)\s+async\s+throws\s+\{\s*\}'
    content = re.sub(empty_init, r'\1// BaseTestClass handles setup automatically - no init() needed', content)
    
    # Pattern 2: init() async throws with TODO - remove
    todo_init = r'(\s+)init\(\)\s+async\s+throws\s+\{\s*//\s*TODO[^\}]*\}'
    content = re.sub(todo_init, r'\1// BaseTestClass handles setup automatically - no init() needed', content, flags=re.DOTALL)
    
    # Pattern 3: init() async throws that calls setupTestEnvironment - remove
    setup_init = r'(\s+)init\(\)\s+async\s+throws\s+\{\s*await\s+setupTestEnvironment\(\)\s*\}'
    content = re.sub(setup_init, r'\1// BaseTestClass handles setup automatically - no init() needed', content)
    
    # Pattern 4: init() async throws that creates data - convert to helper method
    # Find: var prop: Type\n    init() async throws {\n        prop = value\n    }
    data_init_pattern = r'(\s+)(var\s+(\w+):\s*([^\n]+))\s*\n\s*init\(\)\s+async\s+throws\s+\{\s*\n\s*\3\s*=\s*([^\n]+)\s*\n\s*\}'
    
    def convert_to_helper(match):
        indent = match.group(1)
        var_decl = match.group(2)
        prop_name = match.group(3)
        prop_type = match.group(4)
        prop_value = match.group(5)
        
        # Create helper method
        helper_name = f"create{prop_name[0].upper() + prop_name[1:]}"
        return f'{indent}// Helper method - creates fresh data for each test (test isolation)\n{indent}private func {helper_name}() -> {prop_type.strip()} {{\n{indent}    return {prop_value.strip()}\n{indent}}}\n{indent}// BaseTestClass handles setup automatically - no init() needed'
    
    content = re.sub(data_init_pattern, convert_to_helper, content, flags=re.MULTILINE)
    
    # Pattern 5: Multiple property assignments in init()
    multi_prop_pattern = r'(\s+)init\(\)\s+async\s+throws\s+\{\s*\n((?:\s+\w+\s*=\s*[^\n]+\n)+)\s*\}'
    
    def convert_multiple_props(match):
        indent = match.group(1)
        props = match.group(2)
        helpers = []
        for line in props.strip().split('\n'):
            if '=' in line:
                parts = line.strip().split('=', 1)
                prop_name = parts[0].strip()
                prop_value = parts[1].strip()
                # Extract type from var declaration if available
                helper_name = f"create{prop_name[0].upper() + prop_name[1:]}"
                helpers.append(f'{indent}private func {helper_name}() {{\n{indent}    return {prop_value}\n{indent}}}')
        return '\n'.join(helpers) + f'\n{indent}// BaseTestClass handles setup automatically - no init() needed'
    
    # Only apply if we haven't already converted
    if 'init() async throws' in content:
        content = re.sub(multi_prop_pattern, convert_multiple_props, content, flags=re.MULTILINE)
    
    if content != original_content:
        with open(file_path, 'w') as f:
            f.write(content)
        return [f"Fixed {file_path}"]
    return []

def main():
    # Files that need fixing
    files_to_fix = [
        'Development/Tests/SixLayerFrameworkTests/Layers/L2LayoutDecisionTests.swift',
        'Development/Tests/SixLayerFrameworkTests/Layers/L3StrategySelectionTests.swift',
        'Development/Tests/SixLayerFrameworkTests/Layers/LiquidGlassCapabilityDetectionTests.swift',
        'Development/Tests/SixLayerFrameworkTests/Features/Platform/PlatformColorsTests.swift',
        'Development/Tests/SixLayerFrameworkTests/Features/Platform/PlatformDataFrameAnalysisL1Tests.swift',
        'Development/Tests/SixLayerFrameworkTests/Features/OCR/OCRViewTests.swift',
        'Development/Tests/SixLayerFrameworkTests/Features/OCR/OCRServiceTests.swift',
        'Development/Tests/SixLayerFrameworkTests/Utilities/Mocks/MockOCRServiceTests.swift',
        'Development/Tests/LayeredTestingSuite/L3StrategyTests.swift',
        'Development/Tests/LayeredTestingSuite/L1SemanticTests.swift',
        'Development/Tests/LayeredTestingSuite/L4ComponentTests.swift',
        'Development/Tests/LayeredTestingSuite/L5PlatformOptimizationTests.swift',
        'Development/Tests/LayeredTestingSuite/L6PlatformSystemTests.swift',
        'Development/Tests/LayeredTestingSuite/L2LayoutDecisionTests.swift',
    ]
    
    all_changes = []
    for file_path in files_to_fix:
        path = Path(file_path)
        if path.exists():
            try:
                changes = remove_async_inits(path)
                all_changes.extend(changes)
            except Exception as e:
                print(f"Error processing {file_path}: {e}", file=sys.stderr)
    
    print(f"\nFixed {len(all_changes)} files:")
    for change in all_changes:
        print(f"  {change}")

if __name__ == '__main__':
    main()

