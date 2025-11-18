#!/bin/bash

# Find all Swift files with #if !os(macOS) and ViewInspector usage
find Development/Tests -name "*.swift" -exec grep -l "#if !os(macOS)" {} \; | while read file; do
    echo "Processing $file"
    
    # Use sed to replace the conditional compilation pattern
    # This is complex, so let's do it step by step
    
    # First, replace the guard + #if pattern with withInspectedView
    sed -i '' 's/guard let inspected = \(.*\.tryInspect()\) else {/\t\tlet inspectionResult = withInspectedView(\1) { inspected in/g' "$file"
    
    # Then replace the Issue.record in guard with the platform message
    sed -i '' 's/Issue\.record("Failed to inspect .*")/Issue.record("View inspection not available on this platform (likely macOS)")/g' "$file"
    
    # Remove the return statement
    sed -i '' '/return$/d' "$file"
    
    # Replace #if !os(macOS) with the inspection code
    sed -i '' 's/#if !os(macOS)/\t\t}/g' "$file"
    
    # Replace #endif with the nil check
    sed -i '' 's/#endif/\t\tif inspectionResult == nil {/g' "$file"
    
    # This is getting too complex for sed. Let me use a different approach.
done
