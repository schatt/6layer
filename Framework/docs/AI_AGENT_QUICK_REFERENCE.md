# 🤖 SixLayer Framework - AI Agent Quick Reference

**Purpose**: This is a concise guide for AI agents helping developers use the SixLayer Framework. For detailed information, see [AI_AGENT_GUIDE.md](AI_AGENT_GUIDE.md).

**Target Length**: ~1000 lines (fits in context windows)

---

## 🎯 Core Principle (CRITICAL)

**Layer 1 Semantic Intent**: Apps express **WHAT** they want to present, not **HOW** to implement it.

```
✅ CORRECT: platformPresentFormData_L1(fields: formFields, hints: formHints)
❌ WRONG:   VStack { TextField(...) }  // Raw SwiftUI breaks abstraction
```

---

## 🚫 What NOT to Do (Detection Script Violations)

The framework includes `scripts/detect_6layer_violations.py` that checks for these violations:

### Priority 1: Platform-Specific Types (NEVER USE)

| ❌ Wrong | ✅ Correct |
|---------|-----------|
| `NSColor`, `UIColor` | `Color.platformBackground`, `Color.platformLabel`, etc. |
| `NSFont`, `UIFont` | `Font.system()` or `Font.platform*` extensions |
| `NSImage`, `UIImage` | `PlatformImage` |
| `NSPasteboard`, `UIPasteboard` | `PlatformClipboard.copyToClipboard()` |
| `NSViewController`, `UIViewController` | SwiftUI `View` + `platformNavigation()` or `platformSheet()` |
| `NSView`, `UIView` | SwiftUI `View` types |
| `NSWindow`, `UIWindow` | `WindowGroup` in `@main App` struct, or `platformSheet_L4()` for modal windows, or `DocumentGroup` for document-based apps |
| `NSAlert`, `UIAlertController` | SwiftUI `.alert()` modifier or `platformMessagingLayer5` |
| `NSNavigationController`, `UINavigationController` | `platformNavigation()` or `platformNavigationStack()` |
| `NSTableView`, `UITableView` | `platformPresentItemCollection_L1()` or SwiftUI `List` |
| `NSCollectionView`, `UICollectionView` | `platformPresentItemCollection_L1()` or `LazyVGrid`/`LazyHGrid` |
| `NSSharingServicePicker`, `UIActivityViewController` | `platformShare_L4()` |
| `NSScreen`, `UIScreen` | Platform-specific screen detection extensions |
| `UIDevice` | `SixLayerPlatform.deviceType` or `RuntimeCapabilityDetection` |
| `NSApplication`, `UIApplication` | SwiftUI `@main App` lifecycle |
| `NSGraphicsContext`, `UIGraphicsImageRenderer` | `CGContext` with `Color.setFill()` extension |
| `UIImagePickerController` | `platformPhotoCapture_L1()` or `platformPhotoSelection_L1()` |
| `NSSize`, `UISize` | `CGSize` |
| `NSPoint`, `UIPoint` | `CGPoint` |
| `NSRect`, `UIRect` | `CGRect` |

### Priority 2: Incorrect SwiftUI View Usage

| ❌ Wrong | ✅ Correct |
|---------|-----------|
| `TextField` in form context | `platformPresentFormData_L1()` |
| `VStack` without semantic intent | `platformVStackContainer()` or `platformPresentItemCollection_L1()` |
| `HStack` without semantic intent | `platformHStackContainer()` or `platformPresentItemCollection_L1()` |

### Marking Exceptions

If a violation is necessary and intentional, mark it with a comment:

```swift
// 6LAYER_ALLOW: reason for exception
```

**Examples:**
```swift
let color = UIColor.red  // 6LAYER_ALLOW: Legacy code migration in progress

// 6LAYER_ALLOW: Required for platform-specific integration
let image = UIImage(named: "icon")
```

The comment can be on the same line (inline) or on the line immediately before the violation. The detection script will recognize these exceptions and report them separately as "allowed exceptions" rather than violations.

---

## ✅ What TO Do (Layer 1 Functions)

### Forms
```swift
// ✅ Present form data
platformPresentFormData_L1(
    fields: [GenericFormField],
    hints: PresentationHints
)

// ✅ Present modal form
platformPresentModalForm_L1(
    formType: DataTypeHint,
    context: PresentationContext
)
```

### Collections
```swift
// ✅ Present item collection
platformPresentItemCollection_L1<Item: Identifiable>(
    items: [Item],
    hints: PresentationHints
)
```

### Cards
```swift
// ✅ Present responsive card
platformResponsiveCard_L1<Content: View>(
    content: Content,
    hints: PresentationHints
)
```

### Navigation
```swift
// ✅ App navigation (device-aware) - Layer 1
platformPresentAppNavigation_L1<SidebarContent: View, DetailContent: View>(
    sidebar: SidebarContent,
    detail: DetailContent
)

// ✅ Navigation stack - Layer 1
platformPresentNavigationStack_L1<Content: View>(
    content: Content
)

// ✅ Navigation component - Layer 4 (use as component in custom views)
platformNavigation_L4 {
    ContentView()
}

// ✅ Navigation stack implementation - Layer 4 (use as component)
platformImplementNavigationStack_L4 {
    ContentView()
}
```

### Media
```swift
// ✅ Photo capture
platformPhotoCapture_L1(
    onCapture: @escaping (PlatformImage) -> Void
)

// ✅ Photo selection
platformPhotoSelection_L1(
    onSelect: @escaping (PlatformImage) -> Void
)

// ✅ Photo display
platformPhotoDisplay_L1(
    image: PlatformImage
)
```

### Data Types
```swift
// ✅ Numeric data
platformPresentNumericData_L1(
    value: Double,
    hints: PresentationHints
)

// ✅ Temporal data
platformPresentTemporalData_L1(
    date: Date,
    hints: PresentationHints
)

// ✅ Hierarchical data
platformPresentHierarchicalData_L1(
    data: Any,
    hints: PresentationHints
)

// ✅ Media data
platformPresentMediaData_L1(
    media: Any,
    hints: PresentationHints
)
```

### Settings
```swift
// ✅ Settings container
platformPresentSettings_L1(
    settings: [SettingItem]
)
```

### Window Management
```swift
// ✅ App-level window management (in @main App struct)
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// ✅ Document-based apps
@main
struct MyApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: MyDocument()) { file in
            ContentView(document: file.document)
        }
    }
}

// ✅ Modal windows - Layer 4 (use as component)
platformSheet_L4(isPresented: $showModal) {
    ModalContentView()
}

// ✅ Popover - Layer 4 (use as component)
platformPopover_L4(isPresented: $showPopover) {
    PopoverContentView()
}

// ✅ Window state detection (if needed)
let windowDetection = UnifiedWindowDetection()
// Use in view: windowDetection.updateFromGeometry(geometry)
```

### Generic Content
```swift
// ✅ Runtime-unknown content
platformPresentContent_L1(
    content: Any,
    hints: PresentationHints
)
```

### Layer 4 Components (Use as Building Blocks)
```swift
// ✅ Sheet presentation - Layer 4
platformSheet_L4(isPresented: $showSheet) {
    SheetContent()
}

// ✅ Popover - Layer 4
platformPopover_L4(isPresented: $showPopover) {
    PopoverContent()
}

// ✅ Navigation wrapper - Layer 4
platformNavigation_L4 {
    ContentView()
}

// ✅ Print - Layer 4
platformPrint_L4(content: .text("Hello"), jobName: "Document")

// ✅ Clipboard - Layer 4
platformCopyToClipboard_L4(text: "Text to copy")

// ✅ Open URL - Layer 4
platformOpenURL_L4(URL(string: "https://example.com")!)

// ✅ Photo picker - Layer 4
platformPhotoPicker_L4 { image in
    // Handle selected image
}

// ✅ Camera interface - Layer 4
platformCameraInterface_L4 { image in
    // Handle captured image
}

// ✅ Map view - Layer 4
platformMapView_L4(region: $mapRegion)
```

### OCR
```swift
// ✅ OCR with visual correction
platformOCRWithVisualCorrection_L1(
    image: PlatformImage,
    onComplete: @escaping (String) -> Void
)

// ✅ Extract structured data
platformExtractStructuredData_L1(
    image: PlatformImage,
    hints: PresentationHints
)
```

---

## 🏗️ Architecture Layers

```
Layer 1 (Semantic) → Layer 2 (Decision) → Layer 3 (Strategy) → 
Layer 4 (Implementation) → Layer 5 (Optimization) → Layer 6 (Platform)
```

**Layer Usage Guidelines**:
- **Layer 1 (Semantic Intent)**: Use for data presentation - express WHAT you want to present
  - `platformPresentFormData_L1()`, `platformPresentItemCollection_L1()`, etc.
  - Framework decides HOW to implement it
  
- **Layer 4 (Component Implementation)**: Can be used as components when building custom views
  - `platformSheet_L4()`, `platformPopover_L4()`, `platformNavigation_L4()`, etc.
  - Use when you need specific components or building custom UI
  
**As an AI agent**: Prefer Layer 1 for data presentation. Use Layer 4 functions as components when building custom views or when you need specific UI components.

---

## 📝 Common Patterns

### Pattern 0: When to Use Layer 1 vs Layer 4

**Use Layer 1** when presenting data:
```swift
// ✅ Express intent - framework handles implementation
platformPresentFormData_L1(fields: formFields, hints: hints)
platformPresentItemCollection_L1(items: items, hints: hints)
```

**Use Layer 4** when building custom views or need specific components:
```swift
// ✅ Use Layer 4 functions as components in custom views
struct CustomView: View {
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            Button("Show Sheet") { showSheet = true }
        }
        .platformSheet_L4(isPresented: $showSheet) {
            SheetContent()
        }
    }
}
```

### Pattern 1: Form with Business Data
```swift
// ✅ Convert business data to generic form fields
let formFields = vehicleData.map { field in
    GenericFormField(
        id: field.id,
        label: field.label,
        value: field.value,
        dataType: .text  // or .number, .date, etc.
    )
}

// ✅ Create hints with business-specific configuration
let hints = PresentationHints(
    dataType: .form,
    customPreferences: [
        "businessType": "vehicle",
        "requiredFields": ["make", "model", "year"]
    ]
)

// ✅ Present using Layer 1 function
platformPresentFormData_L1(
    fields: formFields,
    hints: hints
)
```

### Pattern 2: Collection of Business Items
```swift
// ✅ Your business type (must conform to Identifiable)
struct Vehicle: Identifiable {
    let id: UUID
    let make: String
    let model: String
}

// ✅ Create hints
let hints = PresentationHints(
    dataType: .collection,
    customPreferences: [
        "layoutStyle": "grid",
        "showImages": true
    ]
)

// ✅ Present using Layer 1 function
platformPresentItemCollection_L1(
    items: vehicles,
    hints: hints
)
```

### Pattern 3: Modal Form
```swift
// ✅ Present modal form
platformPresentModalForm_L1(
    formType: .form,
    context: PresentationContext(
        title: "Add Vehicle",
        customPreferences: ["businessType": "vehicle"]
    )
)
```

---

## ⚠️ Critical Mistakes to Avoid

### 1. Mixing 6layer Functions with SwiftUI Building Blocks
```swift
// ❌ WRONG
platformFormSection {
    VStack {  // ❌ Raw SwiftUI
        Text("Name")  // ❌ Raw SwiftUI
        TextField("Enter name", text: $name)  // ❌ Raw SwiftUI
    }
}

// ✅ CORRECT
platformPresentFormData_L1(
    fields: createFormFields(),
    hints: createFormHints()
)
```

### 2. Using Platform-Specific Types
```swift
// ❌ WRONG
let color = UIColor.red
let font = UIFont.systemFont(ofSize: 16)
let image = UIImage(named: "icon")

// ✅ CORRECT
let color = Color.platformLabel
let font = Font.system(size: 16)
let image = PlatformImage(named: "icon")
```

### 3. Expecting Business-Specific Functions
```swift
// ❌ WRONG - This function doesn't exist
platformPresentVehicleForm_L1(data: vehicleData)

// ✅ CORRECT - Use generic function with business hints
platformPresentFormData_L1(
    fields: convertVehicleToFields(vehicleData),
    hints: createVehicleHints()
)
```

### 4. Using Raw SwiftUI Views in App Code
```swift
// ❌ WRONG
VStack {
    HStack {
        Image(systemName: "car")
        Text("Vehicle")
    }
}

// ✅ CORRECT
platformPresentItemCollection_L1(
    items: vehicles,
    hints: vehicleHints
)
```

---

## 🔍 Quick Reference: Common Replacements

| If you see this... | Use this instead... |
|-------------------|---------------------|
| `VStack { ... }` | `platformVStackContainer()` or Layer 1 function |
| `HStack { ... }` | `platformHStackContainer()` or Layer 1 function |
| `TextField(...)` in forms | `platformPresentFormData_L1()` |
| `List(items) { ... }` | `platformPresentItemCollection_L1()` |
| `NavigationView` | `platformPresentNavigationStack_L1()` or `platformPresentAppNavigation_L1()` or `platformNavigation_L4()` (as component) |
| `Color.red` | `Color.platformLabel` or other `Color.platform*` |
| `Font.system(size:)` | `Font.system(size:)` (this is OK) |
| `Image(...)` | `Image(...)` (SwiftUI Image is OK) |
| `Text(...)` | `Text(...)` (SwiftUI Text is OK, but prefer Layer 1 functions) |

---

## 📚 When to Use What

### Use Layer 1 Functions When:
- ✅ Presenting forms
- ✅ Presenting collections/lists
- ✅ Presenting cards
- ✅ Navigation (semantic intent)
- ✅ Media (photos, images)
- ✅ Settings
- ✅ Any structured data presentation

### Use Layer 4 Functions When:
- ✅ Building custom views that need specific components
- ✅ Need sheet/popover presentation in custom views
- ✅ Need navigation wrapper for custom views
- ✅ Need print, clipboard, URL opening, photo picker, camera, map components
- ✅ Building reusable UI components

### SwiftUI Components Are OK For:
- ✅ Simple text display (`Text`)
- ✅ Simple image display (`Image`)
- ✅ Basic modifiers (`.padding()`, `.background()`, etc.)
- ✅ **BUT**: Prefer Layer 1 functions when available

### Never Use:
- ❌ Platform-specific types (NSColor, UIColor, etc.)
- ❌ Raw VStack/HStack in app code (use Layer 1 functions)
- ❌ Raw TextField in forms (use `platformPresentFormData_L1`)
- ❌ UIKit/AppKit view controllers

---

## 🛠️ Detection Script

Run the detection script to check for violations:

```bash
python scripts/detect_6layer_violations.py [directory]
```

This will report:
- Priority 1: Platform-specific type violations
- Priority 2: Incorrect SwiftUI view usage
- Allowed exceptions: Violations marked with `// 6LAYER_ALLOW: reason` comments

**Marking Exceptions**: If a violation is necessary, add `// 6LAYER_ALLOW: reason` on the same line or line above. The script will report these separately as allowed exceptions.

---

## 📖 For More Information

- **Full Guide**: [AI_AGENT_GUIDE.md](AI_AGENT_GUIDE.md) - Comprehensive guide (3646 lines)
- **Architecture**: [README_6LayerArchitecture.md](README_6LayerArchitecture.md)
- **Layer 1 Details**: [README_Layer1_Semantic.md](README_Layer1_Semantic.md)
- **Layer 4 Details**: [README_Layer4_Implementation.md](README_Layer4_Implementation.md)
- **Usage Examples**: [README_UsageExamples.md](README_UsageExamples.md)

---

## 🎯 Summary for AI Agents

1. **Prefer Layer 1 functions** for data presentation (express WHAT, not HOW)
2. **Use Layer 4 functions as components** when building custom views or need specific UI components
3. **Never use platform-specific types** (NSColor, UIColor, etc.)
4. **Never mix 6layer functions with raw SwiftUI building blocks** (VStack, HStack, TextField in forms)
5. **Express WHAT, not HOW** - let the framework decide implementation (Layer 1)
6. **Use hints for business logic** - not hardcoded business types
7. **Run detection script** to verify compliance

---

**Last Updated**: Based on v6.0.0 detection script and framework structure
