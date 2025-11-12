# SixLayer v5.0.0 Release Notes

## Major Testing and Accessibility Release

This major release represents a significant milestone in the SixLayer Framework's evolution, focusing on comprehensive testing maturity and advanced accessibility compliance. The framework now follows strict Test-Driven Development (TDD) principles and provides complete automatic accessibility identifier generation across all components.

## 🎯 TDD (Test-Driven Development) Maturity

### Complete TDD Implementation
- **Strict TDD Principles**: Framework development now follows rigorous TDD methodology throughout all phases
- **Green Phase Completion**: All stub components have been replaced with comprehensive behavioral tests
- **Test Coverage Enhancement**: Added extensive TDD tests covering all framework components
- **Behavior Verification**: Replaced all stub-verification tests with proper behavioral validation

### Testing Infrastructure Revolution
- **Suite Organization**: Added `@Suite` annotations for improved Xcode test navigator integration
- **Platform Test Coverage**: Complete iOS/macOS platform test branch coverage
- **Test Documentation**: Comprehensive testing commands documentation for both macOS and iOS platforms
- **Cross-Platform Testing**: Enhanced platform mocking and capability testing infrastructure

## ♿ Advanced Accessibility System Overhaul

### Automatic Accessibility Identifier Generation
- **Complete System Overhaul**: Comprehensive accessibility identifier generation system
- **Component Integration**: Added `.automaticAccessibilityIdentifiers()` modifier to all framework components
- **Global Configuration**: Unified accessibility settings across all architectural layers
- **Pattern Standardization**: Consistent accessibility identifier patterns across all platforms
- **Label Text Inclusion**: All components with String labels/titles now automatically include label text in accessibility identifiers
- **Label Sanitization**: Automatic sanitization of label text (lowercase, hyphenated, alphanumeric) for identifier compatibility
- **Environment-Based Label Passing**: Components pass label text via `accessibilityIdentifierLabel` environment key for automatic inclusion

### Apple HIG Compliance
- **Human Interface Guidelines**: Full compliance with Apple's accessibility standards
- **Component Name Verification**: Fixed component name verification in accessibility identifiers
- **OCR Overlay Support**: Corrected accessibility identifier generation for OCR components
- **Platform-Specific Behavior**: Proper handling of platform-specific accessibility requirements

### Accessibility-Aware Cross-Platform Color System
- **New Color Properties**: Added `platformButtonTextOnColor` for high-contrast text on colored button backgrounds
- **Platform Shadow Colors**: Added `platformShadowColor` with platform-appropriate opacity values for shadows and elevation
- **Accessibility Adaptation**: Colors automatically adapt to system accessibility settings (high contrast mode, etc.)
- **Cross-Platform Consistency**: Unified color system eliminates platform-specific color code
- **Code Modernization**: Replaced hardcoded `Color.white` and `Color.black` with accessibility-aware platform colors throughout the framework
- **Documentation Updates**: Enhanced color system documentation with new accessibility-aware color properties

## 🔧 Platform Capability Detection Fixes

### Enhanced Detection Systems
- **AssistiveTouch Detection**: Proper runtime detection for iOS AssistiveTouch functionality
- **VisionOS Capabilities**: Accurate touch/hover/haptic capability detection for visionOS
- **Touch Target Optimization**: Platform-native minTouchTarget values (0 for macOS/tvOS/visionOS)
- **Hover Delay Configuration**: Runtime capability detection for hover delay settings

### Platform Image Properties
- **Cross-Platform Compatibility**: Clarified platform-specific PlatformImage behavior
- **UI Image Restrictions**: Documented limitations when testing uiImage properties on macOS
- **Platform-Specific Documentation**: Enhanced documentation for platform-specific image handling

## 🏗️ Component Architecture Improvements

### New Layer 4 Platform Helpers (Issues #11, #12, #13)

#### Popover and Sheet Helpers (Issue #11)
- **`platformPopover_L4()`**: Unified popover presentation helper with platform-agnostic API
  - **iOS (iPad)**: Floating panel with arrow pointing to source element, dismisses on outside tap
  - **iOS (iPhone)**: Automatically converted to full-screen sheet by SwiftUI
  - **macOS**: Floating panel attached to source element (common for tool palettes)
  - Supports attachment anchors, arrow edges, and programmatic control
  - **Use For**: Contextual actions, tool palettes, quick information displays
- **`platformSheet_L4()`**: Unified sheet presentation helper
  - **iOS (iPhone)**: Full-screen modal (default) or half-sheet with detents (iOS 16+)
  - **iOS (iPad)**: Centered modal window (can be resized)
  - **macOS**: Modal window (not full-screen) with minimum size 400x300, user can move/resize
  - Supports drag-to-dismiss, item-based binding, and custom detents (iOS only)
  - **Use For**: Forms, detail views, editing interfaces, multi-step workflows
- **Cross-Platform Mapping**: 
  - Popovers are contextual and temporary (small-medium size)
  - Sheets are modal and focused (medium-large size)
  - iPhone automatically converts popovers to sheets for better UX
- **Location**: `Framework/Sources/Layers/Layer4-Component/PlatformPopoverSheetLayer4.swift`

#### Share and Clipboard Helpers (Issue #12)
- **`platformShare_L4()`**: Unified share sheet presentation
  - **iOS**: Presents `UIActivityViewController` as a modal sheet (full-screen or half-sheet)
  - **macOS**: Presents `NSSharingServicePicker` as a popover menu
  - Supports multiple content types (text, URLs, images, files)
  - Optional completion callbacks and excluded activity types (iOS only)
  - **Use For**: Sharing content with other apps or services
- **`platformCopyToClipboard_L4()`**: Unified clipboard copy operation
  - Supports text, images, and URLs
  - **iOS**: Optional haptic feedback for user confirmation
  - **macOS**: Visual confirmation only (no haptic feedback)
  - Returns success status for error handling
- **`PlatformClipboard`**: Platform-agnostic clipboard operations enum
  - `copyToClipboard()` methods for text, images, and URLs
  - `getTextFromClipboard()` for reading clipboard content
- **Cross-Platform Mapping**:
  - Share: iOS = modal sheet, macOS = popover menu
  - Clipboard: iOS = haptic feedback, macOS = visual only
- **Location**: `Framework/Sources/Layers/Layer4-Component/PlatformShareClipboardLayer4.swift`

#### Row Actions Helpers (Issue #13)
- **`platformRowActions_L4()`**: Unified row action presentation
  - **iOS**: Swipe left/right on row to reveal action buttons (touch-based)
  - **macOS**: Right-click on row to reveal context menu (mouse-based)
  - Supports leading and trailing actions, full-swipe gestures (iOS only)
  - **Use For**: Quick actions like delete, edit, share on list items
- **`platformContextMenu_L4()`**: Unified context menu presentation
  - **iOS**: Long press to reveal menu with optional preview (iOS 16+)
  - **macOS**: Right-click to reveal menu (no preview support)
  - Supports menu sections, dividers, and disabled actions
  - **Use For**: Secondary actions, information, or navigation options
- **Cross-Platform Mapping**:
  - Row Actions: iOS = swipe gesture, macOS = right-click menu
  - Context Menus: iOS = long press with preview, macOS = right-click
- **Helper Components**:
  - `PlatformRowActionButton`: Consistent action button styling
  - `PlatformDestructiveRowActionButton`: Destructive action button with confirmation support
- **Location**: `Framework/Sources/Layers/Layer4-Component/PlatformRowActionsLayer4.swift`

#### Split View Helpers (Issues #14, #15, #16, #17)
- **`platformVerticalSplit_L4()`**: Unified vertical split view presentation
  - **macOS**: Uses `VSplitView` for resizable vertical split panes (user can drag divider)
  - **iOS**: Uses `VStack` for vertical layout (split views not available on iOS)
  - Spacing parameter applied on iOS, ignored on macOS (uses split view divider)
  - **Use For**: Sidebars, detail views, master-detail interfaces
- **`platformHorizontalSplit_L4()`**: Unified horizontal split view presentation
  - **macOS**: Uses `HSplitView` for resizable horizontal split panes (user can drag divider)
  - **iOS**: Uses `HStack` for horizontal layout (split views not available on iOS)
  - Spacing parameter applied on iOS, ignored on macOS (uses split view divider)
  - **Use For**: Multi-column layouts, side-by-side content
- **Cross-Platform Mapping**:
  - Vertical Split: macOS = resizable VSplitView, iOS = VStack with spacing
  - Horizontal Split: macOS = resizable HSplitView, iOS = HStack with spacing
- **TDD Implementation**: 16 comprehensive tests covering all functionality
- **Location**: `Framework/Sources/Layers/Layer4-Component/PlatformSplitViewLayer4.swift`

##### Split View State Management & Visibility Control (Issue #15)
- **`PlatformSplitViewState`**: Observable object for managing pane visibility and state persistence
  - **Pane Visibility Control**: Show/hide individual panes programmatically
  - **State Persistence**: Save/restore pane visibility to `UserDefaults` or `AppStorage`
  - **Visibility Callbacks**: `onVisibilityChange` callback for responding to pane visibility changes
  - **Default Visibility**: Configurable default visibility state for all panes
- **`splitViewPaneVisibility()`**: View modifier for applying visibility control to individual panes
  - Automatically handles opacity and frame adjustments based on visibility state
  - Works cross-platform (iOS and macOS)
- **State Management Methods**:
  - `isPaneVisible(_:)`: Check if a pane is currently visible
  - `setPaneVisible(_:visible:)`: Show or hide a specific pane
  - `togglePane(_:)`: Toggle pane visibility
  - `saveToUserDefaults(key:)`: Persist state to UserDefaults
  - `restoreFromUserDefaults(key:)`: Restore state from UserDefaults
  - `saveToAppStorage(key:)`: Persist state to AppStorage
- **TDD Implementation**: 14 comprehensive tests covering state management and persistence
- **Use Cases**: Collapsible sidebars, hideable detail panes, responsive layouts

##### Split View Sizing & Constraints (Issue #16)
- **`PlatformSplitViewPaneSizing`**: Configuration for individual pane size constraints
  - **Width Constraints**: `minWidth`, `idealWidth`, `maxWidth`
  - **Height Constraints**: `minHeight`, `idealHeight`, `maxHeight`
  - **Resizing Priority**: Control which panes are more flexible during resizing
- **`PlatformSplitViewSizing`**: Overall split view sizing configuration
  - **Per-Pane Sizing**: `firstPane`, `secondPane`, and `panes` array for multiple panes
  - **Container Constraints**: Overall container min/ideal/max width/height
  - **Responsive Sizing**: Flag to enable responsive behavior
- **`splitViewPaneSizing()`**: View modifier for applying size constraints to individual panes
  - Automatically applies frame constraints based on sizing configuration
  - Works cross-platform (iOS and macOS)
- **TDD Implementation**: 12 comprehensive tests covering sizing configuration and constraints
- **Use Cases**: Fixed-width sidebars, flexible detail panes, responsive multi-pane layouts

##### Split View Styles & Appearance (Issue #17)
- **`PlatformSplitViewStyle`**: Enum for defining split view presentation styles
  - `.balanced`: Equal emphasis on all panes
  - `.prominentDetail`: Detail pane is emphasized
  - `.custom`: Platform-appropriate default
- **`PlatformSplitViewDivider`**: Configuration for divider appearance
  - **Color**: Customizable divider color (defaults to `.separator`)
  - **Width**: Divider thickness (defaults to 1.0)
  - **Style**: `.solid`, `.dashed`, `.dotted`, or `.none`
- **`PlatformSplitViewAppearance`**: Configuration for overall split view appearance
  - **Background Color**: Customizable background (uses cross-platform `Color.platformBackground`)
  - **Corner Radius**: Rounded corners for split view container
  - **Shadow**: Customizable shadow configuration (color, radius, offset)
- **`PlatformSplitViewShadow`**: Shadow configuration structure
  - Color, radius, and X/Y offset customization
- **TDD Implementation**: 10 comprehensive tests covering style, divider, and appearance configuration
- **Cross-Platform Colors**: Uses framework's `Color.platformBackground` for consistent theming
- **Use Cases**: Themed split views, custom divider styling, elevated containers

##### Split View Advanced Features (Issue #18)
- **`PlatformSplitViewAnimationConfiguration`**: Animation configuration for split view transitions
  - **Duration**: Configurable animation duration (defaults to 0.3 seconds)
  - **Curve Types**: `.easeInOut`, `.easeIn`, `.easeOut`, `.linear`, `.spring`
  - **Animation Property**: Returns configured SwiftUI `Animation` instance
- **Keyboard Shortcuts (macOS)**: `PlatformSplitViewKeyboardShortcut` for pane management
  - **Actions**: `.togglePane(Int)`, `.showPane(Int)`, `.hidePane(Int)`, `.toggleAll`
  - **Key Configuration**: Uses `KeyEquivalent` with `EventModifiers` (Command, Option, Control, Shift)
  - **Convenience Initializer**: String-based key initialization for easier use
- **Pane Locking**: Methods to prevent pane resizing
  - `isPaneLocked(_:)`: Check if a pane is locked
  - `setPaneLocked(_:locked:)`: Lock or unlock a pane
  - Locked panes cannot be resized by user interaction
- **Divider Callbacks**: `onDividerDrag` callback for divider interaction events
  - Parameters: `(paneIndex, newPosition)`
  - Fires when user interacts with split view divider
- **State Integration**: All advanced features integrated into `PlatformSplitViewState`
  - Animation configuration stored in state
  - Keyboard shortcuts stored in state (macOS only)
  - Pane locking state persisted with visibility state
- **State Persistence Enhancement**: `saveToUserDefaults()` and `restoreFromUserDefaults()` now save/restore both pane visibility AND pane lock state
- **TDD Implementation**: 10 comprehensive tests covering all advanced features
- **Use Cases**: Animated pane transitions, keyboard-driven workflows, locked sidebar panes, divider interaction tracking

##### Split View Platform-Specific Optimizations (Issue #19)
- **`platformSplitViewOptimizations_L5()`**: Cross-platform optimization wrapper
  - Automatically selects iOS or macOS optimizations based on platform
  - Provides unified API for applying platform-appropriate optimizations
- **iOS-Specific Optimizations**: `platformIOSSplitViewOptimizations_L5()`
  - **Memory Optimization**: Uses `drawingGroup()` to reduce layer count for complex views
  - **Touch Responsiveness**: `contentShape(Rectangle())` for improved hit testing
  - **Rendering Optimization**: `compositingGroup()` for efficient mobile rendering
  - **Smooth Animations**: Transaction-based animation configuration (0.25s easeInOut)
  - **Optimized For**: Touch responsiveness, smooth animations, memory efficiency
- **macOS-Specific Optimizations**: `platformMacOSSplitViewOptimizations_L5()`
  - **Large Dataset Handling**: `drawingGroup()` for efficient rendering of large content
  - **Desktop Rendering**: `compositingGroup()` for optimized desktop rendering
  - **Divider Interactions**: Transaction-based animation for smooth divider interactions (0.2s easeInOut)
  - **Optimized For**: Window performance, large dataset handling, desktop-optimized rendering
- **Layer 5 Integration**: Follows SixLayer architecture pattern
  - Layer 4 provides base split view functionality
  - Layer 5 enhances with platform-specific performance optimizations
- **TDD Implementation**: 8 comprehensive tests covering all optimization scenarios
- **Location**: `Framework/Sources/Layers/Layer5-Platform/PlatformSplitViewOptimizationsLayer5.swift`
- **Use Cases**: High-performance split views, large dataset presentations, smooth animations, memory-efficient mobile apps

### Accessibility Integration
- **Card Expansion Components**: Enhanced with automatic accessibility identifier support
- **Form Field Components**: Complete accessibility integration across all form field types
- **Dynamic Form Components**: Full accessibility support for complex form structures
- **Advanced Field Types**: Accessibility support for rich text editors and complex field types

### Component Updates
- **Automatic Identifiers**: All components now support `.automaticAccessibilityIdentifiers()` modifier
- **Platform Modifier Functions**: Added accessibility support to overloaded platform padding functions
- **View Modifier Integration**: Integrated accessibility modifiers with platform modifier functions
- **platformListRow API Refactoring**: New title-based API that automatically extracts label text for accessibility identifiers
  - **New API**: `EmptyView().platformListRow(title: "Item Title") { trailingContent }`
  - **Automatic Label Extraction**: Title parameter is automatically used for accessibility identifier generation
  - **Legacy Support**: Maintains backward-compatible overload for custom content scenarios
  - **Migration Tools**: Provided migration script and test suite for automated API updates

## 🐛 Critical Bug Fixes

### IntelligentFormView Enhancements (Issues #8, #9)
- **Auto-Persistence for Core Data**: `IntelligentFormView` now automatically persists Core Data entities when the Update button is clicked, even when `onSubmit` callback is empty
- **Update Button Fix**: Resolved issue where Update button appeared functional but did nothing when `onSubmit` was empty
- **Automatic Timestamp Updates**: Framework automatically updates `updatedAt`, `modifiedAt`, or `lastModified` fields when present
- **Error Handling**: Graceful error handling for Core Data save failures with proper logging
- **Backward Compatibility**: Existing code continues to work; auto-save happens before custom `onSubmit` callbacks
- **Comprehensive Testing**: Added 5 TDD tests covering all auto-persistence scenarios

### Empty State Verification (Issue #10)
- **Framework Verification**: Verified that `platformPresentItemCollection_L1` correctly preserves hints and displays custom messages
- **Empty State Support**: Confirmed proper handling of `onCreateItem` callbacks in empty collection states
- **Custom Message Display**: Verified custom messages from `customPreferences` are correctly displayed

### Accessibility Fixes
- **Pattern Matching**: Fixed component name verification in accessibility identifiers
- **Namespace Handling**: Improved accessibility identifier namespace management
- **Configuration Logic**: Better separation of accessibility configuration logic
- **Test Helper Behavior**: Fixed automatic accessibility identifier application in test environments

### Compilation and Build Fixes
- **ViewBuilder Structure**: Fixed AdvancedFieldTypes ViewBuilder structure and switch statements
- **Missing Braces**: Resolved compilation errors related to missing closing braces
- **Modifier Logic**: Fixed .exactNamed() modifier logic and application
- **Test Configuration**: Resolved accessibility test compilation errors

## 🤖 **Advanced OCR Form-Filling Intelligence**

### Calculation Groups with Conflict Resolution
- **Shared Field Calculations**: Fields can belong to multiple calculation groups with priority-based conflict resolution
- **Intelligent OCR Processing**: System calculates missing form values from partial OCR data using mathematical relationships
- **Data Quality Assurance**: Conflicting calculations are marked as "very low confidence" to prevent silent data corruption
- **Flexible Relationships**: Support for any mathematical relationships (A = B * C, D = E * F, etc.)

### OCR Field Identification Hints
- **Keyword-Based Mapping**: OCR fields can include keyword arrays to improve recognition accuracy
- **Multiple Variations**: Support for field variations like `["gallons", "gal", "fuel quantity", "liters", "litres"]`
- **Enhanced OCR Precision**: Better mapping of OCR-extracted text to specific form fields
- **Backward Compatible**: Optional feature that doesn't affect existing implementations

## 📚 Documentation and Developer Experience

### New Feature Documentation
- **[Calculation Groups Guide](Framework/docs/CalculationGroupsGuide.md)**: Comprehensive guide for implementing intelligent form calculations
- **[OCR Field Hints Guide](Framework/docs/OCRFieldHintsGuide.md)**: Documentation for improving OCR recognition with keyword hints
- **Advanced OCR Integration**: Examples of complex form-filling scenarios with mathematical relationships

### Testing Documentation
- **Platform Testing Guide**: Complete instructions for testing iOS paths when running on macOS
- **Testing Commands**: Comprehensive documentation for iOS and macOS testing workflows
- **Suite Naming**: Improved test suite structure and organization
- **API Migration Tools**: Migration scripts for platformListRow API updates with comprehensive test coverage

### Code Quality Standards
- **Commit Early and Often**: Added development practice for frequent, small commits
- **Test Organization**: Enhanced test suite structure and organization
- **Namespace Management**: Improved accessibility identifier namespace handling

## 🔄 Internal Architecture Refactoring

### Configuration Management
- **BaseTestClass Enhancement**: Improved BaseTestClass with better test configuration management
- **Accessibility Configuration**: Better separation of accessibility configuration logic
- **Test Infrastructure**: Enhanced test configuration and setup management

### Platform Detection
- **Capability Detection**: More robust platform capability detection and testing
- **Runtime Overrides**: Proper handling of platform capability overrides in tests
- **Test Platform Setup**: Improved test platform setup and mocking capabilities

## 📊 Quality Assurance

### Test Suite Expansion
- **800+ Tests**: Comprehensive test suite with improved coverage and behavioral verification
- **Platform Coverage**: Enhanced testing across iOS, macOS, and visionOS platforms
- **Accessibility Testing**: Verified compliance with WCAG and Apple HIG accessibility standards

### Performance and Compatibility
- **Native Performance**: Maintained native performance levels with accessibility enhancements
- **Cross-Platform Validation**: Enhanced validation across all supported platforms
- **Backward Compatibility**: Maintained compatibility with existing framework usage patterns

## Migration Guide

### For Existing Projects
- **Accessibility Configuration**: Review and update accessibility identifier configurations if using custom settings
- **Test Updates**: Update any tests that may be affected by the new accessibility identifier patterns
- **Platform Detection**: Verify that platform capability detection works as expected in your environment
- **platformListRow Migration**: If using `platformListRow`, migrate to the new title-based API:
  - **Old API**: `.platformListRow { Text("Item Title") }`
  - **New API**: `.platformListRow(title: "Item Title") { }`
  - **Migration Tool**: Use `scripts/migrate_platform_list_row.py` for automated migration
  - **Benefits**: Automatic label text inclusion in accessibility identifiers

### New Features
- **Calculation Groups**: Implement intelligent form calculations with `DynamicFormField.calculationGroups` for OCR-powered form filling
- **OCR Field Hints**: Use `DynamicFormField.ocrHints` arrays to improve OCR recognition accuracy
- **Advanced OCR Integration**: Leverage `DynamicFormState.calculateFieldFromGroups()` for complex form relationships
- **Automatic Accessibility**: Enable `.automaticAccessibilityIdentifiers()` on components for enhanced accessibility
- **Label Text in Identifiers**: All components with String labels automatically include sanitized label text in accessibility identifiers
- **platformListRow Title API**: Use the new title-based API for automatic label extraction: `.platformListRow(title: "Item") { }`
- **Accessibility-Aware Colors**: Use `Color.platformButtonTextOnColor` for button text on colored backgrounds and `Color.platformShadowColor` for shadows/elevation
- **TDD Testing**: Leverage the comprehensive test suite for better development practices
- **Platform Testing**: Use the enhanced platform testing capabilities for cross-platform validation
- **IntelligentFormView Auto-Persistence**: Core Data entities are automatically saved when using `IntelligentFormView.generateForm()` - no need to manually implement `onSubmit` for persistence
- **Layer 4 Platform Helpers**: Use new platform-agnostic helpers to eliminate `#if` blocks:
  - **Popovers/Sheets**: `.platformPopover_L4()` and `.platformSheet_L4()` for unified presentation
  - **Sharing**: `.platformShare_L4()` and `platformCopyToClipboard_L4()` for cross-platform sharing
  - **Row Actions**: `.platformRowActions_L4()` and `.platformContextMenu_L4()` for consistent action presentation

## Breaking Changes
- **Accessibility Identifier Patterns**: Some accessibility identifier patterns have been standardized - verify custom patterns if used
- **Test Behavior**: Tests now use framework components exclusively, which may affect custom test setups
- **Configuration Defaults**: Accessibility configuration defaults have been updated for better compliance

## Acknowledgments
This release represents months of focused effort on testing maturity and accessibility excellence. Special thanks to the development team for their dedication to quality and the broader community for their feedback and support.
