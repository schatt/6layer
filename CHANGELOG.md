# Changelog

All notable changes to SixLayerFramework will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.5.0] - 2025-01-27

### Added
- **CardDisplayHelper Hint System**: Configurable property mapping for meaningful content display
- **Dependency Injection**: `GeometryProvider` protocol for testable `UnifiedWindowDetection`
- **Parameterized Testing**: Cross-platform component testing with `ViewInspector`
- **Intelligent Fallback System**: 4-priority property discovery for generic data types
- **Robust Reflection Heuristics**: Automatic discovery of title, subtitle, icon, and color properties

### Changed
- **Enhanced CardDisplayHelper**: Added `hints` parameter to all extraction methods
- **Refactored Platform Layer 5**: Components now return UI components instead of Views
- **Updated Layer 1 Components**: Fixed method calls to use correct Layer 4 APIs
- **Improved Test Organization**: Separated accessibility tests from functional tests

### Fixed
- **634+ Compilation Errors**: Fixed across test files
- **Generic Placeholder Issue**: Eliminated "⭐ Item" displays in `GenericItemCollectionView`
- **Nil Comparison Warnings**: Fixed for value types
- **Scope and Import Issues**: Resolved across test files
- **Component Instantiation**: Fixed method calls across the framework

### Removed
- **Tests for Non-existent Components**: Following DTRT principle
- **Inappropriate Accessibility Tests**: Removed for non-UI services

### Technical Details
- **Zero Configuration**: Works out of the box for standard data types
- **Backward Compatible**: All existing code continues to work
- **Performance Optimized**: Efficient reflection with smart caching
- **TDD Red-Phase Compliant**: Tests written first for non-existent functionality

### Known Issues
- **Test Suite Status**: 719 passing, 1,886 failing (accessibility identifier generation issues)
- **Fatal Errors**: DataPresentationIntelligenceTests.swift and EyeTrackingTests.swift
- **TDD Red-Phase**: Some accessibility identifier persistence tests failing

---

## [4.3.1] - 2025-10-09

### Fixed
- **Critical Metal Rendering Crash**: Fixed on macOS 14.0+ with Apple Silicon devices
- **Performance Layer Removal**: Eliminated `.drawingGroup()` and `.compositingGroup()` modifiers
- **Framework Simplification**: Removed entire performance layer for better compatibility

### Removed
- **PlatformOptimizationExtensions.swift**: Performance optimization modifiers
- **Performance Testing Assertions**: Related test infrastructure

### Impact
- ✅ Metal crash completely eliminated
- ✅ Framework simplified and more maintainable  
- ✅ Better compatibility across macOS versions
- ✅ No functional changes to UI behavior

---

*For earlier releases, see Development/RELEASES.md*
