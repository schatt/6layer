#!/usr/bin/env python3
"""
Remove unnecessary await MainActor.run { } wrappers from tests.
Test classes are already @MainActor, so these wrappers are unnecessary and cause 4-second timeouts.
"""

import re
from pathlib import Path

def fix_file(file_path):
    """Remove await MainActor.run wrappers from a test file."""
    content = file_path.read_text()
    original = content
    
    # Pattern: await MainActor.run { ... } where content is indented
    # We need to match the opening brace, capture content, and closing brace
    pattern = r'(\s+)await MainActor\.run \{\s*\n((?:\s+.*\n)*?)(\s+)\}'
    
    def remove_wrapper(match):
        indent = match.group(1)  # Function indent
        content = match.group(2)  # Content inside wrapper
        closing_indent = match.group(3)  # Closing brace indent
        
        # Remove one level of indentation from content (4 spaces)
        lines = content.split('\n')
        fixed_lines = []
        for line in lines:
            if line.strip():  # Non-empty line
                # Remove 4 spaces of indentation
                if line.startswith('    '):
                    fixed_lines.append(line[4:])
                else:
                    fixed_lines.append(line)
            else:
                fixed_lines.append('')
        
        return indent + '\n'.join(fixed_lines).rstrip() + '\n'
    
    content = re.sub(pattern, remove_wrapper, content, flags=re.MULTILINE)
    
    # Also remove 'async' from function signatures that no longer have await
    # Pattern: func testName(...) async { ... } where there's no await inside
    lines = content.split('\n')
    new_lines = []
    i = 0
    while i < len(lines):
        line = lines[i]
        # Check if this is a test function with async
        if re.match(r'\s+func test\w+.*\)\s+async\s*\{', line):
            # Check if there's any await in the function body
            func_start = i
            func_indent = len(line) - len(line.lstrip())
            i += 1
            has_await = False
            brace_count = 1
            
            # Look through function body
            while i < len(lines) and brace_count > 0:
                if 'await' in lines[i]:
                    has_await = True
                if '{' in lines[i]:
                    brace_count += lines[i].count('{')
                if '}' in lines[i]:
                    brace_count -= lines[i].count('}')
                i += 1
            
            # If no await found, remove async
            if not has_await:
                new_lines.append(re.sub(r'\s+async\s*\{', ' {', line))
            else:
                new_lines.append(line)
        else:
            new_lines.append(line)
            i += 1
    
    content = '\n'.join(new_lines)
    
    if content != original:
        file_path.write_text(content)
        return True
    return False

# Fix CollectionEmptyStateViewTests
file_path = Path('Development/Tests/SixLayerFrameworkTests/Features/Collections/CollectionEmptyStateViewTests.swift')
if fix_file(file_path):
    print(f"Fixed {file_path}")
else:
    print(f"No changes needed for {file_path}")

