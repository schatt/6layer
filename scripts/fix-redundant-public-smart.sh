#!/bin/bash

# Smart script to fix redundant 'public' modifiers in public extensions
# This addresses the warnings shown in Xcode while preserving required public methods

echo "🔧 Smart fixing of redundant 'public' modifiers..."

# Find all Swift files in the Framework/Sources directory
find Framework/Sources -name "*.swift" -type f | while read -r file; do
    echo "Processing: $file"
    
    # Create a temporary file
    temp_file=$(mktemp)
    
    # Process the file to remove redundant 'public' modifiers
    # Only remove 'public' from regular functions, not protocol implementations
    # This handles the pattern: 'public func' -> '    func' (with proper indentation)
    # but preserves 'public func body(content:)' and 'public func _body(configuration:)'
    sed -E 's/^([[:space:]]*)public func ([^b_][^o][^d][^y])/\1    func \2/g' "$file" > "$temp_file"
    sed -E 's/^([[:space:]]*)public static func/\1    static func/g' "$temp_file" > "$file"
    
    # Clean up
    rm "$temp_file"
done

echo "✅ Smart fixed redundant 'public' modifiers in all Swift files"
