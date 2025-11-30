# AI Agent Guide for SixLayer Framework v5.5.0

This document provides guidance for AI assistants working with the SixLayer Framework v5.5.0. **Always read this version-specific guide first** before attempting to help with this framework.

**Note**: This guide is for AI agents helping developers USE the framework, not for AI agents working ON the framework itself.

## 🎯 Quick Start

1. **Identify the current framework version** from the project's Package.swift or release tags
2. **Read this AI_AGENT_v5.5.0.md file** for version-specific guidance
3. **Follow the guidelines** for architecture, patterns, and best practices

## 🆕 What's New in v5.5.0

### Swift 6 Compatibility and Complete Test Infrastructure Overhaul

v5.5.0 is a **major compatibility release** that modernizes the framework for Swift 6 while completely overhauling the testing infrastructure:

#### **🎯 Swift 6 Full Compatibility**
- **Concurrency Model**: Complete adoption of Swift 6's strict concurrency checking
- **Main Actor Compliance**: All UI-related code properly annotated with `@MainActor`
- **Async/Await APIs**: Modern async patterns throughout the framework
- **Data Race Prevention**: All potential race conditions eliminated

#### **🧪 Complete Test Infrastructure Revolution**
- **Test Target Separation**: Clean separation between unit tests (logic) and UI tests (ViewInspector)
- **XcodeGen Integration**: Proper project generation with test target configuration
- **Build System**: Enhanced with code signing and multi-platform support
- **Test Organization**: 1,997 unit tests in 188 suites, UI tests infrastructure ready

#### **🔧 Developer Experience Improvements**
- **Modern APIs**: Updated for iOS 17+ and macOS 15+ compatibility
- **Enhanced Error Messages**: Better compile-time and runtime diagnostics
- **Release Automation**: Optional auto-tagging and multi-remote pushing
- **Documentation**: Comprehensive migration guides and best practices

## 🏗️ Framework Architecture Overview

The SixLayer Framework follows a **layered architecture** where each layer builds upon the previous:

1. **Layer 1 (Semantic)**: Express WHAT you want to achieve, not how
2. **Layer 2 (Decision)**: Intelligent layout analysis and decision making
3. **Layer 3 (Strategy)**: Optimal layout strategy selection
4. **Layer 4 (Implementation)**: Platform-agnostic component implementation
5. **Layer 5 (Optimization)**: Performance optimizations and caching
6. **Layer 6 (Platform)**: Platform-specific enhancements and integrations

## 📋 Core Principles

### **DRY (Don't Repeat Yourself)**
- Extract common patterns into reusable components
- Use the framework's layered architecture to avoid duplication
- Leverage hints files for declarative configuration

### **DTRT (Do The Right Thing)**
- Choose semantically appropriate components
- Let the framework handle implementation details
- Follow platform HIG guidelines automatically

### **TDD (Test-Driven Development)**
- Write tests before implementation
- Use the framework's comprehensive test utilities
- Maintain high test coverage for reliability

## 🔑 Key Components & APIs

### **View Extensions**
```swift
// Automatic accessibility identifiers
Text("Hello")
    .automaticCompliance(named: "greeting")

// Platform-aware components
VStack {
    Text("Content")
    Button("Action") { }
}
.platformPresent()
```

### **Hints System**
```swift
// Declarative configuration
struct MyHints: DataHints {
    static let hints = DataHintsConfig(
        namespace: "MyApp",
        fieldMappings: [
            "name": .text(autocorrect: false),
            "email": .email,
        ]
    )
}
```

### **Test Infrastructure**
```swift
// Unit tests (no ViewInspector)
@testable import SixLayerFramework

@Suite("My Feature")
struct MyFeatureTests {
    @Test func testLogic() {
        // Pure logic testing
    }
}

// UI tests (with ViewInspector)
@testable import SixLayerFramework

@Suite("My UI")
struct MyUITests {
    @Test @MainActor func testView() async {
        // ViewInspector testing
        let view = MyView()
        let inspected = try await view.inspect()
        // Test UI behavior
    }
}
```

## 🚨 Critical Guidelines

### **Swift 6 Compatibility**
- **Always use `@MainActor`** for UI-related code
- **Use async/await** for ViewInspector operations
- **Avoid data races** by proper actor isolation
- **Test concurrency** with the new test infrastructure

### **Test Organization**
- **Unit tests**: Pure logic, no ViewInspector, fast execution
- **UI tests**: ViewInspector-dependent, slower but comprehensive
- **Integration tests**: End-to-end validation
- **Use appropriate test suites** for different testing needs

### **Platform Awareness**
- **iOS 17+ APIs**: Use modern async patterns
- **macOS 15+**: Proper AppKit integration
- **Cross-platform**: Test on both platforms
- **Conditional compilation**: Use proper availability checks

## 🛠️ Common Patterns & Solutions

### **Adding Accessibility**
```swift
struct MyView: View {
    var body: some View {
        VStack {
            Text("Title")
            Button("Action") { }
        }
        .automaticCompliance(named: "myView")
    }
}
```

### **Platform-Specific Behavior**
```swift
struct CrossPlatformView: View {
    var body: some View {
        #if os(iOS)
        iOSSpecificView()
        #elseif os(macOS)
        macOSSpecificView()
        #endif
    }
}
```

### **Testing Patterns**
```swift
@Suite("Component Tests")
struct ComponentTests {
    @Test @MainActor
    func testAccessibilityIdentifiers() async throws {
        let config = AccessibilityIdentifierConfig.shared
        config.enableAutoIDs = true

        let view = MyComponent()
        let inspected = try await view.inspect()

        // Test accessibility behavior
        let button = try await inspected.button()
        let id = try await button.accessibilityIdentifier()
        #expect(id.contains("MyComponent"))
    }
}
```

## ⚠️ Common Pitfalls

### **Concurrency Issues**
- ❌ Calling ViewInspector synchronously (pre-v5.5.0)
- ✅ Using `await view.inspect()` (v5.5.0+)

### **Test Organization**
- ❌ Mixing unit and UI test dependencies
- ✅ Separating test targets cleanly

### **Platform Assumptions**
- ❌ Hardcoding platform-specific behavior
- ✅ Using framework's cross-platform abstractions

## 📚 Documentation Resources

- **Framework README**: `Framework/README.md`
- **API Documentation**: `Framework/docs/`
- **Examples**: `Framework/Examples/`
- **Migration Guide**: `Development/RELEASE_v5.5.0.md`
- **Testing Guide**: Framework test organization patterns

## 🔄 Migration from v5.4.0

### **Swift 6 Adoption**
```swift
// Before (v5.4.0)
try view.inspect()

// After (v5.5.0)
try await view.inspect()
```

### **Test Organization**
```swift
// Before: Mixed test file
@testable import SixLayerFramework
// ViewInspector imported conditionally

// After: Separate test files
// UnitTests.swift - no ViewInspector
// UITests.swift - with ViewInspector
```

### **API Updates**
```swift
// Before: Synchronous APIs
UIApplication.shared.open(url)

// After: Async APIs
await UIApplication.shared.open(url)
```

## 🎯 Best Practices

1. **Use the layered architecture** - Don't bypass framework layers
2. **Leverage hints files** - Declarative configuration over imperative code
3. **Test thoroughly** - Use both unit and UI test patterns
4. **Follow Swift 6 patterns** - Proper concurrency and actor isolation
5. **Keep documentation updated** - Release notes and API docs

## 📞 Support

- **Version Check**: Always verify framework version before assistance
- **Documentation Priority**: Framework docs take precedence over general knowledge
- **Testing Focus**: Emphasize proper test organization and execution
- **Migration Help**: Guide users through version upgrades carefully

---

*AI Agent Guide for SixLayer Framework v5.5.0 - Swift 6 Compatible*
