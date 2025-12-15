#!/usr/bin/env python3
"""
CLI tool to check localization completeness for iOS/macOS .strings files.

This script:
1. Parses a base language localization file to get all keys
2. Compares each language file to identify missing keys
3. Generates a report of missing translations

Usage:
    check_localization_completeness.py [OPTIONS]

Examples:
    # Use default paths (Framework/Resources with en.lproj as base)
    check_localization_completeness.py

    # Specify custom base directory
    check_localization_completeness.py --base-dir ./Resources

    # Specify base language file directly
    check_localization_completeness.py --base-file ./en.lproj/Localizable.strings

    # Only check specific languages
    check_localization_completeness.py --languages es fr de

    # Custom report output location
    check_localization_completeness.py --report ./reports/missing_keys.txt
"""

import re
import os
import sys
import argparse
import shutil
from datetime import datetime
from pathlib import Path
from typing import Dict, Set, List, Optional, Tuple
from collections import defaultdict

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

def discover_language_directories(base_dir: Path, base_lang_code: str = 'en') -> Dict[str, str]:
    """
    Auto-discover language directories in the base directory.
    
    Looks for directories matching pattern: {lang_code}.lproj
    Returns a dict mapping lang_code to display name.
    """
    languages = {}
    
    if not base_dir.exists():
        return languages
    
    # Common language code to name mapping
    lang_names = {
        'en': 'English',
        'es': 'Spanish',
        'fr': 'French',
        'de': 'German',
        'ja': 'Japanese',
        'ko': 'Korean',
        'zh-Hans': 'Simplified Chinese',
        'zh-Hant': 'Traditional Chinese',
        'pl': 'Polish',
        'pt': 'Portuguese',
        'it': 'Italian',
        'ru': 'Russian',
        'ar': 'Arabic',
        'hi': 'Hindi',
        'de-CH': 'Swiss German',
        'fr-CA': 'Canadian French',
        'es-MX': 'Mexican Spanish',
    }
    
    for item in base_dir.iterdir():
        if item.is_dir() and item.name.endswith('.lproj'):
            lang_code = item.name.replace('.lproj', '')
            # Skip the base language directory
            if lang_code != base_lang_code:
                display_name = lang_names.get(lang_code, lang_code)
                languages[lang_code] = display_name
    
    return languages

def find_base_language_file(base_dir: Path, base_lang_code: str = 'en', filename: str = 'Localizable.strings') -> Optional[Path]:
    """Find the base language file."""
    base_lang_dir = base_dir / f'{base_lang_code}.lproj'
    base_file = base_lang_dir / filename
    
    if base_file.exists():
        return base_file
    
    # Try alternative: file might be directly in base_dir
    alt_file = base_dir / filename
    if alt_file.exists():
        return alt_file
    
    return None

def find_language_file(base_dir: Path, lang_code: str, filename: str = 'Localizable.strings') -> Optional[Path]:
    """Find a language file."""
    lang_dir = base_dir / f'{lang_code}.lproj'
    lang_file = lang_dir / filename
    
    if lang_file.exists():
        return lang_file
    
    return None

def get_language_name(lang_code: str) -> str:
    """Get display name for a language code."""
    lang_names = {
        'en': 'English',
        'es': 'Spanish',
        'fr': 'French',
        'de': 'German',
        'ja': 'Japanese',
        'ko': 'Korean',
        'zh-Hans': 'Simplified Chinese',
        'zh-Hant': 'Traditional Chinese',
        'pl': 'Polish',
        'pt': 'Portuguese',
        'it': 'Italian',
        'ru': 'Russian',
        'ar': 'Arabic',
        'hi': 'Hindi',
        'de-CH': 'Swiss German',
        'fr-CA': 'Canadian French',
        'es-MX': 'Mexican Spanish',
    }
    return lang_names.get(lang_code, lang_code)

def create_backup(file_path: Path, backup_dir: Path, lang_code: Optional[str] = None) -> Optional[Path]:
    """
    Create a timestamped backup of a file.
    
    Args:
        file_path: Path to the file to backup
        backup_dir: Directory to store backups
        lang_code: Optional language code to include in filename for uniqueness
    
    Returns the path to the backup file, or None if backup failed.
    """
    if not file_path.exists():
        return None
    
    try:
        # Create backup directory if it doesn't exist
        backup_dir.mkdir(parents=True, exist_ok=True)
        
        # Generate backup filename with timestamp and optional language code
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        if lang_code:
            backup_filename = f"{file_path.stem}_{lang_code}_{timestamp}{file_path.suffix}"
        else:
            # Include parent directory name for uniqueness
            parent_name = file_path.parent.name.replace('.lproj', '')
            backup_filename = f"{file_path.stem}_{parent_name}_{timestamp}{file_path.suffix}"
        backup_path = backup_dir / backup_filename
        
        # Copy file to backup location
        shutil.copy2(file_path, backup_path)
        
        return backup_path
    except Exception as e:
        print(f"Warning: Failed to backup {file_path}: {e}", file=sys.stderr)
        return None

def backup_localization_files(
    base_file: Path,
    language_files: List[Tuple[Path, str]],
    base_dir: Path,
    base_lang_code: str,
    quiet: bool = False
) -> List[Path]:
    """
    Create backups of all localization files.
    
    Args:
        base_file: Path to base language file
        language_files: List of tuples (file_path, lang_code)
        base_dir: Base directory for backups
        base_lang_code: Base language code
        quiet: Suppress output
    
    Returns list of successfully backed up file paths.
    """
    # Create backup directory in base directory
    backup_dir = base_dir / '.localization_backups'
    
    backed_up = []
    
    # Backup base file
    if base_file.exists():
        backup_path = create_backup(base_file, backup_dir, base_lang_code)
        if backup_path:
            backed_up.append(backup_path)
            if not quiet:
                print(f"Backed up: {base_file} -> {backup_path}")
    
    # Backup language files
    for lang_file, lang_code in language_files:
        if lang_file and lang_file.exists():
            backup_path = create_backup(lang_file, backup_dir, lang_code)
            if backup_path:
                backed_up.append(backup_path)
                if not quiet:
                    print(f"Backed up: {lang_file} -> {backup_path}")
    
    if not quiet and backed_up:
        print(f"\nCreated {len(backed_up)} backup(s) in: {backup_dir}")
    
    return backed_up

def write_report(report_file: Path, base_strings: Dict[str, str], missing_by_lang: Dict[str, Set[str]], base_lang_code: str = 'en') -> None:
    """Write the missing keys report to a file."""
    all_missing = set()
    for missing in missing_by_lang.values():
        all_missing.update(missing)
    
    with open(report_file, 'w', encoding='utf-8') as f:
        f.write("Missing Localization Keys Report\n")
        f.write("=" * 60 + "\n\n")
        f.write(f"Base language: {get_language_name(base_lang_code)} ({base_lang_code})\n")
        f.write(f"Total keys in base language: {len(base_strings)}\n")
        f.write(f"Total missing keys across all languages: {len(all_missing)}\n\n")
        
        for lang_code, missing in sorted(missing_by_lang.items()):
            if missing:
                f.write(f"\n{get_language_name(lang_code)} ({lang_code}): {len(missing)} missing\n")
                f.write("-" * 60 + "\n")
                for key in sorted(missing):
                    base_value = base_strings.get(key, '')
                    f.write(f'\nKey: "{key}"\n')
                    f.write(f'Base ({base_lang_code}): "{base_value}"\n')
                    f.write(f'Translation needed\n')

def main() -> int:
    """Main function to check localization completeness."""
    parser = argparse.ArgumentParser(
        description='Check localization completeness for iOS/macOS .strings files',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Use default paths (Framework/Resources with en.lproj as base)
  %(prog)s

  # Specify custom base directory
  %(prog)s --base-dir ./Resources

  # Specify base language file directly
  %(prog)s --base-file ./en.lproj/Localizable.strings

  # Only check specific languages
  %(prog)s --languages es fr de

  # Custom report output location
  %(prog)s --report ./reports/missing_keys.txt

  # Quiet mode (exit code only)
  %(prog)s --quiet

  # Create backups before checking
  %(prog)s --backup
        """
    )
    
    parser.add_argument(
        '--base-dir',
        type=Path,
        help='Base directory containing .lproj folders (default: Framework/Resources relative to script)'
    )
    
    parser.add_argument(
        '--base-file',
        type=Path,
        help='Path to base language .strings file (overrides --base-dir)'
    )
    
    parser.add_argument(
        '--base-lang',
        default='en',
        help='Base language code (default: en)'
    )
    
    parser.add_argument(
        '--filename',
        default='Localizable.strings',
        help='Name of the .strings file to check (default: Localizable.strings)'
    )
    
    parser.add_argument(
        '--languages',
        nargs='+',
        help='Specific language codes to check (default: auto-discover all .lproj directories)'
    )
    
    parser.add_argument(
        '--report',
        type=Path,
        help='Path to write report file (default: localization_missing_keys_report.txt in base directory)'
    )
    
    parser.add_argument(
        '--quiet',
        action='store_true',
        help='Quiet mode: only output errors and exit code'
    )
    
    parser.add_argument(
        '--no-report',
        action='store_true',
        help='Do not generate report file'
    )
    
    parser.add_argument(
        '--backup',
        action='store_true',
        help='Create timestamped backups of localization files before checking (default: off)'
    )
    
    args = parser.parse_args()
    
    # Determine base file location
    if args.base_file:
        base_file = Path(args.base_file).resolve()
        if not base_file.exists():
            print(f"Error: Base file not found: {base_file}", file=sys.stderr)
            return 1
        base_dir = base_file.parent.parent  # Go up from {lang}.lproj/Filename
        base_lang_code = base_file.parent.name.replace('.lproj', '')
    elif args.base_dir:
        base_dir = Path(args.base_dir).resolve()
        base_lang_code = args.base_lang
        base_file = find_base_language_file(base_dir, base_lang_code, args.filename)
        if not base_file:
            print(f"Error: Base language file not found in {base_dir}", file=sys.stderr)
            print(f"  Looking for: {base_lang_code}.lproj/{args.filename}", file=sys.stderr)
            return 1
    else:
        # Default: Framework/Resources relative to script
        script_dir = Path(__file__).parent.parent
        base_dir = script_dir / 'Framework' / 'Resources'
        base_lang_code = args.base_lang
        base_file = find_base_language_file(base_dir, base_lang_code, args.filename)
        if not base_file:
            print(f"Error: Base language file not found at {base_dir}", file=sys.stderr)
            print(f"  Looking for: {base_lang_code}.lproj/{args.filename}", file=sys.stderr)
            return 1
    
    if not args.quiet:
        print(f"Base directory: {base_dir}")
        print(f"Base language file: {base_file}")
        print(f"Parsing base language file ({base_lang_code})...")
    
    # Parse base language file
    base_strings = parse_strings_file(base_file)
    base_keys = set(base_strings.keys())
    
    if not args.quiet:
        print(f"Found {len(base_keys)} keys in base language file")
    
    if len(base_keys) == 0:
        print("Warning: No keys found in base language file", file=sys.stderr)
        return 1
    
    # Determine which languages to check
    if args.languages:
        languages_to_check = {lang: get_language_name(lang) for lang in args.languages}
    else:
        languages_to_check = discover_language_directories(base_dir, base_lang_code)
    
    if not languages_to_check:
        print("Warning: No language directories found to check", file=sys.stderr)
        return 1
    
    if not args.quiet:
        print(f"Checking {len(languages_to_check)} language(s)...")
    
    # Create backups if requested
    if args.backup:
        language_files = []
        for lang_code in languages_to_check.keys():
            lang_file = find_language_file(base_dir, lang_code, args.filename)
            if lang_file:
                language_files.append((lang_file, lang_code))
        
        backup_localization_files(base_file, language_files, base_dir, base_lang_code, args.quiet)
        if not args.quiet:
            print()  # Empty line after backup messages
    
    # Check each language
    missing_by_lang = {}
    all_missing = set()
    
    for lang_code, lang_name in sorted(languages_to_check.items()):
        lang_file = find_language_file(base_dir, lang_code, args.filename)
        
        if not lang_file:
            if not args.quiet:
                print(f"\n{lang_name} ({lang_code}): ⚠ File not found")
            missing_by_lang[lang_code] = base_keys.copy()  # All keys missing
            all_missing.update(base_keys)
            continue
        
        lang_strings = parse_strings_file(lang_file)
        lang_keys = set(lang_strings.keys())
        
        missing = find_missing_keys(base_keys, lang_keys)
        missing_by_lang[lang_code] = missing
        all_missing.update(missing)
        
        if not args.quiet:
            if missing:
                print(f"\n{lang_name} ({lang_code}): {len(missing)} missing keys")
                for key in sorted(missing):
                    print(f"  - {key}")
            else:
                print(f"\n{lang_name} ({lang_code}): ✓ Complete")
    
    # Summary
    if not args.quiet:
        print(f"\n{'='*60}")
        print(f"Summary:")
        print(f"  Base language ({base_lang_code}): {len(base_keys)} keys")
        print(f"  Total missing keys across all languages: {len(all_missing)}")
        
        for lang_code, missing in sorted(missing_by_lang.items()):
            if missing:
                print(f"  {get_language_name(lang_code)}: {len(missing)} missing")
    
    # Generate report
    if not args.no_report:
        if args.report:
            report_file = Path(args.report).resolve()
        else:
            report_file = base_dir.parent / 'localization_missing_keys_report.txt'
        
        write_report(report_file, base_strings, missing_by_lang, base_lang_code)
        
        if not args.quiet:
            print(f"\nReport written to: {report_file}")
    
    # Exit code: 0 if complete, 1 if missing keys
    return 0 if len(all_missing) == 0 else 1

if __name__ == '__main__':
    sys.exit(main())


