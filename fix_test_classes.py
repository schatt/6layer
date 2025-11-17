#!/usr/bin/env python3
"""
Script to make all test classes inherit from BaseTestClass and clean up unnecessary init() methods.

Patterns to fix:
1. Change "open class XTests {" to "open class XTests: BaseTestClass {"
2. Remove init() methods that just call setupTestEnvironment() and configure .shared
3. Keep init() methods that do actual necessary setup (like CustomFieldRegistry.shared.reset())
4. Remove unnecessary setupTestEnvironment() calls and .shared config access
"""

import re
import sys
from pathlib import Path

def fix_test_class(file_path):
    """Fix a single test file."""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    changes = []
    
    # Pattern 1: Change class declaration to inherit from BaseTestClass
    # Match: "open class XTests {" or "class XTests {" (not already inheriting)
    class_pattern = r'^(open class|class)\s+(\w+Tests)\s*\{'
    
    def replace_class(match):
        if ': BaseTestClass' not in content[:match.end()]:
            return f'{match.group(1)} {match.group(2)}: BaseTestClass {{'
        return match.group(0)
    
    new_content = re.sub(class_pattern, replace_class, content, flags=re.MULTILINE)
    
    # Pattern 2: Remove init() methods that just do unnecessary setup
    # Look for init() async throws that:
    # - Call setupTestEnvironment()
    # - Access AccessibilityIdentifierConfig.shared
    # - Call resetToDefaults()
    # - Set enableAutoIDs, namespace, mode, enableDebugLogging
    
    init_pattern = r'(\s+)init\(\)\s+async\s+throws\s+\{[^}]*setupTestEnvironment\(\)[^}]*AccessibilityIdentifierConfig\.shared[^}]*resetToDefaults\(\)[^}]*enableAutoIDs[^}]*namespace[^}]*mode[^}]*enableDebugLogging[^}]*\}'
    
    def remove_unnecessary_init(match):
        # Check if this init does anything else important
        init_body = match.group(0)
        # Keep if it does CustomFieldRegistry.shared.reset() or other important things
        if 'CustomFieldRegistry' in init_body or 'testImage' in init_body:
            return match.group(0)  # Keep it
        # Otherwise remove it - BaseTestClass handles setup
        return match.group(1) + '// BaseTestClass handles setup automatically - no custom init needed'
    
    new_content = re.sub(init_pattern, remove_unnecessary_init, new_content, flags=re.DOTALL)
    
    # Pattern 3: Remove standalone setupTestEnvironment() methods that just call AccessibilityTestUtilities
    setup_pattern = r'(\s+)private\s+func\s+setupTestEnvironment\(\)\s+async\s+\{\s*await\s+AccessibilityTestUtilities\.setupAccessibilityTestEnvironment\(\)\s*\}'
    new_content = re.sub(setup_pattern, r'\1// BaseTestClass handles setup automatically', new_content, flags=re.DOTALL)
    
    if new_content != original_content:
        changes.append(f"Fixed {file_path}")
        with open(file_path, 'w') as f:
            f.write(new_content)
    
    return changes

def main():
    test_files = Path('Development/Tests').rglob('*Tests.swift')
    
    all_changes = []
    for test_file in test_files:
        try:
            changes = fix_test_class(test_file)
            all_changes.extend(changes)
        except Exception as e:
            print(f"Error processing {test_file}: {e}", file=sys.stderr)
    
    print(f"\nFixed {len(all_changes)} files:")
    for change in all_changes:
        print(f"  {change}")

if __name__ == '__main__':
    main()

