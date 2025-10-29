//
//  FieldHintsModifiers.swift
//  SixLayerFramework
//
//  ViewModifiers for applying field-level display hints
//

import SwiftUI

// MARK: - Field Hints ViewModifier

/// Modifier that applies field-level display hints to views
public struct FieldHintsModifier: ViewModifier {
    let fieldHints: FieldDisplayHints?
    
    public init(_ fieldHints: FieldDisplayHints?) {
        self.fieldHints = fieldHints
    }
    
    public func body(content: Content) -> some View {
        content
            .frame(width: displayWidth, alignment: .leading)
            .overlay(alignment: .trailing) {
                if showCharacterCounter {
                    CharacterCounterOverlay()
                }
            }
    }
    
    // MARK: - Private Computed Properties
    
    private var displayWidth: CGFloat? {
        guard let fieldHints = fieldHints else { return nil }
        
        // Try to get specific numeric width
        if let width = fieldHints.displayWidthValue() {
            return width
        }
        
        // Use semantic widths
        if fieldHints.isNarrow {
            return 150  // Narrow fields
        } else if fieldHints.isWide {
            return 400  // Wide fields
        }
        
        // Medium or default width
        if fieldHints.displayWidth != nil {
            return 200  // Medium fields
        }
        
        return nil  // No specific width constraint
    }
    
    private var showCharacterCounter: Bool {
        return fieldHints?.showCharacterCounter ?? false
    }
}

// MARK: - Character Counter Overlay

/// Overlay view that displays character count
private struct CharacterCounterOverlay: View {
    @Environment(\.fieldTextContent) var textContent
    
    var body: some View {
        if let text = textContent {
            Text("\(text.count)")
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.trailing, 8)
        }
    }
}

// MARK: - Environment Key for Field Text Content

/// Environment key for accessing current field text content
public struct FieldTextContentKey: EnvironmentKey {
    public static let defaultValue: String? = nil
}

public extension EnvironmentValues {
    var fieldTextContent: String? {
        get { self[FieldTextContentKey.self] }
        set { self[FieldTextContentKey.self] = newValue }
    }
}

// MARK: - View Extensions

public extension View {
    /// Apply field-level display hints to a view
    func applyFieldHints(_ hints: FieldDisplayHints?) -> some View {
        modifier(FieldHintsModifier(hints))
    }
}


