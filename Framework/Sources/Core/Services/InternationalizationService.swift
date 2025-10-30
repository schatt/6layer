//
//  InternationalizationService.swift
//  SixLayerFramework
//
//  Internationalization & Localization Service
//  Provides RTL support, number formatting, date/time formatting, currency formatting
//

import Foundation
import SwiftUI

// MARK: - Internationalization Service

/// Main service for internationalization and localization
public class InternationalizationService: ObservableObject {
    
    // MARK: - Properties
    
    private let locale: Locale
    private let formatter: NumberFormatter
    private let dateFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    private let currencyFormatter: NumberFormatter
    private let percentageFormatter: NumberFormatter
    
    // MARK: - Initialization
    
    public init(locale: Locale = Locale.current) {
        self.locale = locale
        
        // Initialize formatters
        self.formatter = NumberFormatter()
        self.formatter.locale = locale
        self.formatter.numberStyle = .decimal
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.locale = locale
        
        self.timeFormatter = DateFormatter()
        self.timeFormatter.locale = locale
        
        self.currencyFormatter = NumberFormatter()
        self.currencyFormatter.locale = locale
        self.currencyFormatter.numberStyle = .currency
        
        self.percentageFormatter = NumberFormatter()
        self.percentageFormatter.locale = locale
        self.percentageFormatter.numberStyle = .percent
    }
    
    // MARK: - Text Direction
    
    /// Determine text direction for a given string
    /// - Parameter text: The text to analyze
    /// - Returns: Text direction (LTR, RTL, or mixed)
    public func textDirection(for text: String) -> TextDirection {
        guard !text.isEmpty else { return .leftToRight }
        
        // RTL character ranges
        let rtlRanges = [
            "\u{0590}"..."\u{05FF}", // Hebrew
            "\u{0600}"..."\u{06FF}", // Arabic
            "\u{0750}"..."\u{077F}", // Arabic Supplement
            "\u{08A0}"..."\u{08FF}", // Arabic Extended-A
            "\u{FB1D}"..."\u{FDFF}", // Arabic Presentation Forms-A
            "\u{FE70}"..."\u{FEFF}"  // Arabic Presentation Forms-B
        ]
        
        var rtlCount = 0
        var ltrCount = 0
        
        for scalar in text.unicodeScalars {
            let isRTL = rtlRanges.contains { range in
                range.contains(String(scalar))
            }
            
            if isRTL {
                rtlCount += 1
            } else if scalar.isASCII && scalar.properties.isAlphabetic {
                ltrCount += 1
            }
        }
        
        if rtlCount > 0 && ltrCount > 0 {
            return .mixed
        } else if rtlCount > 0 {
            return .rightToLeft
        } else {
            return .leftToRight
        }
    }
    
    /// Determine text alignment for a given string
    /// - Parameter text: The text to analyze
    /// - Returns: Text alignment (leading, trailing, or center)
    public func textAlignment(for text: String) -> TextAlignment {
        let direction = textDirection(for: text)
        
        switch direction {
        case .rightToLeft:
            return .trailing
        case .leftToRight, .mixed:
            return .leading
        }
    }
    
    // MARK: - Number Formatting
    
    /// Format a number according to locale
    /// - Parameters:
    ///   - number: The number to format
    ///   - decimalPlaces: Number of decimal places (optional)
    /// - Returns: Formatted number string
    public func formatNumber(_ number: Double, decimalPlaces: Int? = nil) -> String {
        if let decimalPlaces = decimalPlaces {
            formatter.minimumFractionDigits = decimalPlaces
            formatter.maximumFractionDigits = decimalPlaces
        } else {
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
        }
        
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    /// Format a number as percentage
    /// - Parameter number: The number to format (0.0 to 1.0)
    /// - Returns: Formatted percentage string
    public func formatPercentage(_ number: Double) -> String {
        percentageFormatter.string(from: NSNumber(value: number)) ?? "\(Int(number * 100))%"
    }
    
    /// Format a number as currency
    /// - Parameters:
    ///   - amount: The amount to format
    ///   - currencyCode: The currency code (e.g., "USD", "EUR")
    /// - Returns: Formatted currency string
    public func formatCurrency(_ amount: Double, currencyCode: String) -> String {
        currencyFormatter.currencyCode = currencyCode
        return currencyFormatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    
    // MARK: - Date Formatting
    
    /// Format a date according to locale
    /// - Parameters:
    ///   - date: The date to format
    ///   - style: The date format style
    /// - Returns: Formatted date string
    public func formatDate(_ date: Date, style: DateFormatStyle) -> String {
        switch style {
        case .short:
            dateFormatter.dateStyle = .short
        case .medium:
            dateFormatter.dateStyle = .medium
        case .long:
            dateFormatter.dateStyle = .long
        case .full:
            dateFormatter.dateStyle = .full
        case .custom:
            dateFormatter.dateStyle = .medium
        }
        
        return dateFormatter.string(from: date)
    }
    
    /// Format a date with custom format
    /// - Parameters:
    ///   - date: The date to format
    ///   - format: Custom date format string
    /// - Returns: Formatted date string
    public func formatDate(_ date: Date, format: String) -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    /// Format a date as relative time
    /// - Parameter date: The date to format
    /// - Returns: Formatted relative date string
    public func formatRelativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = locale
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    // MARK: - Time Formatting
    
    /// Format a time according to locale
    /// - Parameters:
    ///   - date: The date containing the time to format
    ///   - style: The time format style
    /// - Returns: Formatted time string
    public func formatTime(_ date: Date, style: TimeFormatStyle) -> String {
        switch style {
        case .short:
            timeFormatter.timeStyle = .short
        case .medium:
            timeFormatter.timeStyle = .medium
        case .long:
            timeFormatter.timeStyle = .long
        case .full:
            timeFormatter.timeStyle = .full
        case .custom:
            timeFormatter.timeStyle = .medium
        }
        
        return timeFormatter.string(from: date)
    }
    
    /// Format a time with custom format
    /// - Parameters:
    ///   - date: The date containing the time to format
    ///   - format: Custom time format string
    /// - Returns: Formatted time string
    public func formatTime(_ date: Date, format: String) -> String {
        timeFormatter.dateFormat = format
        return timeFormatter.string(from: date)
    }
    
    // MARK: - Pluralization
    
    /// Pluralize a word based on count
    /// - Parameters:
    ///   - word: The word to pluralize
    ///   - count: The count
    /// - Returns: Pluralized word
    public func pluralize(_ word: String, count: Int) -> String {
        // Basic English pluralization rules
        if count == 1 {
            return word
        }
        
        // Handle common irregular plurals
        let irregularPlurals: [String: String] = [
            "child": "children",
            "person": "people",
            "man": "men",
            "woman": "women",
            "foot": "feet",
            "tooth": "teeth",
            "mouse": "mice",
            "goose": "geese",
            "ox": "oxen",
            "sheep": "sheep",
            "deer": "deer",
            "fish": "fish",
            "moose": "moose",
            "series": "series",
            "species": "species"
        ]
        
        if let irregular = irregularPlurals[word.lowercased()] {
            return irregular
        }
        
        // Handle words ending in -y
        if word.hasSuffix("y") && !word.hasSuffix("ay") && !word.hasSuffix("ey") && !word.hasSuffix("iy") && !word.hasSuffix("oy") && !word.hasSuffix("uy") {
            return String(word.dropLast()) + "ies"
        }
        
        // Handle words ending in -s, -sh, -ch, -x, -z
        if word.hasSuffix("s") || word.hasSuffix("sh") || word.hasSuffix("ch") || word.hasSuffix("x") || word.hasSuffix("z") {
            return word + "es"
        }
        
        // Handle words ending in -f or -fe
        if word.hasSuffix("f") {
            return String(word.dropLast()) + "ves"
        } else if word.hasSuffix("fe") {
            return String(word.dropLast(2)) + "ves"
        }
        
        // Default: add -s
        return word + "s"
    }
    
    // MARK: - Localized Strings
    
    /// Get localized string for a key
    /// - Parameters:
    ///   - key: The localization key
    ///   - arguments: Optional arguments for string formatting
    /// - Returns: Localized string
    public func localizedString(for key: String, arguments: [String] = []) -> String {
        let localizedString = NSLocalizedString(key, comment: "")

        if localizedString == key {
            // Key not found, return the key itself
            return key
        }

        if arguments.isEmpty {
            return localizedString
        } else {
            return String(format: localizedString, arguments: arguments)
        }
    }

    /// Get the current language code
    /// - Returns: Current language code (e.g., "en", "es", "fr")
    public func currentLanguage() -> String {
        return locale.language.languageCode?.identifier ?? "en"
    }

    /// Get the list of supported languages
    /// - Returns: Array of supported language codes
    public func supportedLanguages() -> [String] {
        // Return a reasonable set of commonly supported languages
        return ["en", "es", "fr", "de", "it", "pt", "zh", "ja", "ko", "ar", "ru", "hi"]
    }

    /// Set the current language
    /// - Parameter languageCode: The language code to set (e.g., "en", "es", "fr")
    public func setLanguage(_ languageCode: String) {
        // Note: In a real implementation, this would update the app's language
        // For now, this is a no-op as SwiftUI doesn't provide direct language switching
        // This would typically require restarting the app or using custom localization
    }
    
    // MARK: - Locale Information
    
    /// Get current locale information
    /// - Returns: Locale information
    public func getLocaleInfo() -> LocaleInfo {
        let languageCode = locale.language.languageCode?.identifier ?? "en"
        let regionCode = locale.region?.identifier ?? "US"
        let currencyCode = locale.currency?.identifier ?? "USD"
        let isRTL = locale.language.languageCode?.identifier.hasPrefix("ar") == true || 
                   locale.language.languageCode?.identifier.hasPrefix("he") == true ||
                   locale.language.languageCode?.identifier.hasPrefix("fa") == true
        
        let numberFormat = NumberFormat(
            decimalSeparator: locale.decimalSeparator ?? ".",
            groupingSeparator: locale.groupingSeparator ?? ",",
            currencySymbol: locale.currencySymbol ?? "$",
            currencyPosition: .before,
            negativeFormat: .minus
        )
        
        let dateFormat = DateFormat(
            shortFormat: "M/d/yy",
            mediumFormat: "MMM d, yyyy",
            longFormat: "MMMM d, yyyy",
            fullFormat: "EEEE, MMMM d, yyyy",
            firstWeekday: 1,
            minimumDaysInFirstWeek: 1
        )
        
        let timeFormat = TimeFormat(
            shortFormat: "h:mm a",
            mediumFormat: "h:mm:ss a",
            longFormat: "h:mm:ss a z",
            fullFormat: "h:mm:ss a zzzz",
            is24Hour: false,
            amSymbol: "AM",
            pmSymbol: "PM"
        )
        
        return LocaleInfo(
            identifier: locale.identifier,
            languageCode: languageCode,
            regionCode: regionCode,
            currencyCode: currencyCode,
            isRTL: isRTL,
            numberFormat: numberFormat,
            dateFormat: dateFormat,
            timeFormat: timeFormat
        )
    }
    
    // MARK: - RTL Layout Support
    
    /// Get RTL-aware layout direction
    /// - Returns: Layout direction for SwiftUI
    public func getLayoutDirection() -> LayoutDirection {
        return getLocaleInfo().isRTL ? .rightToLeft : .leftToRight
    }
    
    /// Get RTL-aware text alignment
    /// - Parameter text: The text to analyze
    /// - Returns: Text alignment for SwiftUI
    public func getTextAlignment(for text: String) -> TextAlignment {
        return textAlignment(for: text)
    }
    
    // MARK: - Validation
    
    /// Validate if a locale is supported
    /// - Parameter locale: The locale to validate
    /// - Returns: True if supported, false otherwise
    public static func isLocaleSupported(_ locale: Locale) -> Bool {
        let supportedLanguages = ["en", "es", "fr", "de", "it", "pt", "zh", "ja", "ko", "ar", "ru", "hi", "th", "vi", "tr", "pl", "nl", "sv", "da", "no", "fi", "cs", "hu", "ro", "bg", "hr", "sk", "sl", "et", "lv", "lt", "el", "he", "fa", "ur", "bn", "ta", "te", "ml", "kn", "gu", "pa", "or", "as", "ne", "si", "my", "km", "lo", "ka", "hy", "az", "kk", "ky", "uz", "tg", "mn", "bo", "dz", "ti", "am", "om", "so", "sw", "zu", "af", "sq", "eu", "be", "bs", "ca", "cy", "eo", "fo", "gl", "is", "mk", "mt", "rm", "sq", "sr", "uk", "wa"]
        
        guard let languageCode = locale.language.languageCode?.identifier else { return false }
        return supportedLanguages.contains(languageCode)
    }
}
