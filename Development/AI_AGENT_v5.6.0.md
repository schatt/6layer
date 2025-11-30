# AI Agent Guide for SixLayer Framework v5.6.0

This document provides guidance for AI assistants working with the SixLayer Framework v5.6.0. **Always read this version-specific guide first** before attempting to help with this framework.

**Note**: This guide is for AI agents helping developers USE the framework, not for AI agents working ON the framework itself.

## 🎯 Quick Start

1. **Identify the current framework version** from the project's Package.swift or release tags
2. **Read this AI_AGENT_v5.6.0.md file** for version-specific guidance
3. **Follow the guidelines** for architecture, patterns, and best practices

## 🆕 What's New in v5.6.0

### Enhanced Layer 1 Functions & KeyboardType Extensions

v5.6.0 introduces **enhanced customization capabilities** while maintaining the framework's core principles of semantic intent, accessibility, and cross-platform compatibility.

#### **🎨 Custom View Support for Layer 1 Functions**
- **Enhanced Functions**: Modal forms, photo functions, and DataFrame analysis now support custom view wrappers
- **Framework Benefits Preserved**: Custom views automatically receive accessibility, platform adaptation, and compliance features
- **Backward Compatible**: All custom parameters are optional with sensible defaults
- **Performance Optimized**: No overhead when custom views are not used

#### **⌨️ KeyboardType View Extensions**
- **Cross-Platform Support**: `keyboardType(_ type: KeyboardType)` works on iOS and macOS
- **Complete Enum Coverage**: All 11 KeyboardType cases supported with proper platform mappings
- **Type Safe**: Leverages existing enum instead of string literals
- **Platform Aware**: iOS applies keyboard types, macOS provides no-op behavior

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
- **Always use framework functions** instead of implementing similar functionality
- **Leverage existing patterns** rather than creating new approaches
- **Extend framework functions** using provided customization points

### **DTRT (Do The Right Thing)**
- **Choose semantic Layer 1 functions** over direct Layer 4 implementations
- **Use framework's decision-making** rather than hardcoding platform logic
- **Trust the framework's intelligence** for optimal behavior

### **Epistemology (Distinguish Facts from Hypotheses)**
- **Use verified framework APIs** rather than assuming behavior
- **Check documentation** for platform-specific behavior
- **Test assumptions** when framework behavior is unclear

## 🔑 Key Guidance for v5.6.0

### **Custom View Support**

#### **When to Use Custom Views**
- **Brand Customization**: Apply custom styling while maintaining framework benefits
- **Specialized UI**: Create domain-specific interfaces
- **Enhanced UX**: Add overlays, custom layouts, or branded elements

#### **Custom View Patterns**
```swift
// Modal forms with custom styling
platformPresentModalForm_L1(
    formType: .user,
    context: .modal,
    customFormContainer: { baseForm in
        baseForm
            .padding()
            .background(Color.brandPrimary.opacity(0.1))
            .cornerRadius(12)
    }
)

// Photo capture with custom overlay
platformPhotoCapture_L1(
    purpose: .profile,
    context: .modal,
    onImageCaptured: { image in /* handle */ },
    customCameraView: { baseCamera in
        ZStack {
            baseCamera
            CustomCameraOverlay()
        }
    }
)
```

#### **Framework Benefits with Custom Views**
- ✅ **Accessibility**: Automatic screen reader support
- ✅ **Platform Adaptation**: iOS/macOS specific optimizations
- ✅ **Compliance**: Automatic UI validation and standards
- ✅ **Performance**: Framework optimizations maintained

### **Keyboard Extensions**

#### **Cross-Platform Usage**
```swift
// iOS: Applies appropriate keyboard type
// macOS: No-op (safe to use)
TextField("Email", text: $email)
    .keyboardType(.emailAddress)

TextField("Phone", text: $phone)
    .keyboardType(.phonePad)

TextField("Amount", text: $amount)
    .keyboardType(.decimalPad)
```

#### **Supported Keyboard Types**
- `.default`, `.asciiCapable`, `.numbersAndPunctuation`
- `.URL`, `.numberPad`, `.phonePad`, `.namePhonePad`
- `.emailAddress`, `.decimalPad`, `.twitter`, `.webSearch`

## 📚 Essential Documentation

### **Primary Documentation**
- **[README_Layer1_Semantic.md](Framework/docs/README_Layer1_Semantic.md)**: Complete Layer 1 function reference with custom view examples
- **[platform-specific-patterns.md](Framework/docs/platform-specific-patterns.md)**: Platform-specific extensions including keyboard types
- **[AI_AGENT_GUIDE.md](Development/AI_AGENT.md)**: General framework guidance

### **Key Resources**
- **Custom View Patterns**: See `README_Layer1_Semantic.md` for comprehensive examples
- **Platform Behavior**: Check `platform-specific-patterns.md` for iOS/macOS differences
- **Migration Guide**: Framework maintains backward compatibility - no migration needed

## 🎯 Best Practices for v5.6.0

### **Custom View Implementation**
1. **Start with Framework**: Use framework functions as base, add custom wrappers
2. **Preserve Framework Benefits**: Don't override accessibility or platform adaptations
3. **Test Thoroughly**: Custom views should work across all supported platforms
4. **Follow Patterns**: Use established ViewBuilder patterns for consistency

### **Keyboard Type Usage**
1. **Use Framework Enum**: Always use `KeyboardType.emailAddress`, not `UIKeyboardType.emailAddress`
2. **Cross-Platform Safe**: Extensions work on both iOS and macOS
3. **Type Safe**: Compile-time verification of keyboard type validity

### **Layer 1 Function Selection**
1. **Enhanced Functions Available**: Prefer functions with custom view support when customization needed
2. **Semantic Intent First**: Choose functions based on WHAT you want to achieve
3. **Customization as Enhancement**: Custom views enhance, don't replace, framework intelligence

## ⚠️ Important Considerations

### **Platform Differences**
- **Custom Views**: Work consistently across iOS/macOS (framework handles platform adaptation)
- **Keyboard Types**: iOS applies types, macOS safely ignores (no-op behavior)
- **Performance**: Custom views have no performance impact when not used

### **Migration Notes**
- **Zero Breaking Changes**: All existing code continues to work
- **Additive Enhancement**: New parameters enhance existing functionality
- **Optional Adoption**: Custom view support is opt-in

### **Testing Custom Views**
- **Unit Test Base Functions**: Test that framework functions work with custom parameters
- **UI Test Custom Rendering**: Verify custom styling renders correctly
- **Accessibility Validation**: Ensure custom views don't break accessibility features

## 🔧 Common Patterns

### **Branded Form Containers**
```swift
platformPresentModalForm_L1(
    formType: .user,
    context: .modal,
    customFormContainer: { baseForm in
        baseForm
            .padding(24)
            .background(Color.brandBackground)
            .cornerRadius(16)
            .shadow(color: Color.brandShadow, radius: 8)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.brandBorder, lineWidth: 1)
            )
    }
)
```

### **Enhanced Photo Interfaces**
```swift
platformPhotoCapture_L1(
    purpose: .document,
    context: .sheet,
    onImageCaptured: { image in
        // Handle captured image
    },
    customCameraView: { baseCamera in
        VStack(spacing: 0) {
            // Custom header
            Text("Document Capture")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))

            // Framework camera
            baseCamera

            // Custom instructions
            Text("Position document clearly in frame")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding()
        }
    }
)
```

## 🎯 Framework Philosophy

**"Express WHAT you want, not HOW to implement it"**

- **Layer 1**: Declarative intent with optional customization
- **Framework Intelligence**: Automatic platform adaptation and optimization
- **Customization Points**: Strategic locations for UI enhancement
- **Consistent Experience**: Same patterns across all framework functions

## 📞 Support Guidelines

### **For Custom View Issues**
1. Verify base framework function works without custom wrapper
2. Check that custom ViewBuilder closure compiles correctly
3. Ensure `AnyView` wrapping is used for type compatibility
4. Test on both iOS and macOS platforms

### **For Keyboard Type Issues**
1. Verify `KeyboardType` enum is imported
2. Check that extension is available (should be via framework import)
3. Confirm platform-appropriate behavior (iOS applies, macOS no-op)

### **General Framework Help**
1. Start with Layer 1 semantic functions
2. Use framework's decision-making intelligence
3. Leverage platform-specific extensions for customization
4. Test across all supported platforms

---

**Version**: 5.6.0
**Focus**: Enhanced Layer 1 Functions & KeyboardType Extensions
**Key Features**: Custom view support, cross-platform keyboard types
**Compatibility**: iOS 17+, macOS 15+, full backward compatibility
