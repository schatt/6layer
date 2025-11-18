#!/usr/bin/env python3

import re
import sys

def fix_test_functions(file_path):
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Pattern to match @Test @MainActor func functionName( followed by comments/let statements
    pattern = r'(@Test @MainActor func \w+\(\s*\n\s*//.*?\n\s*let )'
    
    def replacement(match):
        func_name_match = re.search(r'func (\w+)\(', match.group(0))
        if func_name_match:
            func_name = func_name_match.group(1)
            return f'@Test @MainActor func {func_name}(\n        arguments: TestArguments()\n    ) {{\n        // GIVEN: '
        return match.group(0)
    
    # Apply the fix
    new_content = re.sub(pattern, replacement, content, flags=re.MULTILINE | re.DOTALL)
    
    # Write back to file
    with open(file_path, 'w') as f:
        f.write(new_content)
    
    print(f"Fixed test functions in {file_path}")

if __name__ == "__main__":
    fix_test_functions(sys.argv[1])
