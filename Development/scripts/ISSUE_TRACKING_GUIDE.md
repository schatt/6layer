# Issue Tracking Guide for Releases

## Overview

This guide helps ensure that resolved GitHub issues are properly documented in release notes.

## Best Practices

### 1. **During Development**
- **Link commits to issues**: Use "Fixes #123" or "Resolves #123" in commit messages
- **Close issues when done**: Close issues when the work is complete, not when the release happens
- **Use labels**: Tag issues with appropriate labels (bug, enhancement, feature, etc.)

### 2. **Before Release**
- **Review closed issues**: Check all issues closed since the last release
- **Identify significant issues**: Not all issues need to be in release notes, but significant ones should be:
  - ✅ New features
  - ✅ Breaking changes
  - ✅ Major bug fixes
  - ✅ Security fixes
  - ✅ Performance improvements
  - ❌ Minor typo fixes (usually not needed)
  - ❌ Internal refactoring (unless it affects users)

### 3. **In Release Notes**
- **Reference issues**: Use formats like:
  - `Resolves Issue #123`
  - `Implements [Issue #43](https://github.com/schatt/6layer/issues/43)`
  - `Fixes [Issue #21](https://github.com/schatt/6layer/issues/21)`
- **Group by category**: Organize issues by type (Features, Bug Fixes, etc.)
- **Provide context**: Explain what the issue was and how it was resolved

## Manual Checklist

Before each release, manually verify:

1. ✅ Review closed issues: https://github.com/schatt/6layer/issues?q=is%3Aissue+is%3Aclosed
2. ✅ Check if significant issues are mentioned in `Development/RELEASE_vX.X.X.md`
3. ✅ Verify issue references use correct format (Issue #123 or links)
4. ✅ Ensure breaking changes are clearly marked
5. ✅ Confirm security fixes are documented (if any)

## Automated Checks

The release script (`release-process.sh`) now includes:

1. **Issue Reference Check**: Verifies that release notes contain issue references
2. **GitHub CLI Integration**: If `gh` CLI is installed, shows recently closed issues as a reminder
3. **Warning System**: Warns if no issue references are found (not a blocker, but a reminder)

## Using GitHub CLI

If you have GitHub CLI (`gh`) installed:

```bash
# List recently closed issues
gh issue list --state closed --limit 20

# View a specific issue
gh issue view 123

# List issues closed in a date range
gh issue list --state closed --limit 50 --json number,title,closedAt
```

## Example Release Note Section

```markdown
## 🐛 Bug Fixes

- **Fixed crash in form validation**: Resolves [Issue #123](https://github.com/schatt/6layer/issues/123)
- **Corrected accessibility identifier generation**: Fixes Issue #124

## ✨ New Features

- **Cross-platform printing API**: Implements [Issue #43](https://github.com/schatt/6layer/issues/43)
- **Automatic data binding**: Resolves Issue #45
```

## Troubleshooting

### "No issue references found" warning
- This is a **warning, not an error**
- If your release doesn't resolve any issues, that's fine
- If you did resolve issues, add them to the release notes

### GitHub CLI not available
- Install it: `brew install gh` (macOS) or see https://cli.github.com/
- Or use the manual checklist above
- The release script will still check for issue references in the release file

### Too many closed issues to review
- Focus on issues closed since the last release
- Use GitHub's filtering: `is:issue is:closed closed:>2025-12-01`
- Prioritize issues with labels like `bug`, `enhancement`, `feature`

## Integration with Release Script

The release script automatically:
1. Checks if release notes contain issue references
2. Shows recently closed issues (if GitHub CLI is available)
3. Provides helpful reminders and links

This helps catch missed issues without being overly strict (since not all issues need documentation).

