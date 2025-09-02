#!/bin/bash

# Build Quality Gate Script
# This script treats any build warnings as failures

set -e

echo "🔍 Running Build Quality Gate..."

# Build the framework and capture output with verbose warnings
echo "📦 Building Framework..."
BUILD_OUTPUT=$(swift build --package-path Framework -v 2>&1)
BUILD_EXIT_CODE=$?

# Check for warnings in build output (including redundant public modifiers)
WARNING_COUNT=$(echo "$BUILD_OUTPUT" | grep -c "warning:" || true)

if [ $WARNING_COUNT -gt 0 ]; then
    echo "❌ BUILD QUALITY GATE FAILED: Found $WARNING_COUNT warning(s)"
    echo ""
    echo "Warnings found:"
    echo "$BUILD_OUTPUT" | grep "warning:"
    echo ""
    echo "Please fix all warnings before proceeding."
    exit 1
fi

# Run tests and capture output with verbose warnings
echo "🧪 Running Tests..."
TEST_OUTPUT=$(swift test --package-path Framework -v 2>&1)
TEST_EXIT_CODE=$?

# Check for warnings in test output (including redundant public modifiers)
TEST_WARNING_COUNT=$(echo "$TEST_OUTPUT" | grep -c "warning:" || true)

if [ $TEST_WARNING_COUNT -gt 0 ]; then
    echo "❌ TEST QUALITY GATE FAILED: Found $TEST_WARNING_COUNT warning(s)"
    echo ""
    echo "Warnings found:"
    echo "$TEST_OUTPUT" | grep "warning:"
    echo ""
    echo "Please fix all warnings before proceeding."
    exit 1
fi

if [ $BUILD_EXIT_CODE -eq 0 ] && [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "✅ BUILD QUALITY GATE PASSED: No warnings found"
    echo "✅ All tests passed"
else
    echo "❌ BUILD QUALITY GATE FAILED: Build or test errors"
    exit 1
fi
