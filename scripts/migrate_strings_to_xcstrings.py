#!/usr/bin/env python3
"""
Migration script to convert .lproj/.strings files to .xcstrings format.

This script:
1. Reads all .strings files from .lproj directories
2. Parses keys, values, and comments
3. Generates a single Localizable.xcstrings file in JSON format
4. Preserves all translations, comments, and metadata

Usage:
    migrate_strings_to_xcstrings.py [OPTIONS]

Examples:
    # Migrate Framework/Resources
    migrate_strings_to_xcstrings.py --source-dir Framework/Resources --output Framework/Resources/Localizable.xcstrings

    # Dry run (show what would be created)
    migrate_strings_to_xcstrings.py --source-dir Framework/Resources --dry-run
"""

import re
import json
import os
import sys
import argparse
from pathlib import Path
from typing import Dict, Set, List, Optional, Tuple
from collections import defaultdict

def parse_strings_file(file_path: Path) -> Tuple[Dict[str, str], Dict[str, str]]:
    """
    Parse a .strings file and return:
    - Dictionary of key-value pairs
    - Dictionary of key-comment pairs
    """
    strings = {}
    comments = {}
    
    if not file_path.exists():
        return strings, comments
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Track current comment for next key
    current_comment = None
    comment_buffer = []
    
    lines = content.split('\n')
    for line in lines:
        stripped = line.strip()
        
        # Collect comments
        if stripped.startswith('/*'):
            # Multi-line comment start
            comment_text = stripped[2:].rstrip('*/').strip()
            if '*/' in stripped:
                # Single-line comment
                current_comment = comment_text
            else:
                # Start of multi-line comment
                comment_buffer = [comment_text]
        elif '*/' in stripped and comment_buffer:
            # End of multi-line comment
            comment_buffer.append(stripped.rstrip('*/').strip())
            current_comment = ' '.join(comment_buffer).strip()
            comment_buffer = []
        elif comment_buffer:
            # Continuation of multi-line comment
            comment_buffer.append(stripped)
        elif stripped.startswith('//'):
            # Single-line comment
            current_comment = stripped[2:].strip()
        
        # Match lines like: "key" = "value";
        pattern = r'"([^"]+)"\s*=\s*"((?:[^"\\]|\\.)*)"\s*;'
        match = re.search(pattern, line)
        if match:
            key = match.group(1)
            value = match.group(2)
            # Unescape the value
            value = value.replace('\\"', '"').replace('\\n', '\n').replace('\\\\', '\\')
            strings[key] = value
            
            # Store comment if we have one
            if current_comment:
                comments[key] = current_comment
                current_comment = None
    
    return strings, comments

def discover_language_directories(base_dir: Path) -> Dict[str, Path]:
    """Discover all .lproj directories and return language code -> directory mapping."""
    languages = {}
    
    if not base_dir.exists():
        return languages
    
    for item in base_dir.iterdir():
        if item.is_dir() and item.name.endswith('.lproj'):
            lang_code = item.name[:-6]  # Remove '.lproj' suffix
            strings_file = item / 'Localizable.strings'
            if strings_file.exists():
                languages[lang_code] = strings_file
    
    return languages

def create_xcstrings_file(
    languages: Dict[str, Path],
    source_language: str = 'en',
    output_path: Path = None
) -> Dict:
    """
    Create .xcstrings file structure from .strings files.
    
    Returns the JSON structure that should be written to the file.
    """
    # Read all language files
    all_strings = {}
    all_comments = {}
    all_keys = set()
    
    for lang_code, strings_path in languages.items():
        strings, comments = parse_strings_file(strings_path)
        all_strings[lang_code] = strings
        all_comments[lang_code] = comments
        all_keys.update(strings.keys())
    
    # Build xcstrings structure
    xcstrings = {
        "version": "1.0",
        "sourceLanguage": source_language,
        "strings": {}
    }
    
    # Process each key
    for key in sorted(all_keys):
        key_entry = {}
        
        # Add comment from source language if available
        if source_language in all_comments and key in all_comments[source_language]:
            comment = all_comments[source_language][key].strip()
            if comment:
                key_entry["comment"] = comment
        
        # Add localizations for each language
        localizations = {}
        for lang_code in sorted(languages.keys()):
            if key in all_strings[lang_code]:
                value = all_strings[lang_code][key]
                localizations[lang_code] = {
                    "stringUnit": {
                        "state": "translated",
                        "value": value
                    }
                }
        
        if localizations:
            key_entry["localizations"] = localizations
            xcstrings["strings"][key] = key_entry
    
    return xcstrings

def main():
    parser = argparse.ArgumentParser(
        description='Migrate .lproj/.strings files to .xcstrings format',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Migrate Framework/Resources
  %(prog)s --source-dir Framework/Resources --output Framework/Resources/Localizable.xcstrings

  # Dry run
  %(prog)s --source-dir Framework/Resources --dry-run

  # Custom source language
  %(prog)s --source-dir Framework/Resources --source-language en --output Framework/Resources/Localizable.xcstrings
        """
    )
    
    parser.add_argument(
        '--source-dir',
        type=Path,
        default=Path('Framework/Resources'),
        help='Directory containing .lproj directories (default: Framework/Resources)'
    )
    
    parser.add_argument(
        '--output',
        type=Path,
        default=None,
        help='Output path for Localizable.xcstrings file (default: source-dir/Localizable.xcstrings)'
    )
    
    parser.add_argument(
        '--source-language',
        type=str,
        default='en',
        help='Source language code (default: en)'
    )
    
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Show what would be created without writing files'
    )
    
    args = parser.parse_args()
    
    # Determine output path
    if args.output is None:
        args.output = args.source_dir / 'Localizable.xcstrings'
    
    # Discover language directories
    languages = discover_language_directories(args.source_dir)
    
    if not languages:
        print(f"Error: No .lproj directories with Localizable.strings found in {args.source_dir}")
        sys.exit(1)
    
    print(f"Found {len(languages)} language(s): {', '.join(sorted(languages.keys()))}")
    
    # Verify source language exists
    if args.source_language not in languages:
        print(f"Warning: Source language '{args.source_language}' not found. Using '{sorted(languages.keys())[0]}' instead.")
        args.source_language = sorted(languages.keys())[0]
    
    # Create xcstrings structure
    print(f"Creating .xcstrings file from {len(languages)} language file(s)...")
    xcstrings = create_xcstrings_file(languages, args.source_language, args.output)
    
    # Count keys
    total_keys = len(xcstrings["strings"])
    print(f"Found {total_keys} unique localization key(s)")
    
    # Show statistics
    for lang_code in sorted(languages.keys()):
        lang_keys = sum(1 for key_data in xcstrings["strings"].values() 
                       if lang_code in key_data.get("localizations", {}))
        print(f"  {lang_code}: {lang_keys} key(s)")
    
    if args.dry_run:
        print("\n=== DRY RUN - Would create file ===")
        print(json.dumps(xcstrings, indent=2, ensure_ascii=False))
        return 0
    
    # Write output file
    print(f"\nWriting to {args.output}...")
    args.output.parent.mkdir(parents=True, exist_ok=True)
    
    with open(args.output, 'w', encoding='utf-8') as f:
        json.dump(xcstrings, f, indent=2, ensure_ascii=False)
    
    print(f"✓ Successfully created {args.output}")
    print(f"  Total keys: {total_keys}")
    print(f"  Languages: {', '.join(sorted(languages.keys()))}")
    print(f"\nNext steps:")
    print(f"  1. Add {args.output} to your Xcode project")
    print(f"  2. Remove .lproj directories from Xcode project")
    print(f"  3. Verify all tests pass")
    print(f"  4. Commit the changes")
    
    return 0

if __name__ == '__main__':
    sys.exit(main())





