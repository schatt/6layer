#!/bin/bash

# Script to fix redundant 'public' modifiers in public extensions
# This addresses the warnings shown in Xcode

echo "🔧 Fixing redundant 'public' modifiers..."

# Find all Swift files in the Framework/Sources directory
find Framework/Sources -name "*.swift" -type f | while read -r file; do
    echo "Processing: $file"
    
    # Create a temporary file
    temp_file=$(mktemp)
    
    # Process the file to remove redundant 'public' modifiers
    # This handles the pattern: 'public func' -> '    func' (with proper indentation)
    # and 'public static func' -> '    static func'
    sed -E 's/^([[:space:]]*)public func/\1    func/g' "$file" > "$temp_file"
    sed -E 's/^([[:space:]]*)public static func/\1    static func/g' "$temp_file" > "$file"
    
    # Clean up
    rm "$temp_file"
done

echo "✅ Fixed redundant 'public' modifiers in all Swift files"
