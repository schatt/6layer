#!/bin/bash
# Script to create the GitHub issue on ViewInspector
# 
# Usage: 
#   1. Go to https://github.com/nalexn/ViewInspector/issues
#   2. Click "New Issue"
#   3. Copy the contents of GitHub_Issue.md into the issue description
#   4. Submit the issue

echo "To create the ViewInspector issue:"
echo ""
echo "1. Go to: https://github.com/nalexn/ViewInspector/issues/new"
echo ""
echo "2. Title: ViewInspector fails to compile on macOS SDK 26"
echo ""
echo "3. Copy the contents of Development/Tests/BugReports/ViewInspector_macOS_SDK26/GitHub_Issue.md"
echo ""
echo "4. Submit the issue"
echo ""
echo "Alternative: Use GitHub CLI if installed:"
echo "  gh issue create --repo nalexn/ViewInspector --title 'ViewInspector fails to compile on macOS SDK 26' --body-file Development/Tests/BugReports/ViewInspector_macOS_SDK26/GitHub_Issue.md"

