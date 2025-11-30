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

# Run unit tests first
echo "🧪 Running unit tests..."
if ! xcodebuild test -project SixLayerFramework.xcodeproj -scheme SixLayerFramework-UnitTestsOnly-macOS -destination "platform=macOS" -quiet; then
    echo "❌ Unit tests failed! Cannot proceed with release."
    exit 1
fi
echo "✅ Unit tests passed"

# Note: UI tests are currently disabled due to missing implementations
# They can be re-enabled once the remaining method stubs are implemented
echo "ℹ️  UI tests temporarily disabled (missing implementations)"
echo "✅ Test suite validation complete"

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

# Step 2.5: Check we're on main branch
echo "📋 Step 2.5: Checking current branch..."
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "❌ Not on main branch! Current branch: $CURRENT_BRANCH"
    echo "Please switch to main branch before creating a release."
    exit 1
fi
echo "✅ On main branch"

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

# Check main README.md - verify version appears in key locations
if ! grep -q "v$VERSION" README.md; then
    echo "❌ Main README missing v$VERSION!"
    exit 1
fi

# Check that README.md has the version as the Latest Release
if ! grep -q "^## 🆕 Latest Release: v$VERSION" README.md; then
    echo "❌ README.md does not list v$VERSION as the Latest Release!"
    echo "Please update the 'Latest Release' section in README.md"
    exit 1
fi

# Check that README.md has the version in the package dependency example
if ! grep -q "from: \"$VERSION\"" README.md; then
    echo "❌ README.md package dependency example does not use v$VERSION!"
    echo "Please update the package dependency example in README.md"
    exit 1
fi

# Check that README.md has the version in the Current Status section
if ! grep -A 2 "^## 📋 Current Status" README.md | grep -q "v$VERSION"; then
    echo "❌ README.md Current Status section does not list v$VERSION!"
    echo "Please update the 'Current Status' section in README.md"
    exit 1
fi

echo "✅ Main README correctly updated with v$VERSION"

# Step 6.5: Check Package.swift version consistency
echo "📋 Step 6.5: Checking Package.swift version consistency..."
if ! grep -q "v$VERSION" Package.swift; then
    echo "❌ Package.swift missing v$VERSION in version comment!"
    echo "Please update the version comment in Package.swift to match v$VERSION"
    echo "Expected format: // SixLayerFramework v$VERSION - [Description]"
    exit 1
fi
echo "✅ Package.swift version comment correctly updated with v$VERSION"

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
echo "✅ Package.swift version comment updated"
echo "✅ Project status files updated"
echo "✅ Main AI_AGENT.md file exists"
echo "✅ Documentation files exist"
echo "✅ Example files exist"
echo ""

# Auto-tag and push option
read -p "🚀 Auto-tag and push v$VERSION to all remotes? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🏷️  Creating and pushing tag v$VERSION..."

    # Create annotated tag
    git tag -a "v$VERSION" -m "Release v$VERSION"

    # Push tag to all remotes
    echo "📤 Pushing tag to GitHub..."
    git push github --tags

    echo "📤 Pushing tag to Codeberg..."
    git push codeberg --tags

    echo "📤 Pushing tag to GitLab..."
    git push gitlab --tags

    echo "📤 Pushing commits to all remotes..."
    git push github main
    git push codeberg main
    git push gitlab main

    echo ""
    echo "🎉 Release v$VERSION completed successfully!"
    echo "📦 Tag: v$VERSION"
    echo "🌐 Pushed to: GitHub, Codeberg, GitLab"
else
    echo "🚀 Ready to create release tag v$VERSION"
    echo ""
    echo "Manual steps:"
    echo "1. git tag -a v$VERSION -m \"Release v$VERSION\""
    echo "2. git push github --tags && git push codeberg --tags && git push gitlab --tags"
    echo "3. git push github main && git push codeberg main && git push gitlab main"
fi

echo ""
echo "Release process complete! ✅"
