# SixLayer Framework v4.1.1 Release Notes

**Release Date**: October 5, 2025  
**Release Type**: Patch Release  
**Previous Version**: v4.0.1  

## 🚨 Critical Bug Fix Release

This patch release fixes a critical bug in the automatic accessibility identifier generation system that was introduced in v4.1.0. **v4.1.0 has been removed from all package managers** due to this issue.

## 🐛 Bug Fixes

### Critical: Automatic Accessibility Identifier Generation
- **Fixed**: Automatic accessibility identifiers not being generated for custom UI elements
- **Fixed**: Enhanced Breadcrumb System modifiers (`.trackViewHierarchy()`, `.screenContext()`, `.navigationState()`) not applying accessibility identifiers
- **Fixed**: ID generation using hardcoded values instead of actual view context
- **Fixed**: Missing global automatic ID application system

### Technical Details
- Updated `AccessibilityIdentifierAssignmentModifier.generateAutomaticID()` to use actual view hierarchy and screen context
- Added `.automaticAccessibilityIdentifiers()` to all breadcrumb tracking modifiers
- Created `GlobalAutomaticAccessibilityIdentifierModifier` and `enableGlobalAutomaticAccessibilityIdentifiers()` view extension
- Made `currentViewHierarchy`, `currentScreenContext`, and `currentNavigationState` public in `AccessibilityIdentifierConfig`

## 🧪 Testing

- **5 new TDD tests** added to validate the bug fix
- **All 1654 tests pass** (0 failures)
- **Proper Red-Green-Refactor cycle** followed for bug fix

## 📋 Migration Guide

### For Users of v4.1.0
- **v4.1.0 has been removed** from all package managers
- **Upgrade to v4.1.1** to get the working version
- **No breaking changes** - all existing code continues to work

### For Users of v4.0.1 and Earlier
- **No migration required** - this is a bug fix only
- **All existing functionality** remains unchanged
- **Enhanced Breadcrumb System** now works as documented

## 🔧 Configuration

The automatic accessibility identifier generation now works correctly with:

```swift
// Configure SixLayerFramework Enhanced Breadcrumb System
let config = AccessibilityIdentifierConfig.shared
config.enableAutoIDs = true
config.namespace = "YourApp"
config.mode = .automatic
config.enableViewHierarchyTracking = true
config.enableUITestIntegration = true
#if DEBUG
config.enableDebugLogging = true
#endif
```

## 📱 Usage Examples

### Enhanced Breadcrumb System (Now Working)
```swift
Button(action: { /* action */ }) {
    Label("Add Fuel", systemImage: "plus")
}
.trackViewHierarchy("AddFuelButton")  // ✅ Now applies automatic IDs
.screenContext("UserProfile")          // ✅ Now applies automatic IDs
```

### Global Automatic ID Application
```swift
// In your main App struct
var body: some Scene {
    WindowGroup {
        ContentView()
            .enableGlobalAutomaticAccessibilityIdentifiers()  // ✅ New feature
    }
}
```

## 🎯 Expected Behavior

With v4.1.1, UI elements now correctly receive accessibility identifiers following the pattern:
- **Format**: `namespace.context.role.objectID`
- **Example**: `CarManager.UserProfile.button.AddFuelButton-1234-567`

## 📊 Test Coverage

- **Total Tests**: 1654
- **Test Failures**: 0
- **New Tests**: 5 TDD tests for bug validation
- **Coverage**: All automatic accessibility identifier scenarios

## 🔄 Version History

- **v4.1.0**: ❌ **REMOVED** - Critical bug in automatic accessibility identifier generation
- **v4.1.1**: ✅ **CURRENT** - Bug fix release with working automatic accessibility identifiers

## 🚀 What's Next

- **v4.2.0**: Planned feature release with additional accessibility enhancements
- **v5.0.0**: Major release with comprehensive UI testing framework

## 📞 Support

If you encounter any issues with v4.1.1, please:
1. Check the [documentation](Framework/docs/AutomaticAccessibilityIdentifiers.md)
2. Review the [examples](Framework/Examples/)
3. Open an issue on GitHub

---

**Framework Version**: 4.1.1  
**Swift Version**: 6.0+  
**Platforms**: iOS 15.0+, macOS 12.0+, watchOS 8.0+, tvOS 15.0+, visionOS 1.0+
