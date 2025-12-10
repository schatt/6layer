#!/usr/bin/env python3
import os
import sys
from pathlib import Path

EXCLUDES = {'.git', 'DerivedData', 'build', '__pycache__'}
EXTENSIONS = {
    '.swift', '.storyboard', '.xib', '.plist', '.xcdatamodeld', '.xcdatamodel',
    '.xcassets', '.png', '.jpg', '.jpeg', '.pdf', '.gif', '.tiff', '.bmp', '.heic', '.webp'
}

OUTPUT_FILE = 'all_project_files.txt'


def is_relevant(path: Path) -> bool:
    if any(part in EXCLUDES for part in path.parts):
        return False
    if path.suffix in EXTENSIONS:
        return True
    # .xcassets and .xcdatamodeld are directories, but we want to include them
    if path.is_dir() and path.suffix in {'.xcassets', '.xcdatamodeld'}:
        return True
    return False

def find_files(root: Path):
    files = set()
    for dirpath, dirnames, filenames in os.walk(root):
        # Remove excluded directories in-place
        dirnames[:] = [d for d in dirnames if d not in EXCLUDES]
        for fname in filenames:
            fpath = Path(dirpath) / fname
            if is_relevant(fpath):
                files.add(str(fpath.relative_to(root)))
        # Also include relevant directories (e.g., .xcassets, .xcdatamodeld)
        for dname in dirnames:
            dpath = Path(dirpath) / dname
            if is_relevant(dpath):
                files.add(str(dpath.relative_to(root)))
    return sorted(files)

def main():
    root = Path('.').resolve()
    new_list = find_files(root)
    new_content = '\n'.join(new_list) + '\n'
    out_path = root / OUTPUT_FILE
    if out_path.exists():
        old_content = out_path.read_text(encoding='utf-8')
        if old_content == new_content:
            print(f"No changes to {OUTPUT_FILE}.")
            sys.exit(0)
    out_path.write_text(new_content, encoding='utf-8')
    print(f"Updated {OUTPUT_FILE} with {len(new_list)} entries.")
    sys.exit(0)

if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1) 