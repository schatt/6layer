# AI Agent Guide for SixLayer Framework v6.5.0

This guide summarizes the version-specific context for v6.5.0. **Always read this file before assisting with the framework at this version.**

> **Scope**: This guide is for AI assistants helping developers use or extend the framework (not for automated tooling).

## 🎯 Quick Start

1. Confirm the project is on **v6.5.0** (see `Package.swift` comment or release tags).
2. **📚 Start with the Sample App**: See `Development/Examples/TaskManagerSampleApp/` for a complete, canonical example of how to structure a real app using SixLayer Framework correctly.
3. Understand that **full Swift 6 compatibility** is now ensured with all compilation errors and actor isolation issues resolved.
4. Know that **test infrastructure** has been improved with proper async setup/teardown and actor isolation.
5. Know that **Design System Bridge** enables mapping external design tokens to SixLayer components.
6. Know that **SixLayerTestKit** provides comprehensive testing utilities for consumers.
7. Know that **CloudKit service** is now available with delegate pattern for CloudKit operations.
8. Know that **Notification service** provides unified notification management across platforms.
9. Know that **Security & Privacy service** handles biometric authentication, encryption, and privacy permissions.
10. Know that **framework localization** is now fully supported with automatic string localization.
11. Know that **cross-platform font extensions** provide unified font API.
12. Know that **additional semantic colors** have been added to ColorName enum.
13. Know that **custom value views** are available for display fields.
14. Apply TDD, DRY, DTRT, and Epistemology rules in every change.

## 🆕 What's New in v6.5.0

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
- **Security & Privacy Service**: Biometric authentication, secure text entry management, privacy indicators, data encryption, and keychain integration

### Framework Localization (Issues #104, #108, #109, #115)
- **Framework Localization Support**: Complete localization infrastructure with automatic string localization and key management
- **String Replacement**: Systematic replacement of hardcoded strings with localization keys
- **Localization Testing**: Comprehensive test suite for localization implementation
- **File Completeness**: All localization files contain all required strings

### SixLayerTestKit (Issue #119)
- **SixLayerTestKit**: Comprehensive testing utilities for framework consumers
- **Service Mocks**: Test doubles for CloudKitService, NotificationService, SecurityService, InternationalizationService, and other services
- **Form Testing Helpers**: Utilities for testing DynamicForm and form interactions
- **Navigation Testing Helpers**: Tools for testing navigation flows and Layer 1 functions
- **Layer Flow Driver**: Deterministic testing utilities for Layer 1→6 flows (now `@MainActor` for thread safety)
- **Test Data Generators**: Utilities for generating realistic test data
- **End-to-End Examples**: Complete test examples showing SixLayerTestKit usage

### Platform Bottom-Bar Toolbar Placement (Issue #125)
- **Cross-Platform Abstraction**: `platformBottomBarPlacement()` function for bottom-aligned toolbar items
- **iOS Support**: Returns `.bottomBar` for full-width bottom toolbar items on iOS
- **macOS Fallback**: Returns `.automatic` on macOS and other platforms

## 🧪 Testing Best Practices

### Writing Tests with Swift 6
- **Use Async Setup/Teardown**: Test classes should use async `setUp()` and `tearDown()` methods
- **Actor Isolation**: Add `@MainActor` to test methods that access main actor-isolated properties
- **Test Kit Usage**: Use `SixLayerTestKit` for comprehensive testing utilities
- **Layer Flow Testing**: Use `LayerFlowDriver` (now `@MainActor`) for deterministic Layer 1→6 flow testing

### Test Infrastructure
- All test infrastructure is now fully Swift 6 compatible
- No compilation warnings or errors in test suite
- Proper actor isolation throughout test codebase

## 🔧 Technical Notes

### Swift 6 Compatibility
- All compilation errors resolved
- All actor isolation warnings resolved
- Full Swift 6 concurrency model compliance
- Test infrastructure uses modern async/await patterns

### Code Quality
- No compiler warnings
- Clean build with Swift 6
- Proper actor isolation throughout framework

## 📚 Key Files to Know

### Core Services
- `Framework/Sources/Core/Services/CloudKitService.swift` - CloudKit abstraction (fixed nil coalescing warning)
- `Framework/Sources/Core/Services/NotificationService.swift` - Notification management
- `Framework/Sources/Core/Services/SecurityService.swift` - Security and privacy

### Test Infrastructure
- `Framework/TestKit/Sources/SixLayerTestKit.swift` - Main test kit entry point
- `Framework/TestKit/Sources/FormHelpers/LayerFlowDriver.swift` - Layer flow testing (now `@MainActor`)
- `Framework/TestKit/Tests/SixLayerTestKitExamples.swift` - Test examples (fixed actor isolation)

### Design System
- `Framework/Sources/Extensions/SwiftUI/VisualDesignSystem.swift` - Design system bridge
- `Development/Tests/SixLayerFrameworkUITests/Extensions/SwiftUI/DesignSystemUITests.swift` - Design system tests (fixed actor isolation)

## 🚨 Important Notes

- **No API Changes**: This is a maintenance release with no public API changes
- **No Migration Required**: All changes are internal improvements
- **Swift 6 Ready**: Framework is fully compatible with Swift 6
- **Test Infrastructure**: All test infrastructure is Swift 6 compatible

## 📖 Documentation

- See `Development/RELEASE_v6.5.0.md` for complete release notes
- See `Framework/README.md` for framework documentation
- See `Development/Examples/TaskManagerSampleApp/` for sample app

## 🎯 Development Guidelines

1. **Always use TDD**: Write tests before implementing features
2. **Follow DRY**: Don't repeat yourself - extract common functionality
3. **Do The Right Thing**: Implement proper solutions, not quick fixes
4. **Epistemology**: Distinguish between verified facts and hypotheses
5. **Swift 6 Compliance**: Ensure all code follows Swift 6 concurrency model
6. **Actor Isolation**: Properly isolate code to appropriate actors
7. **Test Infrastructure**: Use async setup/teardown and proper actor isolation in tests
