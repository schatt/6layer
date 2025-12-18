#!/usr/bin/env python3
"""
Wrapper script for translating 6layer framework localization files.

This script calls generate_missing_translations.py with 6layer-specific defaults.
You can override any option by passing it through.

Usage:
    python3 translate_6layer.py [OPTIONS]

Examples:
    # Translate all missing translations
    python3 translate_6layer.py

    # Translate specific languages only
    python3 translate_6layer.py --languages fr de es

    # Use DeepL
    DEEPL_API_KEY=your_key python3 translate_6layer.py --provider deepl

    # Dry run
    python3 translate_6layer.py --dry-run

    # Save more frequently
    python3 translate_6layer.py --save-interval 25
"""

import sys
import subprocess
from pathlib import Path

# Get script directory and project root
SCRIPT_DIR = Path(__file__).parent
PROJECT_ROOT = SCRIPT_DIR.parent
RESOURCES_DIR = PROJECT_ROOT / 'Framework' / 'Resources'

# Build command
cmd = [
    sys.executable,
    str(SCRIPT_DIR / 'generate_missing_translations.py'),
    '--base-dir', str(RESOURCES_DIR)
]

# Pass through all arguments
cmd.extend(sys.argv[1:])

# Run the script
try:
    sys.exit(subprocess.run(cmd).returncode)
except KeyboardInterrupt:
    print("\n\nTranslation interrupted by user.")
    sys.exit(130)
except Exception as e:
    print(f"\n❌ Error: {e}", file=sys.stderr)
    sys.exit(1)




