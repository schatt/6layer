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

# Initialize error tracking
ERRORS_FOUND=0
ERROR_MESSAGES=""

log_error() {
    echo "❌ $1"
    ERRORS_FOUND=$((ERRORS_FOUND + 1))
    ERROR_MESSAGES="${ERROR_MESSAGES}\n❌ $1"
}

echo "🚀 Starting release process for v$VERSION ($RELEASE_TYPE)"

# Step 1: Regenerate Xcode project
echo "📋 Step 1: Ensuring Xcode project is up to date..."
if command -v xcodegen &> /dev/null; then
    echo "🔧 Regenerating Xcode project with xcodegen..."
    if xcodegen; then
        echo "✅ Xcode project regenerated successfully"
    else
        echo "❌ Failed to regenerate Xcode project!"
        exit 1
    fi
else
    echo "⚠️  xcodegen not available, skipping project regeneration"
fi

# Step 2: Run tests
echo "📋 Step 2: Running test suite..."

# Run unit tests first
echo "🧪 Running unit tests..."
if ! xcodebuild test -project SixLayerFramework.xcodeproj -scheme SixLayerFramework-UnitTestsOnly-macOS -destination "platform=macOS" -quiet; then
    log_error "Unit tests failed! Cannot proceed with release."
    exit 1
fi
echo "✅ Unit tests passed"

# Run UI tests
echo "🖥️  Running UI tests..."
if ! xcodebuild test -project SixLayerFramework.xcodeproj -scheme SixLayerFramework-UITestsOnly-macOS -destination "platform=macOS" -quiet; then
    log_error "UI tests failed! Cannot proceed with release."
    exit 1
fi
echo "✅ UI tests passed"
echo "✅ Complete test suite validation passed"

# Step 2: Check git is clean (no uncommitted changes)
echo "📋 Step 2: Checking git repository status..."
if [ -n "$(git status --porcelain)" ]; then
    log_error "Git repository has uncommitted changes! Please commit or stash all changes before creating a release."
    echo ""
    echo "Uncommitted changes:"
    git status --short
fi
echo "✅ Git repository is clean"

# Step 2.5: Check we're on main branch
echo "📋 Step 2.5: Checking current branch..."
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    log_error "Not on main branch! Current branch: $CURRENT_BRANCH. Please switch to main branch before creating a release."
fi
echo "✅ On main branch"

# Step 3: Check if RELEASES.md needs updating
echo "📋 Step 3: Checking RELEASES.md..."
if ! grep -q "v$VERSION" Development/RELEASES.md; then
    log_error "RELEASES.md missing v$VERSION entry! Please update Development/RELEASES.md with the new release information"
fi

# Check that RELEASES.md has the version as the current release at the top
if ! grep -A 5 "^## 📍 \*\*Current Release:" Development/RELEASES.md | grep -q "v$VERSION"; then
    log_error "RELEASES.md does not list v$VERSION as the Current Release! Please update the 'Current Release' section at the top of Development/RELEASES.md"
fi

# Check that the version section exists and is properly formatted
if ! grep -q "^## 🎯 \*\*v$VERSION" Development/RELEASES.md; then
    log_error "RELEASES.md missing proper v$VERSION section header! Expected format: ## 🎯 **v$VERSION - ..."
fi

echo "✅ RELEASES.md correctly updated with v$VERSION"

# Step 4: Check for individual release file
echo "📋 Step 4: Checking for individual release file..."
if [ -f "Development/RELEASE_v$VERSION.md" ]; then
    echo "✅ Individual release file exists"
else
    log_error "Missing Development/RELEASE_v$VERSION.md! Please create the individual release file"
fi

# Step 5: Check for AI_AGENT file (for significant releases)
if [[ "$RELEASE_TYPE" == "major" || "$RELEASE_TYPE" == "minor" ]]; then
    echo "📋 Step 5: Checking for AI_AGENT file..."
    if [ -f "Development/AI_AGENT_v$VERSION.md" ]; then
        echo "✅ AI_AGENT file exists"
    else
        log_error "Missing Development/AI_AGENT_v$VERSION.md for $RELEASE_TYPE release! AI_AGENT files are MANDATORY for major and minor releases"
    fi
fi

# Step 7: Check README files
echo "📋 Step 7: Checking README files..."

# Check main README.md - verify version appears in key locations
if ! grep -q "v$VERSION" README.md; then
    log_error "Main README missing v$VERSION!"
fi

# Check that README.md has the version as the Latest Release
if ! grep -q "^## 🆕 Latest Release: v$VERSION" README.md; then
    log_error "README.md does not list v$VERSION as the Latest Release! Please update the 'Latest Release' section in README.md"
fi

# Check that README.md has the version in the package dependency example
if ! grep -q "from: \"$VERSION\"" README.md; then
    log_error "README.md package dependency example does not use v$VERSION! Please update the package dependency example in README.md"
fi

# Check that README.md has the version in the Current Status section
if ! grep -A 2 "^## 📋 Current Status" README.md | grep -q "v$VERSION"; then
    log_error "README.md Current Status section does not list v$VERSION! Please update the 'Current Status' section in README.md"
fi

echo "✅ Main README correctly updated with v$VERSION"

# Step 7.5: Check Package.swift version consistency
echo "📋 Step 7.5: Checking Package.swift version consistency..."
if ! grep -q "v$VERSION" Package.swift; then
    log_error "Package.swift missing v$VERSION in version comment! Please update the version comment in Package.swift to match v$VERSION. Expected format: // SixLayerFramework v$VERSION - [Description]"
fi
echo "✅ Package.swift version comment correctly updated with v$VERSION"

if grep -q "v$VERSION" Framework/README.md; then
    echo "✅ Framework README updated"
else
    log_error "Framework README missing v$VERSION!"
fi

if grep -q "v$VERSION" Framework/Examples/README.md; then
    echo "✅ Examples README updated"
else
    log_error "Examples README missing v$VERSION!"
fi

# Step 8: Check project status files
echo "📋 Step 8: Checking project status files..."
if grep -q "v$VERSION" Development/PROJECT_STATUS.md; then
    echo "✅ PROJECT_STATUS.md updated"
else
    log_error "PROJECT_STATUS.md missing v$VERSION!"
fi

if grep -q "v$VERSION" Development/todo.md; then
    echo "✅ todo.md updated"
else
    log_error "todo.md missing v$VERSION!"
fi

# Step 9: Check main AI_AGENT.md file
echo "📋 Step 9: Checking main AI_AGENT.md file..."
if [ -f "Development/AI_AGENT.md" ]; then
    echo "✅ Main AI_AGENT.md file exists"
else
    log_error "Missing Development/AI_AGENT.md! Main AI_AGENT.md file is MANDATORY"
fi

# Step 10: Check documentation files (only if features changed)
echo "📋 Step 10: Checking documentation files..."
echo "ℹ️  Feature documentation only needs updating if features changed"
if [ -f "Framework/docs/AutomaticAccessibilityIdentifiers.md" ]; then
    echo "✅ AutomaticAccessibilityIdentifiers.md exists"
else
    echo "⚠️  Missing Framework/docs/AutomaticAccessibilityIdentifiers.md (only needed if accessibility features changed)"
fi

# Step 11: Check example files (only if features changed)
echo "📋 Step 11: Checking example files..."
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

# Check if any errors were found
if [ $ERRORS_FOUND -gt 0 ]; then
    echo "❌ RELEASE CHECKS FAILED!"
    echo ""
    echo "Found $ERRORS_FOUND error(s) that need to be fixed:"
    echo "$ERROR_MESSAGES"
    echo ""
    echo "Please fix all errors and run the release script again."
    echo "💡 Tip: The script now reports ALL errors at once for efficient fixing!"
    exit 1
fi

echo "🎉 All release documentation checks passed!"
echo ""
echo "📋 Release Checklist Complete:"
echo "✅ Xcode project regenerated"
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
echo "🚀 All checks passed! Ready for tagging and release."

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
