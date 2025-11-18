#!/bin/bash

# Comprehensive compilation error fix script
# Following TDD, DRY, DTRT, and epistemological principles

echo "Starting comprehensive compilation error fixes..."

# 1. Fix missing Foundation imports (for UUID, etc.)
echo "Fixing missing Foundation imports..."
find /Users/schatt/code/github/6layer/Development/Tests -name "*.swift" -exec grep -l "cannot find 'UUID'" {} \; | while read file; do
    if ! grep -q "import Foundation" "$file"; then
        sed -i '' '1i\
import Foundation
' "$file"
    fi
done

# 2. Fix missing Testing imports for expect macro
echo "Fixing missing Testing imports..."
find /Users/schatt/code/github/6layer/Development/Tests -name "*.swift" -exec grep -l "no macro named 'expect'" {} \; | while read file; do
    if ! grep -q "import Testing" "$file"; then
        sed -i '' '1i\
import Testing
' "$file"
    fi
done

# 3. Fix setupTestEnvironment and cleanupTestEnvironment issues
echo "Fixing setupTestEnvironment issues..."
find /Users/schatt/code/github/6layer/Development/Tests -name "*.swift" -exec grep -l "cannot find 'setupTestEnvironment'" {} \; | while read file; do
    # Add proper setup methods
    cat > /tmp/setup_fix.swift << 'EOF'
    private func setupTestEnvironment() async {
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    private func cleanupTestEnvironment() async {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
    }
EOF
    
    # Insert before the first test method
    sed -i '' '/@Test func/i\
    private func setupTestEnvironment() async {\
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()\
    }\
    \
    private func cleanupTestEnvironment() async {\
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()\
    }\
' "$file"
done

# 4. Fix actor isolation issues in deinit
echo "Fixing actor isolation issues in deinit..."
find /Users/schatt/code/github/6layer/Development/Tests -name "*.swift" -exec grep -l "main actor-isolated class property 'shared' can not be referenced from a nonisolated context" {} \; | while read file; do
    # Replace problematic deinit patterns
    sed -i '' 's/deinit {/deinit {\
        Task { [weak self] in\
            await self?.cleanupTestEnvironment()\
        }\
    }\
    \
    private func cleanupTestEnvironment() async {\
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()\
    }\
\
    deinit {/' "$file"
done

echo "Compilation error fixes completed!"
