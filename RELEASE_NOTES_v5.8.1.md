# SixLayer Framework v5.8.1 Release Notes

## 🎉 Major Features

### PlatformImage Standardization Complete (Issue #32)

**COMPLETED**: Phase 2 of PlatformImage standardization - all framework code now uses standardized `PlatformImage` type consistently!

#### Key Changes

- **Removed Platform-Specific Type Aliases**: Eliminated `ClipboardImage` typealias that exposed `UIImage`/`NSImage` in public APIs
- **Standardized Clipboard API**: `PlatformClipboard.copyToClipboard(_ image:)` now accepts `PlatformImage` instead of platform-specific types
- **Framework Purity**: No `UIImage`/`NSImage` variables in framework code (only in `PlatformImage` private storage)
- **Currency Exchange Model**: All conversions happen at system boundaries as designed

#### Architecture Compliance

The framework now fully implements the "currency exchange model" for image handling:

- **At System Boundaries**: Convert `UIImage`/`NSImage` → `PlatformImage` when entering framework
- **In Framework Logic**: Use `PlatformImage` everywhere (standardized type)
- **When Leaving Framework**: Convert `PlatformImage` → `UIImage`/`NSImage` at system boundaries

#### Updated APIs

##### Clipboard Operations

```swift
// Before (deprecated - used platform-specific type)
PlatformClipboard.copyToClipboard(image: ClipboardImage) // ❌ Removed

// After (standardized)
PlatformClipboard.copyToClipboard(PlatformImage.createPlaceholder()) // ✅
```

##### Unified Clipboard Helper

```swift
// Now accepts PlatformImage directly
platformCopyToClipboard_L4(
    content: PlatformImage.createPlaceholder(),
    provideFeedback: true
)
```

#### Implementation Details

**System Boundary Conversion**:
```swift
// Clipboard API converts PlatformImage → UIImage/NSImage at boundary
@MainActor
public static func copyToClipboard(_ image: PlatformImage) -> Bool {
    #if os(iOS)
    // System boundary conversion: PlatformImage → UIImage
    UIPasteboard.general.image = image.uiImage
    #elseif os(macOS)
    // System boundary conversion: PlatformImage → NSImage
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    if let tiffData = image.nsImage.tiffRepresentation {
        return pasteboard.setData(tiffData, forType: .tiff)
    }
    #endif
}
```

#### Remaining UIImage/NSImage Usage (All Acceptable)

The following uses of platform-specific types are **architecturally correct**:

1. **Private Storage**: `PlatformImage` uses `_uiImage`/`_nsImage` as private implementation details
2. **System API Calls**: Temporary variables used immediately before conversion to `PlatformImage`
3. **System Boundaries**: Conversions at framework entry/exit points (e.g., `UIImagePickerController` delegates)

## 🔧 Technical Details

### Breaking Changes

**Removed Type Alias**:
- `ClipboardImage` typealias has been removed
- Use `PlatformImage` directly instead

### Migration Guide

#### For Clipboard Operations

```swift
// Before (v5.8.0 and earlier)
#if os(iOS)
let clipboardImage: ClipboardImage = someUIImage
#elseif os(macOS)
let clipboardImage: ClipboardImage = someNSImage
#endif
PlatformClipboard.copyToClipboard(clipboardImage)

// After (v5.8.1+)
let platformImage = PlatformImage(someUIImage) // or PlatformImage(someNSImage)
PlatformClipboard.copyToClipboard(platformImage)
```

#### For Unified Clipboard Helper

```swift
// Before (v5.8.0 and earlier)
let content: Any = ClipboardImage(...)
platformCopyToClipboard_L4(content: content)

// After (v5.8.1+)
let content: Any = PlatformImage(...)
platformCopyToClipboard_L4(content: content)
```

### Backward Compatibility

- **Phase 1 conversions remain**: Implicit conversions `PlatformImage(UIImage)` and `PlatformImage(NSImage)` still work
- **Layer 4 callbacks unchanged**: All Layer 4 photo/camera callbacks already use `PlatformImage`
- **System boundaries preserved**: All system API integrations continue to work

## 🧪 Testing & Quality

### Test Coverage

- **Architecture Tests**: Comprehensive tests enforce `PlatformImage`-only usage in framework
- **System Boundary Tests**: Verify conversions happen correctly at boundaries
- **Backward Compatibility**: All existing tests pass with updated APIs

### Quality Assurance

- **Framework Purity**: No platform-specific image types in public framework APIs
- **Type Safety**: Standardized type prevents platform-specific code in framework logic
- **Architecture Compliance**: Full adherence to currency exchange model
- **Performance**: No performance impact - conversions happen at boundaries only

## 📚 Documentation Updates

### Updated Files

- `todos.md` - Updated PlatformImage Standardization Plan (Phase 2 complete)
- `Framework/Sources/Layers/Layer4-Component/PlatformShareClipboardLayer4.swift` - Updated API documentation

### Architecture Documentation

The framework now fully implements the currency exchange model:

1. **Framework Purity**: ✅ No `UIImage`/`NSImage` variables inside framework
2. **System Boundary**: ✅ All conversions happen at system boundaries
3. **Test Coverage**: ✅ Comprehensive tests enforce architecture
4. **Breaking Change Prevention**: ✅ Tests catch API changes
5. **Single Source of Truth**: ✅ `PlatformImage` handles all image operations

## 🎯 Key Benefits

1. **Consistency**: Single standardized type throughout framework
2. **Type Safety**: Prevents accidental platform-specific code in framework logic
3. **Maintainability**: Easier to add new platforms by extending `PlatformImage`
4. **Architecture Compliance**: Full adherence to currency exchange model
5. **Future-Proof**: Ready for additional platforms (visionOS, watchOS, etc.)

## 🎉 New Features

### Layer 4 System Actions (Issue #42)

**COMPLETED**: Added cross-platform system action functions to eliminate platform-specific code in shared modules.

#### New Functions

##### URL Opening
- `platformOpenURL_L4(_ url: URL) -> Bool` - Cross-platform URL opening
  - **iOS**: Uses `UIApplication.shared.open(url)`
  - **macOS**: Uses `NSWorkspace.shared.open(url)`
  - Handles HTTP, HTTPS, and custom URL schemes
  - Returns success/failure status

##### Sharing
- `platformShare_L4(isPresented:items:onComplete:)` - Share sheet with binding control
- `platformShare_L4(items:from:)` - Convenience overload with automatic presentation
  - **iOS**: Uses `UIActivityViewController` as modal sheet
  - **macOS**: Uses `NSSharingServicePicker` as popover
  - Supports text, URLs, images, and files

#### Usage Examples

```swift
// Open URL
Button("Open Website") {
    if let url = URL(string: "https://example.com") {
        platformOpenURL_L4(url)
    }
}

// Share content
@State private var shareItems: [Any]? = nil
Button("Share") {
    shareItems = ["Text to share", URL(string: "https://example.com")!]
}
.platformShare_L4(items: shareItems ?? [], from: nil)
```

#### Benefits

1. **Eliminates platform-specific code** - No need for `#if os(iOS)` blocks
2. **Reduces violations** - Helps codebases avoid platform-specific type violations
3. **Consistent API** - Same interface regardless of platform
4. **Follows framework patterns** - Aligns with existing Layer 4 component implementation

## 🔄 Related Issues

- **Issue #32**: Complete PlatformImage standardization (Phase 2) - ✅ COMPLETED
- **Issue #42**: Add Layer 4 System Action Functions - ✅ COMPLETED
- **Issue #23**: PlatformImage initializer from CGImage - ✅ Already completed
- **Issue #33**: PlatformImage enhancements (Phase 3) - ⏳ Future work

---

**Version**: 5.8.1
**Release Date**: [Date TBD]
**Previous Version**: 5.8.0
**Issues**: #32 (PlatformImage Standardization Phase 2), #42 (Layer 4 System Actions)

