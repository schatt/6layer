//
//  StringUtilitiesTests.swift
//  SixLayerFramework
//
//  Tests for general-purpose string sanitization utilities
//

import Testing
import Foundation
@testable import SixLayerFramework

@Suite("String Utilities Tests")
struct StringUtilitiesTests {
    
    // MARK: - sanitizeString Tests
    
    @Test func testSanitizeStringWithNormalText() {
        let result = sanitizeString("Hello, World!")
        #expect(result == "Hello, World!")
    }
    
    @Test func testSanitizeStringWithZeroWidthSpace() {
        let result = sanitizeString("John\u{200B}Doe")
        #expect(result == "JohnDoe")
    }
    
    @Test func testSanitizeStringWithZeroWidthNonJoiner() {
        let result = sanitizeString("text\u{200C}here")
        #expect(result == "texthere")
    }
    
    @Test func testSanitizeStringWithZeroWidthJoiner() {
        let result = sanitizeString("text\u{200D}here")
        #expect(result == "texthere")
    }
    
    @Test func testSanitizeStringWithZeroWidthNoBreakSpace() {
        let result = sanitizeString("text\u{FEFF}here")
        #expect(result == "texthere")
    }
    
    @Test func testSanitizeStringWithControlCharacter() {
        let result = sanitizeString("User\u{0001}Name")
        #expect(result == "UserName")
    }
    
    @Test func testSanitizeStringWithNullByte() {
        let result = sanitizeString("text\u{0000}here")
        #expect(result == "texthere")
    }
    
    @Test func testSanitizeStringWithDeleteCharacter() {
        let result = sanitizeString("text\u{007F}here")
        #expect(result == "texthere")
    }
    
    @Test func testSanitizeStringWithBidirectionalOverrideRightToLeft() {
        let result = sanitizeString("Safe\u{202E}evil")
        #expect(result == "Safeevil")
    }
    
    @Test func testSanitizeStringWithBidirectionalOverrideLeftToRight() {
        let result = sanitizeString("Safe\u{202D}evil")
        #expect(result == "Safeevil")
    }
    
    @Test func testSanitizeStringWithLeadingWhitespace() {
        let result = sanitizeString("  Hello")
        #expect(result == "Hello")
    }
    
    @Test func testSanitizeStringWithTrailingWhitespace() {
        let result = sanitizeString("Hello  ")
        #expect(result == "Hello")
    }
    
    @Test func testSanitizeStringWithLeadingAndTrailingWhitespace() {
        let result = sanitizeString("  Hello World  ")
        #expect(result == "Hello World")
    }
    
    @Test func testSanitizeStringPreservesInternalWhitespace() {
        let result = sanitizeString("Hello   World")
        #expect(result == "Hello   World")
    }
    
    @Test func testSanitizeStringWithNewlines() {
        let result = sanitizeString("\nHello\nWorld\n")
        #expect(result == "Hello\nWorld")
    }
    
    @Test func testSanitizeStringWithTabs() {
        let result = sanitizeString("\tHello\tWorld\t")
        #expect(result == "Hello\tWorld")
    }
    
    @Test func testSanitizeStringWithUnicodeNormalization() {
        // Test that Unicode is normalized to NFC
        // "é" can be represented as U+00E9 (NFC) or U+0065 + U+0301 (NFD)
        let nfdString = "cafe\u{0301}" // NFD form
        let result = sanitizeString(nfdString)
        // Should be normalized to NFC: "café"
        #expect(result == "café")
    }
    
    @Test func testSanitizeStringWithEmptyString() {
        let result = sanitizeString("")
        #expect(result == "")
    }
    
    @Test func testSanitizeStringWithOnlyWhitespace() {
        let result = sanitizeString("   ")
        #expect(result == "")
    }
    
    @Test func testSanitizeStringWithOnlyControlCharacters() {
        let result = sanitizeString("\u{0001}\u{0002}\u{0003}")
        #expect(result == "")
    }
    
    @Test func testSanitizeStringPreservesPathSeparators() {
        // Unlike sanitizePath/sanitizeFilename, this should preserve separators
        let result = sanitizeString("path/to/file")
        #expect(result == "path/to/file")
    }
    
    @Test func testSanitizeStringPreservesColons() {
        // Unlike sanitizeFilename, this should preserve colons
        let result = sanitizeString("file:name")
        #expect(result == "file:name")
    }
    
    @Test func testSanitizeStringPreservesSpecialCharacters() {
        // Should preserve most special characters (unlike filesystem sanitization)
        let result = sanitizeString("file@name#test$value")
        #expect(result == "file@name#test$value")
    }
    
    @Test func testSanitizeStringWithMultipleDangerousCharacters() {
        let result = sanitizeString("  User\u{200B}\u{0001}Name\u{202E}  ")
        #expect(result == "UserName")
    }
    
    @Test func testSanitizeStringWithMixedWhitespaceAndControl() {
        let result = sanitizeString("  \t\nHello\u{0001}World\t\n  ")
        #expect(result == "HelloWorld")
    }
    
    @Test func testSanitizeStringWithEmoji() {
        // Emojis should be preserved
        let result = sanitizeString("Hello 👋 World")
        #expect(result == "Hello 👋 World")
    }
    
    @Test func testSanitizeStringWithUnicodeCharacters() {
        // Various Unicode characters should be preserved
        let result = sanitizeString("Café résumé naïve")
        #expect(result == "Café résumé naïve")
    }
    
    @Test func testSanitizeStringWithNumbersAndSymbols() {
        let result = sanitizeString("Price: $99.99 (50% off)")
        #expect(result == "Price: $99.99 (50% off)")
    }
    
    @Test func testSanitizeStringDoesNotRemovePathTraversal() {
        // Unlike sanitizePath, this should NOT remove path traversal sequences
        let result = sanitizeString("../../etc/passwd")
        #expect(result == "../../etc/passwd")
    }
    
    @Test func testSanitizeStringDoesNotEnforceLength() {
        // Unlike sanitizeFilename, this should NOT enforce length limits
        let longString = String(repeating: "a", count: 1000)
        let result = sanitizeString(longString)
        #expect(result == longString)
    }
}
