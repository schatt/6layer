//
//  PlatformInputExtensions.swift
//  SixLayerFramework
//
//  Cross-platform input extensions for keyboard types and text field styles
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - Cross-Platform Input Extensions

public extension View {
    
    /// Cross-platform keyboard type modifier
    func platformKeyboardType(_ type: PlatformKeyboardType) -> some View {
        #if os(iOS)
        return self.keyboardType(type.uiKeyboardType)
        #elseif os(macOS)
        // macOS doesn't have keyboard types, return self
        return self
        #else
        return self
        #endif
    }
    
    /// Cross-platform text field styling
    func platformTextFieldStyle(_ style: PlatformTextFieldStyle) -> some View {
        #if os(iOS)
        return self.textFieldStyle(style.uiTextFieldStyle)
        #elseif os(macOS)
        // macOS uses different styling, return self for now
        return self
        #else
        return self
        #endif
    }
}

// MARK: - Platform Keyboard Type Extensions

public extension PlatformKeyboardType {
    
    #if os(iOS)
    /// Convert to UIKit keyboard type
    var uiKeyboardType: UIKeyboardType {
        switch self {
        case .default:
            return .default
        case .asciiCapable:
            return .asciiCapable
        case .numbersAndPunctuation:
            return .numbersAndPunctuation
        case .URL:
            return .URL
        case .numberPad:
            return .numberPad
        case .phonePad:
            return .phonePad
        case .namePhonePad:
            return .namePhonePad
        case .emailAddress:
            return .emailAddress
        case .decimalPad:
            return .decimalPad
        case .twitter:
            return .twitter
        case .webSearch:
            return .webSearch
        }
    }
    #endif
}

// MARK: - Platform Text Field Style Extensions

public extension PlatformTextFieldStyle {
    
    #if os(iOS)
    /// Convert to UIKit text field style
    var uiTextFieldStyle: DefaultTextFieldStyle {
        switch self {
        case .defaultStyle:
            return DefaultTextFieldStyle()
        case .roundedBorder:
            return DefaultTextFieldStyle() // Fallback to default for now
        case .plain:
            return DefaultTextFieldStyle() // Fallback to default for now
        case .secure:
            return DefaultTextFieldStyle() // Secure is handled by SecureField
        }
    }
    #endif
}