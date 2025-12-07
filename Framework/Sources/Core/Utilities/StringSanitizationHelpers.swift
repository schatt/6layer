//
//  StringSanitizationHelpers.swift
//  SixLayerFramework
//
//  Shared sanitization helper functions and constants
//  Used by both general string sanitization and filesystem sanitization
//

import Foundation

// MARK: - Sanitization Constants

/// Unicode scalars for zero-width characters that should be removed
internal let zeroWidthCharacters: [Unicode.Scalar] = [
    Unicode.Scalar(0x200B)!, // Zero-width space
    Unicode.Scalar(0x200C)!, // Zero-width non-joiner
    Unicode.Scalar(0x200D)!, // Zero-width joiner
    Unicode.Scalar(0xFEFF)! // Zero-width no-break space
]

/// Unicode scalars for bidirectional override characters that should be removed
internal let bidirectionalOverrideCharacters: [Unicode.Scalar] = [
    Unicode.Scalar(0x202E)!, // Right-to-left override
    Unicode.Scalar(0x202D)!  // Left-to-right override
]

// MARK: - Sanitization Helper Functions

/// Removes control characters from a string (0x00-0x1F, 0x7F)
/// - Parameter string: The string to process
/// - Parameter preserveWhitespace: If true, preserves newline (0x0A) and tab (0x09) characters
/// - Returns: String with control characters removed
internal func removeControlCharacters(_ string: String, preserveWhitespace: Bool = false) -> String {
    return string.unicodeScalars.filter { scalar in
        let value = scalar.value
        
        // Preserve newline and tab if requested (for general string sanitization)
        if preserveWhitespace && (value == 0x09 || value == 0x0A) {
            return true
        }
        
        // Remove all control characters (0x00-0x1F, 0x7F)
        return !(value <= 0x1F || value == 0x7F)
    }.reduce("") { $0 + String($1) }
}

/// Removes zero-width characters from a string
/// - Parameter string: The string to process
/// - Returns: String with zero-width characters removed
internal func removeZeroWidthCharacters(_ string: String) -> String {
    return string.unicodeScalars.filter { !zeroWidthCharacters.contains($0) }.reduce("") { $0 + String($1) }
}

/// Removes bidirectional override characters from a string
/// - Parameter string: The string to process
/// - Returns: String with bidirectional override characters removed
internal func removeBidirectionalOverrideCharacters(_ string: String) -> String {
    return string.unicodeScalars.filter { !bidirectionalOverrideCharacters.contains($0) }.reduce("") { $0 + String($1) }
}
