# HIG Compliance TDD Implementation Plan

## Overview

This plan outlines the Test-Driven Development (TDD) approach for implementing HIG compliance features in the `AutomaticComplianceModifier`. All features will follow the RED-GREEN-REFACTOR cycle.

## TDD Principles

1. **RED Phase**: Write failing tests that define the desired behavior
2. **GREEN Phase**: Implement minimal code to make tests pass
3. **REFACTOR Phase**: Improve implementation while keeping tests passing

## Implementation Strategy

**DRY Approach**: We've renamed the shared test functions to reflect they test component compliance (accessibility identifiers + HIG compliance). This means:
- ✅ **No duplication** - One test function for both accessibility identifiers AND HIG compliance
- ✅ **Default enabled** - HIG compliance testing is ON by default (tests both accessibility identifiers and HIG compliance)
- ✅ **Backward compatible** - All 466+ existing test calls continue to work via deprecated aliases
- ✅ **Consistent** - Same test infrastructure used across all components
- ✅ **Opt-out available** - Tests can disable HIG compliance testing with `testHIGCompliance: false` if needed

**Implementation Pattern**:
1. **RED Phase**: Add failing HIG compliance checks to `testHIGComplianceFeatures()` function
2. **GREEN Phase**: Implement HIG compliance features in `AutomaticComplianceModifier`
3. **REFACTOR Phase**: Improve implementation while keeping tests passing

### Phase 1: Core Automatic Features (Priority 1) 🔴 HIGH

These are the most critical HIG compliance features that should be implemented first.

**Total Features**: 7 core features
1. Touch target sizing (iOS/watchOS)
2. Color contrast (WCAG)
3. Typography scaling (Dynamic Type)
4. Focus indicators
5. Motion preferences
6. Tab order
7. Light/dark mode support

#### 1.1 Automatic Touch Target Sizing (iOS)

**RED Phase Test:**
```swift
@Test func testAutomaticComplianceAppliesMinimumTouchTargetOniOS() {
    // Given: A button on iOS
    let button = Button("Test") { }
        .automaticCompliance()
    
    // When: View is created
    // Then: Button should have minimum 44pt touch target
    #if os(iOS)
    // Verify button frame meets 44pt minimum
    #expect(button.frame.height >= 44.0, "iOS buttons should have 44pt minimum touch target")
    #endif
}
```

**GREEN Phase Implementation:**
- Add `.frame(minHeight: 44)` modifier for interactive components on iOS
- Apply only to buttons, links, and other tappable elements
- Skip on macOS (not applicable)

**Test File**: `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/HIGComplianceTouchTargetTests.swift`

**Integration with Shared Test Function**:
```swift
// HIG compliance is tested by default:
let passed = testComponentComplianceSinglePlatform(
    button,
    expectedPattern: "SixLayer.*ui",
    platform: .iOS,
    componentName: "Button"
    // testHIGCompliance defaults to true - tests both accessibility identifiers and HIG compliance
)
```

---

#### 1.2 Automatic Color Contrast (WCAG Compliance)

**RED Phase Test:**
```swift
@Test func testAutomaticComplianceAppliesWCAGColorContrast() {
    // Given: Text with background color
    let view = Text("Test")
        .foregroundColor(.black)
        .background(.white)
        .automaticCompliance()
    
    // When: View is created
    // Then: Color combination should meet WCAG AA contrast ratio (4.5:1 for normal text)
    // Verify contrast ratio calculation
    let contrastRatio = calculateContrastRatio(foreground: .black, background: .white)
    #expect(contrastRatio >= 4.5, "Text should meet WCAG AA contrast ratio")
}
```

**GREEN Phase Implementation:**
- Add color contrast validation
- Automatically adjust colors if contrast is insufficient
- Use system colors that are guaranteed to meet contrast requirements

**Test File**: `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/HIGComplianceColorContrastTests.swift`

---

#### 1.3 Automatic Typography Scaling (Dynamic Type)

**RED Phase Test:**
```swift
@Test func testAutomaticComplianceAppliesDynamicTypeSupport() {
    // Given: Text view
    let view = Text("Test")
        .automaticCompliance()
    
    // When: View is created
    // Then: Text should support Dynamic Type and accessibility sizes
    // Verify .dynamicTypeSize modifier is applied
    #expect(true, "Text should support Dynamic Type scaling")
}
```

**GREEN Phase Implementation:**
- Add `.dynamicTypeSize(...)` modifier with accessibility size range
- Ensure all text automatically scales with system settings
- Enforce minimum font sizes per platform:
  - iOS: Body text minimum 17pt (or use .body which scales)
  - macOS: Body text minimum 13pt
  - tvOS: Body text minimum 24pt (TV viewing distance)
  - watchOS: Body text minimum 16pt
  - visionOS: Body text minimum 18pt
- Use HIG typography styles (.body, .headline, .caption, etc.) that automatically meet platform requirements
- Ensure custom font sizes never go below minimum readable sizes

**Test File**: `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/HIGComplianceTypographyTests.swift`

---

#### 1.4 Automatic Focus Indicators

**RED Phase Test:**
```swift
@Test func testAutomaticComplianceAppliesFocusIndicators() {
    // Given: Focusable button
    let button = Button("Test") { }
        .automaticCompliance()
    
    // When: View is created
    // Then: Button should have visible focus indicator
    // Verify .focusable() and focus ring modifiers are applied
    #expect(true, "Focusable elements should have visible focus indicators")
}
```

**GREEN Phase Implementation:**
- Add `.focusable()` modifier to interactive components
- Apply platform-appropriate focus ring styling
- Ensure focus indicators are visible in high contrast mode

**Test File**: `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/HIGComplianceFocusIndicatorsTests.swift`

---

#### 1.5 Automatic Motion Preferences (Reduced Motion)

**RED Phase Test:**
```swift
@Test func testAutomaticComplianceRespectsReducedMotion() {
    // Given: View with animation
    let view = Text("Test")
        .automaticCompliance()
    
    // When: Reduced motion is enabled
    // Then: Animations should be disabled or simplified
    // Verify .animation() respects accessibility settings
    #expect(true, "Animations should respect reduced motion preference")
}
```

**GREEN Phase Implementation:**
- Check `UIAccessibility.isReduceMotionEnabled` (iOS) or equivalent
- Conditionally apply animations based on accessibility settings
- Use `.animation(nil)` when reduced motion is enabled

**Test File**: `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/HIGComplianceMotionTests.swift`

---

#### 1.6 Automatic Tab Order

**RED Phase Test:**
```swift
@Test func testAutomaticComplianceAppliesCorrectTabOrder() {
    // Given: Multiple focusable elements
    let view = VStack {
        Button("First") { }
        Button("Second") { }
        Button("Third") { }
    }
    .automaticCompliance()
    
    // When: View is created
    // Then: Tab order should follow visual order (top to bottom, left to right)
    // Verify .focusable() order matches visual order
    #expect(true, "Tab order should match visual order")
}
```

**GREEN Phase Implementation:**
- Ensure `.focusable()` is applied in correct order
- Use `.tabIndex()` or equivalent to control tab order
- Follow platform-specific tab order conventions

**Test File**: `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/HIGComplianceTabOrderTests.swift`

---

#### 1.7 Automatic Light/Dark Mode Support

**RED Phase Test:**
```swift
@Test func testAutomaticComplianceRespectsSystemColorScheme() {
    // Given: A view with automatic compliance
    let view = Text("Test")
        .automaticCompliance()
    
    // When: View is created
    // Then: View should respect system color scheme (light/dark mode)
    // Verify system colors are used that adapt automatically
    #expect(true, "View should respect system color scheme")
}
```

**GREEN Phase Implementation:**
- Use system colors (`.primary`, `.secondary`, `.systemBackground`, etc.) that automatically adapt
- Ensure color contrast is maintained in both light and dark modes
- Apply `.preferredColorScheme(nil)` to respect system settings (or detect and apply appropriately)

**Test File**: `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/HIGComplianceLightDarkModeTests.swift`

---

### Phase 2: Visual Design Categories (Priority 2) 🟡 MEDIUM

#### 2.1 Animation Categories

**RED Phase Test:**
```swift
@Test func testAutomaticComplianceAppliesHIGCompliantAnimations() {
    // Given: View with animation
    let view = Text("Test")
        .automaticCompliance()
    
    // When: Animation is triggered
    // Then: Should use HIG-compliant timing (easeInOut, spring)
    // Verify animation timing functions
    #expect(true, "Animations should use HIG-compliant timing")
}
```

**GREEN Phase Implementation:**
- Use `.animation(.easeInOut)` or `.spring()` for default animations
- Avoid non-standard timing functions

**Test File**: `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/HIGComplianceAnimationTests.swift`

---

#### 2.2 Shadow, Corner Radius, Border, Opacity, Blur Categories

**RED Phase Tests:**
- Test that components use HIG-compliant shadow styles
- Test that corner radius follows HIG guidelines (8pt, 12pt, 16pt)
- Test that border widths are appropriate (1pt, 2pt)
- Test that opacity levels follow HIG hierarchy
- Test that blur effects are HIG-compliant

**GREEN Phase Implementation:**
- Apply standard HIG values for shadows, corners, borders, opacity, blur
- Use system-defined constants for consistency

**Test File**: `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/HIGComplianceVisualDesignTests.swift`

---

### Phase 3: Platform-Specific Features (Priority 2) 🟡 MEDIUM

#### 3.0 Cross-Platform Accessibility Features

##### 3.0.1 Zoom Support

**RED Phase Test:**
```swift
@Test func testAutomaticComplianceSupportsSystemZoom() {
    // Given: A view with automatic compliance
    let view = Text("Test")
        .automaticCompliance()
    
    // When: System zoom is enabled
    // Then: View should scale appropriately while maintaining usability
    #expect(true, "View should support system zoom")
}
```

**GREEN Phase Implementation:**
- Ensure components scale properly when system zoom is enabled
- Maintain text readability at all zoom levels
- Preserve layout integrity (no overlapping, proper spacing)
- Use scalable fonts and layouts

**Test File**: `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/HIGComplianceZoomTests.swift`

---

##### 3.0.2 Hover Support

**RED Phase Test:**
```swift
@Test func testAutomaticComplianceSupportsHoverStates() {
    // Given: A button with automatic compliance
    let button = Button("Test") { }
        .automaticCompliance()
    
    // When: View is created on hover-capable platform
    // Then: Button should have appropriate hover state feedback
    #expect(true, "Button should support hover states")
}
```

**GREEN Phase Implementation:**
- Apply hover state visual feedback on hover-capable platforms (macOS, visionOS, iPad)
- Ensure text is readable with macOS Hover Text feature
- Support pointer interactions appropriately

**Test File**: `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/HIGComplianceHoverTests.swift`

---

##### 3.0.3 Caption Support

**RED Phase Test:**
```swift
@Test func testAutomaticComplianceSupportsCaptions() {
    // Given: A video component with automatic compliance
    let video = VideoPlayer(...)
        .automaticCompliance()
    
    // When: View is created
    // Then: Video should support captions
    #expect(true, "Video should support captions")
}
```

**GREEN Phase Implementation:**
- Ensure video/media components support captions
- Position captions appropriately (not overlapping content)
- Ensure captions are accessible (readable, proper contrast)

**Test File**: `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/HIGComplianceCaptionsTests.swift`

---

#### 3.1 iOS-Specific: Haptic Feedback, Gestures, Safe Area

**RED Phase Tests:**
- Test haptic feedback types (light, medium, heavy, success, warning, error)
- Test gesture recognition (tap, long press, swipe, pinch, rotation)
- Test safe area compliance

**GREEN Phase Implementation:**
- Apply appropriate haptic feedback for user actions
- Use standard gesture recognizers
- Apply `.safeAreaInset()` where needed

**Test File**: `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/HIGComplianceIOSFeaturesTests.swift`

---

#### 3.2 macOS-Specific: Window Management, Menu Bar, Keyboard Shortcuts

**RED Phase Tests:**
- Test window management patterns
- Test menu bar integration
- Test keyboard shortcuts (Command+key)

**GREEN Phase Implementation:**
- Apply macOS-appropriate window patterns
- Support menu bar integration
- Apply standard keyboard shortcuts

**Test File**: `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/HIGComplianceMacOSFeaturesTests.swift`

---

### Phase 4: Content Categories (Priority 3) 🟢 LOW

#### 4.1 Forms: Validation States, Error Messages, Field Grouping

**RED Phase Tests:**
- Test input validation state styling
- Test error message positioning
- Test field grouping and relationships

**GREEN Phase Implementation:**
- Apply HIG-compliant validation state styling
- Position error messages according to HIG
- Group related fields visually

**Test File**: `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/HIGComplianceFormTests.swift`

---

#### 4.2 Navigation: Breadcrumbs, Back Buttons, Tab Bars, Sidebars

**RED Phase Tests:**
- Test breadcrumb navigation patterns
- Test back button placement
- Test tab bar compliance
- Test sidebar navigation patterns

**GREEN Phase Implementation:**
- Apply HIG-compliant navigation patterns
- Use platform-appropriate navigation components

**Test File**: `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/HIGComplianceNavigationTests.swift`

---

#### 4.3 Data Visualization: Charts, Graphs, Tables

**RED Phase Tests:**
- Test chart compliance (bar, line, pie, scatter, area)
- Test graph accessibility (color contrast, data labels)
- Test table accessibility (header cells, data relationships)

**GREEN Phase Implementation:**
- Apply HIG-compliant chart styling
- Ensure accessible color schemes
- Add proper table headers and relationships

**Test File**: `Development/Tests/SixLayerFrameworkTests/Features/Accessibility/HIGComplianceDataVisualizationTests.swift`

---

## Implementation Order

### Sprint 1: Core Features (Week 1-2)
1. Touch target sizing (iOS/watchOS)
2. Color contrast (WCAG)
3. Typography scaling (Dynamic Type)
4. Light/dark mode support

### Sprint 2: Accessibility Features (Week 3-4)
4. Focus indicators
5. Motion preferences
6. Tab order

### Sprint 3: Visual Design (Week 5-6)
7. Animation categories
8. Shadow, corner radius, border, opacity, blur

### Sprint 4: Cross-Platform Accessibility (Week 7-8)
9. Zoom support
10. Hover support
11. Caption support

### Sprint 5: Platform-Specific (Week 9-10)
12. iOS-specific features
13. macOS-specific features

### Sprint 6: Content Categories (Week 11-12)
14. Forms
15. Navigation
16. Data visualization

## Test File Structure

```
Development/Tests/SixLayerFrameworkTests/Features/Accessibility/
├── HIGComplianceTouchTargetTests.swift
├── HIGComplianceColorContrastTests.swift
├── HIGComplianceTypographyTests.swift
├── HIGComplianceFocusIndicatorsTests.swift
├── HIGComplianceMotionTests.swift
├── HIGComplianceTabOrderTests.swift
├── HIGComplianceAnimationTests.swift
├── HIGComplianceVisualDesignTests.swift
├── HIGComplianceIOSFeaturesTests.swift
├── HIGComplianceMacOSFeaturesTests.swift
├── HIGComplianceFormTests.swift
├── HIGComplianceNavigationTests.swift
└── HIGComplianceDataVisualizationTests.swift
```

## Implementation Location

All HIG compliance features will be added to:
- `Framework/Sources/Extensions/Accessibility/AutomaticAccessibilityIdentifiers.swift`
- Specifically in the `AutomaticComplianceModifier.body()` method
- Applied alongside accessibility identifier generation

## Test Integration

HIG compliance testing is integrated into the shared test functions (renamed to reflect compliance testing):
- `testComponentComplianceSinglePlatform()` - Single platform testing (HIG compliance ON by default)
- `testComponentComplianceCrossPlatform()` - Cross-platform testing (HIG compliance ON by default)
- `testComponentCompliance()` - Centralized wrapper (HIG compliance ON by default)
- `testCrossPlatformComponentCompliance()` - Cross-platform centralized wrapper (HIG compliance ON by default)

**Deprecated aliases** (backward compatible, but will show deprecation warnings):
- `testAccessibilityIdentifiersSinglePlatform()` → `testComponentComplianceSinglePlatform()`
- `testAccessibilityIdentifiersCrossPlatform()` → `testComponentComplianceCrossPlatform()`
- `testAccessibilityIdentifierGeneration()` → `testComponentCompliance()`
- `testCrossPlatformAccessibilityIdentifierGeneration()` → `testCrossPlatformComponentCompliance()`

**Usage**:
```swift
// New tests (recommended - tests both accessibility identifiers and HIG compliance):
testComponentComplianceSinglePlatform(view, expectedPattern: "...", platform: .iOS, componentName: "Component")
// HIG compliance is tested by default (testHIGCompliance: true)

// Existing tests (backward compatible via deprecated aliases - still work, but will show deprecation warnings):
testAccessibilityIdentifiersSinglePlatform(view, expectedPattern: "...", platform: .iOS, componentName: "Component")
// Also tests HIG compliance by default now

// Opt-out if needed (rare):
testComponentComplianceSinglePlatform(view, expectedPattern: "...", platform: .iOS, componentName: "Component", testHIGCompliance: false)
```

**HIG Compliance Test Function**:
- `testHIGComplianceFeatures()` in `AccessibilityTestUtilities.swift`
- This function will be implemented incrementally as we add each HIG feature
- Each feature will add its checks to this function (RED phase tests first)

## Success Criteria

- ✅ All RED phase tests pass (GREEN phase complete)
- ✅ No breaking changes to existing functionality
- ✅ All existing tests still pass
- ✅ HIG compliance is automatic (no manual configuration required)
- ✅ Works on both iOS and macOS
- ✅ Respects accessibility preferences

## Notes

- Follow the same pattern as accessibility identifier implementation
- Use ViewInspector for testing where possible
- Handle platform differences with conditional compilation
- Ensure backward compatibility with existing code
- Document any limitations or known issues

