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

# Step 2: Check git is clean (no uncommitted changes)
echo "📋 Step 2: Checking git repository status..."
if [ -n "$(git status --porcelain)" ]; then
    echo "❌ Git repository has uncommitted changes!"
    echo "Please commit or stash all changes before creating a release."
    echo ""
    echo "Uncommitted changes:"
    git status --short
    exit 1
fi
echo "✅ Git repository is clean"

# Step 3: Check if RELEASES.md needs updating
echo "📋 Step 3: Checking RELEASES.md..."
if ! grep -q "v$VERSION" Development/RELEASES.md; then
    echo "❌ RELEASES.md missing v$VERSION entry!"
    echo "Please update Development/RELEASES.md with the new release information"
    exit 1
fi

# Check that RELEASES.md has the version as the current release at the top
if ! grep -A 5 "^## 📍 \*\*Current Release:" Development/RELEASES.md | grep -q "v$VERSION"; then
    echo "❌ RELEASES.md does not list v$VERSION as the Current Release!"
    echo "Please update the 'Current Release' section at the top of Development/RELEASES.md"
    exit 1
fi

# Check that the version section exists and is properly formatted
if ! grep -q "^## 🎯 \*\*v$VERSION" Development/RELEASES.md; then
    echo "❌ RELEASES.md missing proper v$VERSION section header!"
    echo "Expected format: ## 🎯 **v$VERSION - ..."
    exit 1
fi

echo "✅ RELEASES.md correctly updated with v$VERSION"

# Step 4: Check for individual release file
echo "📋 Step 4: Checking for individual release file..."
if [ -f "Development/RELEASE_v$VERSION.md" ]; then
    echo "✅ Individual release file exists"
else
    echo "❌ Missing Development/RELEASE_v$VERSION.md!"
    echo "Please create the individual release file"
    exit 1
fi

# Step 5: Check for AI_AGENT file (for significant releases)
if [[ "$RELEASE_TYPE" == "major" || "$RELEASE_TYPE" == "minor" ]]; then
    echo "📋 Step 5: Checking for AI_AGENT file..."
    if [ -f "Development/AI_AGENT_v$VERSION.md" ]; then
        echo "✅ AI_AGENT file exists"
    else
        echo "❌ Missing Development/AI_AGENT_v$VERSION.md for $RELEASE_TYPE release!"
        echo "AI_AGENT files are MANDATORY for major and minor releases"
        exit 1
    fi
fi

# Step 6: Check README files
echo "📋 Step 6: Checking README files..."
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

# Step 7: Check project status files
echo "📋 Step 7: Checking project status files..."
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

# Step 8: Check main AI_AGENT.md file
echo "📋 Step 8: Checking main AI_AGENT.md file..."
if [ -f "Development/AI_AGENT.md" ]; then
    echo "✅ Main AI_AGENT.md file exists"
else
    echo "❌ Missing Development/AI_AGENT.md!"
    echo "Main AI_AGENT.md file is MANDATORY"
    exit 1
fi

# Step 9: Check documentation files (only if features changed)
echo "📋 Step 9: Checking documentation files..."
echo "ℹ️  Feature documentation only needs updating if features changed"
if [ -f "Framework/docs/AutomaticAccessibilityIdentifiers.md" ]; then
    echo "✅ AutomaticAccessibilityIdentifiers.md exists"
else
    echo "⚠️  Missing Framework/docs/AutomaticAccessibilityIdentifiers.md (only needed if accessibility features changed)"
fi

# Step 10: Check example files (only if features changed)
echo "📋 Step 10: Checking example files..."
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
echo "✅ Git repository is clean"
echo "✅ RELEASES.md updated correctly"
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
echo "1. git tag -a v$VERSION -m \"Release v$VERSION\""
echo "2. git push all --tags"
echo "3. git push all && git push codeberg && git push gitlab"
echo ""
echo "Release process validation complete! ✅"
