#!/usr/bin/env python3
"""
Fix super class issues and missing function definitions in Swift test files
Following TDD, DRY, DTRT, and epistemological principles
"""

import os
import re
from pathlib import Path

def fix_super_class_issues(file_path):
    """Fix super class issues and missing function definitions in a Swift test file"""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    
    # Fix 1: Remove super.setUp() and super.tearDown() calls
    content = re.sub(r'try await super\.setUp\(\)\s*\n', '', content)
    content = re.sub(r'try await super\.tearDown\(\)\s*\n', '', content)
    content = re.sub(r'await super\.setUp\(\)\s*\n', '', content)
    content = re.sub(r'await super\.tearDown\(\)\s*\n', '', content)
    
    # Fix 2: Replace setupTestEnvironment() calls with proper async calls
    content = re.sub(r'setupTestEnvironment\(\)', 'await setupTestEnvironment()', content)
    content = re.sub(r'cleanupTestEnvironment\(\)', 'await cleanupTestEnvironment()', content)
    
    # Fix 3: Add proper setup and cleanup methods if they don't exist
    if 'setupTestEnvironment()' in content and 'private func setupTestEnvironment()' not in content:
        # Find the first @Test function and add setup methods before it
        test_match = re.search(r'@Test func', content)
        if test_match:
            setup_methods = '''
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
    
'''
            content = content[:test_match.start()] + setup_methods + content[test_match.start():]
    
    # Fix 4: Fix init methods to be async
    if 'init()' in content and 'init() async' not in content:
        content = re.sub(r'init\(\) \{', 'init() async throws {', content)
    
    # Fix 5: Fix deinit methods to use Task
    if 'deinit' in content and 'Task { [weak self] in' not in content:
        deinit_pattern = r'deinit\s*\{[^}]*\}'
        new_deinit = '''deinit {
        Task { [weak self] in
            await self?.cleanupTestEnvironment()
        }
    }'''
        content = re.sub(deinit_pattern, new_deinit, content, flags=re.DOTALL)
    
    if content != original_content:
        with open(file_path, 'w') as f:
            f.write(content)
        return True
    return False

def main():
    """Main function to fix super class issues"""
    test_dir = "/Users/schatt/code/github/6layer/Development/Tests"
    
    print("Fixing super class issues and missing function definitions...")
    
    swift_files = list(Path(test_dir).rglob("*.swift"))
    fixed_files = 0
    
    for file_path in swift_files:
        try:
            if fix_super_class_issues(file_path):
                fixed_files += 1
                print(f"Fixed: {file_path}")
        except Exception as e:
            print(f"Error fixing {file_path}: {e}")
    
    print(f"Fixed {fixed_files} files with super class issues")

if __name__ == "__main__":
    main()
