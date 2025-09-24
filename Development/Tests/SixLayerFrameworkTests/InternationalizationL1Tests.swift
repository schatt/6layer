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