#!/usr/bin/env python3
"""
Remove unnecessary await MainActor.run { } wrappers that cause 4-second timeouts.
Test classes are already @MainActor, so these wrappers are unnecessary.
"""

import re
from pathlib import Path

def fix_file(file_path):
    """Remove await MainActor.run wrappers and fix setupTestEnvironment calls."""
    content = file_path.read_text()
    original = content
    
    # Step 1: Fix setupTestEnvironment(mode:) calls to use testConfig.mode
    content = re.sub(
        r'setupTestEnvironment\(mode:\s*(\.\w+)\)',
        r'testConfig.mode = \1\n            setupTestEnvironment()',
        content
    )
    
    content = re.sub(
        r'setupTestEnvironment\(enableAutoIDs:\s*(false|true)\)',
        r'testConfig.enableAutoIDs = \1\n            setupTestEnvironment()',
        content
    )
    
    # Step 2: Remove await MainActor.run { } wrappers
    # Pattern: await MainActor.run { ... } where content is indented
    lines = content.split('\n')
    new_lines = []
    i = 0
    skip_until_brace = False
    brace_level = 0
    
    while i < len(lines):
        line = lines[i]
        
        # Check if this is "await MainActor.run {"
        if 'await MainActor.run {' in line:
            # Skip this line and track brace level
            skip_until_brace = True
            brace_level = 1
            i += 1
            continue
        
        if skip_until_brace:
            # Count braces to find the matching closing brace
            if '{' in line:
                brace_level += line.count('{')
            if '}' in line:
                brace_level -= line.count('}')
                if brace_level == 0:
                    # Found the closing brace - stop skipping
                    skip_until_brace = False
                    i += 1
                    continue
            # Skip lines inside the wrapper (but adjust indentation)
            if line.strip():  # Non-empty line
                # Remove 4 spaces of indentation
                if line.startswith('            '):  # 12 spaces
                    new_lines.append(line[4:])  # Remove 4 spaces
                elif line.startswith('        '):  # 8 spaces
                    new_lines.append(line[4:])  # Remove 4 spaces
                else:
                    new_lines.append(line)
            else:
                new_lines.append(line)
            i += 1
        else:
            new_lines.append(line)
            i += 1
    
    content = '\n'.join(new_lines)
    
    # Step 3: Remove 'async' from function signatures that no longer have await
    # Only remove async if there's no await in the function body
    lines = content.split('\n')
    new_lines = []
    i = 0
    
    while i < len(lines):
        line = lines[i]
        # Check if this is a test function with async
        if re.match(r'\s+func test\w+.*\)\s+async\s*\{', line):
            func_start = i
            func_indent = len(line) - len(line.lstrip())
            i += 1
            has_await = False
            brace_count = 1
            
            # Look through function body for await
            while i < len(lines) and brace_count > 0:
                current_line = lines[i]
                if 'await' in current_line:
                    has_await = True
                if '{' in current_line:
                    brace_count += current_line.count('{')
                if '}' in current_line:
                    brace_count -= current_line.count('}')
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

# Fix the file
file_path = Path('Development/Tests/SixLayerFrameworkTests/Features/Collections/CollectionEmptyStateViewTests.swift')
if fix_file(file_path):
    print(f"Fixed {file_path}")
else:
    print(f"No changes needed for {file_path}")

