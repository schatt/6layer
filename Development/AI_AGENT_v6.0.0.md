# AI Agent Guide for SixLayer Framework v6.0.0

This guide summarizes the version-specific context for v6.0.0. **Always read this file before assisting with the framework at this version.**

> **Scope**: This guide is for AI assistants helping developers use or extend the framework (not for automated tooling).

## 🎯 Quick Start

1. Confirm the project is on **v6.0.0** (see `Package.swift` comment or release tags).
2. Understand that **intelligent device-aware navigation** is now available via `platformPresentAppNavigation_L1`.
3. Know that **cross-platform printing** is available via `platformPrint_L4` (from v5.8.0, documented here for completeness).
4. Know that **platform file system utilities** are available for home directory, Application Support, Documents, and iCloud Drive.
5. Know that **platform toolbar placement helpers** abstract toolbar item placement across platforms.
6. Apply TDD, DRY, DTRT, and Epistemology rules in every change.

## 🆕 What's New in v6.0.0

### Intelligent Device-Aware App Navigation (Issue #51)
- `platformPresentAppNavigation_L1()` - Semantic intent for app navigation with automatic pattern selection
- `determineAppNavigationStrategy_L2()` - Device and orientation-aware decision making
- `selectAppNavigationStrategy_L3()` - Platform-aware strategy selection
- `platformAppNavigation_L4()` - Component implementation with automatic or explicit strategy
- Automatically chooses between `NavigationSplitView` and detail-only navigation based on device type, orientation, and screen size

### Platform Settings Container (Issue #58)
- `platformSettingsContainer_L4()` - Device-aware settings views with intelligent pattern selection
- iPad: Uses `NavigationSplitView` (split view for larger screens)
- iPhone: Uses `NavigationStack` with conditional detail display (push detail when selected)
- macOS: Always uses `NavigationSplitView` (standard desktop pattern)

### Cross-Platform Printing Solution (Issue #43)
- `platformPrint_L4` view modifier and direct function for unified printing
- `PrintContent` enum: `.text(String)`, `.image(PlatformImage)`, `.pdf(Data)`, `.view(AnyView)`
- `PrintOptions` struct with job name, copies, page range, and output type (iOS)
- **iOS**: Uses `UIPrintInteractionController` with modal sheet presentation
- **macOS**: Uses `NSPrintOperation` with standard print dialog

### Platform File System Utilities (Issues #46, #48, #53)
- `platformHomeDirectory()` - Returns home directory URL (cross-platform)
- `platformApplicationSupportDirectory(createIfNeeded:)` - Returns Application Support directory
- `platformDocumentsDirectory(createIfNeeded:)` - Returns Documents directory
- iCloud Drive integration support (optional parameter for iCloud containers)
- All functions return `URL?` for safe error handling

### Platform Navigation Extensions (Issue #49)
- `platformNavigationTitleDisplayMode()` - Cross-platform navigation title display mode
- **iOS**: Applies `.navigationBarTitleDisplayMode(mode)`
- **macOS**: No-op (macOS doesn't have this concept)

### Platform Toolbar Placement Helpers (Issue #59)
- `platformConfirmationActionPlacement()` - Returns `.confirmationAction` on iOS/watchOS/visionOS (iOS 16+), `.automatic` on macOS/tvOS
- `platformCancellationActionPlacement()` - Returns `.cancellationAction` on iOS/watchOS/visionOS (iOS 16+), `.automatic` on macOS/tvOS
- `platformPrimaryActionPlacement()` - Returns `.primaryAction` on iOS/watchOS/visionOS (iOS 16+), `.automatic` on macOS/tvOS
- `platformSecondaryActionPlacement()` - Updated to handle all platforms explicitly

### PlatformSpacing HIG Alignment (Issue #60)
- Refactored to match macOS HIG guidelines with 8pt grid system
- All platforms handled explicitly (iOS, macOS, watchOS, tvOS, visionOS)
- macOS uses slightly tighter spacing (12, 20) while maintaining 8pt grid alignment

## 🧠 Guidance for v6.0.0 Work

### 1. App Navigation Usage
- Use `platformPresentAppNavigation_L1()` for semantic intent - framework handles device detection automatically
- Optional bindings for state management - framework provides defaults if `nil`
- Framework automatically selects optimal pattern (split view vs detail-only) based on device, orientation, and screen size
- **iPad**: Always uses `NavigationSplitView`
- **macOS**: Always uses `NavigationSplitView`
- **iPhone Portrait**: Detail-only view with sidebar as sheet
- **iPhone Landscape (Large models)**: `NavigationSplitView` for Plus/Pro Max models
- **iPhone Landscape (Standard models)**: Detail-only view

### 2. Settings Container Usage
- Use `platformSettingsContainer_L4()` for device-aware settings views
- Framework automatically chooses optimal presentation pattern
- Provide optional bindings for column visibility and category selection
- Framework handles state management automatically

### 3. File System Utilities Usage
- Use `platformHomeDirectory()` for cross-platform home directory access
- Use `platformApplicationSupportDirectory(createIfNeeded: true)` to create directory if needed
- Use `platformDocumentsDirectory(createIfNeeded: true)` for user documents
- Always check for `nil` return values - functions return `URL?` for safe error handling
- iCloud Drive integration available via optional parameters

### 4. Toolbar Placement Usage
- Use platform toolbar placement helpers instead of platform-specific conditionals
- iOS/watchOS/visionOS use semantic placements (`.confirmationAction`, `.cancellationAction`, etc.)
- macOS/tvOS use `.automatic` (doesn't support semantic placements)
- Includes iOS 16+/watchOS 9+ availability checks with fallbacks

### 5. Navigation Title Display Mode
- Use `platformNavigationTitleDisplayMode()` instead of `#if os(iOS)` conditionals
- iOS applies the mode, macOS is no-op
- Eliminates platform-specific conditional compilation

### 6. PlatformSpacing Usage
- All values follow 8pt grid system per Apple HIG
- macOS uses slightly tighter spacing (12, 20) while maintaining grid alignment
- All platforms handled explicitly - no `#else` fallback

### 7. Testing Expectations
- Follow TDD: Write tests before implementation
- Test API consistency across platforms
- Test all device types and orientations for navigation
- Test error handling for file system utilities
- Test accessibility compliance
- Test platform-specific behavior (iOS vs macOS)

## ✅ Best Practices

1. **Use semantic Layer 1 functions**: Let framework handle device detection
   ```swift
   // ✅ Good - semantic intent, framework handles device detection
   platformPresentAppNavigation_L1(
       columnVisibility: $columnVisibility,
       showingNavigationSheet: $showingNavigationSheet
   ) {
       SidebarView()
   } detail: {
       DetailView()
   }
   
   // ❌ Avoid - manual device detection
   #if os(iOS)
   if deviceType == .pad {
       NavigationSplitView { ... }
   } else {
       // Detail-only
   }
   #endif
   ```

2. **Use platform toolbar placement helpers**: Eliminate platform conditionals
   ```swift
   // ✅ Good - platform abstraction
   .toolbar {
       ToolbarItem(placement: platformConfirmationActionPlacement()) {
           Button("Save") { save() }
       }
   }
   
   // ❌ Avoid - platform conditionals
   .toolbar {
       ToolbarItem(placement: #if os(iOS) .confirmationAction #else .automatic #endif) {
           Button("Save") { save() }
       }
   }
   ```

3. **Handle file system errors gracefully**: Always check for `nil`
   ```swift
   // ✅ Good - safe error handling
   guard let appSupport = platformApplicationSupportDirectory(createIfNeeded: true) else {
       // Handle error
       return
   }
   
   // ❌ Avoid - force unwrapping
   let appSupport = platformApplicationSupportDirectory(createIfNeeded: true)!  // Can crash
   ```

4. **Use PlatformSpacing for consistency**: Follow HIG guidelines
   ```swift
   // ✅ Good - HIG-compliant spacing
   VStack(spacing: PlatformSpacing.medium) {
       Text("Title")
   }
   .padding(PlatformSpacing.padding)
   
   // ❌ Avoid - hardcoded values
   VStack(spacing: 8) {
       Text("Title")
   }
   .padding(16)
   ```

5. **Test on all platforms**: Verify behavior across iOS, macOS, watchOS, tvOS, visionOS
   ```swift
   // ✅ Good - test platform-specific behavior
   #if os(iOS)
   // Test iOS-specific behavior
   #elseif os(macOS)
   // Test macOS-specific behavior
   #endif
   ```

## 🔍 Common Patterns

### App Navigation with Sidebar and Detail
```swift
struct MyAppView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    @State private var showingNavigationSheet = false
    
    var body: some View {
        platformPresentAppNavigation_L1(
            columnVisibility: $columnVisibility,
            showingNavigationSheet: $showingNavigationSheet
        ) {
            SidebarView()
        } detail: {
            DetailView()
        }
    }
}
```

### Settings Container
```swift
struct SettingsView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    @State private var selectedCategory: String? = nil
    
    var body: some View {
        platformSettingsContainer_L4(
            columnVisibility: $columnVisibility,
            selectedCategory: $selectedCategory
        ) {
            SettingsListView(selectedCategory: $selectedCategory)
        } detail: {
            SettingsDetailView(category: selectedCategory)
        }
    }
}
```

### File System Utilities
```swift
// Home directory
let homeDir = platformHomeDirectory()

// Application Support (with creation)
guard let appSupport = platformApplicationSupportDirectory(createIfNeeded: true) else {
    // Handle error
    return
}

// Documents directory
guard let documents = platformDocumentsDirectory(createIfNeeded: true) else {
    // Handle error
    return
}
```

### Toolbar with Platform Placement
```swift
.toolbar {
    ToolbarItem(placement: platformConfirmationActionPlacement()) {
        Button("Save") { save() }
    }
    ToolbarItem(placement: platformCancellationActionPlacement()) {
        Button("Cancel") { cancel() }
    }
}
```

### Navigation Title Display Mode
```swift
NavigationStack {
    ContentView()
        .platformNavigationTitleDisplayMode(.inline)
}
```

## ⚠️ Important Notes

1. **Navigation pattern selection**: Framework automatically selects optimal pattern based on device, orientation, and screen size. Don't manually implement device detection logic.

2. **File system utilities**: All functions return `URL?` for safe error handling. Always check for `nil` before using the URL.

3. **Toolbar placement**: iOS/watchOS/visionOS use semantic placements with iOS 16+/watchOS 9+ availability checks. macOS/tvOS use `.automatic`.

4. **PlatformSpacing**: All values follow 8pt grid system. macOS uses slightly tighter spacing (12, 20) while maintaining grid alignment.

5. **Settings container**: Framework automatically chooses optimal presentation pattern. iPad and macOS use split view, iPhone uses NavigationStack with conditional detail.

6. **Navigation title display mode**: iOS applies the mode, macOS is no-op. Use the platform helper to eliminate conditionals.

7. **Cross-platform printing**: Available from v5.8.0, documented here for completeness. Supports text, images, PDFs, and SwiftUI views.

## 📚 Related Documentation

- `Development/RELEASE_v6.0.0.md` - Complete release notes
- `Framework/docs/README_Layer1_Semantic.md` - Layer 1 semantic functions documentation
- `Framework/Sources/Layers/Layer1-Semantic/PlatformSemanticLayer1.swift` - App navigation implementation
- `Framework/Sources/Components/Navigation/PlatformToolbarHelpers.swift` - Toolbar placement helpers
- `Framework/Sources/Extensions/Platform/PlatformSpacing.swift` - Platform spacing constants
- `Framework/Sources/Core/Utilities/PlatformFileSystemUtilities.swift` - File system utilities

## 🔗 Related Issues

- [Issue #43](https://github.com/schatt/6layer/issues/43) - Cross-Platform Printing Solution - ✅ COMPLETED
- [Issue #46](https://github.com/schatt/6layer/issues/46) - Add platformHomeDirectory() function - ✅ COMPLETED
- [Issue #48](https://github.com/schatt/6layer/issues/48) - Add platformApplicationSupportDirectory() and platformDocumentsDirectory() functions - ✅ COMPLETED
- [Issue #49](https://github.com/schatt/6layer/issues/49) - Add platformNavigationTitleDisplayMode() view extension - ✅ COMPLETED
- [Issue #51](https://github.com/schatt/6layer/issues/51) - Intelligent Device-Aware App Navigation - ✅ COMPLETED
- [Issue #53](https://github.com/schatt/6layer/issues/53) - Add iCloud Drive integration for platform file system utilities - ✅ COMPLETED
- [Issue #58](https://github.com/schatt/6layer/issues/58) - Feature: Add platformSettingsContainer_L4 for Settings Views - ✅ COMPLETED
- [Issue #59](https://github.com/schatt/6layer/issues/59) - Add Platform Toolbar Placement Helpers - ✅ COMPLETED
- [Issue #60](https://github.com/schatt/6layer/issues/60) - Add PlatformSpacing Struct for Consistent UI Spacing - ✅ COMPLETED (Refactored)

---

**Version**: v6.0.0  
**Last Updated**: December 6, 2025
