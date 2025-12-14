# Cursor Commands with Variables

This directory contains custom Cursor commands that can accept variables.

## How to Use Variables in Cursor Commands

### 1. Positional Arguments (`$1`, `$2`, etc.)

When you invoke a command, you can pass arguments that are accessed as `$1`, `$2`, etc.

**Example command file:**
```bash
#!/bin/bash
FILE_NAME="$1"
SEARCH_TERM="$2"

grep -r "$SEARCH_TERM" "$FILE_NAME"
```

**To invoke:** The command would be called with arguments like: `command.sh "file.swift" "functionName"`

### 2. Cursor Built-in Variables

Cursor automatically provides these variables:

- `${file}` - Currently open file path
- `${workspace}` - Workspace root directory
- `${line}` - Current line number
- `${column}` - Current column number
- `${selectedText}` - Currently selected text
- `${relativeFile}` - Relative path to current file
- `${fileBasename}` - Current file name without path
- `${fileDirname}` - Directory of current file

**Example:**
```bash
#!/bin/bash
echo "Working on: ${file}"
echo "At line: ${line}"
echo "Selected: ${selectedText}"
```

### 3. Environment Variables

You can use any environment variable that's set in your shell:

```bash
#!/bin/bash
echo "User: $USER"
echo "Home: $HOME"
echo "Custom var: $MY_CUSTOM_VAR"
```

### 4. Prompting for Input

For interactive commands, you can prompt the user:

```bash
#!/bin/bash
read -p "Enter file name: " FILE_NAME
read -p "Enter search term: " SEARCH_TERM

grep -r "$SEARCH_TERM" "$FILE_NAME"
```

## Example Commands

### Example 1: Search in File
```bash
#!/bin/bash
# Search for a term in the current file
SEARCH_TERM="$1"
FILE="${file}"

if [ -z "$SEARCH_TERM" ]; then
    echo "Usage: Provide a search term as argument"
    exit 1
fi

grep -n "$SEARCH_TERM" "$FILE"
```

### Example 2: Create File with Template
```bash
#!/bin/bash
# Create a new Swift file with a template
FILE_NAME="$1"
CLASS_NAME="$2"

if [ -z "$FILE_NAME" ] || [ -z "$CLASS_NAME" ]; then
    echo "Usage: create-swift-file.sh <filename> <classname>"
    exit 1
fi

cat > "$FILE_NAME" << EOF
import Foundation

class $CLASS_NAME {
    // TODO: Implement
}
EOF
```

### Example 3: Using Selected Text
```bash
#!/bin/bash
# Process the currently selected text
SELECTED="${selectedText}"

if [ -z "$SELECTED" ]; then
    echo "No text selected"
    exit 1
fi

echo "Selected text: $SELECTED"
# Process it...
```

## How to Invoke Commands

1. **Command Palette**: Press `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux)
2. Type "Cursor: Run Command" or search for your command name
3. Enter arguments when prompted (if the command uses `$1`, `$2`, etc.)

## Notes

- Make sure command files are executable: `chmod +x .cursor/commands/your-command.sh`
- Use `#!/bin/bash` or `#!/bin/sh` at the top of shell scripts
- For Python scripts, use `#!/usr/bin/env python3`
- Variables are case-sensitive
- Always quote variables to handle spaces: `"$1"` not `$1`
