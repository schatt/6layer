#!/bin/bash

# Pre-Release Check Script
# Ensures the test suite passes before any release

set -e

echo "🔍 Running pre-release quality checks..."

# Check if we're in the right directory
if [ ! -f "Package.swift" ]; then
    echo "❌ Error: Must be run from project root directory"
    exit 1
fi

# Run the test suite
echo "🧪 Running test suite..."
if swift test; then
    echo "✅ All tests passed!"
else
    echo "❌ Test suite failed!"
    echo "🚫 Release blocked: Fix failing tests before proceeding"
    exit 1
fi

# Check for any linter warnings (optional)
echo "🔍 Checking for linter warnings..."
if command -v swiftlint &> /dev/null; then
    if swiftlint --quiet; then
        echo "✅ No linter warnings found"
    else
        echo "⚠️  Linter warnings found (non-blocking)"
    fi
else
    echo "ℹ️  SwiftLint not available, skipping linter check"
fi

echo "🎉 Pre-release checks completed successfully!"
echo "✅ Ready for release"
