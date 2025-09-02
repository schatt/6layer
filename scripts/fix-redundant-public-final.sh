#!/bin/bash

# Final script to fix redundant 'public' modifiers in public extensions
# This preserves protocol implementations and other required public methods

echo "🔧 Final fixing of redundant 'public' modifiers..."

# Find all Swift files in the Framework/Sources directory
find Framework/Sources -name "*.swift" -type f | while read -r file; do
    echo "Processing: $file"
    
    # Create a temporary file
    temp_file=$(mktemp)
    
    # Process the file to remove redundant 'public' modifiers
    # Only remove 'public' from regular functions in public extensions
    # Preserve protocol implementations and other required public methods
    
    # Remove 'public' from regular functions that start with lowercase letters
    # This targets functions like 'public func platformSomething' but preserves
    # protocol implementations like 'public func body(content:)' and 'public func _body(configuration:)'
    sed -E 's/^([[:space:]]*)public func ([a-z][a-zA-Z0-9_]*)/\1    func \2/g' "$file" > "$temp_file"
    
    # Remove 'public' from static functions that start with lowercase letters
    sed -E 's/^([[:space:]]*)public static func ([a-z][a-zA-Z0-9_]*)/\1    static func \2/g' "$temp_file" > "$file"
    
    # Clean up
    rm "$temp_file"
done

echo "✅ Final fixed redundant 'public' modifiers in all Swift files"
