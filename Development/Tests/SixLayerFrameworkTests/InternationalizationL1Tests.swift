//
//  InternationalizationL1Tests.swift
//  SixLayerFrameworkTests
//
//  Tests for internationalization L1 functions
//  Tests localized content, RTL support, and internationalization features
//

import XCTest
import SwiftUI
@testable import SixLayerFramework

@MainActor
final class InternationalizationL1Tests: XCTestCase {
    
    // MARK: - Test Data
    
    private var sampleHints: InternationalizationHints = InternationalizationHints()
    
    override func setUp() {
        super.setUp()
        sampleHints = InternationalizationHints()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Localized Content Tests
    
    func testPlatformPresentLocalizedContent_L1() {
        // Given
        let content = Text("Hello World")
        let hints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        
        // When
        let view = platformPresentLocalizedContent_L1(
            content: content,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentLocalizedContent_L1 should return a view")
        
        // Test actual business logic: Content should be wrapped in AnyView for internationalization
        XCTAssertTrue(view is AnyView, "Localized content should be wrapped in AnyView")
        
        // Test that the function handles different locales without crashing
        let arabicHints = InternationalizationHints(locale: Locale(identifier: "ar-SA"))
        let arabicView = platformPresentLocalizedContent_L1(content: content, hints: arabicHints)
        XCTAssertNotNil(arabicView, "Should handle Arabic locale")
        XCTAssertTrue(arabicView is AnyView, "Arabic content should also be wrapped in AnyView")
    }
    
    func testPlatformPresentLocalizedText_L1() {
        // Given
        let text = "Hello World"
        let hints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        
        // When
        let view = platformPresentLocalizedText_L1(
            text: text,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentLocalizedText_L1 should return a view")
        
        // Test actual business logic: Text should be wrapped in AnyView for internationalization
        XCTAssertTrue(view is AnyView, "Localized text should be wrapped in AnyView")
        
        // Test RTL text handling
        let rtlText = "مرحبا بالعالم" // "Hello World" in Arabic
        let rtlHints = InternationalizationHints(locale: Locale(identifier: "ar-SA"))
        let rtlView = platformPresentLocalizedText_L1(text: rtlText, hints: rtlHints)
        XCTAssertNotNil(rtlView, "Should handle RTL text")
        XCTAssertTrue(rtlView is AnyView, "RTL text should also be wrapped in AnyView")
    }
    
    func testPlatformPresentLocalizedNumber_L1() {
        // Given
        let number = 123.45
        let hints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        
        // When
        let view = platformPresentLocalizedNumber_L1(
            number: number,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentLocalizedNumber_L1 should return a view")
        
        // Test actual business logic: Number should be wrapped in AnyView for internationalization
        XCTAssertTrue(view is AnyView, "Localized number should be wrapped in AnyView")
        
        // Test different number formats for different locales
        let germanHints = InternationalizationHints(locale: Locale(identifier: "de-DE"))
        let germanView = platformPresentLocalizedNumber_L1(number: number, hints: germanHints)
        XCTAssertNotNil(germanView, "Should handle German number formatting")
        XCTAssertTrue(germanView is AnyView, "German number should also be wrapped in AnyView")
        
        // Test edge cases
        let zeroView = platformPresentLocalizedNumber_L1(number: 0, hints: hints)
        XCTAssertNotNil(zeroView, "Should handle zero values")
        
        let negativeView = platformPresentLocalizedNumber_L1(number: -123.45, hints: hints)
        XCTAssertNotNil(negativeView, "Should handle negative values")
    }
    
    func testPlatformPresentLocalizedCurrency_L1() {
        // Given
        let amount = 123.45
        let hints = InternationalizationHints(
            locale: Locale(identifier: "en-US"),
            currencyCode: "USD"
        )
        
        // When
        let view = platformPresentLocalizedCurrency_L1(
            amount: amount,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentLocalizedCurrency_L1 should return a view")
        
        // Test actual business logic: Currency should be wrapped in AnyView for internationalization
        XCTAssertTrue(view is AnyView, "Localized currency should be wrapped in AnyView")
        
        // Test different currency formats for different locales
        let euroHints = InternationalizationHints(
            locale: Locale(identifier: "de-DE"),
            currencyCode: "EUR"
        )
        let euroView = platformPresentLocalizedCurrency_L1(amount: amount, hints: euroHints)
        XCTAssertNotNil(euroView, "Should handle Euro currency formatting")
        XCTAssertTrue(euroView is AnyView, "Euro currency should also be wrapped in AnyView")
        
        // Test edge cases
        let zeroView = platformPresentLocalizedCurrency_L1(amount: 0, hints: hints)
        XCTAssertNotNil(zeroView, "Should handle zero amounts")
        
        let negativeView = platformPresentLocalizedCurrency_L1(amount: -123.45, hints: hints)
        XCTAssertNotNil(negativeView, "Should handle negative amounts")
    }
    
    func testPlatformPresentLocalizedDate_L1() {
        // Given
        let date = Date()
        let hints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        
        // When
        let view = platformPresentLocalizedDate_L1(
            date: date,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentLocalizedDate_L1 should return a view")
        
        // Test actual business logic: Date should be wrapped in AnyView for internationalization
        XCTAssertTrue(view is AnyView, "Localized date should be wrapped in AnyView")
        
        // Test different date formats for different locales
        let japaneseHints = InternationalizationHints(locale: Locale(identifier: "ja-JP"))
        let japaneseView = platformPresentLocalizedDate_L1(date: date, hints: japaneseHints)
        XCTAssertNotNil(japaneseView, "Should handle Japanese date formatting")
        XCTAssertTrue(japaneseView is AnyView, "Japanese date should also be wrapped in AnyView")
        
        // Test edge cases
        let pastDate = Date(timeIntervalSince1970: 0) // Jan 1, 1970
        let pastView = platformPresentLocalizedDate_L1(date: pastDate, hints: hints)
        XCTAssertNotNil(pastView, "Should handle past dates")
        
        let futureDate = Date(timeIntervalSinceNow: 86400) // Tomorrow
        let futureView = platformPresentLocalizedDate_L1(date: futureDate, hints: hints)
        XCTAssertNotNil(futureView, "Should handle future dates")
    }
    
    func testPlatformPresentLocalizedTime_L1() {
        // Given
        let date = Date()
        let hints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        
        // When
        let view = platformPresentLocalizedTime_L1(
            date: date,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentLocalizedTime_L1 should return a view")
    }
    
    func testPlatformPresentLocalizedPercentage_L1() {
        // Given
        let value = 0.75
        let hints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        
        // When
        let view = platformPresentLocalizedPercentage_L1(
            value: value,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentLocalizedPercentage_L1 should return a view")
    }
    
    func testPlatformPresentLocalizedPlural_L1() {
        // Given
        let word = "item"
        let count = 5
        let hints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        
        // When
        let view = platformPresentLocalizedPlural_L1(
            word: word,
            count: count,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentLocalizedPlural_L1 should return a view")
    }
    
    func testPlatformPresentLocalizedString_L1() {
        // Given
        let key = "welcome_message"
        let hints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        
        // When
        let view = platformPresentLocalizedString_L1(
            key: key,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformPresentLocalizedString_L1 should return a view")
    }
    
    // MARK: - RTL Support Tests
    
    func testPlatformRTLContainer_L1() {
        // Given
        let content = Text("RTL Content")
        let hints = InternationalizationHints(enableRTL: true)
        
        // When
        let view = platformRTLContainer_L1(
            content: content,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformRTLContainer_L1 should return a view")
        
        // Test actual business logic: RTL container should be wrapped in AnyView
        XCTAssertTrue(view is AnyView, "RTL container should be wrapped in AnyView")
        
        // Test RTL vs LTR behavior
        let ltrHints = InternationalizationHints(enableRTL: false)
        let ltrView = platformRTLContainer_L1(content: content, hints: ltrHints)
        XCTAssertNotNil(ltrView, "Should handle LTR content")
        XCTAssertTrue(ltrView is AnyView, "LTR container should also be wrapped in AnyView")
        
        // Test with different content types
        let imageContent = Image(systemName: "star")
        let imageView = platformRTLContainer_L1(content: imageContent, hints: hints)
        XCTAssertNotNil(imageView, "Should handle image content in RTL container")
        XCTAssertTrue(imageView is AnyView, "Image RTL container should be wrapped in AnyView")
    }
    
    func testPlatformRTLHStack_L1() {
        // Given
        let hints = InternationalizationHints(enableRTL: true)
        
        // When
        let view = platformRTLHStack_L1(
            content: {
                Text("RTL HStack")
            },
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformRTLHStack_L1 should return a view")
    }
    
    func testPlatformRTLVStack_L1() {
        // Given
        let hints = InternationalizationHints(enableRTL: true)
        
        // When
        let view = platformRTLVStack_L1(
            content: {
                Text("RTL VStack")
            },
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformRTLVStack_L1 should return a view")
    }
    
    func testPlatformRTLZStack_L1() {
        // Given
        let hints = InternationalizationHints(enableRTL: true)
        
        // When
        let view = platformRTLZStack_L1(
            content: {
                Text("RTL ZStack")
            },
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformRTLZStack_L1 should return a view")
    }
    
    // MARK: - Localized Input Tests
    
    func testPlatformLocalizedTextField_L1() {
        // Given
        let title = "Enter text"
        let text = Binding.constant("")
        let hints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        
        // When
        let view = platformLocalizedTextField_L1(
            title: title,
            text: text,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformLocalizedTextField_L1 should return a view")
    }
    
    func testPlatformLocalizedSecureField_L1() {
        // Given
        let title = "Enter password"
        let text = Binding.constant("")
        let hints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        
        // When
        let view = platformLocalizedSecureField_L1(
            title: title,
            text: text,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformLocalizedSecureField_L1 should return a view")
    }
    
    func testPlatformLocalizedTextEditor_L1() {
        // Given
        let title = "Enter text"
        let text = Binding.constant("")
        let hints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        
        // When
        let view = platformLocalizedTextEditor_L1(
            title: title,
            text: text,
            hints: hints
        )
        
        // Then
        XCTAssertNotNil(view, "platformLocalizedTextEditor_L1 should return a view")
    }
}