# Release v2.0.6 - iOS 17.0+ API Compilation Fixes

**Release Date:** September 5, 2025  
**Status:** ✅ WORKING  
**Build Status:** ✅ SUCCESS  
**Test Status:** ✅ 477/480 PASSING (3 photo tests failing)

## Overview
This release fixes remaining compilation issues with iOS 17.0+ API usage and adds platform-specific initializers to PlatformImage.

## What's Fixed

### 🔧 **PlatformImage Platform-Specific Initializers**
- Added `init(uiImage:)` for iOS platform
- Added `init(nsImage:)` for macOS platform
- Enables direct creation of PlatformImage from platform-specific image types

### 🔧 **PhotoSemanticLayerTests PlatformImage Usage**
- Fixed test to use new `PlatformImage(uiImage:)` initializer
- Removed unsafe force unwrapping
- Tests now compile and run successfully

### 🔧 **iOS 17.0+ API Compilation Issues**
- All remaining compilation errors with newer iOS APIs resolved
- Framework now builds successfully on all supported platforms

## Technical Details

### New APIs
```swift
// iOS
public init(uiImage: UIImage)

// macOS  
public init(nsImage: NSImage)
```

### Breaking Changes
- None

### API Changes
- Added platform-specific initializers to `PlatformImage`

### Dependencies
- No new dependencies added

## Build Information
- **Target Platforms:** iOS 16.0+, macOS 13.0+, tvOS 16.0+, watchOS 9.0+, visionOS 1.0+
- **Swift Version:** 5.9+
- **Xcode Version:** 15.0+

## Known Issues
- 3 photo functionality tests still failing (addressed in v2.0.7)

## Migration Guide
No migration required - new initializers are additive.

## Files Changed
- `Framework/Sources/Shared/Models/PlatformTypes.swift`
- `Development/Tests/SixLayerFrameworkTests/PhotoSemanticLayerTests.swift`

## Next Steps
- Fix remaining photo functionality test failures
- Continue with Apple HIG compliance implementation
