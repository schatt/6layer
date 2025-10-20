#!/usr/bin/env python3

import os
import re
import glob

def fix_actor_isolation_in_file(file_path):
    """Add @MainActor to test functions that call @MainActor methods"""
    
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    
    # Pattern to find @Test func that might need @MainActor
    # Look for @Test func followed by content that calls platformDetailView or other @MainActor methods
    test_func_pattern = r'(@Test)\s+func\s+(\w+)\s*\([^)]*\)\s*\{'
    
    def needs_main_actor(match):
        test_decorator = match.group(1)
        func_name = match.group(2)
        
        # Find the function body
        start_pos = match.end()
        brace_count = 1
        pos = start_pos
        
        while pos < len(content) and brace_count > 0:
            if content[pos] == '{':
                brace_count += 1
            elif content[pos] == '}':
                brace_count -= 1
            pos += 1
        
        if pos < len(content):
            func_body = content[start_pos:pos]
            
            # Check if function body contains @MainActor method calls
            main_actor_calls = [
                'platformDetailView(',
                'IntelligentDetailView.',
                'IntelligentFormView.',
                'ResponsiveContainer.',
                'ResponsiveLayout.',
                'UnifiedWindowDetection(',
                'OCROverlayView(',
                'OCRDisambiguationView('
            ]
            
            for call in main_actor_calls:
                if call in func_body:
                    return f"@Test @MainActor func {func_name}("
        
        return match.group(0)  # No change needed
    
    # Apply the fix
    content = re.sub(test_func_pattern, needs_main_actor, content)
    
    # Only write if content changed
    if content != original_content:
        with open(file_path, 'w') as f:
            f.write(content)
        print(f"Fixed actor isolation in: {file_path}")
        return True
    
    return False

def main():
    """Fix actor isolation issues in all test files"""
    
    # Find all Swift test files
    test_files = glob.glob("Development/Tests/SixLayerFrameworkTests/**/*.swift", recursive=True)
    
    fixed_count = 0
    
    for file_path in test_files:
        if fix_actor_isolation_in_file(file_path):
            fixed_count += 1
    
    print(f"Fixed actor isolation in {fixed_count} files")

if __name__ == "__main__":
    main()
