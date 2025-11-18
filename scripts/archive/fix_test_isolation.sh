#!/bin/bash

# Script to automatically fix tests that access AccessibilityIdentifierConfig.shared directly
# This script:
# 1. Wraps test methods with runWithTaskLocalConfig() for tests extending BaseTestClass
# 2. Replaces .shared accesses with testConfig within wrapped contexts
# 3. Updates init methods that access .shared

set -e

TEST_DIR="Development/Tests/SixLayerFrameworkTests"

echo "🔧 Fixing test isolation issues..."
echo ""

# Find all test files that extend BaseTestClass
find "$TEST_DIR" -name "*.swift" -type f | while read -r file; do
    # Check if file extends BaseTestClass
    if grep -q "BaseTestClass" "$file"; then
        echo "Processing: $file"
        
        # Create a temporary file
        temp_file=$(mktemp)
        
        # Process the file
        python3 << 'PYTHON_SCRIPT'
import sys
import re

file_path = sys.argv[1]
temp_file = sys.argv[2]

with open(file_path, 'r') as f:
    content = f.read()

# Pattern to match @Test methods
# Matches: @Test func testName() async { ... } or @Test func testName() { ... }
test_pattern = r'(@Test\s+func\s+\w+\([^)]*\)\s*(?:async\s+)?(?:throws\s+)?\{)'

def wrap_test_method(match):
    method_decl = match.group(1)
    
    # Check if already wrapped
    if 'runWithTaskLocalConfig' in method_decl:
        return method_decl
    
    # Determine if async/throws
    is_async = 'async' in method_decl
    is_throws = 'throws' in method_decl
    
    # Build the wrapper
    if is_async and is_throws:
        return method_decl + '\n        try await runWithTaskLocalConfig {'
    elif is_async:
        return method_decl + '\n        try await runWithTaskLocalConfig {'
    else:
        return method_decl + '\n        try runWithTaskLocalConfig {'

# Find all @Test methods and wrap them
# We need to be careful about nested braces
lines = content.split('\n')
result = []
i = 0
in_test = False
brace_count = 0
test_start_line = -1

while i < len(lines):
    line = lines[i]
    
    # Check if this is a test method declaration
    if re.match(r'\s*@Test\s+func\s+\w+', line):
        in_test = True
        test_start_line = i
        brace_count = 0
        result.append(line)
        i += 1
        continue
    
    if in_test:
        # Count braces
        brace_count += line.count('{') - line.count('}')
        
        # Check if we hit .shared access
        if 'AccessibilityIdentifierConfig.shared' in line:
            # Replace .shared with testConfig
            line = line.replace('AccessibilityIdentifierConfig.shared', 'testConfig')
            # Remove resetToDefaults() calls on testConfig as BaseTestClass already sets it up
            line = re.sub(r'testConfig\.resetToDefaults\(\)\s*', '', line)
        
        result.append(line)
        
        # If we've closed all braces, we're done with this test
        if brace_count <= 0 and '{' in lines[test_start_line]:
            # Check if we need to add closing brace for runWithTaskLocalConfig
            # Look back to see if we added the opening
            needs_closing = False
            for j in range(test_start_line, i + 1):
                if 'runWithTaskLocalConfig' in lines[j] and '{' in lines[j]:
                    needs_closing = True
                    break
            
            if needs_closing:
                # Find the last non-empty line before this closing brace
                last_line_idx = len(result) - 1
                while last_line_idx >= 0 and result[last_line_idx].strip() == '':
                    last_line_idx -= 1
                
                # Insert closing brace before the test method's closing brace
                if last_line_idx >= 0:
                    indent = len(result[last_line_idx]) - len(result[last_line_idx].lstrip())
                    result.insert(last_line_idx + 1, ' ' * indent + '}')
            
            in_test = False
            test_start_line = -1
    else:
        result.append(line)
    
    i += 1

# Also fix init methods that access .shared
content = '\n'.join(result)

# Remove init methods that just set up .shared (BaseTestClass handles this)
content = re.sub(
    r'(override\s+)?init\([^)]*\)\s*(?:async\s+throws\s+)?\{[^}]*AccessibilityIdentifierConfig\.shared[^}]*\}',
    r'// BaseTestClass handles setup automatically',
    content,
    flags=re.MULTILINE | re.DOTALL
)

# Fix standalone .shared accesses in non-test contexts
content = re.sub(
    r'let config = AccessibilityIdentifierConfig\.shared',
    r'let config = AccessibilityIdentifierConfig.currentTaskLocalConfig ?? AccessibilityIdentifierConfig.shared',
    content
)

with open(temp_file, 'w') as f:
    f.write(content)

print(f"Processed: {file_path}")
PYTHON_SCRIPT
"$file" "$temp_file"
        
        # Replace original file if changes were made
        if ! diff -q "$file" "$temp_file" > /dev/null; then
            mv "$temp_file" "$file"
            echo "  ✅ Fixed: $file"
        else
            rm "$temp_file"
            echo "  ⏭️  No changes needed: $file"
        fi
    fi
done

echo ""
echo "✅ Done fixing test isolation issues!"
echo ""
echo "Next steps:"
echo "1. Review the changes"
echo "2. Run tests to verify fixes"
echo "3. Fix any remaining issues manually"

