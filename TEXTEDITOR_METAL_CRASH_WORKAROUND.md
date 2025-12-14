# TextEditor Metal Telemetry Crash - Workaround Guide

## Problem

TextEditor crashes when used with certain SwiftUI modifiers due to a bug in Apple's Metal telemetry system. Metal telemetry tries to inspect TextEditor's internal properties and crashes when it encounters NSNumber values.

**Crash**: `-[__NSCFNumber length]: unrecognized selector sent to instance`

## Root Cause

When modifiers like `.background()`, `.foregroundStyle()`, `.font()`, `.cornerRadius()`, or `.overlay()` are applied to TextEditor (or parent views containing TextEditor), Metal telemetry is triggered to inspect the view hierarchy. Metal telemetry incorrectly calls `length` on NSNumber values found in TextEditor's internal properties.

## Solutions

### Solution 1: Use SafeTextEditor Wrapper (Recommended)

Use the `SafeTextEditor` or `StyledSafeTextEditor` wrapper provided by SixLayer Framework:

```swift
import SixLayerFramework

struct MyView: View {
    @State private var text = ""
    
    var body: some View {
        // Option 1: Basic safe wrapper
        SafeTextEditor(text: $text)
            .frame(minHeight: 120)
        
        // Option 2: Styled safe wrapper
        StyledSafeTextEditor(
            text: $text,
            backgroundColor: .platformBackground,
            cornerRadius: 8,
            minHeight: 120
        )
    }
}
```

### Solution 2: Apply Styling to Container, Not TextEditor

Instead of applying modifiers directly to TextEditor, apply them to a container:

```swift
// ❌ BAD - Triggers Metal telemetry crash
TextEditor(text: $text)
    .background(Color.platformBackground)
    .cornerRadius(8)
    .overlay(...)

// ✅ GOOD - Styling on container, not TextEditor
ZStack(alignment: .topLeading) {
    RoundedRectangle(cornerRadius: 8)
        .fill(Color.platformBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
        )
    
    TextEditor(text: $text)
        .scrollContentBackground(.hidden) // Hide default background
        .padding(8)
}
.frame(minHeight: 120)
```

### Solution 3: Use TextField with axis (iOS 16+ / macOS 13+)

For shorter multi-line text, use `TextField` with `axis: .vertical` instead of `TextEditor`:

```swift
// ✅ Works without Metal telemetry issues
TextField("Enter text", text: $text, axis: .vertical)
    .lineLimit(5...10)
    .textFieldStyle(.roundedBorder)
    .background(Color.platformBackground)
    .cornerRadius(8)
```

### Solution 4: Avoid Problematic Modifiers on TextEditor

If you must use TextEditor directly, avoid these modifiers on or near it:
- `.background()` - Use container approach instead
- `.foregroundStyle()` - Apply to parent views only
- `.font()` - Apply to parent views only  
- `.cornerRadius()` - Use container with RoundedRectangle instead
- `.overlay()` - Use ZStack container instead
- `.padding()` - Apply to container, not TextEditor

## Migration Guide

### Before (Crashes)

```swift
TextEditor(text: $inputText)
    .frame(minHeight: 120)
    .padding(8)
    .background(Color.platformBackground)  // ❌ Triggers Metal telemetry
    .cornerRadius(8)                        // ❌ Triggers Metal telemetry
    .overlay(                               // ❌ Triggers Metal telemetry
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
    )
```

### After (Safe)

```swift
// Option A: Use SafeTextEditor wrapper
StyledSafeTextEditor(
    text: $inputText,
    backgroundColor: .platformBackground,
    cornerRadius: 8,
    minHeight: 120
)

// Option B: Manual container approach
ZStack(alignment: .topLeading) {
    RoundedRectangle(cornerRadius: 8)
        .fill(Color.platformBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
        )
    
    TextEditor(text: $inputText)
        .scrollContentBackground(.hidden)
        .padding(8)
}
.frame(minHeight: 120)
```

## Framework Changes

SixLayer Framework has been updated to:
1. ✅ Remove `.drawingGroup()` and `.compositingGroup()` from Layer 5 optimizations
2. ✅ Remove visual styling modifiers from `applyHIGComplianceFeatures()` that trigger Metal telemetry
3. ✅ Provide `SafeTextEditor` wrapper for safe TextEditor usage

## Long-Term Solution

**File a radar bug report** with Apple (see `METAL_TELEMETRY_TEXTEDITOR_CRASH_RADAR.md`). This is a bug in Apple's Metal framework that needs to be fixed at the framework level.

## Additional Notes

- The crash occurs in Metal telemetry, not in your code or SwiftUI
- This affects any app using TextEditor with styling modifiers
- The workaround (container approach) maintains visual appearance while preventing crashes
- Consider using `TextField` with `axis: .vertical` for shorter text inputs (iOS 16+ / macOS 13+)






