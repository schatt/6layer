#!/usr/bin/env python3
"""
Script to fix MainActor isolation issues in DataPresentationIntelligenceTests.swift
"""

import re

def fix_test_file():
    file_path = "Development/Tests/SixLayerFrameworkTests/Core/Models/DataPresentationIntelligenceTests.swift"
    
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Pattern to match test functions that call intelligence.analyzeData
    # but are not already async
    pattern = r'(@Test func [^{]+?\{[^}]*?intelligence\.analyzeData[^}]*?\})'
    
    def fix_test_function(match):
        func_content = match.group(1)
        
        # Check if it's already async
        if 'async' in func_content:
            return func_content
        
        # Add async to function signature
        func_content = re.sub(r'(@Test func [^{]+?)\{', r'\1 async {', func_content)
        
        # Wrap the body in MainActor.run
        # Find the opening brace after the function signature
        brace_pos = func_content.find('{')
        if brace_pos != -1:
            # Find the content inside the function
            brace_count = 0
            start_pos = brace_pos + 1
            end_pos = len(func_content) - 1  # Last character should be }
            
            # Find the matching closing brace
            for i in range(start_pos, len(func_content)):
                if func_content[i] == '{':
                    brace_count += 1
                elif func_content[i] == '}':
                    if brace_count == 0:
                        end_pos = i
                        break
                    brace_count -= 1
            
            # Extract the function body
            function_body = func_content[start_pos:end_pos].strip()
            
            # Wrap in MainActor.run
            new_body = f"await MainActor.run {{\n{function_body}\n}}"
            
            # Reconstruct the function
            new_func = func_content[:start_pos] + new_body + func_content[end_pos:]
            return new_func
        
        return func_content
    
    # Apply the fix
    new_content = re.sub(pattern, fix_test_function, content, flags=re.DOTALL)
    
    with open(file_path, 'w') as f:
        f.write(new_content)
    
    print("Fixed MainActor isolation issues in DataPresentationIntelligenceTests.swift")

if __name__ == "__main__":
    fix_test_file()
