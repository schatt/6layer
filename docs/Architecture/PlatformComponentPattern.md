# Platform Component Pattern

## Overview

The Platform Component Pattern is a cross-platform architecture approach used in the 6-Layer Framework that provides a single public API while maintaining platform-specific implementations as reusable components.

## Pattern Structure

```swift
// Public API function
func platformFunction() -> some View {
    #if os(iOS)
        return iosImplementation()
    #elseif os(macOS)
        return macImplementation()
    #else
        return fallbackImplementation()
    #endif
}

// Platform-specific component implementations
#if os(iOS)
private func iosImplementation() -> some View {
    // Complex iOS-specific logic
}
#endif

#if os(macOS)
private func macImplementation() -> some View {
    // Complex macOS-specific logic
}
#endif

private func fallbackImplementation() -> some View {
    // Fallback for other platforms
}
```

## Benefits

1. **Single Public API** - Users call one function, regardless of platform
2. **Reusable Components** - Platform-specific logic can be shared across multiple functions
3. **Maintainable** - Changes to platform behavior happen in one place
4. **Testable** - Platform components can be tested independently
5. **Follows DRY** - No duplicate public functions or platform logic

## When to Use

- **Complex platform-specific logic** that would be hard to read inline
- **Reusable platform components** that multiple functions need
- **Platform-specific optimizations** that require significant code
- **Maintaining consistency** across platform implementations

## Examples in the Framework

### Button Extensions
- `platformNavigationSheetButton()` - Single public API
- `iosNavigationSheetButton()` - iOS-specific implementation
- `macNavigationSheetButton()` - macOS-specific implementation

### Navigation Views
- `platformNavigationStack()` - Single public API
- `iosNavigationStack()` - iOS-specific implementation
- `macNavigationStack()` - macOS-specific implementation

## Implementation Guidelines

1. **Public function** should have a clear, descriptive name
2. **Platform components** should be private and focused on one platform
3. **Conditional compilation** should be simple and readable
4. **Fallback implementations** should provide reasonable defaults
5. **Documentation** should clearly explain platform differences

## Testing Strategy

1. **Test the public function** for cross-platform behavior
2. **Test platform components** for platform-specific logic
3. **Mock platform conditions** to test different code paths
4. **Verify consistency** across platform implementations
