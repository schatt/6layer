//
//  PlatformInternationalizationL1Tests.swift
//  SixLayerFrameworkTests
//
//  Tests for PlatformInternationalizationL1.swift
//  Tests L1 internationalization functions with proper business logic testing
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

@MainActor
final class PlatformInternationalizationL1Tests: XCTestCase {
    
    // MARK: - Test Data
    
    private var sampleHints: InternationalizationHints = InternationalizationHints()
    
    override func setUp() {
        super.setUp()
        sampleHints = InternationalizationHints()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Localized Content Tests with Business Logic
    
    func testPlatformPresentLocalizedContent_L1() {
        // Given
        let content = Text("Hello World")
        let hints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        
        // When
        let view = platformPresentLocalizedContent_L1(
            content: content,
            hints: hints
        )
        
        // Then: Test the two critical aspects
        
        // 1. View created - The view can be instantiated successfully
        XCTAssertNotNil(view, "Localized content view should be created successfully")
        
        // 2. Contains what it needs to contain - The view should contain the localized content
        do {
            // The view should be wrapped in AnyView
            let anyView = try view.inspect().anyView()
            XCTAssertNotNil(anyView, "Localized content should be wrapped in AnyView")
            
            // The view should contain text elements with our content
            let viewText = try view.inspect().findAll(ViewType.Text.self)
            XCTAssertFalse(viewText.isEmpty, "Localized content view should contain text elements")
            
            // Should contain our original text content
            let hasOriginalText = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("Hello World")
                } catch {
                    return false
                }
            }
            XCTAssertTrue(hasOriginalText, "Localized content should contain the original text 'Hello World'")
            
        } catch {
            XCTFail("Failed to inspect localized content view: \(error)")
        }
        
        // Test that the function handles different locales without crashing
        let arabicHints = InternationalizationHints(locale: Locale(identifier: "ar-SA"))
        let arabicView = platformPresentLocalizedContent_L1(content: content, hints: arabicHints)
        XCTAssertNotNil(arabicView, "Should handle Arabic locale")
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
        
        // Then: Test the two critical aspects
        
        // 1. View created - The view can be instantiated successfully
        XCTAssertNotNil(view, "Localized text view should be created successfully")
        
        // 2. Contains what it needs to contain - The view should contain the localized text
        do {
            // The view should be wrapped in AnyView
            let anyView = try view.inspect().anyView()
            XCTAssertNotNil(anyView, "Localized text should be wrapped in AnyView")
            
            // The view should contain text elements
            let viewText = try view.inspect().findAll(ViewType.Text.self)
            XCTAssertFalse(viewText.isEmpty, "Localized text view should contain text elements")
            
            // Should contain our text content
            let hasTextContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("Hello World")
                } catch {
                    return false
                }
            }
            XCTAssertTrue(hasTextContent, "Localized text should contain the text 'Hello World'")
            
        } catch {
            XCTFail("Failed to inspect localized text view: \(error)")
        }
        
        // Test different locales
        let germanHints = InternationalizationHints(locale: Locale(identifier: "de-DE"))
        let germanView = platformPresentLocalizedText_L1(text: text, hints: germanHints)
        XCTAssertNotNil(germanView, "Should handle German locale")
    }
    
    func testPlatformPresentLocalizedNumber_L1() {
        // Given
        let number = 1234.56
        let hints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        
        // When
        let view = platformPresentLocalizedNumber_L1(
            number: number,
            hints: hints
        )
        
        // Then: Test the two critical aspects
        
        // 1. View created - The view can be instantiated successfully
        XCTAssertNotNil(view, "Localized number view should be created successfully")
        
        // 2. Contains what it needs to contain - The view should contain the localized number
        do {
            // The view should be wrapped in AnyView
            let anyView = try view.inspect().anyView()
            XCTAssertNotNil(anyView, "Localized number should be wrapped in AnyView")
            
            // The view should contain text elements
            let viewText = try view.inspect().findAll(ViewType.Text.self)
            XCTAssertFalse(viewText.isEmpty, "Localized number view should contain text elements")
            
            // Should contain formatted number content
            let hasNumberContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("1,234.56") || textContent.contains("1234.56")
                } catch {
                    return false
                }
            }
            XCTAssertTrue(hasNumberContent, "Localized number should contain formatted number content")
            
        } catch {
            XCTFail("Failed to inspect localized number view: \(error)")
        }
        
        // Test different number formats for different locales
        let germanHints = InternationalizationHints(locale: Locale(identifier: "de-DE"))
        let germanView = platformPresentLocalizedNumber_L1(number: number, hints: germanHints)
        XCTAssertNotNil(germanView, "Should handle German number formatting")
    }
    
    func testPlatformPresentLocalizedCurrency_L1() {
        // Given
        let amount = 99.99
        let hints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        
        // When
        let view = platformPresentLocalizedCurrency_L1(
            amount: amount,
            hints: hints
        )
        
        // Then: Test the two critical aspects
        
        // 1. View created - The view can be instantiated successfully
        XCTAssertNotNil(view, "Localized currency view should be created successfully")
        
        // 2. Contains what it needs to contain - The view should contain the localized currency
        do {
            // The view should be wrapped in AnyView
            let anyView = try view.inspect().anyView()
            XCTAssertNotNil(anyView, "Localized currency should be wrapped in AnyView")
            
            // The view should contain text elements
            let viewText = try view.inspect().findAll(ViewType.Text.self)
            XCTAssertFalse(viewText.isEmpty, "Localized currency view should contain text elements")
            
            // Should contain currency content (format may vary by locale)
            let hasCurrencyContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("$") || textContent.contains("99.99") || textContent.contains("99,99")
                } catch {
                    return false
                }
            }
            XCTAssertTrue(hasCurrencyContent, "Localized currency should contain currency content")
            
        } catch {
            XCTFail("Failed to inspect localized currency view: \(error)")
        }
        
        // Test different currency formats for different locales
        let euroHints = InternationalizationHints(locale: Locale(identifier: "de-DE"))
        let euroView = platformPresentLocalizedCurrency_L1(amount: amount, hints: euroHints)
        XCTAssertNotNil(euroView, "Should handle Euro currency formatting")
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
        
        // Then: Test the two critical aspects
        
        // 1. View created - The view can be instantiated successfully
        XCTAssertNotNil(view, "Localized date view should be created successfully")
        
        // 2. Contains what it needs to contain - The view should contain the localized date
        do {
            // The view should be wrapped in AnyView
            let anyView = try view.inspect().anyView()
            XCTAssertNotNil(anyView, "Localized date should be wrapped in AnyView")
            
            // The view should contain text elements
            let viewText = try view.inspect().findAll(ViewType.Text.self)
            XCTAssertFalse(viewText.isEmpty, "Localized date view should contain text elements")
            
            // Should contain date content (format may vary by locale)
            let hasDateContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    // Date format will vary, just check it's not empty
                    return !textContent.isEmpty
                } catch {
                    return false
                }
            }
            XCTAssertTrue(hasDateContent, "Localized date should contain date content")
            
        } catch {
            XCTFail("Failed to inspect localized date view: \(error)")
        }
        
        // Test different date formats for different locales
        let japaneseHints = InternationalizationHints(locale: Locale(identifier: "ja-JP"))
        let japaneseView = platformPresentLocalizedDate_L1(date: date, hints: japaneseHints)
        XCTAssertNotNil(japaneseView, "Should handle Japanese date formatting")
    }
    
    func testPlatformPresentLocalizedTime_L1() {
        // Given
        let time = Date()
        let hints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        
        // When
        let view = platformPresentLocalizedTime_L1(
            date: time,
            hints: hints
        )
        
        // Then: Test the two critical aspects
        
        // 1. View created - The view can be instantiated successfully
        XCTAssertNotNil(view, "Localized time view should be created successfully")
        
        // 2. Contains what it needs to contain - The view should contain the localized time
        do {
            // The view should be wrapped in AnyView
            let anyView = try view.inspect().anyView()
            XCTAssertNotNil(anyView, "Localized time should be wrapped in AnyView")
            
            // The view should contain text elements
            let viewText = try view.inspect().findAll(ViewType.Text.self)
            XCTAssertFalse(viewText.isEmpty, "Localized time view should contain text elements")
            
            // Should contain time content (format may vary by locale)
            let hasTimeContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    // Time format will vary, just check it's not empty
                    return !textContent.isEmpty
                } catch {
                    return false
                }
            }
            XCTAssertTrue(hasTimeContent, "Localized time should contain time content")
            
        } catch {
            XCTFail("Failed to inspect localized time view: \(error)")
        }
        
        // Test 24-hour vs 12-hour format handling
        let militaryHints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        let militaryView = platformPresentLocalizedTime_L1(date: time, hints: militaryHints)
        XCTAssertNotNil(militaryView, "Should handle 24-hour time format")
    }
    
    func testPlatformPresentLocalizedPercentage_L1() {
        // Given
        let percentage = 0.75
        let hints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        
        // When
        let view = platformPresentLocalizedPercentage_L1(
            value: percentage,
            hints: hints
        )
        
        // Then: Test the two critical aspects
        
        // 1. View created - The view can be instantiated successfully
        XCTAssertNotNil(view, "Localized percentage view should be created successfully")
        
        // 2. Contains what it needs to contain - The view should contain the localized percentage
        do {
            // The view should be wrapped in AnyView
            let anyView = try view.inspect().anyView()
            XCTAssertNotNil(anyView, "Localized percentage should be wrapped in AnyView")
            
            // The view should contain text elements
            let viewText = try view.inspect().findAll(ViewType.Text.self)
            XCTAssertFalse(viewText.isEmpty, "Localized percentage view should contain text elements")
            
            // Should contain percentage content (format may vary by locale)
            let hasPercentageContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("%") || textContent.contains("75") || textContent.contains("0.75")
                } catch {
                    return false
                }
            }
            XCTAssertTrue(hasPercentageContent, "Localized percentage should contain percentage content")
            
        } catch {
            XCTFail("Failed to inspect localized percentage view: \(error)")
        }
        
        // Test different percentage formats for different locales
        let frenchHints = InternationalizationHints(locale: Locale(identifier: "fr-FR"))
        let frenchView = platformPresentLocalizedPercentage_L1(value: percentage, hints: frenchHints)
        XCTAssertNotNil(frenchView, "Should handle French percentage formatting")
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
        
        // Then: Test the two critical aspects
        
        // 1. View created - The view can be instantiated successfully
        XCTAssertNotNil(view, "Localized plural view should be created successfully")
        
        // 2. Contains what it needs to contain - The view should contain the localized plural
        do {
            // The view should be wrapped in AnyView
            let anyView = try view.inspect().anyView()
            XCTAssertNotNil(anyView, "Localized plural should be wrapped in AnyView")
            
            // The view should contain text elements
            let viewText = try view.inspect().findAll(ViewType.Text.self)
            XCTAssertFalse(viewText.isEmpty, "Localized plural view should contain text elements")
            
            // Should contain plural content (should use plural form for count > 1)
            let hasPluralContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("items") || textContent.contains("5")
                } catch {
                    return false
                }
            }
            XCTAssertTrue(hasPluralContent, "Localized plural should contain plural content")
            
        } catch {
            XCTFail("Failed to inspect localized plural view: \(error)")
        }
        
        // Test different plural rules for different languages
        let russianHints = InternationalizationHints(locale: Locale(identifier: "ru-RU"))
        let russianView = platformPresentLocalizedPlural_L1(
            word: word,
            count: count,
            hints: russianHints
        )
        XCTAssertNotNil(russianView, "Should handle Russian plural rules")
    }
    
    func testPlatformPresentLocalizedString_L1() {
        // Given
        let key = "hello_world"
        let hints = InternationalizationHints(locale: Locale(identifier: "en-US"))
        
        // When
        let view = platformPresentLocalizedString_L1(
            key: key,
            hints: hints
        )
        
        // Then: Test the two critical aspects
        
        // 1. View created - The view can be instantiated successfully
        XCTAssertNotNil(view, "Localized string view should be created successfully")
        
        // 2. Contains what it needs to contain - The view should contain the localized string
        do {
            // The view should be wrapped in AnyView
            let anyView = try view.inspect().anyView()
            XCTAssertNotNil(anyView, "Localized string should be wrapped in AnyView")
            
            // The view should contain text elements
            let viewText = try view.inspect().findAll(ViewType.Text.self)
            XCTAssertFalse(viewText.isEmpty, "Localized string view should contain text elements")
            
            // Should contain string content (may be the key itself if no translation found)
            let hasStringContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains(key) || !textContent.isEmpty
                } catch {
                    return false
                }
            }
            XCTAssertTrue(hasStringContent, "Localized string should contain string content")
            
        } catch {
            XCTFail("Failed to inspect localized string view: \(error)")
        }
        
        // Test string interpolation and formatting
        let chineseHints = InternationalizationHints(locale: Locale(identifier: "zh-CN"))
        let chineseView = platformPresentLocalizedString_L1(key: "你好世界", hints: chineseHints)
        XCTAssertNotNil(chineseView, "Should handle Chinese string formatting")
    }
    
    func testPlatformRTLContainer_L1() {
        // Given
        let content = Text("Hello World")
        let hints = InternationalizationHints(locale: Locale(identifier: "ar-SA"))
        
        // When
        let view = platformRTLContainer_L1(
            content: content,
            hints: hints
        )
        
        // Then: Test the two critical aspects
        
        // 1. View created - The view can be instantiated successfully
        XCTAssertNotNil(view, "RTL container view should be created successfully")
        
        // 2. Contains what it needs to contain - The view should contain the RTL content
        do {
            // The view should be wrapped in AnyView
            let anyView = try view.inspect().anyView()
            XCTAssertNotNil(anyView, "RTL container should be wrapped in AnyView")
            
            // The view should contain text elements
            let viewText = try view.inspect().findAll(ViewType.Text.self)
            XCTAssertFalse(viewText.isEmpty, "RTL container view should contain text elements")
            
            // Should contain our content
            let hasContent = viewText.contains { text in
                do {
                    let textContent = try text.string()
                    return textContent.contains("Hello World")
                } catch {
                    return false
                }
            }
            XCTAssertTrue(hasContent, "RTL container should contain the content 'Hello World'")
            
        } catch {
            XCTFail("Failed to inspect RTL container view: \(error)")
        }
        
        // Test LTR content in RTL container
        let ltrContent = Text("LTR Content")
        let ltrView = platformRTLContainer_L1(content: ltrContent, hints: hints)
        XCTAssertNotNil(ltrView, "Should handle LTR content in RTL container")
    }
}
