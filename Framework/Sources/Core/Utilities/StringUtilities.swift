//
//  StringUtilities.swift
//  SixLayerFramework
//
//  General-purpose string sanitization utilities
//

import Foundation

// MARK: - String Sanitization

/// Sanitizes a string to remove dangerous or problematic characters.
///
/// This is a general-purpose sanitization function for any text field or user input.
/// It removes characters that could cause security issues, display problems, or data corruption.
///
/// **Use cases:**
/// - User-provided text in forms
/// - Display names and labels
/// - Content that will be stored or displayed
/// - Any string that needs cleaning of dangerous characters
///
/// **What it does:**
/// - Normalizes Unicode to NFC form (prevents compatibility issues)
/// - Removes all control characters (0x00-0x1F, 0x7F)
/// - Removes zero-width characters (can hide malicious content)
/// - Removes bidirectional override characters (can reverse text display)
/// - Trims leading/trailing whitespace
///
/// **What it does NOT do:**
/// - Remove path separators (use `sanitizePath()` or `sanitizeFilename()` for that)
/// - Validate content (e.g., email format, phone numbers)
/// - Enforce length limits
/// - Detect Unicode confusables (homoglyphs)
/// - Remove path traversal sequences (use `sanitizePath()` for that)
///
/// - Parameter string: The string to sanitize
/// - Returns: Sanitized string with dangerous characters removed
public func sanitizeString(_ string: String) -> String {
    var result = string
    
    // 1. Unicode normalization to NFC
    result = result.precomposedStringWithCanonicalMapping
    
    // 2. Remove control characters (0x00-0x1F, 0x7F), preserving newlines/tabs
    result = removeControlCharacters(result, preserveWhitespace: true)
    
    // 3. Remove zero-width characters
    result = removeZeroWidthCharacters(result)
    
    // 4. Remove bidirectional override characters
    result = removeBidirectionalOverrideCharacters(result)
    
    // 5. Trim leading/trailing whitespace (but preserve internal whitespace)
    result = result.trimmingCharacters(in: .whitespacesAndNewlines)
    
    return result
}

// Note: Sanitization helper functions are defined in StringSanitizationHelpers.swift
// to avoid code duplication with PlatformFileSystemUtilities.swift
