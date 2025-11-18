#!/usr/bin/env python3
"""
Remove debug print statements from AccessibilityTestUtilities.swift to improve test performance.
"""

import re
import sys
from pathlib import Path

def remove_debug_prints(file_path):
    """Remove all debug print statements from the file"""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_lines = len(content.split('\n'))
    
    # Remove debug print statements
    # Pattern 1: print("DEBUG: ...")
    content = re.sub(r'\s*print\("DEBUG:.*?"\)\s*\n', '', content)
    
    # Pattern 2: print("🔍 SWIFTUI DEBUG: ...")
    content = re.sub(r'\s*print\("🔍 SWIFTUI DEBUG:.*?"\)\s*\n', '', content)
    
    # Pattern 3: print("🔍 PLATFORM FALLBACK: ...")
    content = re.sub(r'\s*print\("🔍 PLATFORM FALLBACK:.*?"\)\s*\n', '', content)
    
    # Pattern 4: print("🔍 COLLECT: ...")
    content = re.sub(r'\s*print\("🔍 COLLECT:.*?"\)\s*\n', '', content)
    
    # Pattern 5: print("❌ DISCOVERY: ...")
    content = re.sub(r'\s*print\("❌ DISCOVERY:.*?"\)\s*\n', '', content)
    
    # Pattern 6: print("⚠️ DISCOVERY: ...")
    content = re.sub(r'\s*print\("⚠️ DISCOVERY:.*?"\)\s*\n', '', content)
    
    # Pattern 7: print("❌ CROSS-PLATFORM: ...")
    content = re.sub(r'\s*print\("❌ CROSS-PLATFORM:.*?"\)\s*\n', '', content)
    
    # Pattern 8: Multi-line prints with string interpolation
    # This is more complex - remove print statements that span multiple lines
    content = re.sub(r'\s*print\(".*?"\)\s*\n', '', content)
    
    new_lines = len(content.split('\n'))
    removed = original_lines - new_lines
    
    with open(file_path, 'w') as f:
        f.write(content)
    
    return removed

if __name__ == "__main__":
    file_path = Path("/Users/schatt/code/github/6layer/Development/Tests/SixLayerFrameworkTests/Utilities/TestHelpers/AccessibilityTestUtilities.swift")
    
    if not file_path.exists():
        print(f"❌ File not found: {file_path}")
        sys.exit(1)
    
    print(f"🔧 Removing debug prints from {file_path.name}...")
    removed = remove_debug_prints(file_path)
    print(f"✅ Removed {removed} lines containing debug prints")


