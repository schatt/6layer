#!/usr/bin/env python3
"""
Systematic compilation error fix script
Following TDD, DRY, DTRT, and epistemological principles

This script fixes the most common compilation errors in the test suite:
1. Missing Foundation imports (for UUID, etc.)
2. Missing Testing imports (for expect macro)
3. setupTestEnvironment/cleanupTestEnvironment issues
4. Actor isolation issues
5. Basic API mismatches
"""

import os
import re
import subprocess
from pathlib import Path

def find_swift_files(directory):
    """Find all Swift test files"""
    return list(Path(directory).rglob("*.swift"))

def fix_missing_imports(file_path):
    """Fix missing Foundation and Testing imports"""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    
    # Add Foundation import if UUID is used but Foundation not imported
    if 'UUID()' in content and 'import Foundation' not in content:
        # Find the first import statement and add Foundation after it
        import_match = re.search(r'^import \w+', content, re.MULTILINE)
        if import_match:
            content = content[:import_match.end()] + '\nimport Foundation' + content[import_match.end():]
    
    # Add Testing import if expect is used but Testing not imported
    if 'expect(' in content and 'import Testing' not in content:
        # Find the first import statement and add Testing after it
        import_match = re.search(r'^import \w+', content, re.MULTILINE)
        if import_match:
            content = content[:import_match.end()] + '\nimport Testing' + content[import_match.end():]
    
    if content != original_content:
        with open(file_path, 'w') as f:
            f.write(content)
        return True
    return False

def fix_setup_environment_issues(file_path):
    """Fix setupTestEnvironment and cleanupTestEnvironment issues"""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    
    # Check if file has setupTestEnvironment issues
    if 'cannot find \'setupTestEnvironment\'' in content or 'setupTestEnvironment()' in content:
        # Add proper setup methods if they don't exist
        if 'private func setupTestEnvironment()' not in content:
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
    
    # Fix deinit issues
    if 'main actor-isolated class property \'shared\' can not be referenced from a nonisolated context' in content:
        # Replace problematic deinit patterns
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

def fix_actor_isolation_issues(file_path):
    """Fix actor isolation issues"""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    
    # Add @MainActor to classes that need it
    if 'main actor-isolated' in content and '@MainActor' not in content:
        # Find class definitions and add @MainActor
        class_pattern = r'(final class \w+)'
        content = re.sub(class_pattern, r'@MainActor\n\1', content)
    
    # Fix init methods to be async
    if 'init()' in content and 'init() async' not in content:
        content = re.sub(r'init\(\) \{', 'init() async throws {', content)
    
    if content != original_content:
        with open(file_path, 'w') as f:
            f.write(content)
        return True
    return False

def main():
    """Main function to fix compilation errors"""
    test_dir = "/Users/schatt/code/github/6layer/Development/Tests"
    
    print("Starting systematic compilation error fixes...")
    
    swift_files = find_swift_files(test_dir)
    print(f"Found {len(swift_files)} Swift files")
    
    fixed_files = 0
    
    for file_path in swift_files:
        try:
            file_fixed = False
            
            # Fix missing imports
            if fix_missing_imports(file_path):
                file_fixed = True
            
            # Fix setup environment issues
            if fix_setup_environment_issues(file_path):
                file_fixed = True
            
            # Fix actor isolation issues
            if fix_actor_isolation_issues(file_path):
                file_fixed = True
            
            if file_fixed:
                fixed_files += 1
                print(f"Fixed: {file_path}")
                
        except Exception as e:
            print(f"Error fixing {file_path}: {e}")
    
    print(f"Fixed {fixed_files} files")
    print("Compilation error fixes completed!")

if __name__ == "__main__":
    main()
