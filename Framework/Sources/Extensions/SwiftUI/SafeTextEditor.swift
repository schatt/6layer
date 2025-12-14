//
//  SafeTextEditor.swift
//  SixLayerFramework
//
//  Safe wrapper for TextEditor that prevents Metal telemetry crashes
//  Workaround for Apple bug: Metal telemetry crashes when inspecting TextEditor properties
//

import SwiftUI

/// Safe wrapper for TextEditor that prevents Metal telemetry crashes
/// 
/// **Problem**: Metal telemetry crashes when inspecting TextEditor's internal properties
/// that contain NSNumber values, calling `length` on them expecting strings.
///
/// **Solution**: This wrapper isolates TextEditor from modifiers that trigger Metal telemetry
/// by applying styling modifiers only to a container, not directly to TextEditor.
///
/// **Usage**:
/// ```swift
/// SafeTextEditor(text: $inputText)
///     .frame(minHeight: 120)
///     // Styling applied to container, not TextEditor itself
/// ```
@available(iOS 14.0, macOS 11.0, *)
public struct SafeTextEditor: View {
    @Binding var text: String
    
    public init(text: Binding<String>) {
        self._text = text
    }
    
    public var body: some View {
        // Wrap TextEditor in a container to isolate it from Metal telemetry
        // Apply styling to the container, not directly to TextEditor
        ZStack {
            // Background layer (applied to container, not TextEditor)
            Color.clear
                .contentShape(Rectangle())
            
            // TextEditor without styling modifiers that trigger Metal telemetry
            TextEditor(text: $text)
                // Only apply safe modifiers that don't trigger Metal telemetry
                .scrollContentBackground(.hidden) // Hide default background
        }
    }
}

/// Safe TextEditor with custom styling that doesn't trigger Metal telemetry
@available(iOS 14.0, macOS 11.0, *)
public struct StyledSafeTextEditor: View {
    @Binding var text: String
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let borderColor: Color
    let borderWidth: CGFloat
    let minHeight: CGFloat
    
    public init(
        text: Binding<String>,
        backgroundColor: Color = Color.platformBackground,
        cornerRadius: CGFloat = 8,
        borderColor: Color = Color.secondary.opacity(0.3),
        borderWidth: CGFloat = 1,
        minHeight: CGFloat = 120
    ) {
        self._text = text
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.minHeight = minHeight
    }
    
    public var body: some View {
        // Use ZStack to separate TextEditor from styling
        // This prevents Metal telemetry from inspecting TextEditor properties
        ZStack(alignment: .topLeading) {
            // Background and border applied to container
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
            
            // TextEditor without styling modifiers
            TextEditor(text: $text)
                .scrollContentBackground(.hidden) // Hide default background
                .padding(8)
        }
        .frame(minHeight: minHeight)
    }
}

// MARK: - View Extension

public extension View {
    /// Apply safe styling to TextEditor without triggering Metal telemetry
    /// 
    /// **Important**: Use this instead of applying `.background()`, `.cornerRadius()`, 
    /// `.overlay()`, `.foregroundStyle()`, or `.font()` directly to TextEditor.
    ///
    /// **Example**:
    /// ```swift
    /// TextEditor(text: $text)
    ///     .safeTextEditorStyle(
    ///         backgroundColor: .platformBackground,
    ///         cornerRadius: 8
    ///     )
    /// ```
    @available(iOS 14.0, macOS 11.0, *)
    func safeTextEditorStyle(
        backgroundColor: Color = Color.platformBackground,
        cornerRadius: CGFloat = 8,
        borderColor: Color = Color.secondary.opacity(0.3),
        borderWidth: CGFloat = 1
    ) -> some View {
        // Wrap in container to isolate from Metal telemetry
        ZStack(alignment: .topLeading) {
            // Apply styling to container
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
            
            // Content without styling modifiers
            self
                .scrollContentBackground(.hidden)
                .padding(8)
        }
    }
}





