# SixLayer Framework Repository

This repository contains the SixLayer Framework, a comprehensive SwiftUI framework implementing a six-layer architecture for cross-platform development.

## 📁 Repository Structure

```
6layer/
├── Framework/                 ← **This is the Swift Package**
│   ├── Sources/              ← Framework source code
│   ├── Package.swift         ← Package definition
│   ├── README.md             ← Framework documentation
│   └── Stubs/                ← Framework stubs
└── Development/               ← Development files (not in package)
    ├── todo.md                ← Project roadmap
    ├── PROJECT_STATUS.md      ← Current status
    ├── Tests/                 ← Test suite
    ├── docs/                  ← Technical documentation
    └── Examples/              ← Usage examples
```

## 🚀 Getting Started

### **For Users (Consuming the Framework):**
Navigate to the `Framework/` directory and use it as a Swift Package:

```swift
// In your Package.swift
dependencies: [
    .package(url: "https://github.com/schatt/6layer.git", from: "4.1.1")
]
```

### **For Developers (Contributing):**
- **Framework Code**: `Framework/Sources/`
- **Documentation**: `Framework/docs/`
- **Project Status**: `Development/todo.md`
- **Tests**: `Development/Tests/`

## 📦 Swift Package

The framework is distributed as a Swift Package from the `Framework/` directory. This ensures that only the essential framework code is included when other projects consume it.

## 🆕 Latest Release: v4.8.0

### **Field-Level Display Hints System**
🎯 **New Feature**: Declarative `.hints` files that describe how to present data models.

**Highlights:**
- ✅ **Field-Level Hints** - Define display properties for individual fields
- ✅ **DRY Architecture** - Define hints once in `.hints` files, use everywhere
- ✅ **Automatic Discovery** - 6Layer reads hints from `Hints/` folder based on model name
- ✅ **Cached Loading** - Hints loaded once and reused for performance
- ✅ **Organized Storage** - All hints in `Hints/` subfolder
- ✅ **Display Width System** - `narrow`, `medium`, `wide`, or numeric values
- ✅ **Character Counter** - Optional character count overlay
- ✅ **Type-Safe** - Strongly-typed `FieldDisplayHints` structure
- ✅ **Backward Compatible** - Existing code continues to work without changes
- ✅ **Comprehensive Tests** - Complete test coverage for hint system
- ✅ **Documentation** - Complete guides and examples

**See [Field Hints Complete Guide](Framework/docs/FieldHintsCompleteGuide.md) for full documentation**

**Example:**
```swift
platformPresentItemCollection_L1(
    items: products,
    hints: hints,
    customItemView: { product in
        MyCustomProductView(product: product)
    }
)
```

## 🔗 Quick Links

- **[Framework README](Framework/README.md)** - Complete framework documentation
- **[Project Status](Development/PROJECT_STATUS.md)** - Current development status
- **[Roadmap](Development/todo.md)** - Development phases and progress
- **[Documentation](Framework/docs/)** - Technical implementation details
- **[Release Notes v4.1.3](Development/RELEASE_v4.1.3.md)** - Fix Critical Automatic Accessibility Identifier Bug
- **[OCR Overlay Guide](Framework/docs/OCROverlayGuide.md)** - Interactive visual text correction

## 🤖 For AI Assistants

This framework has a specific architecture that requires careful understanding. **Please read the AI Agent Guide first** before attempting to help with this framework:

- **[AI_AGENT Guide](Development/AI_AGENT.md)** - Complete guide with version-specific links
- **[Latest Features](Development/AI_AGENT_v4.1.2.md)** - Automatic Accessibility Identifiers Fix for Layers 2-6
- **[All AI Agent Files](Development/)** - Complete history of version-specific guides

These guides contain critical information about the Layer 1 Semantic Intent philosophy, correct usage patterns, and common mistakes to avoid.

## 📋 Current Status

**Version**: v4.1.2 (Automatic Accessibility Identifiers Fix for Layers 2-6)  
**Phase**: Patch Release (Bug Fix)  
**Next**: Continue framework development and stability improvements

## 🤝 Contributing

Please read the development documentation in the `Development/` directory before contributing. The framework follows a strict six-layer architecture pattern.

---

**Note**: This repository structure separates framework code from development files, ensuring clean package distribution while maintaining development transparency.
