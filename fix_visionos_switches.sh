#!/bin/bash

# Script to add visionOS cases to all switch statements in the framework

# Find all Swift files with switch statements on Platform
find Framework/Sources/Shared -name "*.swift" -exec grep -l "switch.*platform" {} \; | while read file; do
    echo "Processing $file"
    
    # Add visionOS cases to switch statements
    # This is a simple approach - we'll add visionOS as a fallback case
    sed -i '' 's/case \.tvOS:$/case .tvOS:\
        case .visionOS:/g' "$file"
    
    # For switch statements that don't have tvOS, add visionOS as a separate case
    # This is more complex and would need more sophisticated parsing
    # For now, let's handle the common patterns manually
done

echo "Done processing files"
