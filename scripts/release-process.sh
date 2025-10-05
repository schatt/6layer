#!/bin/bash

# SixLayer Framework Release Process Script
# This script enforces the mandatory release documentation process

set -e

VERSION=$1
RELEASE_TYPE=${2:-"patch"}  # major, minor, patch

if [ -z "$VERSION" ]; then
    echo "❌ Error: Version required"
    echo "Usage: $0 <version> [release_type]"
    echo "Example: $0 4.2.0 minor"
    exit 1
fi

echo "🚀 Starting release process for v$VERSION ($RELEASE_TYPE)"

# Step 1: Run tests
echo "📋 Step 1: Running test suite..."
if ! swift test; then
    echo "❌ Tests failed! Cannot proceed with release."
    exit 1
fi
echo "✅ Tests passed"

# Step 2: Check if RELEASES.md needs updating
echo "📋 Step 2: Checking RELEASES.md..."
if grep -q "v$VERSION" Development/RELEASES.md; then
    echo "✅ RELEASES.md already contains v$VERSION"
else
    echo "❌ RELEASES.md missing v$VERSION entry!"
    echo "Please update Development/RELEASES.md with the new release information"
    exit 1
fi

# Step 3: Check for individual release file
echo "📋 Step 3: Checking for individual release file..."
if [ -f "Development/RELEASE_v$VERSION.md" ]; then
    echo "✅ Individual release file exists"
else
    echo "❌ Missing Development/RELEASE_v$VERSION.md!"
    echo "Please create the individual release file"
    exit 1
fi

# Step 4: Check for AI_AGENT file (for significant releases)
if [[ "$RELEASE_TYPE" == "major" || "$RELEASE_TYPE" == "minor" ]]; then
    echo "📋 Step 4: Checking for AI_AGENT file..."
    if [ -f "Development/AI_AGENT_v$VERSION.md" ]; then
        echo "✅ AI_AGENT file exists"
    else
        echo "❌ Missing Development/AI_AGENT_v$VERSION.md for $RELEASE_TYPE release!"
        echo "AI_AGENT files are MANDATORY for major and minor releases"
        exit 1
    fi
fi

# Step 5: Check README files
echo "📋 Step 5: Checking README files..."
if grep -q "v$VERSION" README.md; then
    echo "✅ Main README updated"
else
    echo "❌ Main README missing v$VERSION!"
    exit 1
fi

if grep -q "v$VERSION" Framework/README.md; then
    echo "✅ Framework README updated"
else
    echo "❌ Framework README missing v$VERSION!"
    exit 1
fi

if grep -q "v$VERSION" Framework/Examples/README.md; then
    echo "✅ Examples README updated"
else
    echo "❌ Examples README missing v$VERSION!"
    exit 1
fi

# Step 6: Check project status files
echo "📋 Step 6: Checking project status files..."
if grep -q "v$VERSION" Development/PROJECT_STATUS.md; then
    echo "✅ PROJECT_STATUS.md updated"
else
    echo "❌ PROJECT_STATUS.md missing v$VERSION!"
    exit 1
fi

if grep -q "v$VERSION" Development/todo.md; then
    echo "✅ todo.md updated"
else
    echo "❌ todo.md missing v$VERSION!"
    exit 1
fi

# Step 7: Check main AI_AGENT.md file
echo "📋 Step 7: Checking main AI_AGENT.md file..."
if [ -f "Development/AI_AGENT.md" ]; then
    echo "✅ Main AI_AGENT.md file exists"
else
    echo "❌ Missing Development/AI_AGENT.md!"
    echo "Main AI_AGENT.md file is MANDATORY"
    exit 1
fi

# Step 8: Check documentation files (only if features changed)
echo "📋 Step 8: Checking documentation files..."
echo "ℹ️  Feature documentation only needs updating if features changed"
if [ -f "Framework/docs/AutomaticAccessibilityIdentifiers.md" ]; then
    echo "✅ AutomaticAccessibilityIdentifiers.md exists"
else
    echo "⚠️  Missing Framework/docs/AutomaticAccessibilityIdentifiers.md (only needed if accessibility features changed)"
fi

# Step 9: Check example files (only if features changed)
echo "📋 Step 9: Checking example files..."
echo "ℹ️  Example files only need updating if features changed"
if [ -f "Framework/Examples/AutomaticAccessibilityIdentifiersExample.swift" ]; then
    echo "✅ AutomaticAccessibilityIdentifiersExample.swift exists"
else
    echo "⚠️  Missing AutomaticAccessibilityIdentifiersExample.swift (only needed if accessibility features changed)"
fi

if [ -f "Framework/Examples/AccessibilityIdentifierDebuggingExample.swift" ]; then
    echo "✅ AccessibilityIdentifierDebuggingExample.swift exists"
else
    echo "⚠️  Missing AccessibilityIdentifierDebuggingExample.swift (only needed if debugging features changed)"
fi

if [ -f "Framework/Examples/EnhancedBreadcrumbExample.swift" ]; then
    echo "✅ EnhancedBreadcrumbExample.swift exists"
else
    echo "⚠️  Missing EnhancedBreadcrumbExample.swift (only needed if breadcrumb features changed)"
fi

echo ""
echo "🎉 All release documentation checks passed!"
echo ""
echo "📋 Release Checklist Complete:"
echo "✅ Tests passed"
echo "✅ RELEASES.md updated"
echo "✅ Individual release file exists"
echo "✅ AI_AGENT file exists (for major/minor releases)"
echo "✅ All README files updated"
echo "✅ Project status files updated"
echo "✅ Main AI_AGENT.md file exists"
echo "✅ Documentation files exist"
echo "✅ Example files exist"
echo ""
echo "🚀 Ready to create release tag v$VERSION"
echo ""
echo "Next steps:"
echo "1. git add ."
echo "2. git commit -m \"Release v$VERSION\""
echo "3. git tag v$VERSION"
echo "4. git push origin main --tags"
echo ""
echo "Release process validation complete! ✅"
