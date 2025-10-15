#!/usr/bin/env python3
"""
Fix actor isolation issues in test files
Following TDD, DRY, DTRT, and epistemological principles
"""

import os
import re
from pathlib import Path

def fix_actor_isolation_issues(file_path):
    """Fix actor isolation issues in a Swift test file"""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    
    # Fix 1: deinit methods accessing main actor properties
    # Pattern: deinit { ... AccessibilityIdentifierConfig.shared ... }
    deinit_pattern = r'(deinit\s*\{[^}]*AccessibilityIdentifierConfig\.shared[^}]*\})'
    
    def fix_deinit(match):
        deinit_content = match.group(1)
        # Replace with proper async deinit
        return '''deinit {
        Task { [weak self] in
            await self?.cleanupTestEnvironment()
        }
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }'''
    
    content = re.sub(deinit_pattern, fix_deinit, content, flags=re.DOTALL)
    
    # Fix 2: init methods that need to be async
    # Pattern: init() { ... setupTestEnvironment() ... }
    init_pattern = r'(init\(\)\s*\{[^}]*setupTestEnvironment\(\)[^}]*\})'
    
    def fix_init(match):
        init_content = match.group(1)
        # Replace with async init
        return '''init() async throws {
        await setupTestEnvironment()
    }
    
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }'''
    
    content = re.sub(init_pattern, fix_init, content, flags=re.DOTALL)
    
    # Fix 3: Add @MainActor to classes that need it
    if 'main actor-isolated' in content and '@MainActor' not in content:
        # Find class definitions and add @MainActor
        class_pattern = r'(final class \w+)'
        content = re.sub(class_pattern, r'@MainActor\n\1', content)
    
    # Fix 4: Fix direct calls to AccessibilityIdentifierConfig.shared in non-isolated contexts
    # Replace with proper async calls
    config_pattern = r'let config = AccessibilityIdentifierConfig\.shared'
    content = re.sub(config_pattern, 'let config = await AccessibilityIdentifierConfig.shared', content)
    
    if content != original_content:
        with open(file_path, 'w') as f:
            f.write(content)
        return True
    return False

def main():
    """Main function to fix actor isolation issues"""
    test_dir = "/Users/schatt/code/github/6layer/Development/Tests"
    
    print("Fixing actor isolation issues...")
    
    swift_files = list(Path(test_dir).rglob("*.swift"))
    fixed_files = 0
    
    for file_path in swift_files:
        try:
            if fix_actor_isolation_issues(file_path):
                fixed_files += 1
                print(f"Fixed: {file_path}")
        except Exception as e:
            print(f"Error fixing {file_path}: {e}")
    
    print(f"Fixed {fixed_files} files with actor isolation issues")

if __name__ == "__main__":
    main()
