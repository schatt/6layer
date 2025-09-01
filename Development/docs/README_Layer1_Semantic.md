# Layer 1: Semantic Intent

## Overview

Layer 1 focuses on expressing WHAT you want to achieve without worrying about implementation details. These functions provide a platform-agnostic way to express user intent.

## 📁 File Location

*`Shared/Views/Extensions/PlatformSemanticLayer1.swift`*

## 🎯 Purpose

Define the user's intent in platform-agnostic terms that can be interpreted by the decision engine and strategy layers.

## 🔧 Implementation Details

**Content:** Contains `extension View` blocks for semantic functions

## 📋 Available Functions

### **Form Presentation**
- `platformPresentForm(type:complexity:style:)` - Express intent to present a form
- `platformPresentNavigation(style:title:)` - Express intent to present navigation
- `platformPresentModal(type:content:)` - Express intent to present a modal

### **Responsive Cards**
- `platformResponsiveCard(type:content:)` - Express intent for responsive cards

## 📊 Data Types

### **FormType**
- `dataCreation` - Data creation forms
- `dataEntry` - Data entry forms
- `recordEntry` - Record entry forms
- `itemRecord` - Item record forms
- `tireChange` - Tire change forms
- `warrantyEntry` - Warranty entry forms
- `insuranceEntry` - Insurance entry forms

### **NavigationStyle**
- `embedded` - Embedded navigation within the current view
- `sheet` - Modal sheet presentation
- `window` - New window presentation (macOS)
- `sidebar` - Sidebar navigation (macOS)

### **ModalType**
- `alert` - Alert dialog
- `sheet` - Modal sheet
- `confirmationDialog` - Confirmation dialog
- `popover` - Popover presentation

### **FormIntent**
- `simple` - Simple forms with few fields
- `moderate` - Moderate complexity forms
- `complex` - Complex forms with many fields
- `veryComplex` - Very complex forms requiring special handling

### **CardType**
- `dashboard` - Dashboard-style cards
- `detail` - Detail view cards
- `summary` - Summary information cards
- `action` - Action-oriented cards
- `media` - Media-rich cards

## 💡 Usage Examples

### **Basic Form Presentation**
```swift
.platformPresentForm(
    type: .dataEntry,
    complexity: .moderate,
    style: .standard
) {
    // Form content
}
```

### **Responsive Card Intent**
```swift
.platformResponsiveCard(type: .dashboard) {
    // Card content
}
```

### **Navigation Intent**
```swift
.platformPresentNavigation(
    style: .sheet,
    title: "Add Item"
) {
    // Navigation content
}
```

## 🔄 Integration with Other Layers

### **Layer 1 → Layer 2**
Layer 1 functions call Layer 2 decision functions to determine how to implement the intent.

### **Layer 1 → Layer 4**
Layer 1 can directly call Layer 4 implementation functions for immediate execution.

## 🎨 Design Principles

1. **Intent-First:** Focus on what the user wants, not how to achieve it
2. **Platform-Agnostic:** Functions work the same on all platforms
3. **Progressive Enhancement:** Can be used independently or with other layers
4. **Semantic Clarity:** Function names clearly express the user's goal

## 🚀 Future Enhancements

- **More Form Types:** Additional specialized form types
- **Custom Intent Types:** User-defined intent types
- **Intent Validation:** Validate intent parameters before processing
- **Intent Chaining:** Chain multiple intents together

## 📚 Related Documentation

- **Architecture Overview:** [README_6LayerArchitecture.md](README_6LayerArchitecture.md)
- **Layer 2:** [README_Layer2_Decision.md](README_Layer2_Decision.md)
- **Layer 4:** [README_Layer4_Implementation.md](README_Layer4_Implementation.md)
- **Usage Examples:** [README_UsageExamples.md](README_UsageExamples.md)
