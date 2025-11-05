#!/usr/bin/env python3
"""
Test script for platformListRow migration - tests the migration patterns
before running on actual code.
"""

import re

def extract_text_string(text_match):
    """Extract string content from Text(...) call."""
    # Return as-is - preserve quotes for string literals, preserve variables/expressions
    return text_match.group(1).strip()

def migrate_platform_list_row(content):
    """Migrate platformListRow calls to new API."""
    
    # Pattern 1: .platformListRow { Text("...") }
    pattern1 = r'\.platformListRow\s*\{\s*Text\(([^)]+)\)\s*\}'
    def replace1(match):
        text_content = extract_text_string(match)
        return f'.platformListRow(title: {text_content}) {{ }}'
    
    # Pattern 2: .platformListRow { Text(...) ... }
    pattern2 = r'\.platformListRow\s*\{\s*Text\(([^)]+)\)\s*;?\s*(.*?)\s*\}'
    def replace2(match):
        text_content = extract_text_string(match)
        trailing = match.group(2).strip()
        if trailing:
            trailing = re.sub(r'Text\([^)]+\)\s*;?\s*', '', trailing)
            trailing = trailing.strip()
            if trailing:
                return f'.platformListRow(title: {text_content}) {{ {trailing} }}'
        return f'.platformListRow(title: {text_content}) {{ }}'
    
    content = re.sub(pattern2, replace2, content, flags=re.DOTALL)
    content = re.sub(pattern1, replace1, content)
    
    return content

def test_migrations():
    """Test various migration patterns."""
    test_cases = [
        # (input, expected_output, description)
        (
            '.platformListRow { Text("Item Title") }',
            '.platformListRow(title: "Item Title") { }',
            'Simple Text literal'
        ),
        (
            '.platformListRow { Text(item.title) }',
            '.platformListRow(title: item.title) { }',
            'Text with variable'
        ),
        (
            '.platformListRow { Text(item.title); Spacer(); Image(systemName: "chevron.right") }',
            '.platformListRow(title: item.title) { Spacer(); Image(systemName: "chevron.right") }',
            'Text with trailing content'
        ),
        (
            'Text(item1.title)\n            .platformListRow { Text(item1.title) }',
            'Text(item1.title)\n            .platformListRow(title: item1.title) { }',
            'Multi-line with Text before'
        ),
    ]
    
    print("🧪 Testing platformListRow migration patterns...\n")
    
    all_passed = True
    for i, (input_text, expected, description) in enumerate(test_cases, 1):
        result = migrate_platform_list_row(input_text)
        passed = result == expected
        all_passed = all_passed and passed
        
        status = "✅" if passed else "❌"
        print(f"{status} Test {i}: {description}")
        if not passed:
            print(f"   Input:    {input_text!r}")
            print(f"   Expected: {expected!r}")
            print(f"   Got:      {result!r}")
            print()
    
    if all_passed:
        print("\n✨ All tests passed!")
    else:
        print("\n❌ Some tests failed!")
    
    return all_passed

if __name__ == '__main__':
    test_migrations()

