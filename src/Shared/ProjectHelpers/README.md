# Project-Specific UI Helper Functions

This directory is for **project-specific UI helper functions** that extend the SixLayer framework for your specific application needs.

## 🎯 Purpose

- **Extend the framework** with your own UI patterns and helpers
- **Keep business logic separate** from the core framework
- **Provide examples** of how to use the 6-layer architecture
- **Enable customization** without modifying core framework code

## 📁 Structure

```
ProjectHelpers/
├── README.md                    # This file
├── ExampleHelpers.swift         # Example helper functions
├── CustomLayouts.swift          # Custom layout strategies
├── BusinessSpecificUI.swift     # Business-specific UI patterns
└── YourProjectHelpers.swift     # Your custom helpers
```

## 🚀 How to Use

1. **Add your helper files** to this directory
2. **Import them** in your project-specific code
3. **Extend the framework** with your own patterns
4. **Keep them separate** from core framework logic

## 💡 Example

```swift
// In YourProjectHelpers.swift
import SwiftUI
import SixLayerShared

public struct ProjectSpecificCard: View {
    public init() {}
    
    public var body: some View {
        // Your custom UI implementation
        // Using the 6-layer framework underneath
    }
}
```

## ⚠️ Important Notes

- **Do NOT modify** core framework files in other directories
- **Keep helpers generic** where possible for reusability
- **Document your helpers** for team members
- **Test thoroughly** to ensure they work with the framework

## 🔗 Integration

These helpers will be automatically included in your project when you add this directory to your project.yml sources, but they won't interfere with the core framework functionality.
