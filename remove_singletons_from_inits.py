#!/usr/bin/env python3
"""
Remove ALL singleton access from test init() methods.
BaseTestClass already handles setup with isolated configs.
"""

import re
import sys
from pathlib import Path

def remove_singleton_access_from_init(file_path):
    """Remove singleton access from init() methods."""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    changes = []
    
    # Pattern 1: Remove init() methods that access AccessibilityIdentifierConfig.shared
    # Match: init() async throws { ... AccessibilityIdentifierConfig.shared ... }
    init_with_shared_config = r'(\s+)(init\(\)\s+async\s+throws\s+\{[^}]*AccessibilityIdentifierConfig\.shared[^}]*\})'
    
    def remove_shared_config_init(match):
        indent = match.group(1)
        return f'{indent}// BaseTestClass handles setup automatically - no singleton access needed'
    
    new_content = re.sub(init_with_shared_config, remove_shared_config_init, content, flags=re.DOTALL)
    
    # Pattern 2: Remove init() methods that call AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    # This accesses TestSetupUtilities.shared singleton
    init_with_setup = r'(\s+)(init\(\)\s+async\s+throws\s+\{[^}]*AccessibilityTestUtilities\.setupAccessibilityTestEnvironment\(\)[^}]*\})'
    
    def remove_setup_init(match):
        indent = match.group(1)
        return f'{indent}// BaseTestClass handles setup automatically - no singleton access needed'
    
    new_content = re.sub(init_with_setup, remove_setup_init, new_content, flags=re.DOTALL)
    
    # Pattern 3: Remove CustomFieldRegistry.shared.reset() from init()
    # This is a singleton - should be done in test methods, not init()
    init_with_registry = r'(\s+)(override\s+)?init\(\)\s+(async\s+throws\s+)?\{[^}]*CustomFieldRegistry\.shared\.reset\(\)[^}]*\}'
    
    def remove_registry_init(match):
        indent = match.group(1)
        override = match.group(2) or ''
        return f'{indent}{override}init() {{\n{indent}    super.init()\n{indent}    // CustomFieldRegistry.shared.reset() should be called in test methods, not init()\n{indent}    // BaseTestClass handles setup automatically'
    
    new_content = re.sub(init_with_registry, remove_registry_init, new_content, flags=re.DOTALL)
    
    # Pattern 4: Remove synchronous init() that accesses .shared
    sync_init_with_shared = r'(\s+)(override\s+)?init\(\)\s+\{[^}]*AccessibilityIdentifierConfig\.shared[^}]*\}'
    
    def remove_sync_shared_init(match):
        indent = match.group(1)
        override = match.group(2) or ''
        if override:
            return f'{indent}override init() {{\n{indent}    super.init()\n{indent}    // BaseTestClass handles setup automatically - no singleton access needed'
        return f'{indent}// BaseTestClass handles setup automatically - no singleton access needed'
    
    new_content = re.sub(sync_init_with_shared, remove_sync_shared_init, new_content, flags=re.DOTALL)
    
    if new_content != original_content:
        changes.append(f"Removed singleton access from {file_path}")
        with open(file_path, 'w') as f:
            f.write(new_content)
    
    return changes

def main():
    test_files = Path('Development/Tests').rglob('*Tests.swift')
    
    all_changes = []
    for test_file in test_files:
        try:
            changes = remove_singleton_access_from_init(test_file)
            all_changes.extend(changes)
        except Exception as e:
            print(f"Error processing {test_file}: {e}", file=sys.stderr)
    
    print(f"\nFixed {len(all_changes)} files:")
    for change in all_changes:
        print(f"  {change}")

if __name__ == '__main__':
    main()

