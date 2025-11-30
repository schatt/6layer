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
    .package(url: "https://github.com/schatt/6layer.git", from: "5.5.0")
]
```

### **For Developers (Contributing):**
- **Framework Code**: `Framework/Sources/`
- **Documentation**: `Framework/docs/`
- **Project Status**: `Development/todo.md`
- **Tests**: `Development/Tests/`

## 📦 Swift Package

The framework is distributed as a Swift Package from the `Framework/` directory. This ensures that only the essential framework code is included when other projects consume it.

## 🆕 Latest Release: v5.5.0

### **Swift 6 Compatibility and Complete Test Infrastructure Overhaul**
🎯 **OCR Hints in Hints Files**: Define OCR hints directly in `.hints` files for intelligent form-filling
🧮 **Calculation Groups in Hints Files**: Declarative calculation groups for automatic field computation
🌍 **Internationalization Support**: Language-specific OCR hints with automatic fallback
📄 **OCR Overlay Sheet Modifier**: Convenient `ocrOverlaySheet()` view modifier for presenting OCR results in a sheet (Issue #22)
📝 **Declarative Configuration**: All OCR and calculation configuration in JSON, no code changes needed
✅ **100% Backward Compatible**: Existing hints files continue to work without modification

### **Previous Release: v5.2.1 - Runtime Capability Detection Refactoring**
🎯 **Complete TDD Implementation**: Framework now follows strict TDD principles throughout development
♿ **Advanced Accessibility Overhaul**: Complete accessibility system with automatic identifier generation
🧪 **Testing Infrastructure Revolution**: Comprehensive testing with 800+ tests and full platform coverage

**Highlights:**
- ✅ **Complete TDD Implementation** - Strict Test-Driven Development throughout
- ✅ **Advanced Accessibility System** - Automatic identifier generation for all components
- ✅ **800+ Comprehensive Tests** - Full platform coverage with behavioral verification
- ✅ **Apple HIG Compliance** - Complete compliance with Human Interface Guidelines
- ✅ **Platform Capability Detection** - Accurate runtime detection for all platforms
- ✅ **Component Architecture** - All components support automatic accessibility
- ✅ **Testing Infrastructure** - Suite organization with Xcode test navigator integration
- ✅ **Cross-Platform Validation** - Enhanced testing across iOS, macOS, visionOS

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

**Version**: v5.5.0 (Swift 6 Compatibility and Complete Test Infrastructure Overhaul)
**Phase**: Minor Release
**Next**: Continue framework development and stability improvements

## 🤝 Contributing

Please read the development documentation in the `Development/` directory before contributing. The framework follows a strict six-layer architecture pattern.

---

**Note**: This repository structure separates framework code from development files, ensuring clean package distribution while maintaining development transparency.
