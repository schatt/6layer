# SixLayer Framework

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

## 📱 Supported Platforms

- **iOS**: 18.0+
- **macOS**: 15.0+
- **Swift**: 6.1+

## 🛠️ Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/6layer.git", from: "1.0.0")
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
    type: .vehicle,
    context: .dashboard
) { vehicle in
    VehicleCardView(vehicle: vehicle)
}
```

### Advanced Example

```swift
// Layer 1: Semantic form presentation
platformPresentFormFields_L1(
    type: .vehicleCreation,
    complexity: .complex,
    layout: .adaptive
) {
    TextField("Make", text: $make)
    TextField("Model", text: $model)
    TextField("Year", text: $year)
}
```

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

## 🔧 Development

### Prerequisites

- Xcode 16.4+
- Swift 6.1+
- iOS 18.0+ / macOS 15.0+

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

- **Issues**: [GitHub Issues](https://github.com/yourusername/6layer/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/6layer/discussions)
- **Documentation**: [Wiki](https://github.com/yourusername/6layer/wiki)

---

**SixLayer Framework** - Intelligent UI abstraction for modern Swift development.
