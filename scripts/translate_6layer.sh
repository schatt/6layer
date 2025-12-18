#!/bin/bash
#
# Wrapper script for translating 6layer framework localization files
# This script calls generate_missing_translations.py with 6layer-specific defaults
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RESOURCES_DIR="$PROJECT_ROOT/Framework/Resources"

# Default to 6layer resources directory
BASE_DIR="${BASE_DIR:-$RESOURCES_DIR}"

# Run the translation script with 6layer defaults
python3 "$SCRIPT_DIR/generate_missing_translations.py" \
    --base-dir "$BASE_DIR" \
    "$@"




