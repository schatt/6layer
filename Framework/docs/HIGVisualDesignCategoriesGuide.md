# HIG-Compliant Visual Design Categories Guide

## Overview

The SixLayer Framework provides a comprehensive visual design category system that ensures all UI components follow Apple's Human Interface Guidelines (HIG) for visual design. This system provides platform-appropriate defaults for animations, shadows, corner radius, border width, opacity, and blur effects.

## Key Features

- **Platform-Appropriate Defaults**: Each category provides values optimized for iOS, macOS, and other platforms
- **HIG-Compliant**: All values follow Apple's Human Interface Guidelines
- **Easy to Use**: Simple view modifiers for applying visual design categories
- **Customizable**: Support for custom values when needed
- **Integrated**: Automatically available through `PlatformDesignSystem`

## Visual Design Categories

### 1. Animation Categories

Animation categories provide HIG-compliant animation options with platform-appropriate defaults.

#### Available Categories

- **`.easeInOut`**: Smooth ease-in-out animation (default for macOS)
- **`.spring`**: Natural spring animation (default for iOS)
- **`.custom(TimingFunction)`**: Custom timing function with control points

#### Usage

```swift
// Apply easeInOut animation
Text("Animated Text")
    .higAnimationCategory(.easeInOut)

// Apply spring animation (iOS default)
Text("Animated Text")
    .higAnimationCategory(.spring)

// Apply custom timing function
Text("Animated Text")
    .higAnimationCategory(.custom(.easeIn))
```

#### Platform Defaults

- **iOS**: Spring animations (response: 0.3, damping: 0.7)
- **macOS**: EaseInOut animations (duration: 0.25)
- **Other Platforms**: EaseInOut animations (duration: 0.25)

### 2. Shadow Categories

Shadow categories provide HIG-compliant shadow styles with platform-specific rendering.

#### Available Categories

- **`.elevated`**: Subtle shadow for elevated elements
- **`.floating`**: More pronounced shadow for floating elements
- **`.custom(radius:offset:color:)`**: Custom shadow with specific parameters

#### Usage

```swift
// Apply elevated shadow
Card()
    .higShadowCategory(.elevated)

// Apply floating shadow
FloatingButton()
    .higShadowCategory(.floating)

// Apply custom shadow
CustomView()
    .higShadowCategory(.custom(
        radius: 8,
        offset: CGSize(width: 0, height: 4),
        color: .black.opacity(0.15)
    ))
```

#### Platform Defaults

**Elevated Shadow:**
- **iOS**: radius: 4, offset: (0, 2), opacity: 0.1
- **macOS**: radius: 2, offset: (0, 1), opacity: 0.08

**Floating Shadow:**
- **iOS**: radius: 8, offset: (0, 4), opacity: 0.15
- **macOS**: radius: 6, offset: (0, 3), opacity: 0.12

### 3. Corner Radius Categories

Corner radius categories provide HIG-compliant radius values following platform conventions.

#### Available Categories

- **`.small`**: Small corner radius (8pt iOS, 4pt macOS)
- **`.medium`**: Medium corner radius (12pt iOS, 8pt macOS)
- **`.large`**: Large corner radius (16pt iOS, 12pt macOS)
- **`.custom(CGFloat)`**: Custom radius value

#### Usage

```swift
// Apply medium corner radius
RoundedCard()
    .higCornerRadiusCategory(.medium)

// Apply custom corner radius
CustomCard()
    .higCornerRadiusCategory(.custom(20))
```

#### Platform Defaults

- **Small**: iOS 8pt, macOS 4pt
- **Medium**: iOS 12pt, macOS 8pt
- **Large**: iOS 16pt, macOS 12pt

### 4. Border Width Categories

Border width categories provide HIG-compliant border widths for platform-appropriate styling.

#### Available Categories

- **`.thin`**: Thin border (0.5pt)
- **`.medium`**: Medium border (0.5pt iOS, 1.0pt macOS)
- **`.thick`**: Thick border (1.0pt iOS, 2.0pt macOS)

#### Usage

```swift
// Apply thin border
BorderedView()
    .higBorderWidthCategory(.thin, color: .separator)

// Apply medium border with custom color
BorderedView()
    .higBorderWidthCategory(.medium, color: .blue)
```

#### Platform Defaults

- **Thin**: 0.5pt (all platforms)
- **Medium**: 0.5pt iOS, 1.0pt macOS
- **Thick**: 1.0pt iOS, 2.0pt macOS

### 5. Opacity Categories

Opacity categories provide HIG-compliant opacity levels for visual hierarchy.

#### Available Categories

- **`.primary`**: Full opacity (1.0) for primary content
- **`.secondary`**: Medium opacity (0.7) for secondary content
- **`.tertiary`**: Low opacity (0.4) for tertiary content
- **`.custom(Double)`**: Custom opacity value (0.0-1.0)

#### Usage

```swift
// Apply primary opacity
PrimaryText()
    .higOpacityCategory(.primary)

// Apply secondary opacity
SecondaryText()
    .higOpacityCategory(.secondary)

// Apply custom opacity
CustomText()
    .higOpacityCategory(.custom(0.75))
```

#### Opacity Values

- **Primary**: 1.0 (fully opaque)
- **Secondary**: 0.7 (70% opacity)
- **Tertiary**: 0.4 (40% opacity)

### 6. Blur Categories

Blur categories provide HIG-compliant blur effects with platform-specific implementations.

#### Available Categories

- **`.light`**: Light blur effect (5pt iOS, 4pt macOS)
- **`.medium`**: Medium blur effect (10pt iOS, 8pt macOS)
- **`.heavy`**: Heavy blur effect (20pt iOS, 16pt macOS)
- **`.custom(radius:)`**: Custom blur radius

#### Usage

```swift
// Apply light blur
BlurredBackground()
    .higBlurCategory(.light)

// Apply medium blur
BlurredOverlay()
    .higBlurCategory(.medium)

// Apply custom blur
CustomBlurredView()
    .higBlurCategory(.custom(radius: 15))
```

#### Platform Defaults

- **Light**: iOS 5pt, macOS 4pt
- **Medium**: iOS 10pt, macOS 8pt
- **Heavy**: iOS 20pt, macOS 16pt

## Integration with PlatformDesignSystem

The visual design system is automatically integrated into `PlatformDesignSystem`:

```swift
let designSystem = PlatformDesignSystem(for: .iOS)
let visualDesign = designSystem.visualDesignSystem

// Access individual systems
let animationSystem = visualDesign.animationSystem
let shadowSystem = visualDesign.shadowSystem
let cornerRadiusSystem = visualDesign.cornerRadiusSystem
// ... etc
```

## Using with VisualConsistencyModifier

The `VisualConsistencyModifier` automatically includes the visual design system, making it available for use:

```swift
Text("Content")
    .visualConsistency()
    // Visual design system is now available
    .higShadowCategory(.elevated)
    .higCornerRadiusCategory(.medium)
```

## Complete Examples

### Basic Card Example

```swift
struct CardView: View {
    var body: some View {
        VStack {
            Text("Card Title")
                .font(.headline)
            Text("Card Content")
                .font(.body)
        }
        .padding()
        .higShadowCategory(.elevated)
        .higCornerRadiusCategory(.medium)
        .higBorderWidthCategory(.thin, color: .separator)
        .background(Color.systemBackground)
    }
}
```

### Animated View with State Changes

```swift
struct AnimatedCardView: View {
    @State private var isExpanded = false
    
    var body: some View {
        VStack {
            Text("Tap to expand")
                .font(.headline)
            
            if isExpanded {
                Text("Expanded content")
                    .font(.body)
                    .higOpacityCategory(.secondary)
            }
        }
        .padding()
        .higCornerRadiusCategory(.medium)
        .higShadowCategory(isExpanded ? .floating : .elevated)
        .higAnimationCategory(.spring) // iOS default
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
}
```

### Blurred Overlay Example

```swift
struct BlurredOverlayView: View {
    var body: some View {
        ZStack {
            // Background content
            Image("background")
                .resizable()
                .scaledToFill()
            
            // Blurred overlay
            Color.black
                .higOpacityCategory(.tertiary)
                .higBlurCategory(.medium)
            
            // Foreground content
            VStack {
                Text("Content on Blur")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}
```

### Complete Form Card with All Categories

```swift
struct FormCardView: View {
    @State private var isFocused = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Form Title")
                .font(.headline)
                .higOpacityCategory(.primary)
            
            TextField("Enter text", text: .constant(""))
                .padding()
                .higCornerRadiusCategory(.small)
                .higBorderWidthCategory(
                    isFocused ? .medium : .thin,
                    color: isFocused ? .blue : .separator
                )
                .higShadowCategory(isFocused ? .floating : .elevated)
                .onTapGesture {
                    withAnimation {
                        isFocused = true
                    }
                }
            
            Button("Submit") {
                // Action
            }
            .padding()
            .higCornerRadiusCategory(.medium)
            .higShadowCategory(.elevated)
        }
        .padding()
        .higCornerRadiusCategory(.large)
        .higShadowCategory(.elevated)
        .background(Color.systemBackground)
        .higAnimationCategory(.spring)
    }
}
```

### Configuration-Based Automatic Application

```swift
struct AppView: View {
    @StateObject private var complianceManager = AppleHIGComplianceManager()
    
    var body: some View {
        VStack {
            Text("Automatically Styled Content")
                .visualConsistency()
        }
        .onAppear {
            // Configure automatic visual design category application
            complianceManager.visualDesignConfig.applyShadows = true
            complianceManager.visualDesignConfig.applyCornerRadius = true
            complianceManager.visualDesignConfig.defaultShadowCategory = .elevated
            complianceManager.visualDesignConfig.defaultCornerRadiusCategory = .medium
        }
    }
}
```

### Platform-Specific Example

```swift
struct PlatformAwareCardView: View {
    var body: some View {
        VStack {
            Text("Platform-Aware Card")
                .font(.headline)
        }
        .padding()
        // Automatically uses platform-appropriate defaults
        .higShadowCategory(.elevated) // iOS: larger radius, macOS: smaller radius
        .higCornerRadiusCategory(.medium) // iOS: 12pt, macOS: 8pt
        .higAnimationCategory(.spring) // iOS default, but can override
        .background(Color.systemBackground)
    }
}
```

## Best Practices

1. **Use Categories Over Custom Values**: Prefer using predefined categories (`.medium`, `.elevated`, etc.) over custom values to ensure HIG compliance
2. **Platform-Aware**: The system automatically provides platform-appropriate defaults, so you don't need platform-specific code
3. **Consistent Styling**: Use the same categories across similar UI elements for visual consistency
4. **Accessibility**: Visual design categories respect accessibility settings (e.g., reduced motion, high contrast)

## Related Documentation

- [Apple HIG Compliance Guide](README.md#apple-hig-compliance-by-default)
- [Platform Design System](README.md#platform-specific-patterns)
- [Visual Consistency Modifier](README.md#visual-design-consistency)

## API Reference

### View Modifiers

- `higAnimationCategory(_:for:)` - Apply animation category
- `higShadowCategory(_:for:)` - Apply shadow category
- `higCornerRadiusCategory(_:for:)` - Apply corner radius category
- `higBorderWidthCategory(_:color:for:)` - Apply border width category
- `higOpacityCategory(_:for:)` - Apply opacity category
- `higBlurCategory(_:for:)` - Apply blur category

### Systems

- `HIGVisualDesignSystem` - Main visual design system
- `HIGAnimationSystem` - Animation category system
- `HIGShadowSystem` - Shadow category system
- `HIGCornerRadiusSystem` - Corner radius category system
- `HIGBorderWidthSystem` - Border width category system
- `HIGOpacitySystem` - Opacity category system
- `HIGBlurSystem` - Blur category system

---

**Version**: 5.9.0  
**Issue**: #37  
**Status**: ✅ Implemented

