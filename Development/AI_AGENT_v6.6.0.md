# AI Agent Guide for SixLayer Framework v6.6.0

This guide summarizes the version-specific context for v6.6.0. **Always read this file before assisting with the framework at this version.**

> **Scope**: This guide is for AI assistants helping developers use or extend the framework (not for automated tooling).

## 🎯 Quick Start

1. Confirm the project is on **v6.6.0** (see `Package.swift` comment or release tags).
2. **📚 Start with the Sample App**: See `Development/Examples/TaskManagerSampleApp/` for a complete, canonical example of how to structure a real app using SixLayer Framework correctly.
3. Understand that **platform capability detection** now correctly aligns with Apple HIG.
4. Know that **minTouchTarget** is platform-based (44.0 for iOS/watchOS, 0.0 for others) per Apple HIG.
5. Know that **AssistiveTouch availability** is correctly detected based on platform support.
6. Know that **tests use runtime platform detection** instead of compile-time checks for better accuracy.
7. Know that **accessibility feature testing** properly configures test overrides for enabled state checking.
8. Apply TDD, DRY, DTRT, and Epistemology rules in every change.

## 🆕 What's New in v6.6.0

### Platform Capability Detection Alignment with Apple HIG
- **minTouchTarget Platform-Based**: `minTouchTarget` is now purely platform-based (44.0 for iOS/watchOS, 0.0 for others) per Apple Human Interface Guidelines, reflecting the platform's primary interaction method
- **AssistiveTouch Availability**: `supportsAssistiveTouch` correctly checks platform availability (iOS/watchOS = true, others = false) instead of relying on testing defaults
- **Runtime Platform Detection**: Tests now use runtime `RuntimeCapabilityDetection.currentPlatform` instead of compile-time `#if os(...)` checks for better accuracy
- **Accessibility Feature Testing**: VoiceOver and Switch Control detection in tests properly configured with test overrides for enabled state checking
- **Test Suite Name Fix**: Corrected test suite name from "mac O S Window Detection" to "macOS Window Detection"

## 🔄 What's Inherited from v6.5.0

### Swift 6 Compilation Fixes
- **CloudKitService**: Fixed nil coalescing warning for non-optional `serverChangeToken` property
- **Test Infrastructure**: All Swift 6 compilation errors and actor isolation warnings resolved
- **LayerFlowDriver**: Made `@MainActor` to ensure thread-safe access in test scenarios
- **Test Kit Examples**: Fixed actor isolation, type inference, and initialization issues
- **Design System Tests**: Fixed actor isolation issues in design system test suite

### Test Infrastructure Enhancements
- **Async Setup/Teardown**: Test classes now use async `setUp()` and `tearDown()` methods for Swift 6 compatibility
- **Proper Actor Isolation**: All test methods properly isolated to `@MainActor` where needed
- **Type Safety**: Fixed type inference issues in test mocks and examples

## 🔄 What's Inherited from v6.4.0

### Design System Bridge (Issue #118)
- **Design System Bridge**: Framework-level abstraction for mapping external design tokens to SixLayer components
- **DesignSystem Protocol**: Standardized interface for design system implementations
- **DesignTokens Structures**: Structured token types for colors, typography, spacing, and component states
- **Theme Injection**: Environment-based theme injection with automatic component adaptation
- **Built-in Design Systems**: SixLayerDesignSystem (default), HighContrastDesignSystem, and CustomDesignSystem
- **External Token Mapping**: Support for Figma tokens, JSON design systems, and CSS custom properties

### Services Infrastructure (Issues #103, #106, #105)
- **CloudKit Service**: Framework-level abstraction for CloudKit operations with delegate pattern, offline queue management, and comprehensive error handling
- **Notification Service**: Unified notification management with local and remote notification support, permission handling, and deep linking
- **Security & Privacy Service**: Biometric authentication, encryption, and privacy permission management
- **Internationalization Service**: Complete framework localization support with automatic string replacement and language detection

### Platform Extensions
- **Cross-Platform Font Extensions**: Unified font API across iOS and macOS
- **Additional Semantic Colors**: Extended ColorName enum with additional semantic color names
- **Custom Value Views**: Support for custom value views in display fields

## ⚠️ Critical Guidelines

### Platform Capability Detection
- **Always use runtime detection**: Use `RuntimeCapabilityDetection.currentPlatform` instead of `#if os(...)` for platform checks
- **minTouchTarget is platform-based**: Reflects Apple HIG requirements (44.0 for iOS/watchOS, 0.0 for others)
- **Accessibility features check enabled state**: VoiceOver, Switch Control, and AssistiveTouch check if features are enabled, not just available

### Testing Requirements
- **Use runtime platform detection in tests**: Don't use compile-time `#if os(...)` checks in test assertions
- **Configure test overrides properly**: Set test overrides for accessibility features that check enabled state
- **Clear capability overrides**: Use `RuntimeCapabilityDetection.clearAllCapabilityOverrides()` to test true platform defaults

### Apple HIG Compliance
- **Touch target sizes**: Follow Apple HIG minimum touch target sizes (44x44 points on touch-first platforms)
- **Platform primary interaction**: Consider the platform's primary interaction method when making design decisions
- **Accessibility**: Ensure all features work with assistive technologies

## 🔧 Common Patterns

### Runtime Platform Detection
```swift
// ✅ Good - Runtime detection
let platform = RuntimeCapabilityDetection.currentPlatform
switch platform {
case .iOS, .watchOS:
    // Touch-first platform
case .macOS, .tvOS, .visionOS:
    // Non-touch-first platform
}

// ❌ Bad - Compile-time detection
#if os(iOS)
    // Touch-first platform
#endif
```

### Platform Capability Testing
```swift
// ✅ Good - Clear overrides and test defaults
RuntimeCapabilityDetection.clearAllCapabilityOverrides()
let config = getCardExpansionPlatformConfig()
// Test true platform defaults

// ✅ Good - Set overrides for enabled state checking
RuntimeCapabilityDetection.setTestVoiceOver(true)
RuntimeCapabilityDetection.setTestSwitchControl(true)
// Test with features enabled
```

### minTouchTarget Usage
```swift
// ✅ Good - Platform-based value per Apple HIG
let minSize = RuntimeCapabilityDetection.minTouchTarget
// iOS/watchOS: 44.0
// macOS/tvOS/visionOS: 0.0

// ❌ Bad - Don't assume capability-based
let minSize = RuntimeCapabilityDetection.supportsTouch ? 44.0 : 0.0
```

## 📖 Additional Resources

- **[Framework README](../Framework/README.md)** - Complete framework documentation
- **[Project Status](PROJECT_STATUS.md)** - Current development status
- **[Release Notes](RELEASES.md)** - Complete release history
- **[Examples](../Framework/Examples/)** - Code examples and usage patterns

## 🤝 Contributing Guidelines

When helping with this framework:

1. **Use runtime platform detection** - Don't use compile-time `#if os(...)` checks
2. **Follow Apple HIG** - Ensure touch target sizes and platform capabilities align with guidelines
3. **Test with proper overrides** - Configure test overrides for accessibility features that check enabled state
4. **Clear overrides when testing defaults** - Use `clearAllCapabilityOverrides()` to test true platform defaults
5. **Consider accessibility** - All features must work with assistive technologies

---

**Remember**: This framework prioritizes **Apple HIG compliance**, **runtime platform detection**, and **accessibility**. Always consider these principles when making suggestions or implementing features.