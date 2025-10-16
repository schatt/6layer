#!/bin/bash

# Script to fix missing hints parameters in card component calls
# This addresses the systematic issue where card components require hints parameter

echo "Fixing missing hints parameters in card component calls..."

# Fix SimpleCardComponent calls with layoutDecision parameter (more complex pattern)
find Development/Tests/SixLayerFrameworkTests/ -name "*.swift" -exec sed -i '' 's/layoutDecision: layoutDecision,/layoutDecision: layoutDecision,\
            hints: PresentationHints(),/g' {} \;

# Fix ListCardComponent calls with single item parameter
find Development/Tests/SixLayerFrameworkTests/ -name "*.swift" -exec sed -i '' 's/ListCardComponent(item: \([^)]*\))/ListCardComponent(item: \1, hints: PresentationHints())/g' {} \;

# Fix MasonryCardComponent calls with single item parameter  
find Development/Tests/SixLayerFrameworkTests/ -name "*.swift" -exec sed -i '' 's/MasonryCardComponent(item: \([^)]*\))/MasonryCardComponent(item: \1, hints: PresentationHints())/g' {} \;

echo "Fixed missing hints parameters"
