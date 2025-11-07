#!/usr/bin/env python3
"""
Script to migrate platformListRow calls from old API to new API.

Old API:
    .platformListRow { Text("Item Title") }
    .platformListRow { Text(item.title) }
    .platformListRow { Text(item.title); Spacer(); Image(...) }

New API:
    .platformListRow(title: "Item Title") { }
    .platformListRow(title: item.title) { }
    .platformListRow(title: item.title) { Spacer(); Image(...) }
"""

import re
import sys
from pathlib import Path

def extract_text_string(text_match):
    """Extract string content from Text(...) call."""
    # Match Text("literal") or Text(variable) or Text(item.title)
    text_content = text_match.group(1)
    
    # Return as-is - preserve quotes for string literals, preserve variables/expressions
    # The regex captures the content inside Text(), so we just need to preserve it
    return text_content.strip()

def migrate_platform_list_row(content):
    """Migrate platformListRow calls to new API."""
    
    # Pattern 1: .platformListRow { Text("...") }
    # Pattern 2: .platformListRow { Text(...) ... }
    # Pattern 3: .platformListRow(label: "...") { Text(...) }
    
    # Handle simple case: .platformListRow { Text(...) }
    pattern1 = r'\.platformListRow\s*\{\s*Text\(([^)]+)\)\s*\}'
    def replace1(match):
        text_content = extract_text_string(match)
        return f'.platformListRow(title: {text_content}) {{ }}'
    
    # Handle case with Text followed by other content
    # This is more complex - we need to match the full closure
    pattern2 = r'\.platformListRow\s*\{\s*Text\(([^)]+)\)\s*;?\s*(.*?)\s*\}'
    def replace2(match):
        text_content = extract_text_string(match)
        trailing = match.group(2).strip()
        if trailing:
            # Remove Text from the trailing content if it appears
            trailing = re.sub(r'Text\([^)]+\)\s*;?\s*', '', trailing)
            trailing = trailing.strip()
            if trailing:
                return f'.platformListRow(title: {text_content}) {{ {trailing} }}'
        return f'.platformListRow(title: {text_content}) {{ }}'
    
    # Try pattern 2 first (more complex)
    content = re.sub(pattern2, replace2, content, flags=re.DOTALL)
    
    # Then pattern 1 (simpler)
    content = re.sub(pattern1, replace1, content)
    
    # Handle case with label parameter - remove label, use title instead
    pattern3 = r'\.platformListRow\s*\(label:\s*([^,)]+)\)\s*\{\s*Text\(([^)]+)\)'
    def replace3(match):
        label = match.group(1).strip()
        text_content = extract_text_string(match)
        # Use text_content if it's a variable, otherwise use label
        if not (text_content.startswith('"') or text_content.startswith("'")):
            title = text_content
        else:
            title = label
        return f'.platformListRow(title: {title}) {{'
    
    content = re.sub(pattern3, replace3, content)
    
    return content

def migrate_file(file_path):
    """Migrate a single file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original = content
        content = migrate_platform_list_row(content)
        
        if content != original:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"✅ Migrated: {file_path}")
            return True
        else:
            print(f"⏭️  No changes: {file_path}")
            return False
    except Exception as e:
        print(f"❌ Error processing {file_path}: {e}")
        return False

def main():
    """Main entry point."""
    if len(sys.argv) > 1:
        paths = [Path(p) for p in sys.argv[1:]]
    else:
        # Default: search in Framework and Development
        paths = [
            Path("Framework/Sources"),
            Path("Development/Tests")
        ]
    
    migrated = 0
    for path in paths:
        if path.is_file():
            if path.suffix == '.swift':
                if migrate_file(path):
                    migrated += 1
        elif path.is_dir():
            for swift_file in path.rglob('*.swift'):
                if migrate_file(swift_file):
                    migrated += 1
    
    print(f"\n✨ Migration complete: {migrated} file(s) updated")
    print("\n⚠️  Please review the changes and test thoroughly!")
    print("   Some patterns may need manual adjustment.")

if __name__ == '__main__':
    main()

