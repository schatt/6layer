# ViewInspector macOS Workaround Implementation

**Related External Issue**: [ViewInspector Issue #405](https://github.com/nalexn/ViewInspector/issues/405)

## Summary

ViewInspector fails to compile on macOS SDK 26 due to iOS-only SwiftUI types. We've implemented a comprehensive workaround that allows our test suite to work around this limitation while maintaining a single point of control for when ViewInspector is fixed.

## Problem

ViewInspector uses iOS-only SwiftUI types (`VideoPlayer`, `SignInWithAppleButton`, `Map` variants) that are not available on macOS SDK 26, causing compilation failures when building test targets on macOS.

## Solution Implemented

We've created a centralized wrapper system with a compile-time flag that allows us to:

1. **Use ViewInspector on iOS** (works currently)
2. **Gracefully handle macOS** (tests skip ViewInspector-dependent assertions)
3. **Single point of control** (one line change in `Package.swift` when ViewInspector is fixed)

### Implementation Details

#### 1. ViewInspectorWrapper.swift
**Location**: `Development/Tests/SixLayerFrameworkTests/Utilities/TestHelpers/ViewInspectorWrapper.swift`

Centralized wrapper that provides:
- `tryInspect()` extension on `View`
- `inspectView()` extension on `View`  
- `withInspectedView()` helper function
- `withInspectedViewThrowing()` helper function
- Platform-agnostic API that handles conditional compilation internally

#### 2. Compile-Time Flag
**Location**: `Package.swift` (swiftSettings section)

```swift
swiftSettings: [
    // Compile-time flag to control ViewInspector macOS support
    // When ViewInspector fixes GitHub issue #405, uncomment this line:
    // .define("VIEW_INSPECTOR_MAC_FIXED")
]
```

#### 3. Conditional Compilation Pattern
All test files use this pattern:
```swift
#if canImport(ViewInspector) && (!os(macOS) || VIEW_INSPECTOR_MAC_FIXED)
// ViewInspector-specific code
#else
// Fallback for macOS when ViewInspector not available
#endif
```

## Files Updated

**Total: 38 test files + 1 wrapper file**

See [FIXED_FILES.md](./FIXED_FILES.md) for complete list organized by category:

- **Components**: 2 files
- **Core Architecture**: 5 files
- **Core Views**: 3 files
- **Accessibility**: 10 files
- **Collections**: 2 files
- **Forms**: 3 files
- **Images, Intelligence, Navigation, OCR, Platform**: 5 files
- **Integration**: 1 file
- **Layers**: 4 files
- **Utilities**: 1 file
- **Wrapper**: 1 file (`ViewInspectorWrapper.swift`)

## Migration Path

When ViewInspector fixes [Issue #405](https://github.com/nalexn/ViewInspector/issues/405):

1. **Uncomment one line** in `Package.swift`:
   ```swift
   .define("VIEW_INSPECTOR_MAC_FIXED")
   ```

2. **All test files automatically work** - no manual updates needed

3. **Tests will run on macOS** with full ViewInspector support

## Benefits

✅ **Single point of control** - Change one line to enable macOS support  
✅ **No manual file updates** - All 38 test files automatically adapt  
✅ **Type safety** - Wrapper handles `Any` vs `InspectableView` differences  
✅ **Centralized logic** - Platform differences handled in one place  
✅ **Easy migration** - Simple one-line change when ViewInspector is fixed  
✅ **Maintainable** - Clear pattern for future test files

## Current Status

- ✅ Wrapper implementation complete
- ✅ Compile-time flag configured
- ✅ All 38 test files updated
- ✅ Documentation complete
- ⏳ Waiting for ViewInspector to fix Issue #405

## Testing

- **iOS**: All tests pass with full ViewInspector support
- **macOS**: Tests compile and run, ViewInspector-dependent assertions are skipped gracefully
- **Migration**: When flag is enabled, all tests will automatically use ViewInspector on macOS

## Related Documentation

- [FIXED_FILES.md](./FIXED_FILES.md) - Complete list of updated files
- [README.md](./README.md) - Detailed issue description
- [ViewInspector Issue #405](https://github.com/nalexn/ViewInspector/issues/405) - Upstream issue

## Implementation Date

Workaround implemented: November 2024

