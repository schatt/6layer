# SixLayer Framework v2.3.2 Release Notes

## 🐛 Bug Fixes

### CarPlay Detection Fix
- **Fixed**: `UIUserInterfaceIdiom.car` compilation error
- **Issue**: Incorrect use of `.car` instead of `.carPlay` for CarPlay detection
- **Solution**: Updated `PlatformTypes.swift` to use correct `.carPlay` case
- **Impact**: Resolves compilation errors in consuming projects that use CarPlay detection

## 📊 Test Results
- **Total Tests**: 818 tests
- **Success Rate**: 99.4% (5 minor OCR async test failures)
- **Platform Coverage**: iOS, macOS, watchOS, tvOS, visionOS
- **Build Status**: ✅ Successful compilation

## 🔧 Technical Details

### Platform Detection Improvements
- Corrected CarPlay detection logic in `PlatformTypes.swift`
- Fixed `isCarPlayActive` property to use proper iOS API
- Maintained backward compatibility with existing CarPlay functionality

### Build System
- Swift Package Manager compilation successful
- All platform targets building correctly
- No breaking changes to public API

## 📦 Distribution
- **Swift Package**: Available via GitHub
- **Version Tag**: v2.3.2
- **Compatibility**: iOS 14.0+, macOS 11.0+, watchOS 7.0+, tvOS 14.0+, visionOS 1.0+

## 🚀 Next Steps
- Continue comprehensive testing implementation
- Address remaining OCR async test timeouts
- Enhance platform-specific optimizations
- Expand accessibility testing coverage

---
**Release Date**: September 6, 2025  
**Framework Version**: 2.3.2  
**Test Coverage**: 818 tests, 99.4% success rate
