# SixLayer Framework

[![Version](https://img.shields.io/badge/version-v1.7.2-blue.svg)](https://github.com/schatt/6layer/releases/tag/v1.7.2)
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

## 🆕 What's New in v1.7.2

- **Image Functionality**: Complete cross-platform image handling system
- **Photo Components**: Camera interface, photo picker, display, and editing
- **Input Handling & Interactions**: Platform-adaptive input behavior
- **Touch vs Mouse**: Intelligent interaction patterns for different input methods
- **Keyboard Shortcuts**: Platform-appropriate keyboard shortcut management
- **Haptic Feedback**: Smart haptic and sound feedback system
- **Drag & Drop**: Cross-platform drag and drop functionality
- **Gesture Recognition**: Swipe, pinch, and rotate gesture support
- **Comprehensive Testing**: 37 tests for Input Handling & Interactions
- **Photo Test Suite**: Complete test coverage for image functionality

## 📋 Previous Release (v1.7.1)

- **Build Quality Gate**: Comprehensive system for treating warnings as errors
- **Zero Warnings**: Fixed all redundant 'public' modifier warnings across codebase
- **Protocol Compliance**: Fixed all required protocol implementation methods
- **Modern APIs**: Updated deprecated NavigationLink usage to iOS 16+ standards
- **UI Consistency**: Ensured consistent behavior across iOS versions
- **CI/CD Integration**: GitHub Actions workflow for automated quality checks
- **Local Development**: Build quality check script and Makefile integration

## 📱 Supported Platforms

- **iOS**: 16.0+
- **macOS**: 13.0+
- **Swift**: 5.9+

## 🛠️ Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/schatt/6layer.git", from: "1.7.1")
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

### [v1.7.2] - 2025-09-04 (Image Functionality & Input Handling)

#### 🖼️ Image Functionality
- **PlatformImage Type**: Cross-platform image handling with extensions
- **Image Manipulation**: Resizing, cropping, compression, thumbnail generation
- **Photo Components**: Camera interface, photo picker, display, and editing
- **Photo Strategy Selection**: Intelligent photo display strategy selection
- **Photo Layout Decisions**: Smart layout decisions for photo components
- **Photo Semantic Layer**: High-level photo operations and abstractions
- **Comprehensive Testing**: Complete test suite for photo functionality

#### 🎯 Input Handling & Interactions
- **Platform-Adaptive Input**: Intelligent input behavior based on platform
- **Touch vs Mouse**: Smart interaction patterns for different input methods
- **Keyboard Shortcuts**: Platform-appropriate keyboard shortcut management
- **Haptic Feedback**: Smart haptic and sound feedback system
- **Drag & Drop**: Cross-platform drag and drop functionality
- **Gesture Recognition**: Swipe, pinch, and rotate gesture support
- **Interaction Patterns**: Platform-specific interaction behavior
- **Comprehensive Testing**: 37 tests covering all input handling functionality

#### 🔧 Technical Improvements
- **Cross-Platform Compatibility**: All new features work on iOS and macOS
- **Type Safety**: Full Swift type safety with compile-time validation
- **Performance**: Optimized for native performance
- **Accessibility**: Built-in accessibility enhancements
- **Documentation**: Comprehensive documentation and examples

### [v1.7.1] - 2025-01-15 (Build Quality & Framework Enhancement)
- **Build Quality Gate**: Comprehensive system for treating warnings as errors
- **Zero Warnings**: Fixed all redundant 'public' modifier warnings across codebase
- **Protocol Compliance**: Fixed all required protocol implementation methods (UIViewRepresentable, Encodable, etc.)
- **Modern APIs**: Updated deprecated NavigationLink usage to iOS 16+ standards
- **UI Consistency**: Ensured consistent behavior across iOS versions
- **CI/CD Integration**: GitHub Actions workflow for automated quality checks
- **Local Development**: Build quality check script and Makefile integration
- **Result**: Complete build quality system with zero warnings detected

### [v1.6.8] - 2024-12-19 (Ready for Release)
- **Phase 4 Week 13 Completion**: Cross-Platform Optimization Layer 6
- **Cross-Platform Optimization Manager**: Centralized management of platform-specific optimizations
- **Performance Benchmarking**: Comprehensive performance measurement and analysis tools
- **Platform UI Patterns**: Intelligent UI pattern selection based on platform capabilities
- **Memory Management**: Advanced memory strategies and performance optimization levels
- **Cross-Platform Testing**: Utilities for testing views across iOS, macOS, visionOS, and watchOS

### [v1.6.6] - 2024-12-19
- **Documentation Reorganization**: All documentation now visible in user's IDE for better discoverability
- **Professional Framework Structure**: Clean, organized framework distribution without development clutter
- **Complete Documentation**: Comprehensive guides, examples, and API references included
- **Performance & Accessibility**: Complete Phase 4 implementation with lazy loading, memory management, and accessibility features

### [v1.6.5] - 2025-01-15
- **Repository Restructuring**: Separated framework code from development files
- **Framework**: Moved to `Framework/` directory (clean package distribution)
- **Development**: Moved to `Development/` directory (maintains transparency)
- **Result**: Users get clean package view, developers see full structure

### [v1.6.4] - 2025-01-15
- **Package Distribution Cleanup**: Development files no longer included in distributed packages
- **Added**: `.swiftpmignore` to exclude internal development files
- **Result**: Users now get clean, professional framework packages
- **Maintained**: `Stubs/` directory included (contains framework functionality)

### [v1.6.3] - 2025-01-15
- **Phase 4 Completion**: Performance Optimization and Accessibility Features
- **Performance Optimization**: Lazy loading, memory management, performance profiling, caching strategies
- **Accessibility Features**: VoiceOver support, keyboard navigation, high contrast mode, accessibility testing
- **Build System**: Clean compilation for all platforms

### [v1.6.2] - 2025-01-15
- **Phase 3 Completion**: Advanced Form Types and Analytics
- **Advanced Field Types**: Rich text editor, autocomplete, file upload capabilities
- **Form Analytics**: Performance monitoring, error tracking, A/B testing, insights dashboard
- **Platform Compatibility**: iOS 16.0+ and macOS 13.0+ with proper availability checks

### [v1.6.1] - 2025-01-15
- **Phase 2 Completion**: Validation Engine and Form Management
- **Validation Engine**: Complete form validation system with custom rules and validation state management
- **Enhanced Form Types**: Complex form layouts and dynamic field generation
- **Improved Hints System**: Better layout decision making and customization

### [v1.6.0] - 2025-01-15
- **Phase 1 Completion**: Foundation and Core Architecture
- **Intelligent Layout Engine**: AI-driven layout decisions and optimization
- **Cross-Platform Components**: Unified UI components for iOS and macOS
- **Performance Optimizations**: Enhanced rendering and memory management

### [v1.3.0] - 2025-01-15
- **Public API Access**: All platform functions now have `public` access for external project integration
- **Updated Platform Support**: iOS 16.0+ and macOS 13.0+ with proper availability checks
- **Improved Build System**: Cleaner project structure and successful compilation
- **Enhanced Compatibility**: Better cross-platform support and reduced platform-specific issues

### [v1.2.0] - 2025-01-15
- **Validation Engine**: Complete form validation system with custom rules
- **Advanced Form Types**: Complex form layouts and dynamic field generation
- **Enhanced Hints System**: Improved layout decision making and customization

### [v1.1.0] - 2025-01-15
- **Intelligent Layout Engine**: AI-driven layout decisions and optimization
- **Cross-Platform Components**: Unified UI components for iOS and macOS
- **Performance Optimizations**: Enhanced rendering and memory management

### [v1.0.0] - 2025-01-15
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
- [Usage Examples](docs/README_UsageExamples.md)
- [Developer Extension Guide](docs/DeveloperExtensionGuide.md)
- [Function Index](docs/FunctionIndex.md)
- [AI Agent Guide](docs/AI_AGENT_GUIDE.md) - For AI assistants working with the framework

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
