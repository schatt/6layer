# SixLayer Framework

[![Version](https://img.shields.io/badge/version-v2.1.0-blue.svg)](https://github.com/schatt/6layer/releases/tag/v2.1.0)
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
- **Layout Reasoning**: Transparent decision-making with detailed reasoning for debugging and analytics
- **Performance Optimized**: Native performance with intelligent caching
- **Accessibility First**: Built-in accessibility enhancements
- **Type Safe**: Full Swift type safety with compile-time validation
- **Extensible**: Easy to extend with custom layers and strategies

## 🆕 What's New in v2.0.0

### **🔍 OCR (Optical Character Recognition) System**
- **Cross-Platform OCR**: Native iOS/macOS OCR using Apple's Vision framework
- **Intelligent Text Recognition**: Smart text type detection (prices, dates, numbers)
- **Multi-Language Support**: Support for multiple languages with automatic detection
- **Document Analysis**: Intelligent document type detection (receipts, invoices, forms)
- **6-Layer OCR Architecture**: Complete OCR implementation following framework architecture

### **♿ Advanced Accessibility System**
- **VoiceOver Support**: Complete VoiceOver integration with announcement management
- **Keyboard Navigation**: Full keyboard navigation with focus management
- **High Contrast Mode**: Automatic high contrast support and theme adaptation
- **Dynamic Type**: Support for all accessibility text sizes
- **Accessibility Testing**: Comprehensive accessibility compliance validation
- **WCAG Compliance**: Web Content Accessibility Guidelines compliance

### **🚀 Framework Enhancements**
- **Unified OCR API**: Single API for all OCR operations across platforms
- **Accessibility Modifiers**: Easy-to-use accessibility enhancement modifiers
- **Performance Optimization**: Optimized OCR and accessibility performance
- **Comprehensive Testing**: OCR and accessibility test suites
- **Enhanced Documentation**: Complete guides for OCR and accessibility features

## 📋 Previous Release (v1.7.4)

- **Cross-Platform Color Utilities**: Comprehensive color system that eliminates platform-specific color code
- **Platform Color Extensions**: 20+ cross-platform color properties with intelligent fallbacks
- **Color Examples**: Complete usage examples for forms, lists, cards, and system colors
- **Comprehensive Testing**: 21 tests covering all color utilities and platform behaviors
- **Accessibility Support**: Colors work correctly with accessibility features and dark mode
- **Performance Optimized**: Fast color creation with consistent behavior across platforms

## 📋 Previous Release (v1.7.3)

- **Layout Decision Reasoning**: Transparent decision-making with detailed reasoning for debugging and analytics
- **Reasoning Examples**: Comprehensive examples showing debugging, analytics, and transparency usage
- **Reasoning Tests**: 11 tests verifying reasoning content and consistency
- **Documentation**: Complete documentation with practical usage examples
- **API Transparency**: Public reasoning properties for better developer experience

## 📋 Previous Release (v1.7.2)

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

- **Licensing System**: Comprehensive tiered licensing model with honor system approach
- **Free Tier**: Personal projects, open source, educational use
- **Startup Tier**: Free for applications with < 1,000 users
- **Professional Tier**: $0.10/user/month for subscription applications
- **Enterprise Tier**: $2,500/year for internal commercial use
- **Honor System**: Trust-based compliance with clear documentation
- **Legal Framework**: Complete license terms and compliance guidelines

## 📱 Supported Platforms

- **iOS**: 16.0+
- **macOS**: 13.0+
- **Swift**: 5.9+

## 🛠️ Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/schatt/6layer.git", from: "1.7.4")
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

### Layout Decision Reasoning

The framework provides transparent decision-making with detailed reasoning for debugging and analytics:

```swift
// Get layout decision with reasoning
let decision = determineOptimalLayout_L2(
    items: items,
    hints: hints,
    screenWidth: 768.0,
    deviceType: .pad
)

// Access reasoning for debugging
print("Layout reasoning: \(decision.reasoning)")
// Output: "Layout optimized for current device and content: uniform approach with 1 columns, 8.0pt spacing, and standard performance"

// Use reasoning for analytics
analytics.track("layout_decision", properties: [
    "approach": decision.approach.rawValue,
    "reasoning": decision.reasoning
])
```

### Cross-Platform Color Utilities

Eliminate platform-specific color code with intelligent cross-platform color utilities:

```swift
// ❌ Before: Platform-specific code
#if os(iOS)
.foregroundColor(.tertiaryLabel)
#elseif os(macOS)
.foregroundColor(.secondary)
#endif

// ✅ After: Cross-platform utilities
.foregroundColor(.platformTertiaryLabel)
```

#### Available Color Utilities

```swift
// Label colors with intelligent fallbacks
Text("Primary Text")
    .foregroundColor(.platformPrimaryLabel)

Text("Secondary Text")
    .foregroundColor(.platformSecondaryLabel)

Text("Tertiary Text")
    .foregroundColor(.platformTertiaryLabel)

Text("Quaternary Text")
    .foregroundColor(.platformQuaternaryLabel)

// Text input colors
TextField("Placeholder", text: $text)
    .foregroundColor(.platformPlaceholderText)

// Separator colors
Divider()
    .background(Color.platformSeparator)

Rectangle()
    .fill(Color.platformOpaqueSeparator)
    .frame(height: 1)

// Background colors
VStack {
    // Content
}
.background(Color.platformBackground)

// System colors (consistent across platforms)
Text("Error")
    .foregroundColor(.platformDestructive)

Text("Success")
    .foregroundColor(.platformSuccess)
```

### Reasoning Examples

The framework includes comprehensive examples showing how to use reasoning properties:

- **Debugging**: Access reasoning to understand why specific layouts were chosen
- **Analytics**: Log reasoning for monitoring and optimization
- **Transparency**: Display reasoning to users for transparency
- **Testing**: Verify reasoning content in automated tests

See `PlatformUIExamples.swift` for complete working examples.

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

### [v1.8.0] - 2025-01-15 (Licensing System & Legal Framework)
- **Licensing System**: Comprehensive tiered licensing model with honor system approach
- **Free Tier**: Personal projects, open source, educational use
- **Startup Tier**: Free for applications with < 1,000 users  
- **Professional Tier**: $0.10/user/month for subscription applications
- **Enterprise Tier**: $2,500/year for internal commercial use
- **Honor System**: Trust-based compliance with clear documentation
- **Legal Framework**: Complete license terms and compliance guidelines
- **Documentation**: Comprehensive licensing guide and implementation details
- **Transparency**: Clear pricing and usage guidelines for all tiers

### [v1.7.4] - 2025-09-04 (Cross-Platform Color Utilities)

#### 🎨 Cross-Platform Color System
- **Platform Color Extensions**: 20+ cross-platform color properties with intelligent fallbacks
- **Eliminates Conditional Compilation**: No more `#if os(iOS)` / `#elseif os(macOS)` for colors
- **Intelligent Fallbacks**: Automatic fallback colors for platform-specific color APIs
- **Consistent API**: Same color names work across iOS and macOS
- **Performance Optimized**: Fast color creation with consistent behavior

#### 🎯 Key Color Utilities
- **Label Colors**: `platformPrimaryLabel`, `platformSecondaryLabel`, `platformTertiaryLabel`, `platformQuaternaryLabel`
- **Text Colors**: `platformPlaceholderText` with platform-appropriate fallbacks
- **Separator Colors**: `platformSeparator`, `platformOpaqueSeparator` with intelligent mapping
- **Background Colors**: `platformBackground`, `platformSecondaryBackground`, `platformGroupedBackground`
- **System Colors**: All standard system colors with cross-platform consistency

#### 📚 Usage Examples & Documentation
- **Comprehensive Examples**: Complete usage examples for forms, lists, cards, and system colors
- **Before/After Comparison**: Clear examples showing the improvement over platform-specific code
- **Color Swatches**: Visual examples of all available colors
- **Form Examples**: Real-world usage in forms and input fields
- **List Examples**: Practical usage in list views and data display
- **Card Examples**: Usage in card-based layouts and content presentation

#### 🧪 Comprehensive Testing
- **21 Test Cases**: Complete test coverage for all color utilities
- **Platform Behavior Tests**: Verification of correct platform-specific behavior
- **Accessibility Tests**: Colors work correctly with accessibility features
- **Dark Mode Tests**: Proper behavior in both light and dark modes
- **Performance Tests**: Fast color creation and consistent behavior
- **Edge Case Tests**: Proper handling of different contexts and usage scenarios

#### 🔧 Technical Improvements
- **Type Safety**: Full Swift type safety for all color utilities
- **Documentation**: Complete inline documentation with usage examples
- **Error Handling**: Graceful error handling for all color operations
- **Backward Compatibility**: Fully backward compatible with existing code
- **Cross-Platform**: Consistent behavior across iOS and macOS platforms

### [v1.7.3] - 2025-09-04 (Layout Decision Reasoning)

#### 🧠 Layout Decision Reasoning
- **Transparent Decision-Making**: Detailed reasoning for all layout decisions
- **Debugging Support**: Access reasoning properties for debugging and troubleshooting
- **Analytics Integration**: Log reasoning for monitoring and optimization
- **User Transparency**: Display reasoning to users for transparency
- **Comprehensive Testing**: 11 tests verifying reasoning content and consistency

#### 📚 Documentation & Examples
- **Usage Examples**: Three comprehensive example views showing practical usage
- **Code Examples**: Complete working examples for debugging, analytics, and transparency
- **API Documentation**: Full documentation of reasoning properties and usage patterns
- **Developer Guide**: Clear guidance on how to use reasoning in applications

#### 🔧 Technical Improvements
- **Public API**: Reasoning properties are now documented as intentional public API features
- **Type Safety**: Full Swift type safety for reasoning properties
- **Performance**: Optimized reasoning generation with minimal overhead
- **Cross-Platform**: Reasoning works consistently across iOS and macOS

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
- **Layout Decision Reasoning**: Transparent decision-making with detailed reasoning for debugging and analytics
- **Reasoning Examples**: Comprehensive examples showing debugging, analytics, and transparency usage
- **Reasoning Tests**: 11 tests verifying reasoning content and consistency
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

The SixLayer Framework uses a **tiered licensing model** based on usage and commercial nature:

- **Free Tier**: Personal projects, open source, educational use
- **Startup Tier**: Free for applications with < 1,000 users
- **Professional Tier**: $0.10/user/month for subscription applications
- **Enterprise Tier**: $2,500/year for internal commercial use
- **Enterprise Plus**: Custom pricing for high-volume applications

**Honor System**: No technical enforcement - we trust developers to comply with license terms.

For detailed licensing information, see:
- **[Complete License Terms](../LICENSE)** - Full license agreement
- **[Licensing Guide](docs/Licensing.md)** - Implementation and usage guide
- **[Contact Licensing](mailto:licensing@sixlayerframework.com)** - Questions and custom pricing

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
