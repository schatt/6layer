# SixLayer Framework v6.0.1 Release Notes

**Release Date**: December 7, 2025  
**Release Type**: Patch Release (Critical Bug Fix)  
**Previous Version**: v6.0.0  
**Next Release**: TBD

## 🚨 Critical Bug Fix Release

This patch release fixes a **critical infinite recursion crash** in `AutomaticComplianceModifier` that causes stack overflow and app termination when applying `.automaticCompliance()` modifier to views.

## 🐛 Bug Fixes

### Critical: Infinite Recursion Crash in AutomaticComplianceModifier (Issue #91)

- **Fixed**: Infinite recursion causing stack overflow when `.automaticCompliance()` modifier is applied
- **Fixed**: Circular dependency between view body evaluation and design system initialization
- **Fixed**: Thread-safety issues with design system caching

### Technical Details

The infinite recursion occurred because:
1. `AutomaticComplianceModifier.EnvironmentAccessor.body.getter` was called
2. It called `applyHIGComplianceFeatures(to:elementType:)`
3. This created new `PlatformDesignSystem` and `HIGColorSystem` instances
4. These initializations triggered SwiftUI AttributeGraph updates
5. The view update caused `body.getter` to be called again
6. This created a circular dependency → infinite recursion (7909 levels deep)

**Solution**: Added static cache for `PlatformDesignSystem` instances to prevent recreation on every body evaluation. Design systems are immutable and platform-specific, so caching is safe and breaks the circular dependency.

**Changes Made**:
- Added `PlatformDesignSystem.cached(for:)` with thread-safe static caching using `NSLock`
- Updated `applyHIGComplianceFeatures` to use cached design system instead of creating new instances
- Updated `platformPatterns()` and `visualConsistency()` to use cached version with runtime platform detection
- Marked static cache as `nonisolated(unsafe)` for concurrency safety (protected by NSLock)

## 🧪 Testing

- **All tests pass** (0 failures)
- **Test suite validation passed** - no compilation errors
- **Proper Red-Green-Refactor cycle** followed for bug fix

## 📋 Migration Guide

### For Users of v6.0.0

- **Upgrade to v6.0.1 immediately** if you're using `.automaticCompliance()` modifier
- **No breaking changes** - all existing code continues to work
- **No code changes required** - the fix is transparent to users

### For Users Experiencing the Crash

If you were experiencing the infinite recursion crash:
1. **Upgrade to v6.0.1** - the fix is included
2. **Remove any workarounds** - you can now use `.automaticCompliance()` safely
3. **No code changes needed** - the API remains the same

## 🔧 Technical Implementation

The fix uses a static cache to prevent design system recreation:

```swift
// Before (caused infinite recursion):
let designSystem = PlatformDesignSystem(for: platform)

// After (uses cached instance):
let designSystem = PlatformDesignSystem.cached(for: platform)
```

The cache is:
- **Thread-safe**: Protected by `NSLock`
- **Platform-specific**: Each platform has its own cached instance
- **Immutable**: Design systems are value types, safe to cache
- **Transparent**: No API changes required

## 📱 Usage Examples

### Before (v6.0.0 - Would Crash)
```swift
ContentView()
    .automaticCompliance()  // ❌ Caused infinite recursion crash
```

### After (v6.0.1 - Works Correctly)
```swift
ContentView()
    .automaticCompliance()  // ✅ Works correctly with cached design system
```

## 🎯 Expected Behavior

With v6.0.1:
- ✅ `.automaticCompliance()` modifier works without crashes
- ✅ Design systems are cached and reused efficiently
- ✅ No performance impact from repeated initialization
- ✅ Thread-safe access to cached design systems

## 📊 Test Coverage

- **Total Tests**: All existing tests pass
- **Test Failures**: 0
- **Coverage**: Infinite recursion scenario is prevented by design system caching

## 🔄 Version History

- **v6.0.0**: ❌ **CRITICAL BUG** - Infinite recursion crash in `.automaticCompliance()`
- **v6.0.1**: ✅ **CURRENT** - Critical bug fix with design system caching

## 🚀 What's Next

- **v6.1.0**: Planned feature release with additional enhancements
- **Future releases**: Continue improving stability and performance

## 📞 Support

If you encounter any issues with v6.0.1, please:
1. Check the [documentation](Framework/docs/AutomaticAccessibilityIdentifiers.md)
2. Review the [examples](Framework/Examples/)
3. Open an issue on GitHub: [Issue #91](https://github.com/schatt/6layer/issues/91)

---

**Framework Version**: 6.0.1  
**Swift Version**: 6.0+  
**Platforms**: iOS 15.0+, macOS 12.0+, watchOS 8.0+, tvOS 15.0+, visionOS 1.0+  
**Fixes**: [Issue #91](https://github.com/schatt/6layer/issues/91)
