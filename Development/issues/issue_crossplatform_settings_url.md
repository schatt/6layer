# Add Cross-Platform Settings URL Opening Support

## Summary

The framework currently provides no abstraction for opening system settings URLs, which differ significantly between iOS and macOS. We need a cross-platform helper function that handles these platform differences automatically, following the framework's existing platform-specific pattern.

## Current State

### ❌ What's Missing

1. **No settings URL handling**: The framework has no functionality for opening system settings
2. **No cross-platform abstraction**: Developers must implement platform-specific code themselves
3. **Inconsistent with framework patterns**: Other platform-specific features (like `platformDismissSettings`) exist, but there's no corresponding "open settings" functionality

### ✅ What Exists

1. **`SettingsDismissalType` enum**: Exists in `PlatformSpecificViewExtensions.swift` for dismissing settings views
2. **Platform-specific patterns**: Framework already uses `#if os(iOS)` / `#if os(macOS)` patterns throughout
3. **View extension infrastructure**: `PlatformSpecificViewExtensions.swift` has the structure for adding this functionality

## Problem

Opening system settings requires different approaches on each platform:

### iOS
- Uses `UIApplicationOpenSettingsURLString` constant
- Opens the app's specific settings page in the Settings app
- Requires `UIApplication.shared.open()` or SwiftUI's `Environment.openURL`

### macOS
- No direct equivalent to `UIApplicationOpenSettingsURLString`
- Apps typically present preferences within the app itself
- macOS 13+ has System Settings, but no standard URL scheme for app-specific settings
- Would typically use `NSWorkspace.shared.open()` or present in-app preferences window

**Current Impact**: Developers must write platform-specific code every time they need to open settings, which:
- Breaks the framework's cross-platform abstraction
- Requires developers to know platform-specific APIs
- Leads to code duplication across projects
- Doesn't follow the framework's "express WHAT, not HOW" philosophy

## Proposed Solution

Add a cross-platform helper function that abstracts platform differences:

### Option 1: View Extension Method (Recommended)
Add a `platformOpenSettings()` method to the `View` extension in `PlatformSpecificViewExtensions.swift`:

```swift
/// Platform-specific settings opening
/// iOS: Opens app settings in System Settings app
/// macOS: Opens app preferences (implementation TBD based on app architecture)
func platformOpenSettings() {
    #if os(iOS)
    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(settingsURL)
    }
    #elseif os(macOS)
    // Option A: Open System Settings (if app has settings bundle)
    // Option B: Present in-app preferences window
    // Option C: Use NSWorkspace to open System Settings
    // Implementation depends on app architecture
    #endif
}
```

### Option 2: Standalone Function
Add a standalone function that can be called from anywhere:

```swift
/// Cross-platform function to open app settings
@MainActor
public func platformOpenAppSettings() {
    #if os(iOS)
    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(settingsURL)
    }
    #elseif os(macOS)
    // macOS implementation
    #endif
}
```

### Option 3: Environment-Based (SwiftUI)
Use SwiftUI's `Environment` for `openURL` when available:

```swift
func platformOpenSettings(openURL: OpenURLAction) {
    #if os(iOS)
    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
        openURL(settingsURL)
    }
    #elseif os(macOS)
    // macOS implementation
    #endif
}
```

## Implementation Tasks

### Phase 1: Research & Design
- [ ] Research macOS settings/preferences opening patterns
- [ ] Determine best approach for macOS (System Settings vs in-app preferences)
- [ ] Decide on function signature and location
- [ ] Document platform-specific behavior differences

### Phase 2: iOS Implementation
- [ ] Implement iOS settings URL opening using `UIApplicationOpenSettingsURLString`
- [ ] Handle error cases (URL creation failure, open failure)
- [ ] Add appropriate error handling/logging

### Phase 3: macOS Implementation
- [ ] Determine macOS strategy (System Settings, in-app preferences, or both)
- [ ] Implement macOS-specific settings opening
- [ ] Handle macOS version differences (pre-13.0 vs 13.0+)
- [ ] Add appropriate error handling/logging

### Phase 4: Cross-Platform Abstraction
- [ ] Create unified API that works on both platforms
- [ ] Add to `PlatformSpecificViewExtensions.swift` or appropriate location
- [ ] Follow existing framework patterns (`#if os(iOS)` / `#if os(macOS)`)
- [ ] Ensure consistent behavior across platforms

### Phase 5: Testing
- [ ] Write unit tests for iOS implementation
- [ ] Write unit tests for macOS implementation
- [ ] Test on actual devices/simulators for both platforms
- [ ] Test error cases (invalid URLs, unavailable settings)

### Phase 6: Documentation
- [ ] Document the function in code comments
- [ ] Add usage examples
- [ ] Document platform-specific behavior differences
- [ ] Update framework documentation

## Acceptance Criteria

- [ ] Function exists and can be called from SwiftUI views
- [ ] iOS implementation opens app settings in System Settings app
- [ ] macOS implementation handles settings appropriately for that platform
- [ ] Function follows framework's platform-specific patterns
- [ ] Error cases are handled gracefully
- [ ] Tests pass for both platforms
- [ ] Documentation is complete with examples
- [ ] Function is discoverable in `PlatformSpecificViewExtensions.swift`

## Related Files

- `Framework/Sources/Extensions/Platform/PlatformSpecificViewExtensions.swift` - Where `SettingsDismissalType` is defined and where this should be added
- `Framework/Sources/Core/Models/PlatformTypes.swift` - Platform detection utilities
- `Framework/docs/Architecture/PlatformComponentPattern.md` - Pattern documentation

## Open Questions

1. **macOS Strategy**: Should we open System Settings, present in-app preferences, or provide both options?
2. **Function Location**: Should this be a View extension method, standalone function, or both?
3. **SwiftUI Integration**: Should we use `Environment.openURL` when available, or always use `UIApplication.shared.open()`?
4. **Error Handling**: How should we handle cases where settings can't be opened (e.g., no settings bundle on iOS)?
5. **Return Value**: Should the function return a `Bool` indicating success, or be `Void`?

## Notes

- This should follow the same pattern as `platformDismissSettings()` which already exists
- Must maintain consistency with framework's cross-platform abstraction philosophy
- Consider iOS version differences (though `UIApplicationOpenSettingsURLString` is available on all iOS versions)
- macOS implementation may need to be flexible to support different app architectures (settings bundle vs in-app preferences)

