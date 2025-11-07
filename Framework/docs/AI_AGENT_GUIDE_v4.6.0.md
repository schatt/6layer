# 🤖 AI Agent Guide for SixLayer Framework v4.6.0

*This document is specifically designed for AI agents (like Claude, GPT, etc.) to understand the new features and changes in SixLayer Framework v4.6.0.*

## 🎯 **Purpose of This Guide**

AI agents need to understand the **NEW FEATURES** in v4.6.0:
- **Default Values in Hints System** - Major new capability for handling missing/empty data
- **Enhanced CardDisplayHelper** - Improved data extraction with better fallback behavior
- **UI Layer Placeholder System** - Better separation of concerns between data and UI layers
- **Breaking Changes** - Internal API changes that are non-breaking for external developers

## 📚 **Table of Contents**

1. **[What's New in v4.6.0](#-whats-new-in-v460)** - New features and capabilities
2. **[Default Values System](#-default-values-system)** - Complete guide to the new default values feature
3. **[CardDisplayHelper Changes](#-carddisplayhelper-changes)** - Internal improvements and API changes
4. **[Migration Guide](#-migration-guide)** - How to upgrade from v4.5.0
5. **[Best Practices](#-best-practices)** - How to use new features effectively
6. **[Troubleshooting](#-troubleshooting)** - Common issues and solutions

## 🆕 **What's New in v4.6.0**

### **Major New Features**

#### **1. Default Values in Hints System** ⭐ **BREAKTHROUGH FEATURE**
```swift
// ✅ NEW: Default values for missing or empty properties
let hints = PresentationHints(
    dataType: .collection,
    presentationPreference: .list,
    complexity: .moderate,
    context: .browse,
    customPreferences: [
        "itemTitleProperty": "name",
        "itemTitleDefault": "Untitled Document",        // NEW: Default when name is missing/empty
        "itemSubtitleProperty": "description", 
        "itemSubtitleDefault": "No description available", // NEW: Default when description is missing/empty
        "itemIconProperty": "status",
        "itemIconDefault": "doc.text",                   // NEW: Default when status is missing/empty
        "itemColorProperty": "priority",
        "itemColorDefault": "gray"                      // NEW: Default when priority is missing/empty
    ]
)
```

#### **2. Enhanced CardDisplayHelper** 🔧 **INTERNAL IMPROVEMENT**
- **Better Priority System**: More intelligent content extraction
- **Nil Returns**: Returns `nil` instead of hardcoded fallbacks when no content found
- **Smart Empty String Handling**: Respects empty strings unless default provided
- **UI Layer Separation**: Better separation between data and UI responsibilities

#### **3. UI Layer Placeholder System** 🎨 **UX IMPROVEMENT**
- **Field Name Placeholders**: Shows field names (e.g., "Title") when no content found
- **Lighter Color Styling**: Placeholders displayed in lighter colors
- **Better User Experience**: Clear distinction between content and placeholders

### **Key Benefits**

1. **Fine-Grained Control**: Developers can now control fallback behavior precisely
2. **Better UX**: Users see meaningful placeholders instead of generic text
3. **Cleaner Architecture**: Better separation between data and UI layers
4. **Non-Breaking**: External API remains unchanged for existing code

## 🎯 **Default Values System**

### **Core Concept**

The default values system allows developers to specify fallback values when properties are missing, empty, or fail to extract meaningful content. This provides fine-grained control over how the framework handles incomplete data.

### **Available Default Properties**

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `itemTitleDefault` | String | Default title when title property is missing/empty | `"Untitled Document"` |
| `itemSubtitleDefault` | String | Default subtitle when subtitle property is missing/empty | `"No description available"` |
| `itemIconDefault` | String | Default icon when icon property is missing/empty | `"doc.text"` |
| `itemColorDefault` | String | Default color when color property is missing/empty | `"gray"` |

### **Priority System (Enhanced)**

The framework uses a sophisticated priority system for content extraction:

#### **1. Priority 1: Hint Property Extraction**
```swift
// Try to extract from the specified property
"itemTitleProperty": "title"  // Extract from item.title
```

#### **2. Priority 1.5: Default Values** ⭐ **NEW**
```swift
// Use default when hint property fails or extracts empty string
"itemTitleDefault": "Untitled Document"
```

#### **3. Priority 2: CardDisplayable Protocol**
```swift
// Fall back to CardDisplayable protocol (if no hints provided)
protocol CardDisplayable {
    var cardTitle: String { get }
}
```

#### **4. Priority 3: Reflection Discovery**
```swift
// Use reflection to find meaningful properties (if no hints provided)
// Looks for common property names like "title", "name", "label"
```

#### **5. Priority 4: UI Layer Placeholders**
```swift
// UI layer provides field name placeholders
Text(extractedTitle ?? "Title")  // Shows "Title" in lighter color
```

### **Usage Examples**

#### **Basic Default Values**
```swift
let hints = PresentationHints(
    customPreferences: [
        "itemTitleProperty": "name",
        "itemTitleDefault": "Untitled Document",
        "itemSubtitleProperty": "description", 
        "itemSubtitleDefault": "No description available",
        "itemIconProperty": "status",
        "itemIconDefault": "doc.text",
        "itemColorProperty": "priority",
        "itemColorDefault": "gray"
    ]
)

platformPresentItemCollection_L1(items: documents, hints: hints)
```

#### **Handling Missing Properties**
```swift
// When Core Data entities have nil values
let task = Task(title: nil, description: nil, status: nil)

let hints = PresentationHints(
    customPreferences: [
        "itemTitleProperty": "title",        // Will be nil
        "itemTitleDefault": "Untitled Task",  // Will be used
        "itemSubtitleProperty": "description", // Will be nil  
        "itemSubtitleDefault": "No description" // Will be used
    ]
)

// Result: "Untitled Task" and "No description" will be displayed
```

#### **Handling Empty Strings**
```swift
// When properties exist but are empty strings
let task = Task(title: "", description: "", status: "")

let hints = PresentationHints(
    customPreferences: [
        "itemTitleProperty": "title",        // Will extract ""
        "itemTitleDefault": "Untitled Task",  // Will override empty string
        "itemSubtitleProperty": "description", // Will extract ""
        "itemSubtitleDefault": "No description" // Will override empty string
    ]
)

// Result: "Untitled Task" and "No description" will be displayed
```

#### **Respecting Intentional Empty Strings**
```swift
// When you want to preserve empty strings as valid content
let task = Task(title: "", description: "", status: "")

let hints = PresentationHints(
    customPreferences: [
        "itemTitleProperty": "title"
        // No default provided - empty string will be preserved
    ]
)

// Result: Empty string will be displayed (UI layer will show placeholder)
```

### **Color Default Values**

Color defaults support both string names and hex values:

```swift
let hints = PresentationHints(
    customPreferences: [
        "itemColorProperty": "priority",
        "itemColorDefault": "red"        // Named color
        // OR
        "itemColorDefault": "#FF0000"    // Hex color (future support)
    ]
)
```

#### **Supported Color Names**
| Color Name | SwiftUI Color |
|------------|---------------|
| `red` | `.red` |
| `blue` | `.blue` |
| `green` | `.green` |
| `yellow` | `.yellow` |
| `orange` | `.orange` |
| `purple` | `.purple` |
| `pink` | `.pink` |
| `gray` | `.gray` |
| `black` | `.black` |
| `white` | `.white` |
| `cyan` | `.cyan` |
| `mint` | `.mint` |
| `teal` | `.teal` |
| `indigo` | `.indigo` |
| `brown` | `.brown` |

### **Icon Default Values**

Icon defaults support SF Symbols:

```swift
let hints = PresentationHints(
    customPreferences: [
        "itemIconProperty": "status",
        "itemIconDefault": "doc.text"           // SF Symbol
        // OR
        "itemIconDefault": "checkmark.circle"    // SF Symbol
    ]
)
```

## 🔧 **CardDisplayHelper Changes**

### **Internal API Changes**

The `CardDisplayHelper` has been enhanced with better logic and cleaner architecture:

#### **Before (v4.5.0 and earlier)**
```swift
// Old behavior - always got hardcoded fallbacks
let title = CardDisplayHelper.extractTitle(from: item) // Always returned a string
// No way to customize fallback behavior
```

#### **After (v4.6.0+)**
```swift
// New behavior - can return nil, defaults can override
let title = CardDisplayHelper.extractTitle(from: item) // Can return nil

// NEW: Use defaults to control fallback behavior
let hints = PresentationHints(
    customPreferences: [
        "itemTitleProperty": "name",
        "itemTitleDefault": "Untitled Document"  // NEW: Custom default
    ]
)
```

### **What Changed**

1. **Return Types**: `extractTitle`, `extractIcon`, and `extractColor` now return optionals
2. **Nil Returns**: Methods return `nil` when no meaningful content (or default) is found
3. **Empty String Logic**: Empty strings return `nil` unless explicit default is configured
4. **CardDisplayable Fallback**: Removed from data layer (now UI layer responsibility)
5. **Reflection Logic**: Only used when no hints are provided at all

### **Why This Is Non-Breaking**

- **Internal Implementation**: `CardDisplayHelper` is an internal implementation detail
- **Public API Unchanged**: `platformPresentItemCollection_L1` API remains the same
- **UI Layer Handles**: UI layer provides appropriate placeholders for `nil` values
- **Better Experience**: Users get better UX with meaningful placeholders

## 📋 **Migration Guide**

### **For Existing Code**

#### **✅ No Changes Required**
Most existing code will continue to work without changes:

```swift
// This code continues to work exactly as before
let view = platformPresentItemCollection_L1(
    items: myItems,
    hints: PresentationHints(
        dataType: .collection,
        presentationPreference: .list
    )
)
```

#### **✅ Optional: Add Default Values**
You can optionally add default values for better UX:

```swift
// Enhanced version with default values
let view = platformPresentItemCollection_L1(
    items: myItems,
    hints: PresentationHints(
        dataType: .collection,
        presentationPreference: .list,
        customPreferences: [
            "itemTitleProperty": "name",
            "itemTitleDefault": "Untitled Item",        // NEW: Better UX
            "itemSubtitleProperty": "description",
            "itemSubtitleDefault": "No description"     // NEW: Better UX
        ]
    )
)
```

### **For New Code**

#### **✅ Use Default Values for Better UX**
```swift
// Recommended approach for new code
let hints = PresentationHints(
    dataType: .collection,
    presentationPreference: .list,
    customPreferences: [
        "itemTitleProperty": "title",
        "itemTitleDefault": "Untitled Document",
        "itemSubtitleProperty": "description",
        "itemSubtitleDefault": "No description available",
        "itemIconProperty": "status",
        "itemIconDefault": "doc.text",
        "itemColorProperty": "priority",
        "itemColorDefault": "gray"
    ]
)
```

## 🎯 **Best Practices**

### **1. Provide Meaningful Defaults**
```swift
// ✅ Good - Descriptive defaults
"itemTitleDefault": "Untitled Document"
"itemSubtitleDefault": "No description available"

// ❌ Avoid - Generic defaults
"itemTitleDefault": "Item"
"itemSubtitleDefault": "N/A"
```

### **2. Use Context-Appropriate Defaults**
```swift
// ✅ Good - Context-specific defaults
// For tasks
"itemTitleDefault": "Untitled Task"
"itemIconDefault": "doc.text"

// For projects  
"itemTitleDefault": "Untitled Project"
"itemIconDefault": "folder"

// For users
"itemTitleDefault": "Unknown User"
"itemIconDefault": "person.circle"
```

### **3. Consider User Experience**
```swift
// ✅ Good - User-friendly defaults
"itemTitleDefault": "Untitled Document"
"itemSubtitleDefault": "Tap to add description"

// ❌ Avoid - Technical defaults
"itemTitleDefault": "nil"
"itemSubtitleDefault": "undefined"
```

### **4. Handle Different Data States**
```swift
// ✅ Good - Comprehensive default handling
let hints = PresentationHints(
    customPreferences: [
        // Handle missing properties
        "itemTitleProperty": "title",
        "itemTitleDefault": "Untitled Task",
        
        // Handle empty properties  
        "itemSubtitleProperty": "description",
        "itemSubtitleDefault": "No description",
        
        // Handle invalid properties
        "itemIconProperty": "status",
        "itemIconDefault": "doc.text"
    ]
)
```

## 🔍 **Troubleshooting**

### **Common Issues and Solutions**

#### **1. Default Values Not Working**
```
Problem: Default values not being used
Solution: 
- Check property names match actual property names
- Ensure default values are non-empty strings
- Verify hints are being passed correctly
```

#### **2. Empty Strings Not Respected**
```
Problem: Empty strings being overridden by defaults
Solution:
- Remove defaults if you want to preserve empty strings
- Use UI placeholders for empty string display
```

#### **3. CardDisplayable Not Used**
```
Problem: CardDisplayable protocol not being used
Solution:
- CardDisplayable is only used when no hints are provided
- Use defaults in hints to control fallback behavior
```

#### **4. UI Placeholders Not Showing**
```
Problem: Field name placeholders not appearing
Solution:
- This is handled automatically by the UI layer
- Ensure CardDisplayHelper returns nil when appropriate
- Check that UI layer is using nil-coalescing operator
```

### **Debugging Tips**

#### **1. Check Hint Configuration**
```swift
// Debug hint configuration
print("Hints: \(hints.customPreferences)")
print("Title property: \(hints.customPreferences["itemTitleProperty"])")
print("Title default: \(hints.customPreferences["itemTitleDefault"])")
```

#### **2. Test Default Values**
```swift
// Test default values with known data
let testItem = TestItem(title: nil, description: nil)
let hints = PresentationHints(
    customPreferences: [
        "itemTitleProperty": "title",
        "itemTitleDefault": "Test Default"
    ]
)

let extractedTitle = CardDisplayHelper.extractTitle(from: testItem, hints: hints)
print("Extracted title: \(extractedTitle ?? "nil")")
```

#### **3. Verify UI Layer Behavior**
```swift
// Check UI layer placeholder behavior
let view = platformPresentItemCollection_L1(items: [testItem], hints: hints)
// Should show "Test Default" instead of generic placeholder
```

## 📚 **Resources**

### **Documentation Links**
- **[Hints Default Values Guide](HintsDefaultValuesGuide.md)** - Complete guide to default values
- **[AI Agent Guide](AI_AGENT_GUIDE.md)** - General AI agent guidance
- **[Hints System Extensibility](HintsSystemExtensibility.md)** - Advanced hints usage

### **Key Files**
- `Framework/Sources/Core/Models/CardDisplayable.swift` - CardDisplayHelper implementation
- `Framework/Sources/Layers/Layer4-Component/IntelligentCardExpansionLayer4.swift` - UI layer implementation
- `Development/Tests/SixLayerFrameworkTests/Features/Collections/HintsDefaultValueTests.swift` - Test examples

### **Test Examples**
- `HintsDefaultValueTests.swift` - Comprehensive test coverage
- `CardDisplayableBugTests.swift` - Bug fix verification
- `CardDisplayHelperNilFallbackTests.swift` - Nil return behavior tests

## 🎯 **Key Takeaways for AI Agents**

### **When Developers Ask About Missing Data**
```
Developer: "How do I handle missing or empty properties?"
AI Agent: "Use the new default values feature in v4.6.0! Add default values 
          to your hints like 'itemTitleDefault': 'Untitled Document'. 
          This gives you fine-grained control over fallback behavior."
```

### **When Developers Ask About Empty Strings**
```
Developer: "How do I handle empty strings?"
AI Agent: "The framework now has smart empty string handling! Empty strings 
          are respected as valid content unless you provide a default value. 
          If you want to override empty strings, add a default in your hints."
```

### **When Developers Ask About CardDisplayable**
```
Developer: "Why isn't CardDisplayable being used?"
AI Agent: "CardDisplayable is now only used when no hints are provided. 
          Use default values in hints to control fallback behavior instead. 
          This gives you more control and better UX."
```

### **When Developers Ask About Migration**
```
Developer: "Do I need to change my existing code?"
AI Agent: "No! v4.6.0 is non-breaking. Your existing code continues to work. 
          You can optionally add default values for better UX, but it's not required."
```

---

**Version**: SixLayer Framework v4.6.0  
**Last Updated**: October 24, 2025  
**Related**: [AI Agent Guide](AI_AGENT_GUIDE.md), [Hints Default Values Guide](HintsDefaultValuesGuide.md)

**Remember**: The default values feature is a **major new capability** that provides developers with fine-grained control over fallback behavior. Help developers understand and use this powerful new feature effectively.
