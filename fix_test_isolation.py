#!/usr/bin/env python3
"""
Script to automatically fix tests that access AccessibilityIdentifierConfig.shared directly.

This script:
1. Wraps test methods with runWithTaskLocalConfig() for tests extending BaseTestClass
2. Replaces .shared accesses with testConfig within wrapped contexts
3. Removes init methods that just set up .shared (BaseTestClass handles this)
4. Updates helper function calls to use task-local config
"""

import re
import sys
from pathlib import Path

def fix_test_file(file_path: Path) -> bool:
    """Fix a single test file. Returns True if changes were made."""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    lines = content.split('\n')
    
    # Check if file extends BaseTestClass
    if 'BaseTestClass' not in content:
        return False
    
    # Check if file accesses .shared
    if 'AccessibilityIdentifierConfig.shared' not in content:
        return False
    
    print(f"Processing: {file_path}")
    
    # Step 1: Remove init methods that just set up .shared
    # Pattern: init() { ... AccessibilityIdentifierConfig.shared ... }
    content = re.sub(
        r'(override\s+)?init\([^)]*\)\s*(?:async\s+throws\s+)?\{[^}]*AccessibilityIdentifierConfig\.shared[^}]*\}',
        r'// BaseTestClass handles setup automatically - no need for custom init',
        content,
        flags=re.MULTILINE | re.DOTALL
    )
    
    # Step 2: Wrap @Test methods with runWithTaskLocalConfig()
    # This is complex because we need to match the method body correctly
    test_method_pattern = r'(@Test\s+func\s+\w+\([^)]*\)\s*(?:async\s+)?(?:throws\s+)?\{)'
    
    def wrap_test_method(match):
        method_decl = match.group(1)
        # Skip if already wrapped
        if 'runWithTaskLocalConfig' in method_decl:
            return method_decl
        
        is_async = 'async' in method_decl
        is_throws = 'throws' in method_decl
        
        # Determine indentation
        indent = len(method_decl) - len(method_decl.lstrip())
        indent_str = ' ' * (indent + 8)  # 8 spaces for method body
        
        if is_async and is_throws:
            return method_decl + f'\n{indent_str}try await runWithTaskLocalConfig {{'
        elif is_async:
            return method_decl + f'\n{indent_str}try await runWithTaskLocalConfig {{'
        else:
            return method_decl + f'\n{indent_str}try runWithTaskLocalConfig {{'
    
    # Find all test methods and process them
    lines = content.split('\n')
    result = []
    i = 0
    
    while i < len(lines):
        line = lines[i]
        
        # Check if this is a @Test method
        test_match = re.match(r'(\s*)(@Test\s+func\s+\w+\([^)]*\)\s*(?:async\s+)?(?:throws\s+)?\{)', line)
        if test_match:
            indent = len(test_match.group(1))
            method_decl = test_match.group(2)
            
            # Skip if already wrapped
            if 'runWithTaskLocalConfig' not in method_decl:
                result.append(line)
                
                # Determine wrapper call - use same indentation as method body
                is_async = 'async' in method_decl
                is_throws = 'throws' in method_decl
                # Method body indentation is typically 4 spaces from method declaration
                indent_str = ' ' * (indent + 4)
                
                if is_async and is_throws:
                    wrapper = f'{indent_str}try await runWithTaskLocalConfig {{'
                elif is_async:
                    wrapper = f'{indent_str}try await runWithTaskLocalConfig {{'
                else:
                    wrapper = f'{indent_str}try runWithTaskLocalConfig {{'
                
                result.append(wrapper)
                
                # Track braces to find where to close
                i += 1
                brace_count = 1
                method_start = len(result)
                
                while i < len(lines) and brace_count > 0:
                    current_line = lines[i]
                    brace_count += current_line.count('{') - current_line.count('}')
                    
                    # Replace .shared with testConfig
                    if 'AccessibilityIdentifierConfig.shared' in current_line:
                        current_line = current_line.replace('AccessibilityIdentifierConfig.shared', 'testConfig')
                        # Remove resetToDefaults() calls
                        current_line = re.sub(r'testConfig\.resetToDefaults\(\)\s*', '', current_line)
                    
                    # Indent the line if it's inside the method body
                    # Method body lines are typically at indent + 4, we need to add 4 more for wrapper
                    if brace_count > 0:
                        # Get current indentation
                        current_indent = len(current_line) - len(current_line.lstrip())
                        # Method body level is typically indent + 4
                        method_body_indent = indent + 4
                        # If this line is at method body level, add wrapper indent
                        if current_indent >= method_body_indent:
                            # Add 4 spaces for the wrapper level
                            current_line = ' ' * 4 + current_line
                        # If it's at the opening brace level (indent), it's the opening brace itself
                        elif current_indent == indent and current_line.strip() == '{':
                            # Keep the opening brace as-is (it's already handled)
                            pass
                    
                    result.append(current_line)
                    i += 1
                
                # Add closing brace for wrapper before the method's closing brace
                if brace_count == 0:
                    # Find the last non-empty line before the closing brace
                    last_idx = len(result) - 1
                    while last_idx >= method_start and (not result[last_idx].strip() or result[last_idx].strip() == '}'):
                        last_idx -= 1
                    
                    if last_idx >= method_start:
                        # Get indentation from the wrapper opening (same as wrapper)
                        result.insert(last_idx + 1, indent_str + '}')
                
                continue
            else:
                result.append(line)
                i += 1
                continue
        
        # Replace standalone .shared accesses (not in already processed contexts)
        if 'AccessibilityIdentifierConfig.shared' in line:
            # Replace with task-local check
            line = re.sub(
                r'let\s+config\s*=\s*AccessibilityIdentifierConfig\.shared',
                r'let config = AccessibilityIdentifierConfig.currentTaskLocalConfig ?? AccessibilityIdentifierConfig.shared',
                line
            )
            # Direct .shared property access
            line = line.replace('AccessibilityIdentifierConfig.shared', 'testConfig')
        
        result.append(line)
        i += 1
    
    new_content = '\n'.join(result)
    
    if new_content != original_content:
        with open(file_path, 'w') as f:
            f.write(new_content)
        print(f"  ✅ Fixed: {file_path}")
        return True
    else:
        print(f"  ⏭️  No changes needed: {file_path}")
        return False

def main():
    """Main entry point."""
    test_dir = Path("Development/Tests/SixLayerFrameworkTests")
    
    if not test_dir.exists():
        print(f"Error: Test directory not found: {test_dir}")
        sys.exit(1)
    
    print("🔧 Fixing test isolation issues...")
    print("")
    
    fixed_count = 0
    total_count = 0
    
    # Find all Swift test files
    for test_file in test_dir.rglob("*.swift"):
        total_count += 1
        if fix_test_file(test_file):
            fixed_count += 1
    
    print("")
    print(f"✅ Done! Fixed {fixed_count} out of {total_count} test files.")
    print("")
    print("Next steps:")
    print("1. Review the changes with: git diff")
    print("2. Run tests to verify fixes: swift test")
    print("3. Fix any remaining issues manually")

if __name__ == "__main__":
    main()

