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

## 🆕 Latest Release: v4.1.2

### **Automatic Accessibility Identifiers Fix for Layers 2-6**
🚨 **Critical Bug Fix**: Fixed automatic accessibility identifiers for Layers 2-6 functions. All SixLayer framework elements now properly generate accessibility identifiers for UI testing and accessibility compliance.

**Highlights:**
- ✅ **Complete Automatic Accessibility Identifiers** - Now works for all Layers 1-6
- ✅ **Comprehensive Test Coverage** - 1,662 tests passing with 0 failures
- ✅ **Mandatory Testing Rules** - Established TDD methodology for future development
- ✅ **Layer 4-6 Functions Fixed** - Photo components, performance extensions, haptic feedback
- ✅ **Backward Compatible** - No migration required
- ✅ **Enhanced Debug Output** - Rich debugging with hierarchy and context
- ✅ **UI Test Helpers** - Generate tap actions, text input actions
- ✅ **Proper TDD Process** - Red-Green-Refactor cycle followed

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
- **[Release Notes v4.1.2](Development/RELEASE_v4.1.2.md)** - Automatic Accessibility Identifiers Fix for Layers 2-6
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
