# SixLayer Framework

[![Version](https://img.shields.io/badge/version-v1.6.6-blue.svg)](https://github.com/schatt/6layer/releases/tag/v1.6.6)
[![Platform](https://img.shields.io/badge/platform-iOS%2016%2B%20%7C%20macOS%2013%2B-lightgrey.svg)](https://github.com/schatt/6layer)
[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)

A modern, intelligent UI framework that provides a six-layer abstraction architecture for cross-platform Swift development. This framework eliminates platform-specific UI code while maintaining native performance and user experience.

## 🏗️ Architecture Overview

The SixLayer Framework implements a sophisticated six-layer UI abstraction that transforms semantic intent into intelligent, platform-optimized layouts:

```
Layer 1: Semantic Intent → Layer 2: Layout Decision → Layer 3: Strategy Selection → Layer 4: Component Implementation → Layer 5: Platform Optimization → Layer 6: Platform System
```

### Layer Breakdown

- **Layer 1 (Semantic)**: Express what you want to achieve, not how
- **Layer 2 (Decision)**: Intelligent layout analysis and decision making
- **Layer 3 (Strategy)**: Optimal layout strategy selection
- **Layer 4 (Implementation)**: Platform-agnostic component implementation
- **Layer 5 (Optimization)**: Platform-specific enhancements and optimizations
- **Layer 6 (System)**: Direct platform system calls and native implementations

## 🚀 Key Features

- **Cross-Platform**: Write once, run on iOS and macOS
- **Intelligent Layout**: AI-driven layout decisions based on content and context
- **Performance Optimized**: Native performance with intelligent caching
- **Accessibility First**: Built-in accessibility enhancements
- **Type Safe**: Full Swift type safety with compile-time validation
- **Extensible**: Easy to extend with custom layers and strategies

## 🆕 What's New in v1.6.6

- **Documentation Reorganization**: All documentation now visible in user's IDE for better discoverability
- **Professional Framework Structure**: Clean, organized framework distribution without development clutter
- **Complete Documentation**: Comprehensive guides, examples, and API references included
- **Performance & Accessibility**: Complete Phase 4 implementation with lazy loading, memory management, and accessibility features
- **Public API Access**: All platform functions have `public` access for external project integration
- **Updated Platform Support**: iOS 16.0+ and macOS 13.0+ with proper availability checks

## 📱 Supported Platforms

- **iOS**: 16.0+
- **macOS**: 13.0+
- **Swift**: 5.9+

## 🛠️ Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/schatt/6layer.git", from: "1.6.6")
]
```

### Manual Installation

1. Clone the repository
2. Add the framework to your Xcode project
3. Link against the appropriate target for your platform

## 💻 Usage

### Basic Example

```swift
import SixLayerFramework

// Layer 1: Semantic intent
platformPresentItemCollection_L1(
    items: vehicles,
    hints: PresentationHints(
        dataType: .collection,
        presentationPreference: .cards,
        complexity: .moderate,
        context: .dashboard
    )
)
```

### Advanced Example

```swift
// Layer 1: Semantic form presentation
platformPresentFormData_L1(
    fields: formFields,
    hints: PresentationHints(
        dataType: .form,
        presentationPreference: .automatic,
        complexity: .complex,
        context: .input
    )
)
```

## 🔧 Extending the Framework

The SixLayer Framework is designed to be highly extensible. Developers can:

- **Create custom views** that integrate seamlessly with the framework
- **Use the hints system** to influence layout decisions and behavior
- **Leverage all six layers** for progressive enhancement
- **Maintain platform independence** while adding custom functionality

For comprehensive guidance on extending the framework, see:
- **[Developer Extension Guide](docs/DeveloperExtensionGuide.md)** - Complete guide for developers
- **[Hints System Extensibility](docs/HintsSystemExtensibility.md)** - Advanced customization
- **[Usage Examples](docs/README_UsageExamples.md)** - Practical examples and patterns

## 🏗️ Project Structure

```
6layer/
├── docs/                           # Documentation
├── src/                           # Source code
│   ├── Shared/                    # Shared components
│   │   ├── Views/                 # View implementations
│   │   │   └── Extensions/        # 6-layer extensions
│   │   ├── Models/                # Data models
│   │   ├── Services/              # Business logic
│   │   ├── Utils/                 # Utility functions
│   │   ├── Components/            # Reusable components
│   │   └── Resources/             # Assets and resources
│   ├── iOS/                       # iOS-specific implementations
│   └── macOS/                     # macOS-specific implementations
├── Tests/                         # Unit tests
├── project.yml                    # XcodeGen configuration
└── README.md                      # This file
```

## 📋 Changelog

### [v1.3.0] - 2025-01-XX
- **Public API Access**: All platform functions now have `public` access for external project integration
- **Updated Platform Support**: iOS 16.0+ and macOS 13.0+ with proper availability checks
- **Improved Build System**: Cleaner project structure and successful compilation
- **Enhanced Compatibility**: Better cross-platform support and reduced platform-specific issues

### [v1.2.0] - 2025-01-XX
- **Validation Engine**: Complete form validation system with custom rules
- **Advanced Form Types**: Complex form layouts and dynamic field generation
- **Enhanced Hints System**: Improved layout decision making and customization

### [v1.1.0] - 2025-01-XX
- **Intelligent Layout Engine**: AI-driven layout decisions and optimization
- **Cross-Platform Components**: Unified UI components for iOS and macOS
- **Performance Optimizations**: Enhanced rendering and memory management

### [v1.0.0] - 2025-01-XX
- **Core Framework Foundation**: Basic six-layer architecture implementation
- **Platform Abstraction**: Initial cross-platform UI abstraction layer
- **Basic Components**: Fundamental UI components and extensions

## 🔧 Development

- Xcode 15.0+
- Swift 5.9+
- iOS 16.0+ / macOS 13.0+

### Building

1. Install XcodeGen: `brew install xcodegen`
2. Generate Xcode project: `xcodegen generate`
3. Open `SixLayerFramework.xcodeproj`
4. Build your target

### Testing

```bash
# Run all tests
xcodebuild test -scheme SixLayerFramework -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test target
xcodebuild test -scheme SixLayerFramework -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:SixLayerFrameworkTests
```

## 📚 Documentation

- [Six-Layer Architecture Overview](docs/six-layer-architecture-current-status.md)
- [Implementation Plan](docs/six-layer-architecture-implementation-plan.md)
- [API Reference](docs/6layerapi.txt)
- [Migration Guide](docs/migration_guide.md)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built on the foundation of the CarManager project
- Inspired by modern UI/UX design principles
- Community contributions and feedback

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/schatt/6layer/issues)
- **Discussions**: [GitHub Discussions](https://github.com/schatt/6layer/discussions)
- **Documentation**: [Wiki](https://github.com/schatt/6layer/wiki)

---

**SixLayer Framework** - Intelligent UI abstraction for modern Swift development.
