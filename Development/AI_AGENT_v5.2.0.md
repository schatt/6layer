# AI Agent Guide for SixLayer Framework v5.2.0

This document provides guidance for AI assistants working with the SixLayer Framework v5.2.0. **Always read this version-specific guide first** before attempting to help with this framework.

**Note**: This guide is for AI agents helping developers USE the framework, not for AI agents working ON the framework itself.

## 🎯 Quick Start

1. **Identify the current framework version** from the project's Package.swift or release tags
2. **Read this AI_AGENT_v5.2.0.md file** for version-specific guidance
3. **Follow the guidelines** for architecture, patterns, and best practices

## 🆕 What's New in v5.2.0

### Runtime Capability Detection Refactoring

v5.2.0 refactors the runtime capability detection system to use real OS API detection instead of a test platform simulation mechanism.

#### Key Changes

- **Removed testPlatform Mechanism**: The `testPlatform` thread-local variable and `setTestPlatform()` method have been completely removed
- **Real OS API Detection**: All capability detection now queries actual OS APIs (UIAccessibility, NSWorkspace, UserDefaults, etc.)
- **No Hardcoded Values**: All hardcoded `true`/`false` returns replaced with runtime detection functions
- **Simplified Code**: Removed unnecessary `#else` branches and unreachable code paths

#### Breaking Changes

**Removed APIs:**
```swift
// ❌ REMOVED - No longer available
RuntimeCapabilityDetection.setTestPlatform(.iOS)
let platform = RuntimeCapabilityDetection.testPlatform
TestSetupUtilities.shared.simulatePlatform(.macOS)
```

**Migration:**
```swift
// ✅ NEW - Use capability-specific overrides
RuntimeCapabilityDetection.setTestTouchSupport(true)
RuntimeCapabilityDetection.setTestHapticFeedback(true)
RuntimeCapabilityDetection.setTestHover(false)
RuntimeCapabilityDetection.setTestVoiceOver(true)
RuntimeCapabilityDetection.setTestSwitchControl(true)
RuntimeCapabilityDetection.setTestAssistiveTouch(true)

// Or use helper function
setCapabilitiesForPlatform(.iOS)
```

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

## 🔧 Runtime Capability Detection

### How It Works

The framework now uses real OS APIs to detect capabilities:

- **Touch Support**: Queries `UIDevice.current.model` and `NSEvent` APIs
- **Hover Support**: Queries `NSEvent` and `UIHoverGestureRecognizer` availability
- **Haptic Feedback**: Queries `UserDefaults` and platform-specific APIs
- **Accessibility Features**: Queries `UIAccessibility` and `NSWorkspace` APIs
- **Vision/OCR**: Queries `VNDocumentCameraViewController` availability

### Testing with Capability Overrides

When writing tests, use capability-specific overrides:

```swift
// Set specific capability overrides
RuntimeCapabilityDetection.setTestTouchSupport(true)
RuntimeCapabilityDetection.setTestHapticFeedback(true)
RuntimeCapabilityDetection.setTestHover(false)

// Test your code
let config = getCardExpansionPlatformConfig()
#expect(config.supportsTouch == true)

// Clean up
RuntimeCapabilityDetection.clearAllCapabilityOverrides()
```

### Platform-Appropriate Assertions

Tests should verify values appropriate for the current platform:

```swift
let currentPlatform = SixLayerPlatform.current
let expectedMinTouchTarget: CGFloat = (currentPlatform == .iOS || currentPlatform == .watchOS) ? 44.0 : 0.0
let expectedHoverDelay: TimeInterval = (currentPlatform == .macOS) ? 0.5 : 0.0

#expect(config.minTouchTarget == expectedMinTouchTarget, 
       "Current platform \(currentPlatform) should have platform-appropriate minTouchTarget")
```

## 📚 Previous Version Guides

For information about previous versions:
- **[v5.0.0 Guide](AI_AGENT_v5.0.0.md)** - Major Testing and Accessibility Release
- **[v5.1.1 Guide](RELEASE_v5.1.1.md)** - PlatformImage EXIF GPS Location Extraction

## ⚠️ Common Mistakes to Avoid

1. **Don't use removed APIs**: `setTestPlatform()` and `testPlatform` no longer exist
2. **Don't hardcode platform values**: Use `SixLayerPlatform.current` and platform-appropriate assertions
3. **Don't assume capabilities**: Always check runtime detection or use capability overrides in tests
4. **Don't forget cleanup**: Always call `clearAllCapabilityOverrides()` after tests

## 🎯 Best Practices

1. **Use capability overrides** for testing specific capability combinations
2. **Verify platform-appropriate values** based on `SixLayerPlatform.current`
3. **Set accessibility overrides** when testing accessibility features
4. **Clean up overrides** after each test to avoid test pollution

## 📖 Additional Resources

- **[Framework Documentation](../Framework/docs/)**
- **[Release Notes](RELEASE_v5.2.0.md)**
- **[Release History](RELEASES.md)**

