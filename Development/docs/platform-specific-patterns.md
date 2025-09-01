# Platform-Specific View Patterns

This document provides comprehensive guidance on using the platform-specific view infrastructure in the SixLayer Framework. The infrastructure is designed to provide consistent, maintainable, and type-safe platform-specific view handling.

## Overview

The platform-specific infrastructure consists of two main components:

1. **Platform-Specific View Extensions** (`PlatformSpecificViewExtensions.swift`)
2. **Platform-Aware View Protocol System** (`PlatformAwareView.swift`)

## Quick Start

### Basic Platform-Specific Modifiers

```swift
struct MyView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
            Button("Action") { }
        }
        .platformNavigationTitle("My View")
        .platformContentSpacing()
        .platformFrame(minWidth: 400, minHeight: 300)
    }
}
```

### Platform-Aware Views

```swift
struct MyPlatformAwareView: PlatformAwareView {
    let title: String
    
    @ViewBuilder
    func buildForiOS() -> some View {
        NavigationView {
            VStack {
                Text(title)
                Button("iOS Action") { }
            }
            .navigationTitle("iOS Title")
        }
    }
    
    @ViewBuilder
    func buildFormacOS() -> some View {
        VStack {
            Text(title)
            Button("macOS Action") { }
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}
```

## Platform-Specific View Extensions

### Navigation and Layout

#### `platformNavigation<Content: View>(@ViewBuilder content: () -> Content)`

Wraps content in platform-appropriate navigation. On iOS, wraps in NavigationView. On macOS, returns content directly.

```swift
platformNavigation {
    VStack {
        Text("My Content")
        Button("Action") { }
    }
    .navigationTitle("My View")
}
```

#### `platformNavigationTitle(_ title: String)`

Applies navigation title consistently across platforms.

```swift
Text("Content")
    .platformNavigationTitle("My Title")
```

#### `platformFrame(minWidth: CGFloat?, minHeight: CGFloat?, maxWidth: CGFloat?, maxHeight: CGFloat?)`

Applies frame constraints only on macOS. No effect on iOS.

```swift
VStack {
    Text("Content")
}
.platformFrame(minWidth: 400, minHeight: 300)
```

#### `platformContentSpacing(topPadding: CGFloat?)`

Applies platform-specific content spacing with optional custom top padding.

```swift
VStack {
    Text("Content")
}
.platformContentSpacing(topPadding: 20)
```

#### `platformContentSpacing(top: CGFloat?, bottom: CGFloat?, leading: CGFloat?, trailing: CGFloat?)`

Applies platform-specific content spacing with custom directional padding.

```swift
VStack {
    Text("Content")
}
.platformContentSpacing(top: 20, bottom: 16, leading: 12, trailing: 12)
```

#### `platformContentSpacing(horizontal: CGFloat?, vertical: CGFloat?)`

Applies platform-specific content spacing with horizontal and vertical padding.

```swift
VStack {
    Text("Content")
}
.platformContentSpacing(horizontal: 20, vertical: 16)
```

#### `platformContentSpacing(all: CGFloat?)`

Applies platform-specific content spacing with uniform padding on all sides.

```swift
VStack {
    Text("Content")
}
.platformContentSpacing(all: 16)
```

### Form and Container Modifiers

#### `platformFormContainer<Content: View>(@ViewBuilder content: () -> Content)`

Provides consistent form layout across platforms.

```swift
platformFormContainer {
    VStack(spacing: 16) {
        TextField("Name", text: $name)
        TextField("Email", text: $email)
        Button("Save") { }
    }
}
```

#### `platformListContainer<Content: View>(@ViewBuilder content: () -> Content)`

Provides consistent list styling across platforms.

```swift
platformListContainer {
    ForEach(items) { item in
        Text(item.name)
    }
}
```

#### `platformCardContainer<Content: View>(@ViewBuilder content: () -> Content)`

Provides consistent card styling across platforms.

```swift
platformCardContainer {
    VStack {
        Text("Card Title")
        Text("Card content goes here")
    }
}
```

### Toolbar Modifiers

#### `platformFormToolbar(onCancel: () -> Void, onSave: () -> Void, saveButtonTitle: String, cancelButtonTitle: String)`

Provides consistent toolbar for form views.

```swift
VStack {
    Text("Form Content")
}
.platformFormToolbar(
    onCancel: { dismiss() },
    onSave: { save() },
    saveButtonTitle: "Save",
    cancelButtonTitle: "Cancel"
)
```

#### `platformDetailToolbar(onCancel: () -> Void, onSave: () -> Void, saveButtonTitle: String)`

Simplified toolbar for detail views.

```swift
VStack {
    Text("Detail Content")
}
.platformDetailToolbar(
    onCancel: { dismiss() },
    onSave: { save() }
)
```

#### `platformListToolbar(onAdd: () -> Void, addButtonTitle: String, addButtonIcon: String)`

Toolbar for list views with add functionality.

```swift
List {
    ForEach(items) { item in
        Text(item.name)
    }
}
.platformListToolbar(
    onAdd: { addItem() },
    addButtonTitle: "Add",
    addButtonIcon: "plus"
)
```

### Sheet and Alert Modifiers

#### `platformSheet<SheetContent: View>(isPresented: Binding<Bool>, detents: [PlatformPresentationDetent], @ViewBuilder content: () -> SheetContent)`

Provides consistent sheet presentation across platforms.

```swift
VStack {
    Text("Main Content")
}
.platformSheet(isPresented: $showingSheet, detents: [.medium, .large]) {
    VStack {
        Text("Sheet Content")
        Button("Dismiss") { showingSheet = false }
    }
    .navigationTitle("Sheet Title")
}
```

#### `platformAlert(isPresented: Binding<Bool>, title: String, message: String?, primaryButton: Alert.Button, secondaryButton: Alert.Button?)`

Provides consistent alert presentation across platforms.

```swift
Button("Show Alert") { showingAlert = true }
.platformAlert(
    isPresented: $showingAlert,
    title: "Confirmation",
    message: "Are you sure?",
    primaryButton: .default("OK") { },
    secondaryButton: .cancel("Cancel")
)
```

### Input Control Modifiers

#### `platformTextFieldStyle()`

Consistent text field styling across platforms.

```swift
TextField("Enter text", text: $text)
    .platformTextFieldStyle()
```

#### `platformPickerStyle()`

Consistent picker styling across platforms.

```swift
Picker("Select option", selection: $selection) {
    Text("Option 1").tag(1)
    Text("Option 2").tag(2)
}
.platformPickerStyle()
```

#### `platformDatePickerStyle()`

Consistent date picker styling across platforms.

```swift
DatePicker("Select date", selection: $date)
    .platformDatePickerStyle()
```

### Button Style Modifiers

#### `platformPrimaryButtonStyle()`

Consistent primary button styling across platforms.

```swift
Button("Primary Action") { }
    .platformPrimaryButtonStyle()
```

#### `platformSecondaryButtonStyle()`

Consistent secondary button styling across platforms.

```swift
Button("Secondary Action") { }
    .platformSecondaryButtonStyle()
```

#### `platformDestructiveButtonStyle()`

Consistent destructive button styling across platforms.

```swift
Button("Delete") { }
    .platformDestructiveButtonStyle()
```

## Platform-Aware View Protocol System

### Basic Platform-Aware Views

The `PlatformAwareView` protocol allows you to define different view implementations for iOS and macOS while maintaining a single interface.

```swift
struct MyPlatformAwareView: PlatformAwareView {
    let title: String
    let onAction: () -> Void
    
    @ViewBuilder
    func buildForiOS() -> some View {
        NavigationView {
            VStack {
                Text(title)
                Button("Action", action: onAction)
            }
            .navigationTitle("iOS Title")
        }
    }
    
    @ViewBuilder
    func buildFormacOS() -> some View {
        VStack {
            Text(title)
            Button("Action", action: onAction)
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}
```

### Specialized Platform-Aware Protocols

#### `PlatformFormView`

For views that represent forms with save/cancel actions.

```swift
struct MyFormView: PlatformFormView {
    let title: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    @State private var text = ""
    
    @ViewBuilder
    func buildForiOS() -> some View {
        NavigationView {
            VStack {
                TextField("Enter text", text: $text)
                HStack {
                    Button("Cancel", action: onCancel)
                    Button("Save", action: onSave)
                }
            }
            .navigationTitle(title)
        }
    }
    
    @ViewBuilder
    func buildFormacOS() -> some View {
        VStack {
            TextField("Enter text", text: $text)
            HStack {
                Button("Cancel", action: onCancel)
                Button("Save", action: onSave)
            }
        }
        .frame(minWidth: 400, minHeight: 200)
    }
}
```

#### `PlatformNavigationView`

For views that need navigation functionality.

```swift
struct MyNavigationView: PlatformNavigationView {
    let navigationTitle: String
    let showNavigationBar: Bool
    
    @ViewBuilder
    func buildForiOS() -> some View {
        NavigationView {
            VStack {
                Text("iOS Navigation Content")
            }
            .navigationTitle(navigationTitle)
            .navigationBarHidden(!showNavigationBar)
        }
    }
    
    @ViewBuilder
    func buildFormacOS() -> some View {
        VStack {
            Text("macOS Navigation Content")
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}
```

#### `PlatformSheetView`

For views that are presented as sheets.

```swift
struct MySheetView: PlatformSheetView {
    let isPresented: Binding<Bool>
    let detents: [PlatformPresentationDetent]
    
    @ViewBuilder
    func buildForiOS() -> some View {
        NavigationView {
            VStack {
                Text("iOS Sheet Content")
                Button("Dismiss") { isPresented.wrappedValue = false }
            }
            .navigationTitle("Sheet Title")
        }
    }
    
    @ViewBuilder
    func buildFormacOS() -> some View {
        VStack {
            Text("macOS Sheet Content")
            Button("Dismiss") { isPresented.wrappedValue = false }
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}
```

#### `PlatformListView`

For views that display lists of items.

```swift
struct MyListView: PlatformListView {
    let items: [any Identifiable]
    let onAdd: () -> Void
    
    @ViewBuilder
    func buildForiOS() -> some View {
        NavigationView {
            List {
                ForEach(items, id: \.id) { item in
                    Text("Item: \(item.id)")
                }
            }
            .navigationTitle("iOS List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: onAdd) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func buildFormacOS() -> some View {
        VStack {
            List {
                ForEach(items, id: \.id) { item in
                    Text("Item: \(item.id)")
                }
            }
            .listStyle(.inset)
            
            HStack {
                Spacer()
                Button("Add Item", action: onAdd)
                    .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .frame(minWidth: 300, minHeight: 400)
    }
}
```

### Platform-Aware View Utilities

#### `PlatformAwareUtils.createView`

Create platform-aware views from closures.

```swift
// Single closure for both platforms
let view = PlatformAwareUtils.createView {
    VStack {
        Text("Shared Content")
        Button("Action") { }
    }
}

// Different content for each platform
let view = PlatformAwareUtils.createView(
    iOSContent: {
        NavigationView {
            VStack {
                Text("iOS Content")
            }
        }
    },
    macOSContent: {
        VStack {
            Text("macOS Content")
        }
        .frame(minWidth: 400, minHeight: 300)
    }
)
```

## Platform-Specific Colors

The infrastructure provides platform-specific color extensions:

```swift
// Platform-specific background colors
Color.cardBackground
Color.secondaryBackground
Color.tertiaryBackground
```

## Platform-Specific Utilities

The `PlatformUtils` struct provides utility functions:

```swift
// Check if layout is horizontal
let isHorizontal = PlatformUtils.isHorizontalLayout()

// Get optimal spacing for current platform
let spacing = PlatformUtils.getOptimalSpacing()

// Get optimal corner radius for current platform
let cornerRadius = PlatformUtils.getOptimalCornerRadius()
```

## Best Practices

### 1. Use Platform-Specific Modifiers for Simple Cases

For simple platform differences, use the modifier approach:

```swift
VStack {
    Text("Content")
}
.platformNavigationTitle("Title")
.platformContentSpacing()
.platformFrame(minWidth: 400, minHeight: 300)
```

### 2. Use Platform-Aware Views for Complex Differences

For views with significantly different layouts or behavior:

```swift
struct MyComplexView: PlatformAwareView {
    // Define different implementations for each platform
}
```

### 3. Avoid Inline Platform Checks

Instead of:
```swift
#if os(iOS)
NavigationView {
    content
}
#else
content
#endif
```

Use:
```swift
platformNavigation {
    content
}
```

### 4. Leverage Specialized Protocols

Use the specialized protocols when they match your use case:

```swift
struct MyForm: PlatformFormView {
    // Automatically provides form-specific functionality
}
```

### 5. Test on Both Platforms

Always test your platform-specific code on both iOS and macOS to ensure consistent behavior.

## Migration Guide

### From Inline Platform Checks

**Before:**
```swift
#if os(iOS)
NavigationView {
    VStack {
        Text("Content")
    }
    .navigationTitle("Title")
}
#else
VStack {
    Text("Content")
}
.frame(minWidth: 400, minHeight: 300)
#endif
```

**After:**
```swift
platformNavigation {
    VStack {
        Text("Content")
    }
    .navigationTitle("Title")
}
.platformFrame(minWidth: 400, minHeight: 300)
```

### From Duplicate Form Code

**Before:**
```swift
#if os(iOS)
ScrollView {
    VStack(spacing: 20) {
        formContent
    }
    .padding()
}
#else
Form {
    formContent
}
.formStyle(.grouped)
.padding()
#endif
```

**After:**
```swift
platformFormContainer {
    formContent
}
```

## Troubleshooting

### Common Issues

1. **Type Erasure Warnings**: The infrastructure avoids `AnyView` usage. If you see type erasure warnings, check that you're using the correct return types.

2. **Platform-Specific Compilation Errors**: Ensure that platform-specific code is properly wrapped in `#if os()` directives.

3. **Missing Modifiers**: If a modifier doesn't exist, consider creating it in the `PlatformSpecificViewExtensions.swift` file.

### Performance Considerations

1. **Avoid Excessive Type Erasure**: The infrastructure is designed to minimize type erasure. Use the provided modifiers instead of creating your own `AnyView` wrappers.

2. **Lazy Loading**: For complex platform-specific views, consider using lazy loading to defer initialization until needed.

3. **Conditional Compilation**: The infrastructure uses compile-time conditional compilation, which has minimal runtime overhead.

## Examples

See the example implementations in `PlatformAwareView.swift` for complete working examples of platform-aware views.

## Support

For questions or issues with the platform-specific infrastructure, refer to this documentation or consult the team lead. 