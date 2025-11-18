#!/usr/bin/env python3
"""
Script to fix testConfig optional unwrapping errors in test files.
Replaces patterns like:
  let config = testConfig
with:
  guard let config = testConfig else {
      Issue.record("testConfig is nil")
      return
  }
"""

import re
import sys
from pathlib import Path

def fix_testconfig_unwrapping(file_path: Path) -> bool:
    """Fix testConfig unwrapping in a single file."""
    try:
        content = file_path.read_text(encoding='utf-8')
        original = content
        
        # Pattern 1: Simple assignment in function body
        # let config = testConfig
        # (but not already in a guard let or if let)
        pattern1 = re.compile(
            r'(?<!guard let )'  # Not already guard let
            r'(?<!if let )'      # Not already if let
            r'(?<!let )'         # Not already let
            r'(\s+)(let config = testConfig)(\s*\n)',
            re.MULTILINE
        )
        
        def replace_simple(match):
            indent = match.group(1)
            assignment = match.group(2)
            newline = match.group(3)
            return f'{indent}guard {assignment} else {{\n{indent}    Issue.record("testConfig is nil")\n{indent}    return\n{indent}}}{newline}'
        
        content = pattern1.sub(replace_simple, content)
        
        # Pattern 2: Inside MainActor.run or other closures
        # let config = testConfig (inside closure, may need self.)
        pattern2 = re.compile(
            r'(\s+)(let config = )(testConfig)(\s*\n)',
            re.MULTILINE
        )
        
        def replace_in_closure(match):
            indent = match.group(1)
            let_part = match.group(2)
            config_ref = match.group(3)
            newline = match.group(4)
            
            # Check if we're in a closure context (MainActor.run, etc.)
            # If so, use self.testConfig
            lines_before = content[:match.start()].split('\n')
            context_line = lines_before[-1] if lines_before else ""
            
            # If we're in a closure (MainActor.run, etc.), use self.testConfig
            if 'MainActor.run' in context_line or 'await' in context_line or 'async' in context_line:
                config_ref = f'self.{config_ref}'
            
            return f'{indent}guard {let_part}{config_ref} else {{\n{indent}    Issue.record("testConfig is nil")\n{indent}    return\n{indent}}}{newline}'
        
        # Re-apply pattern2 on updated content
        content = pattern2.sub(replace_in_closure, content)
        
        # Pattern 3: Already has guard/if let but accessing config properties without unwrapping
        # This is trickier - we'll handle the simpler case first
        # config.enableAutoIDs where config is optional
        # Actually, if we fix pattern1 and pattern2, this should be handled
        
        # Pattern 3: Direct property access on testConfig
        # This is complex - we need to find blocks where testConfig is accessed directly
        # and wrap them with guard let
        # Strategy: Find function/test blocks and check if they access testConfig directly
        
        # Find patterns like testConfig.property or testConfig?.property
        # But only if not already inside a guard let block
        lines = content.split('\n')
        new_lines = []
        i = 0
        in_guard_block = False
        guard_indent = 0
        
        while i < len(lines):
            line = lines[i]
            
            # Track if we're in a guard let block for testConfig
            if 'guard let' in line and 'testConfig' in line:
                in_guard_block = True
                guard_indent = len(line) - len(line.lstrip())
                new_lines.append(line)
                i += 1
                continue
            elif in_guard_block:
                # Check if we've closed the guard block
                current_indent = len(line) - len(line.lstrip()) if line.strip() else 0
                if line.strip() and current_indent <= guard_indent and '}' in line:
                    in_guard_block = False
                    new_lines.append(line)
                    i += 1
                    continue
            
            # Check for direct testConfig access (not self.testConfig, not already in guard)
            # Pattern: testConfig.property or testConfig?.property
            if not in_guard_block and re.search(r'\btestConfig\.[a-zA-Z]', line):
                # Check if this is inside a function/test that needs guard
                # Look backwards for function/test declaration
                needs_guard = False
                for j in range(max(0, i-20), i):
                    prev_line = lines[j]
                    if '@Test' in prev_line or 'func ' in prev_line:
                        needs_guard = True
                        break
                
                if needs_guard:
                    # Find the indentation level
                    indent = len(line) - len(line.lstrip())
                    indent_str = ' ' * indent
                    
                    # Insert guard let before this line
                    # But only if we haven't already inserted one recently
                    if not (len(new_lines) > 0 and 'guard let' in new_lines[-1] and 'testConfig' in new_lines[-1]):
                        # Determine if we need self. (inside closure)
                        needs_self = False
                        for j in range(max(0, i-10), i):
                            if 'MainActor.run' in lines[j] or 'await' in lines[j]:
                                needs_self = True
                                break
                        
                        config_ref = 'self.testConfig' if needs_self else 'testConfig'
                        new_lines.append(f'{indent_str}guard let config = {config_ref} else {{')
                        new_lines.append(f'{indent_str}    Issue.record("testConfig is nil")')
                        new_lines.append(f'{indent_str}    return')
                        new_lines.append(f'{indent_str}}}')
                        new_lines.append('')
                    
                    # Replace testConfig with config in this line and subsequent lines in this block
                    # But only until we hit a closing brace at same or lower indent
                    modified_line = re.sub(r'\btestConfig\.', 'config.', line)
                    new_lines.append(modified_line)
                    i += 1
                    
                    # Continue replacing testConfig in subsequent lines until block ends
                    block_indent = indent
                    while i < len(lines):
                        next_line = lines[i]
                        next_indent = len(next_line) - len(next_line.lstrip()) if next_line.strip() else 0
                        
                        # If we hit a closing brace at same or lower indent, stop
                        if next_line.strip() and next_indent <= block_indent and '}' in next_line:
                            new_lines.append(next_line)
                            i += 1
                            break
                        
                        # Replace testConfig with config in this line
                        modified_next = re.sub(r'\btestConfig\.', 'config.', next_line)
                        new_lines.append(modified_next)
                        i += 1
                    continue
            
            new_lines.append(line)
            i += 1
        
        content = '\n'.join(new_lines)
        
        if content != original:
            file_path.write_text(content, encoding='utf-8')
            return True
        return False
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False

def main():
    """Main entry point."""
    test_dir = Path("Development/Tests/SixLayerFrameworkTests")
    
    if not test_dir.exists():
        print(f"Error: Test directory not found: {test_dir}")
        sys.exit(1)
    
    # Find all Swift test files
    test_files = list(test_dir.rglob("*.swift"))
    
    fixed_count = 0
    for file_path in test_files:
        if fix_testconfig_unwrapping(file_path):
            print(f"Fixed: {file_path}")
            fixed_count += 1
    
    print(f"\nFixed {fixed_count} files")

if __name__ == "__main__":
    main()

