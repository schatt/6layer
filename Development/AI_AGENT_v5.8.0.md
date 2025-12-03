# AI Agent Guide for SixLayer Framework v5.8.0

This guide summarizes the version-specific context for v5.8.0. **Always read this file before assisting with the framework at this version.**

> **Scope**: This guide is for AI assistants helping developers use or extend the framework (not for automated tooling).

## 🎯 Quick Start

1. Confirm the project is on **v5.8.0** (see `Package.swift` comment or release tags).
2. Understand that **cross-platform printing** is now available via `platformPrint_L4`.
3. Know that printing supports text, images, PDFs, and SwiftUI views.
4. Apply TDD, DRY, DTRT, and Epistemology rules in every change.

## 🆕 What's New in v5.8.0

### Cross-Platform Printing API
- `platformPrint_L4` view modifier and direct function for unified printing
- `PrintContent` enum: `.text(String)`, `.image(PlatformImage)`, `.pdf(Data)`, `.view(AnyView)`
- `PrintOptions` struct with job name, copies, page range, and output type (iOS)
- Automatic photo-quality printing for images (iOS)

### Platform Implementations
- **iOS**: Uses `UIPrintInteractionController` with modal sheet presentation
- **macOS**: Uses `NSPrintOperation` with standard print dialog
- Error handling for no printer available scenarios
- Graceful fallbacks for older OS versions

### Key Features
- Accepts `PlatformImage` directly (no manual `.uiImage`/`.nsImage` conversion)
- Photo-quality printing support (`.photo` output type on iOS)
- Completion callbacks for print status
- Automatic accessibility identifiers

## 🧠 Guidance for v5.8.0 Work

### 1. Printing API Usage
- Use view modifier for SwiftUI integration: `.platformPrint_L4(isPresented:content:options:onComplete:)`
- Use direct function for programmatic printing: `platformPrint_L4(content:options:)`
- Always pass `PlatformImage` directly - no conversion needed
- Images default to photo-quality printing automatically

### 2. Content Type Selection
- **Text**: Use `.text(String)` for simple text documents
- **Images**: Use `.image(PlatformImage)` for photos, insurance cards, etc.
- **PDFs**: Use `.pdf(Data)` for PDF documents
- **Views**: Use `.view(AnyView(...))` for SwiftUI views (requires iOS 16+/macOS 13+)

### 3. Print Options Configuration
- Set `jobName` for better user experience (appears in print dialog)
- Use `outputType: .photo` for photo-quality printing (iOS only)
- Copies and page range are handled by system print dialog UI
- Options are optional - sensible defaults are provided

### 4. Error Handling
- Always check return value from direct function (returns `Bool`)
- Use `onComplete` callback for detailed feedback
- Handle "no printer available" gracefully (function returns `false`)
- User cancellation is indicated via callback (`false`), not return value

### 5. Testing Expectations
- Follow TDD: tests in `PlatformPrintLayer4Tests.swift`
- Test API consistency across platforms
- Test all content types (text, image, PDF, view)
- Test error handling (no printer, invalid content)
- Test accessibility compliance

## ✅ Best Practices

1. **Use PlatformImage directly**: No manual conversion needed
   ```swift
   // ✅ Good - direct PlatformImage usage
   .platformPrint_L4(
       isPresented: $showPrintDialog,
       content: .image(platformImage)
   )
   
   // ❌ Avoid - manual conversion
   .platformPrint_L4(
       isPresented: $showPrintDialog,
       content: .image(PlatformImage(uiImage: image.uiImage))  // Unnecessary
   )
   ```

2. **Set meaningful job names**: Helps users identify print jobs
   ```swift
   // ✅ Good - descriptive job name
   PrintOptions(jobName: "Insurance Card")
   
   // ❌ Avoid - generic or missing job name
   PrintOptions()  // Uses default "Document"
   ```

3. **Use photo quality for images**: Especially for insurance cards, photos
   ```swift
   // ✅ Good - photo quality for images
   PrintOptions(
       jobName: "Insurance Card",
       outputType: .photo
   )
   
   // ❌ Avoid - general quality for photos
   PrintOptions(outputType: .general)  // Lower quality
   ```

4. **Handle completion callbacks**: Provide user feedback
   ```swift
   // ✅ Good - handle completion
   .platformPrint_L4(
       isPresented: $showPrintDialog,
       content: .image(image),
       onComplete: { success in
           if success {
               showSuccessMessage()
           } else {
               showErrorMessage()
           }
       }
   )
   
   // ❌ Avoid - ignore completion
   .platformPrint_L4(
       isPresented: $showPrintDialog,
       content: .image(image)
       // No feedback to user
   )
   ```

5. **Test on both platforms**: Verify behavior on iOS and macOS
   ```swift
   // ✅ Good - test both platforms
   #if os(iOS)
   // Test iOS-specific behavior
   #elseif os(macOS)
   // Test macOS-specific behavior
   #endif
   ```

## 🔍 Common Patterns

### Insurance Card Printing
```swift
struct InsuranceCardView: View {
    @State private var showPrintDialog = false
    let insuranceCardImage: PlatformImage
    
    var body: some View {
        Button("Print Insurance Card") {
            showPrintDialog = true
        }
        .platformPrint_L4(
            isPresented: $showPrintDialog,
            content: .image(insuranceCardImage),
            options: PrintOptions(
                jobName: "Insurance Card",
                outputType: .photo  // Photo-quality printing
            ),
            onComplete: { success in
                if success {
                    print("Insurance card printed successfully")
                }
            }
        )
    }
}
```

### Document Printing
```swift
struct DocumentView: View {
    @State private var showPrintDialog = false
    let documentText: String
    
    var body: some View {
        Button("Print Document") {
            showPrintDialog = true
        }
        .platformPrint_L4(
            isPresented: $showPrintDialog,
            content: .text(documentText),
            options: PrintOptions(jobName: "Report")
        )
    }
}
```

### Programmatic Printing
```swift
func printReport() {
    let success = platformPrint_L4(
        content: .text(reportContent),
        options: PrintOptions(jobName: "Monthly Report")
    )
    if !success {
        // Handle error (no printer available, etc.)
    }
}
```

## ⚠️ Important Notes

1. **PlatformImage conversion**: The API accepts `PlatformImage` directly. Internal conversion to `UIImage`/`NSImage` happens at the system boundary - this is expected and correct.

2. **Photo quality default**: Images automatically use `.photo` output type unless explicitly set to `.general` or `.grayscale`.

3. **View printing limitations**: SwiftUI view printing requires iOS 16+/macOS 13+. Fallbacks are provided for older versions but may have reduced quality.

4. **Error handling**: The direct function returns `false` if the print dialog cannot be shown (no printer, invalid content). The callback provides more detailed feedback (user cancellation, system errors).

5. **Accessibility**: The print modifier automatically applies accessibility identifiers. No additional accessibility work needed.

## 📚 Related Documentation

- `Framework/docs/PlatformPrintLayer4Guide.md` - Complete usage guide
- `Framework/Sources/Layers/Layer4-Component/PlatformPrintLayer4.swift` - Implementation
- `Development/Tests/SixLayerFrameworkUnitTests/Features/Platform/PlatformPrintLayer4Tests.swift` - Test suite

## 🔗 Related Issues

- [Issue #43](https://github.com/schatt/6layer/issues/43) - Cross-Platform Printing Solution (implemented)

---

**Version**: v5.8.0  
**Last Updated**: December 3, 2025

