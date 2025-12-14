#!/usr/bin/env python3
"""
Script to generate machine translations for missing localization keys.

This script:
1. Identifies missing keys in each language file
2. Generates machine translations using deep-translator
3. Updates the language files with missing translations
"""

import re
import os
import sys
from pathlib import Path
from typing import Dict, Set, List, Tuple

try:
    from deep_translator import GoogleTranslator
except ImportError:
    print("Error: deep-translator not installed. Install with: pip install deep-translator")
    sys.exit(1)

# Language codes mapping
LANGUAGE_MAPPING = {
    'es': 'es',  # Spanish
    'fr': 'fr',  # French
    'de': 'de',  # German
    'ja': 'ja',  # Japanese
    'ko': 'ko',  # Korean
    'zh-Hans': 'zh-CN',  # Simplified Chinese
    'pl': 'pl',  # Polish
    'de-CH': 'de',  # Swiss German (use German)
}

LANGUAGE_NAMES = {
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

def escape_string(value: str) -> str:
    """Escape a string for use in .strings file."""
    return value.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n')

def find_insertion_point(content: str, section_comment: str = None) -> int:
    """Find where to insert new keys in the file."""
    lines = content.split('\n')
    
    # If we have a section comment, try to find it
    if section_comment:
        for i, line in enumerate(lines):
            if section_comment in line:
                # Find the end of this section
                for j in range(i + 1, len(lines)):
                    if lines[j].strip().startswith('/*') and '===' in lines[j]:
                        return j
                # If no next section, append at end
                return len(lines)
    
    # Otherwise, append at the end before the last newline
    return len(lines) - 1 if lines and lines[-1] == '' else len(lines)

def get_section_for_key(key: str, en_structure: Dict) -> str:
    """Determine which section a key belongs to based on English file structure."""
    # Simple heuristic based on key prefix
    if key.startswith('SixLayerFramework.error'):
        return 'ERROR MESSAGES'
    elif key.startswith('SixLayerFramework.form.placeholder'):
        return 'FORM PLACEHOLDERS'
    elif key.startswith('SixLayerFramework.button'):
        return 'BUTTON LABELS'
    elif key.startswith('SixLayerFramework.ocr'):
        return 'OCR INTERFACE'
    elif key.startswith('SixLayerFramework.validation'):
        return 'VALIDATION MESSAGES'
    elif key.startswith('SixLayerFramework.status'):
        return 'STATUS AND LOADING'
    elif key.startswith('SixLayerFramework.navigation'):
        return 'NAVIGATION'
    elif key.startswith('SixLayerFramework.emptyState'):
        return 'NAVIGATION'
    elif key.startswith('SixLayerFramework.complexity'):
        return 'NAVIGATION'
    elif key.startswith('SixLayerFramework.form'):
        return 'FORM FIELD LABELS'
    elif key.startswith('SixLayerFramework.barcode'):
        return 'OCR INTERFACE'
    elif key.startswith('SixLayerFramework.location'):
        return 'ERROR MESSAGES'
    elif key.startswith('SixLayerFramework.directory'):
        return 'ERROR MESSAGES'
    elif key.startswith('SixLayerFramework.filesystem'):
        return 'ERROR MESSAGES'
    elif key.startswith('SixLayerFramework.metadata'):
        return 'ERROR MESSAGES'
    elif key.startswith('SixLayerFramework.image'):
        return 'ERROR MESSAGES'
    elif key.startswith('SixLayerFramework.fieldAction'):
        return 'ERROR MESSAGES'
    elif key.startswith('SixLayerFramework.platform'):
        return 'PLATFORM SPECIFIC'
    elif key.startswith('SixLayerFramework.runtime'):
        return 'PLATFORM SPECIFIC'
    elif key.startswith('SixLayerFramework.vision'):
        return 'PLATFORM SPECIFIC'
    elif key.startswith('SixLayerFramework.accessibility'):
        return 'ACCESSIBILITY'
    elif key.startswith('SixLayerFramework.list'):
        return 'LIST AND COLLECTION'
    elif key.startswith('SixLayerFramework.detail'):
        return 'PLATFORM SPECIFIC'
    elif key.startswith('SixLayerFramework.example'):
        return 'PLATFORM SPECIFIC'
    elif key.startswith('SixLayerFramework.camera'):
        return 'BUTTON LABELS'
    elif key.startswith('SixLayerFramework.imagePicker'):
        return 'BUTTON LABELS'
    else:
        return 'PLATFORM SPECIFIC'

def translate_text(text: str, target_lang: str, source_lang: str = 'en') -> str:
    """Translate text using Google Translator."""
    try:
        translator = GoogleTranslator(source=source_lang, target=target_lang)
        translated = translator.translate(text)
        return translated
    except Exception as e:
        print(f"  Warning: Translation failed for '{text}': {e}")
        return text  # Return original if translation fails

def update_language_file(lang_code: str, missing_keys: Set[str], en_strings: Dict[str, str], 
                        base_dir: Path, dry_run: bool = False) -> bool:
    """Update a language file with missing translations."""
    lang_file = base_dir / f'{lang_code}.lproj' / 'Localizable.strings'
    
    if not lang_file.exists():
        print(f"Error: Language file not found: {lang_file}")
        return False
    
    # Read current content
    with open(lang_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Get target language code
    target_lang = LANGUAGE_MAPPING.get(lang_code, 'en')
    
    print(f"\nTranslating {len(missing_keys)} keys for {LANGUAGE_NAMES[lang_code]}...")
    
    # Group keys by section
    keys_by_section = {}
    for key in sorted(missing_keys):
        section = get_section_for_key(key, {})
        if section not in keys_by_section:
            keys_by_section[section] = []
        keys_by_section[section].append(key)
    
    # Generate translations
    translations = []
    for section, keys in keys_by_section.items():
        translations.append(f"\n/* {section} - Missing translations */\n")
        for key in keys:
            english_value = en_strings.get(key, '')
            if not english_value:
                continue
            
            # Handle format strings - preserve %@, %d, etc.
            # Translate the text parts
            translated = translate_text(english_value, target_lang)
            
            # Escape for .strings file
            escaped_key = escape_string(key)
            escaped_value = escape_string(translated)
            
            translations.append(f'"{escaped_key}" = "{escaped_value}";\n')
    
    if dry_run:
        print(f"\nWould add to {lang_file}:")
        print(''.join(translations))
        return True
    
    # Append translations to file
    with open(lang_file, 'a', encoding='utf-8') as f:
        f.write('\n')
        f.write('/* ============================================================================\n')
        f.write('   MACHINE TRANSLATIONS - REVIEW REQUIRED\n')
        f.write('   ============================================================================ */\n')
        f.write(''.join(translations))
    
    print(f"✓ Updated {lang_file}")
    return True

def main():
    """Main function."""
    import argparse
    
    parser = argparse.ArgumentParser(description='Generate missing translations')
    parser.add_argument('--dry-run', action='store_true', help='Show what would be added without modifying files')
    parser.add_argument('--lang', help='Only update specific language (e.g., es, fr, de)')
    args = parser.parse_args()
    
    base_dir = Path(__file__).parent.parent / 'Framework' / 'Resources'
    en_file = base_dir / 'en.lproj' / 'Localizable.strings'
    
    if not en_file.exists():
        print(f"Error: English file not found at {en_file}")
        return 1
    
    # Parse English file
    print("Parsing English localization file...")
    en_strings = parse_strings_file(en_file)
    en_keys = set(en_strings.keys())
    print(f"Found {len(en_keys)} keys in English file")
    
    # Check each language
    languages_to_update = [args.lang] if args.lang else list(LANGUAGE_NAMES.keys())
    
    for lang_code in languages_to_update:
        if lang_code not in LANGUAGE_NAMES:
            print(f"Warning: Unknown language code: {lang_code}")
            continue
        
        lang_file = base_dir / f'{lang_code}.lproj' / 'Localizable.strings'
        if not lang_file.exists():
            print(f"Warning: Language file not found: {lang_file}")
            continue
        
        lang_strings = parse_strings_file(lang_file)
        lang_keys = set(lang_strings.keys())
        
        missing = en_keys - lang_keys
        
        if missing:
            print(f"\n{LANGUAGE_NAMES[lang_code]} ({lang_code}): {len(missing)} missing keys")
            update_language_file(lang_code, missing, en_strings, base_dir, args.dry_run)
        else:
            print(f"\n{LANGUAGE_NAMES[lang_code]} ({lang_code}): ✓ Complete")
    
    print("\n✓ Done!")
    return 0

if __name__ == '__main__':
    sys.exit(main())

