#!/usr/bin/env python3
"""
Fix compilation errors after BaseTestClass changes:
1. Fix setupTestEnvironment calls in CollectionEmptyStateViewTests
2. Fix testDataFrame -> createTestDataFrame() in PlatformDataFrameAnalysisL1Tests
3. Fix sampleItems -> createSampleItems() in L2LayoutDecisionTests
4. Fix samplePhotoContext -> createSamplePhotoContext() in L2LayoutDecisionTests
5. Fix init() override issues
"""

import re
import sys
from pathlib import Path

def fix_collection_empty_state_view_tests(file_path):
    """Fix setupTestEnvironment calls to use instance method or update testConfig."""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    
    # Replace setupTestEnvironment calls with testConfig updates
    # Pattern: setupTestEnvironment(mode: .X) -> testConfig.mode = .X; setupTestEnvironment()
    patterns = [
        (r'setupTestEnvironment\(mode:\s*\.(\w+)\)', r'testConfig.mode = .\1\n            setupTestEnvironment()'),
        (r'setupTestEnvironment\(enableAutoIDs:\s*(false|true)\)', r'testConfig.enableAutoIDs = \1\n            setupTestEnvironment()'),
        (r'setupTestEnvironment\(\)', r'setupTestEnvironment()'),  # Keep as-is if no params
    ]
    
    for pattern, replacement in patterns:
        content = re.sub(pattern, replacement, content)
    
    if content != original_content:
        with open(file_path, 'w') as f:
            f.write(content)
        return True
    return False

def fix_platform_dataframe_tests(file_path):
    """Fix testDataFrame -> createTestDataFrame()."""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    
    # Replace testDataFrame with createTestDataFrame()
    content = re.sub(r'\btestDataFrame\b', r'createTestDataFrame()', content)
    
    if content != original_content:
        with open(file_path, 'w') as f:
            f.write(content)
        return True
    return False

def fix_l2_layout_decision_tests(file_path):
    """Fix sampleItems -> createSampleItems() and samplePhotoContext -> createSamplePhotoContext()."""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    
    # Replace sampleItems with createSampleItems()
    content = re.sub(r'\bsampleItems\b', r'createSampleItems()', content)
    
    # Replace samplePhotoContext with createSamplePhotoContext()
    content = re.sub(r'\bsamplePhotoContext\b', r'createSamplePhotoContext()', content)
    
    if content != original_content:
        with open(file_path, 'w') as f:
            f.write(content)
        return True
    return False

def fix_init_override_issues(file_path):
    """Fix init() methods that need override keyword or should be removed."""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    
    # Pattern: public init() {} in a class that inherits from BaseTestClass
    # Should either be removed or have override keyword
    # But BaseTestClass.init() is not final anymore, so we can't override
    # So we should remove them
    
    # Match: public init() {} or init() {} in class inheriting from BaseTestClass
    init_pattern = r'(\s+)(public\s+)?init\(\)\s*\{\s*\}'
    
    def remove_init(match):
        indent = match.group(1)
        return f'{indent}// BaseTestClass.init() handles setup automatically'
    
    content = re.sub(init_pattern, remove_init, content)
    
    if content != original_content:
        with open(file_path, 'w') as f:
            f.write(content)
        return True
    return False

def main():
    fixes = []
    
    # Fix CollectionEmptyStateViewTests
    file_path = Path('Development/Tests/SixLayerFrameworkTests/Features/Collections/CollectionEmptyStateViewTests.swift')
    if file_path.exists():
        if fix_collection_empty_state_view_tests(file_path):
            fixes.append(str(file_path))
    
    # Fix PlatformDataFrameAnalysisL1Tests
    file_path = Path('Development/Tests/SixLayerFrameworkTests/Features/Platform/PlatformDataFrameAnalysisL1Tests.swift')
    if file_path.exists():
        if fix_platform_dataframe_tests(file_path):
            fixes.append(str(file_path))
    
    # Fix L2LayoutDecisionTests
    file_path = Path('Development/Tests/SixLayerFrameworkTests/Layers/L2LayoutDecisionTests.swift')
    if file_path.exists():
        if fix_l2_layout_decision_tests(file_path):
            fixes.append(str(file_path))
    
    # Fix init override issues
    for file_path in [
        'Development/Tests/SixLayerFrameworkTests/Features/Platform/PlatformPresentContentL1Tests.swift',
        'Development/Tests/SixLayerFrameworkTests/Layers/Layer1AccessibilityTests.swift',
    ]:
        path = Path(file_path)
        if path.exists():
            if fix_init_override_issues(path):
                fixes.append(str(path))
    
    if fixes:
        print(f"Fixed {len(fixes)} files:")
        for f in fixes:
            print(f"  - {f}")
    else:
        print("No fixes needed")

if __name__ == '__main__':
    main()

