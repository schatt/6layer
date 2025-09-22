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

## Development Standards

### Code Quality
- All new code must include appropriate tests
- Deprecated APIs should be properly marked and documented
- Breaking changes require major version bumps

### Documentation
- API changes must be documented
- Release notes must be comprehensive
- Breaking changes must be clearly highlighted

---

*This document establishes mandatory quality gates for the SixLayer Framework project.*
