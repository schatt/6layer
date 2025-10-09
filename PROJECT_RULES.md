# SixLayer Framework - Project Rules

## Release Quality Gates

### Rule 1: Test Suite Must Pass Before Release
**MANDATORY**: Releases cannot be made until the project passes the test suite.

- All tests must compile successfully
- All tests must pass without failures
- No test warnings should be present
- This applies to all release types (major, minor, patch, pre-release)

### Implementation
- Run `swift test` before any release
- If tests fail, fix the issues before proceeding
- Consider this a hard blocker for any release process

### Rationale
- Ensures code quality and stability
- Prevents broken functionality from reaching users
- Maintains confidence in the framework's reliability
- Supports continuous integration practices

### Rule 2: Complete Release Documentation Package
**MANDATORY**: Every release must include ALL of the following documentation files:

#### Core Release Files (ALL releases):
- **`Development/RELEASES.md`**: Must contain the new release entry with full details
- **`Development/RELEASE_vX.X.X.md`**: Individual release file with comprehensive notes
- **`README.md` (root)**: Must reflect latest version and features
- **`Framework/README.md`**: Must show current version badge and updated features
- **`Framework/Examples/README.md`**: Must list all current example files
- **`Development/PROJECT_STATUS.md`**: Must reflect current release status
- **`Development/todo.md`**: Must show current release as completed

#### AI Agent Documentation (Major/Minor releases):
- **`Development/AI_AGENT_vX.X.X.md`**: Detailed AI agent guide for the release
- **`Development/AI_AGENT.md`**: Main hub file must reference the new version

#### Feature Documentation (when applicable):
- **`Framework/docs/AutomaticAccessibilityIdentifiers.md`**: Only update if accessibility features changed
- **`Framework/docs/OCROverlayGuide.md`**: Only update if OCR features changed
- **Other feature-specific docs**: Only update if the specific feature was modified

#### Example Files (when applicable):
- **`Framework/Examples/AutomaticAccessibilityIdentifiersExample.swift`**: Only update if accessibility features changed
- **`Framework/Examples/AccessibilityIdentifierDebuggingExample.swift`**: Only update if debugging features changed
- **`Framework/Examples/EnhancedBreadcrumbExample.swift`**: Only update if breadcrumb features changed
- **Other example files**: Only update if the specific feature was modified

### Automated Release Validation
**MANDATORY**: Use the release process script to validate completeness:

```bash
./scripts/release-process.sh <version> <type>
```

This script will:
- Run the test suite
- Verify all required files exist
- Check that all files contain the new version
- Prevent incomplete releases from being tagged

### Enforcement
- **No exceptions**: This process applies to ALL releases, including patch releases
- **Documentation is part of the release**: Incomplete documentation = incomplete release
- **RELEASES.md is the single source of truth**: All release information must be centralized here
- **Backward compatibility**: Never remove or modify existing release entries
- **Automated validation**: Use the release script to ensure completeness

## Development Standards

### Test-Driven Development (TDD) Requirement
**MANDATORY**: All development must follow Test-Driven Development principles.

- **Write tests first**: All new features, bug fixes, and enhancements must begin with failing tests
- **Red-Green-Refactor cycle**: Follow the complete TDD cycle (failing test → implementation → passing test → refactor)
- **No implementation without tests**: Code must not be written before corresponding tests exist
- **Comprehensive test coverage**: Every code path, edge case, and integration point must be tested

### SwiftUI Testing Requirements
**MANDATORY**: SwiftUI functionality must be tested with the appropriate testing method.

#### Critical Distinction: `swift test` vs `xcodebuild test`
- **`swift test`**: Only tests object creation and method calls - does NOT test SwiftUI rendering
- **`xcodebuild test`**: Tests actual SwiftUI rendering and catches SwiftUI-specific crashes
- **SwiftUI rendering issues**: Only caught by `xcodebuild test`, not `swift test`

#### When to Use Each Method
- **`swift test`**: For pure business logic, data processing, utility functions
- **`xcodebuild test`**: For SwiftUI views, UI components, view modifiers, accessibility features
- **UI testing**: Must use `xcodebuild test` to catch rendering crashes and visual issues

#### SwiftUI Test Validation
- **All SwiftUI tests must pass with `xcodebuild test`**: This is the only way to validate actual UI rendering
- **Command line validation**: Use `xcodebuild test -workspace .swiftpm/xcode/package.xcworkspace -scheme SixLayerFramework -destination "platform=macOS"`
- **No false positives**: `swift test` passing does not guarantee SwiftUI rendering works
- **Real UI testing**: `xcodebuild test` provides the same testing as Xcode GUI testing

### Code Quality
- All new code must include appropriate tests (redundant with TDD requirement above)
- Deprecated APIs should be properly marked and documented
- Breaking changes require major version bumps

### Documentation
- API changes must be documented
- Release notes must be comprehensive
- Breaking changes must be clearly highlighted

---

*This document establishes mandatory quality gates for the SixLayer Framework project.*
