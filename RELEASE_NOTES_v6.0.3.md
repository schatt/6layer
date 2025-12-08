# SixLayer Framework v6.0.3 Release Notes

## 🐛 Critical Bug Fix

### Additional Infinite Recursion Fixes in Accessibility Identifier Generation

**FIXED**: Resolved 7 additional instances of infinite recursion crashes in accessibility identifier generation that were missed in v6.0.2.

#### The Problem

While v6.0.2 fixed the main infinite recursion issue, there were additional places where `@Published` properties were accessed directly during SwiftUI view body evaluation:

1. `config.namespace` and `config.globalPrefix` in `generateIdentifier` methods
2. `config.enableAutoIDs` in debug logging statements
3. `config.enableDebugLogging` accessed directly instead of using captured values
4. `generateNamedAccessibilityIdentifier` accessing all config properties directly
5. `generateExactNamedAccessibilityIdentifier` accessing `config.enableDebugLogging` directly
6. `AccessibilityIdentifierGenerator.generateID` accessing all config properties directly

These created the same reactive dependency cycles that caused infinite recursion.

#### The Solution

Fixed all 7 instances by:
- Capturing `namespace` and `globalPrefix` as local variables before use
- Capturing `enableAutoIDs` for debug logging
- Using captured `enableDebugLogging` values instead of accessing directly
- Updating all `generateIdentifier` methods to accept captured values as parameters
- Fixing `AccessibilityIdentifierGenerator` (public API) to capture all values

#### Impact

- **Severity**: Critical - caused app crashes
- **Affected Components**: All views using automatic accessibility identifier generation with non-empty namespace/prefix
- **Platforms**: iOS and macOS
- **Why Tests Didn't Catch**: Tests use ViewInspector which doesn't trigger SwiftUI's AttributeGraph update cycle

#### Technical Details

The fix was applied to:
1. `AutomaticComplianceModifier.EnvironmentAccessor.generateIdentifier()` - added `namespace` and `globalPrefix` captures
2. `AutomaticComplianceModifier.EnvironmentAccessor.body` - fixed debug logging to use captured values
3. `AutomaticComplianceModifier.NamedEnvironmentAccessor.body` - fixed debug logging
4. `NamedModifierEnvironmentAccessor.generateNamedAccessibilityIdentifier` - fixed all config property accesses
5. `ExactNamedModifierEnvironmentAccessor.generateExactNamedAccessibilityIdentifier` - fixed debug logging
6. `AccessibilityIdentifierGenerator.generateID` - fixed all config property accesses (public API)

All methods now capture config values as local variables before use, preventing SwiftUI from tracking them as reactive dependencies.

## 🔄 Migration Notes

No migration required. This is a bug fix that maintains API compatibility.

## ✅ Testing

- All unit tests pass
- Code compiles without errors
- All `@Published` property accesses are now properly captured

## 📚 Related Issues

This fixes the same root cause as v6.0.2 but addresses additional code paths that were missed in the initial fix.
