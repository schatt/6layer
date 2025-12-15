#!/usr/bin/env python3
"""
Script to check localization completeness and generate missing translations.

This script:
1. Parses the English localization file to get all keys
2. Compares each language file to identify missing keys
3. Generates machine translations for missing keys
"""

import re
import os
from pathlib import Path
from typing import Dict, Set, Tuple
from collections import defaultdict

# Language codes and their display names
LANGUAGES = {
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'ja': 'Japanese',
    'ko': 'Korean',
    'zh-Hans': 'Simplified Chinese',
    'pl': 'Polish',
    'de-CH': 'Swiss German'
}

def parse_strings_file(file_path: Path) -> Dict[str, str]:
    """Parse a .strings file and return a dictionary of key-value pairs."""
    strings = {}
    if not file_path.exists():
        return strings
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Match lines like: "key" = "value";
    pattern = r'"([^"]+)"\s*=\s*"([^"]*(?:\\.[^"]*)*)"\s*;'
    matches = re.finditer(pattern, content, re.MULTILINE)
    
    for match in matches:
        key = match.group(1)
        value = match.group(2)
        # Unescape the value
        value = value.replace('\\"', '"').replace('\\n', '\n').replace('\\\\', '\\')
        strings[key] = value
    
    return strings

def extract_comments_and_structure(file_path: Path) -> Dict[str, any]:
    """Extract comments and structure from a .strings file."""
    structure = {
        'header': '',
        'sections': [],
        'keys': {}
    }
    
    if not file_path.exists():
        return structure
    
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    current_section = None
    header_lines = []
    in_header = True
    
    for line in lines:
        stripped = line.strip()
        
        # Check if we're still in the header (before first key)
        if in_header:
            if re.match(r'^"[^"]+"\s*=', line):
                in_header = False
                structure['header'] = ''.join(header_lines)
            else:
                header_lines.append(line)
                continue
        
        # Check for section comments
        if stripped.startswith('/*') and '===' in stripped:
            current_section = stripped
            structure['sections'].append({
                'comment': stripped,
                'keys': []
            })
        elif stripped.startswith('/*') and not '===' in stripped:
            # Regular comment
            if current_section:
                structure['sections'][-1]['comment'] += '\n' + stripped
        elif re.match(r'^"[^"]+"\s*=', line):
            key_match = re.search(r'"([^"]+)"', line)
            if key_match:
                key = key_match.group(1)
                if current_section:
                    structure['sections'][-1]['keys'].append(key)
                structure['keys'][key] = line.rstrip()
    
    return structure

def find_missing_keys(base_keys: Set[str], lang_keys: Set[str]) -> Set[str]:
    """Find keys that are in base but not in lang."""
    return base_keys - lang_keys

def generate_translation_placeholder(key: str, english_value: str, lang_code: str) -> str:
    """Generate a placeholder translation (machine translation would go here)."""
    # For now, return a comment indicating it needs translation
    # In a real implementation, this would call a translation API
    return f'/* TODO: Translate "{english_value}" */\n"{key}" = "{english_value}";'

def main():
    """Main function to check and update localization files."""
    base_dir = Path(__file__).parent.parent / 'Framework' / 'Resources'
    en_file = base_dir / 'en.lproj' / 'Localizable.strings'
    
    if not en_file.exists():
        print(f"Error: English file not found at {en_file}")
        return
    
    # Parse English file
    print("Parsing English localization file...")
    en_strings = parse_strings_file(en_file)
    en_structure = extract_comments_and_structure(en_file)
    en_keys = set(en_strings.keys())
    
    print(f"Found {len(en_keys)} keys in English file")
    
    # Check each language
    missing_by_lang = {}
    all_missing = set()
    
    for lang_code, lang_name in LANGUAGES.items():
        lang_file = base_dir / f'{lang_code}.lproj' / 'Localizable.strings'
        lang_strings = parse_strings_file(lang_file)
        lang_keys = set(lang_strings.keys())
        
        missing = find_missing_keys(en_keys, lang_keys)
        missing_by_lang[lang_code] = missing
        all_missing.update(missing)
        
        if missing:
            print(f"\n{lang_name} ({lang_code}): {len(missing)} missing keys")
            for key in sorted(missing):
                print(f"  - {key}")
        else:
            print(f"\n{lang_name} ({lang_code}): ✓ Complete")
    
    # Summary
    print(f"\n{'='*60}")
    print(f"Summary:")
    print(f"  Total keys in English: {len(en_keys)}")
    print(f"  Total missing keys across all languages: {len(all_missing)}")
    
    for lang_code, missing in missing_by_lang.items():
        if missing:
            print(f"  {LANGUAGES[lang_code]}: {len(missing)} missing")
    
    # Generate report
    report_file = base_dir.parent.parent / 'localization_missing_keys_report.txt'
    with open(report_file, 'w', encoding='utf-8') as f:
        f.write("Missing Localization Keys Report\n")
        f.write("=" * 60 + "\n\n")
        f.write(f"Total keys in English: {len(en_keys)}\n")
        f.write(f"Total missing keys: {len(all_missing)}\n\n")
        
        for lang_code, missing in missing_by_lang.items():
            if missing:
                f.write(f"\n{LANGUAGES[lang_code]} ({lang_code}): {len(missing)} missing\n")
                f.write("-" * 60 + "\n")
                for key in sorted(missing):
                    english_value = en_strings.get(key, '')
                    f.write(f'\nKey: "{key}"\n')
                    f.write(f'English: "{english_value}"\n')
                    f.write(f'Translation needed\n')
    
    print(f"\nReport written to: {report_file}")
    
    return missing_by_lang, en_strings

if __name__ == '__main__':
    main()


