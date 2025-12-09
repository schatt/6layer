# SixLayer Framework v6.0.5 Release Notes

**Release Date**: December 8, 2025  
**Release Type**: Patch Release (Critical Bug Fix)  
**Previous Version**: v6.0.4  
**Next Release**: TBD

## 🚨 Critical Bug Fix Release

This patch release fixes a **critical infinite recursion crash** in HIG compliance modifiers that causes stack overflow when applying `.automaticCompliance()` modifier to views.

## 🐛 Bug Fixes

### Critical: Infinite Recursion Crash in HIG Compliance Modifiers

- **Fixed**: Infinite recursion causing stack overflow when `.automaticCompliance()` modifier is applied
- **Fixed**: Circular dependency between `AutomaticComplianceModifier.applyHIGComplianceFeatures()` and modifier body methods
- **Fixed**: 5 modifiers calling `.automaticCompliance()` recursively within the compliance feature chain

### Technical Details

The infinite recursion occurred because:

1. `AutomaticComplianceModifier.EnvironmentAccessor.body.getter` was called
2. It called `applyHIGComplianceFeatures(to:elementType:)`
3. This applied modifiers like `SystemColorModifier`, `SystemTypographyModifier`, `SpacingModifier`, `PlatformStylingModifier`, and `PlatformIconModifier`
4. Each of these modifiers called `.automaticCompliance()` again in their body methods
5. This created another `AutomaticComplianceModifier` instance
6. Which called `applyHIGComplianceFeatures` again
7. Creating a circular dependency → infinite recursion (thousands of stack frames)

**Solution**: Removed `.automaticCompliance()` calls from the 5 modifiers that are already applied within `applyHIGComplianceFeatures`. These modifiers don't need to call `.automaticCompliance()` because they're already part of the compliance feature chain.

**Fixed Modifiers**:
- `SystemColorModifier` - removed `.automaticCompliance()` call
- `SystemTypographyModifier` - removed `.automaticCompliance()` call
- `SpacingModifier` - removed `.automaticCompliance()` call
- `PlatformStylingModifier` - removed `.automaticCompliance()` call
- `PlatformIconModifier` - removed `.automaticCompliance()` call

**Changes Made**:
- Updated `AppleHIGComplianceModifiers.swift` to remove recursive `.automaticCompliance()` calls
- Added comments explaining why these calls were removed
- All modifiers now return content directly without recursive compliance application

## 🧪 Testing

- **All tests pass** (0 failures)
- **Test suite validation passed** - no compilation errors
- **Proper Red-Green-Refactor cycle** followed for bug fix

## 📋 Migration Guide

### For Users of v6.0.4 and Earlier

- **Upgrade to v6.0.5 immediately** if you're using `.automaticCompliance()` modifier
- **No breaking changes** - all existing code continues to work
- **No code changes required** - the fix is transparent to users

### For Users Experiencing the Crash

If you were experiencing the infinite recursion crash:
1. **Upgrade to v6.0.5** - the fix is included
2. **Remove any workarounds** - you can now use `.automaticCompliance()` safely
3. **No code changes needed** - the API remains the same

## 🔧 Technical Implementation

The fix removes recursive `.automaticCompliance()` calls from modifiers that are already part of the compliance chain:

```swift
// Before (caused infinite recursion):
public struct SystemColorModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(colorSystem.text)
            .background(colorSystem.background)
            .automaticCompliance()  // ❌ Causes infinite recursion
    }
}

// After (fixed):
public struct SystemColorModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(colorSystem.text)
            .background(colorSystem.background)
        // CRITICAL: Do NOT call .automaticCompliance() here - it causes infinite recursion
        // This modifier is already applied within AutomaticComplianceModifier.applyHIGComplianceFeatures
    }
}
```

## 📱 Usage Examples

### Before (v6.0.4 - Would Crash)
```swift
ContentView()
    .automaticCompliance()  // ❌ Caused infinite recursion crash
```

### After (v6.0.5 - Works Correctly)
```swift
ContentView()
    .automaticCompliance()  // ✅ Works correctly without recursion
```

## 🎯 Expected Behavior

With v6.0.5:
- ✅ `.automaticCompliance()` modifier works without crashes
- ✅ HIG compliance features are applied correctly
- ✅ No infinite recursion or stack overflow
- ✅ All accessibility identifiers are generated properly

## 📊 Test Coverage

- **Total Tests**: All existing tests pass
- **Test Failures**: 0
- **Coverage**: Infinite recursion scenario is prevented by removing recursive modifier calls

## 🔄 Version History

- **v6.0.4**: ❌ **CRITICAL BUG** - Infinite recursion crash in HIG compliance modifiers
- **v6.0.5**: ✅ **CURRENT** - Critical bug fix with recursive call removal

## 📚 Related Issues

This fixes the same root cause pattern as v6.0.1, v6.0.2, and v6.0.3, but addresses a different code path - the HIG compliance modifier chain rather than the accessibility identifier generation logic.
