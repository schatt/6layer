# Deprecated APIs Audit

This document tracks deprecated APIs in the SixLayer Framework codebase and their status.

## ✅ Properly Deprecated (With Migration Paths)

These APIs are intentionally deprecated and have proper `@available(*, deprecated)` annotations with migration guidance.

### 1. GenericFormField
**Status**: ✅ Properly deprecated  
**Location**: `Framework/Examples/GenericTypes.swift`, `Framework/Sources/Layers/Layer1-Semantic/PlatformSemanticLayer1.swift`  
**Replacement**: `DynamicFormField` with `DynamicFormState`  
**Migration Guide**: See `Framework/docs/6layerapi.txt`

### 2. OCR Layer 4 Functions
**Status**: ✅ Properly deprecated  
**Location**: `Framework/Sources/Layers/Layer4-Component/PlatformOCRComponentsLayer4.swift`  
**Replacement**: `OCRService.processImage()`  
**Migration Guide**: See file comments

### 3. Accessibility Functions (Renamed)
**Status**: ✅ Properly deprecated with renamed versions  
**Location**: `Framework/Sources/Extensions/Accessibility/AutomaticAccessibilityIdentifiers.swift`  
**Replacement**: 
- `automaticCompliance()` (replaces deprecated versions)
- `automaticCompliance(named:)` (replaces deprecated versions)
- `enableGlobalAutomaticCompliance()` (replaces deprecated versions)

### 4. Test Helper Functions (Renamed)
**Status**: ✅ Properly deprecated with renamed versions  
**Location**: 
- `Development/Tests/SixLayerFrameworkTests/Utilities/TestHelpers/AccessibilityTestUtilities.swift`
- `Development/Tests/SixLayerFrameworkTests/Utilities/TestHelpers/CentralizedTestFunctions.swift`  
**Replacement**: Functions with `Compliance` suffix that test both accessibility and HIG compliance

## ⚠️ Deprecated APIs in Use (With Fallbacks)

These APIs are deprecated but still used with appropriate availability checks and fallbacks.

### 1. UIScreen.screens
**Status**: ⚠️ Deprecated in iOS 16, but has fallback  
**Location**: `Framework/Sources/Core/Models/PlatformTypes.swift:170`  
**Issue**: `UIScreen.screens` is deprecated in iOS 16+  
**Current Implementation**: 
```swift
if #available(iOS 16.0, *) {
    // Use the new API
    if UIApplication.shared.openSessions.count > 1 {
        return .externalDisplay
    }
} else {
    // Use the deprecated API for older iOS versions
    if UIScreen.screens.count > 1 {
        return .externalDisplay
    }
}
```
**Assessment**: ✅ **Acceptable** - Properly handles both old and new APIs with availability checks

### 2. NavigationLink with destination parameter
**Status**: ✅ Already migrated with availability checks  
**Location**: `Framework/Sources/Layers/Layer4-Component/PlatformNavigationLayer4.swift`  
**Current Implementation**: Uses `NavigationLink(value:)` with `.navigationDestination()` for iOS 16+, falls back to `NavigationLink(destination:)` for older versions  
**Assessment**: ✅ **Complete** - Properly handles both old and new APIs with availability checks

## ✅ Recently Migrated

### 1. NavigationView → NavigationStack
**Status**: ✅ Migrated with availability checks  
**Location**: 
- `Framework/Sources/Core/CrossPlatformNavigation.swift`
- `Framework/Sources/Layers/Layer4-Component/PlatformNavigationLayer4.swift`
- `Framework/Sources/Extensions/Platform/PlatformSpecificViewExtensions.swift`

**Implementation**: 
- Uses `NavigationStack` on iOS 16+
- Falls back to `NavigationView` on iOS 15 and earlier
- Maintains same public API

**Benefits**:
- Modern navigation API on iOS 16+
- Better performance and navigation state management
- Supports programmatic navigation with NavigationPath
- Still supports iOS 15 with fallback

**Date**: 2025-11-20

### 2. UIImagePickerController → PHPickerViewController
**Status**: ✅ Migrated with availability checks  
**Location**: 
- `Framework/Sources/Components/Images/UnifiedImagePicker.swift`
- `Framework/Sources/Layers/Layer4-Component/PlatformPhotoComponentsLayer4.swift`

**Implementation**: 
- Uses `PHPickerViewController` on iOS 14+
- Falls back to `UIImagePickerController` on iOS 13
- Maintains same public API (returns `PlatformImage`)

**Benefits**:
- Better privacy controls on iOS 14+
- Access to full photo library (not just camera roll)
- Better performance
- More modern API
- Still supports iOS 13 with fallback

**Date**: 2025-11-20

### 2. MapAnnotation (Not Currently Used)
**Status**: ✅ Not used, documented  
**Location**: N/A (no usage found)  
**Documentation**: `Framework/docs/MapAPIUsage.md`  
**Modern Alternative**: `Annotation` with `MapContentBuilder` (iOS 17+)

## ✅ Recently Fixed

### 1. NSLocalizedDescriptionKey
**Status**: ✅ Fixed  
**Location**: `Development/Tests/SixLayerFrameworkTests/Core/Models/FieldHintsOCRExtensionTests.swift`  
**Fix**: Replaced deprecated `NSLocalizedDescriptionKey` constant with string literal `"NSLocalizedDescription"`  
**Date**: 2025-11-20

## 📋 Summary

### Deprecated APIs Status
- **Properly Deprecated (with migration)**: 4 categories ✅
- **Deprecated but with fallbacks**: 2 APIs ✅
- **Consider for future migration**: 1 API (UIImagePickerController) ⚠️
- **Recently fixed**: 1 API ✅

### Recommendations

1. **No Immediate Action Required**: All deprecated APIs are either:
   - Properly deprecated with migration paths
   - Used with appropriate fallbacks for older iOS versions
   - Already fixed or migrated

2. **Future Considerations**:
   - Continue monitoring for new deprecations in future iOS versions
   - When dropping iOS 13 support, can remove legacy `UIImagePickerController` fallback

3. **Best Practices**:
   - Always use availability checks when supporting multiple iOS versions
   - Provide migration guides for intentionally deprecated APIs
   - Document deprecated APIs in code comments and migration guides

## References

- [Apple Deprecation Warnings](https://developer.apple.com/documentation/)
- [SwiftUI Migration Guide](https://developer.apple.com/documentation/swiftui/)
- Framework API Documentation: `Framework/docs/6layerapi.txt`
- Map API Guide: `Framework/docs/MapAPIUsage.md`

