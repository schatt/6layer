# Bug Report Tests

This folder contains tests that specifically verify bug fixes and prevent regressions. These tests are created in response to reported bugs and serve as:

1. **Regression Prevention**: Ensure bugs don't reoccur
2. **Bug Verification**: Verify that fixes actually work
3. **Documentation**: Show exactly what was broken and how it was fixed
4. **Testing Strategy**: Demonstrate proper testing approaches for similar issues

## Test Naming Convention

Bug report tests should follow this naming pattern:
- `[Component][BugDescription]BugFixVerificationTests.swift` - Verifies the fix works
- `[Component][BugDescription]RegressionPreventionTests.swift` - Prevents the bug from recurring
- `[Component][BugDescription]TestingFailureDemonstrationTests.swift` - Shows what testing gaps existed

## Current Bug Reports

### PlatformImage Breaking Change (v4.6.2)
- **Bug**: `PlatformImage` initializer breaking change violated semantic versioning
- **Files**:
  - `PlatformImageBugFixVerificationTests.swift` - Verifies the fix works
  - `PlatformImageBreakingChangeDetectionTests.swift` - Detects the breaking change
  - `TestingFailureDemonstrationTests.swift` - Shows testing gaps that allowed the bug

## Guidelines for Adding New Bug Report Tests

1. **Create verification tests** that prove the bug is fixed
2. **Create regression prevention tests** that would have caught the bug
3. **Document the testing failure** that allowed the bug to slip through
4. **Include the exact broken code** as comments or test cases
5. **Test both the old (broken) and new (fixed) patterns** where applicable
6. **Use descriptive test names** that explain what was broken

## Benefits

- **Prevents regressions** by testing the exact scenarios that broke
- **Improves testing strategy** by identifying gaps
- **Documents bug history** for future reference
- **Provides examples** of proper bug fix testing
- **Ensures semantic versioning compliance** for API changes
