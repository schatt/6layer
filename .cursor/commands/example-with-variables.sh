#!/bin/bash
# Example Cursor command that accepts variables
# Usage: This command demonstrates how to use variables in Cursor commands

# Positional arguments (passed when command is invoked)
ARG1="$1"  # First argument
ARG2="$2"  # Second argument
ARG3="$3"  # Third argument

# Cursor built-in variables (automatically provided by Cursor)
CURRENT_FILE="${file}"           # Currently open file
WORKSPACE="${workspace}"         # Workspace root path
LINE_NUMBER="${line}"            # Current line number
COLUMN_NUMBER="${column}"        # Current column number
SELECTED_TEXT="${selectedText}"  # Currently selected text

# Example: Print all variables
echo "Positional Arguments:"
echo "  Arg 1: $ARG1"
echo "  Arg 2: $ARG2"
echo "  Arg 3: $ARG3"
echo ""
echo "Cursor Variables:"
echo "  File: $CURRENT_FILE"
echo "  Workspace: $WORKSPACE"
echo "  Line: $LINE_NUMBER"
echo "  Column: $COLUMN_NUMBER"
echo "  Selected: $SELECTED_TEXT"

# Example: Use variables in a command
if [ -n "$ARG1" ]; then
    echo "Processing: $ARG1"
    # Your command logic here
fi





