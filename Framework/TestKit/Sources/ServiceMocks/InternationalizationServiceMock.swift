//
//  InternationalizationServiceMock.swift
//  SixLayerTestKit
//
//  Mock implementation of InternationalizationService for testing
//

import Foundation
import SixLayerFramework

/// Mock implementation of InternationalizationService for testing
public class InternationalizationServiceMock: InternationalizationServiceDelegate {

    // MARK: - Configuration

    private var translations: [String: [String: String]] = [:]
    private var currentLocale: String = "en"

    // MARK: - Mock State Tracking

    public private(set) var localizedStringWasCalled = false
    public private(set) var requestedKeys: [String] = []
    public private(set) var requestedLocales: [String] = []

    // MARK: - Configuration Methods

    /// Configure translations for testing
    public func configureTranslations(_ translations: [String: [String: String]]) {
        self.translations = translations
    }

    /// Configure current locale
    public func configureLocale(_ locale: String) {
        currentLocale = locale
    }

    /// Add translation for specific key and locale
    public func addTranslation(key: String, value: String, locale: String = "en") {
        if translations[locale] == nil {
            translations[locale] = [:]
        }
        translations[locale]?[key] = value
    }

    /// Reset all tracking state
    public func reset() {
        localizedStringWasCalled = false
        requestedKeys = []
        requestedLocales = []
        translations = [:]
        currentLocale = "en"
    }

    // MARK: - InternationalizationServiceDelegate Implementation

    public func localizedString(for key: String, locale: String?, defaultValue: String) -> String {
        localizedStringWasCalled = true
        requestedKeys.append(key)

        let effectiveLocale = locale ?? currentLocale
        requestedLocales.append(effectiveLocale)

        return translations[effectiveLocale]?[key] ?? defaultValue
    }

    public func localizedString(for key: String, locale: String?, arguments: [String]) -> String {
        localizedStringWasCalled = true
        requestedKeys.append(key)

        let effectiveLocale = locale ?? currentLocale
        requestedLocales.append(effectiveLocale)

        guard let template = translations[effectiveLocale]?[key] else {
            return arguments.isEmpty ? key : "\(key): \(arguments.joined(separator: ", "))"
        }

        return String(format: template, arguments: arguments)
    }

    // MARK: - Convenience Methods

    /// Set up common test translations
    public func setupCommonTranslations() {
        addTranslation(key: "button.save", value: "Save")
        addTranslation(key: "button.cancel", value: "Cancel")
        addTranslation(key: "error.network", value: "Network Error")
        addTranslation(key: "success.saved", value: "Item saved successfully")
        addTranslation(key: "form.field.required", value: "This field is required")
    }

    /// Get the most recently requested key
    public var lastRequestedKey: String? {
        return requestedKeys.last
    }

    /// Get the most recently requested locale
    public var lastRequestedLocale: String? {
        return requestedLocales.last
    }

    /// Check if a specific key was requested
    public func wasKeyRequested(_ key: String) -> Bool {
        return requestedKeys.contains(key)
    }
}