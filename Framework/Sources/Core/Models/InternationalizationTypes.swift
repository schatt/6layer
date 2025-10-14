//
//  InternationalizationTypes.swift
//  SixLayerFramework
//
//  Types and structures for Internationalization & Localization
//  Provides RTL support, number formatting, date/time formatting, currency formatting
//

import Foundation
import SwiftUI

// MARK: - Text Direction

/// Text direction for internationalization
public enum TextDirection: String, CaseIterable, Sendable {
    case leftToRight = "ltr"
    case rightToLeft = "rtl"
    case mixed = "mixed"
    
    public var isRTL: Bool {
        return self == .rightToLeft
    }
    
    public var isLTR: Bool {
        return self == .leftToRight
    }
    
    public var isMixed: Bool {
        return self == .mixed
    }
}

// MARK: - Text Alignment

/// Text alignment for internationalization
public enum TextAlignment: String, CaseIterable, Sendable {
    case leading = "leading"
    case trailing = "trailing"
    case center = "center"
    case justified = "justified"
    
    public var isRTL: Bool {
        return self == .trailing
    }
    
    public var isLTR: Bool {
        return self == .leading
    }
}

// MARK: - Date Format Style

/// Date format styles for internationalization
public enum DateFormatStyle: String, CaseIterable, Sendable {
    case short = "short"
    case medium = "medium"
    case long = "long"
    case full = "full"
    case custom = "custom"
}

// MARK: - Time Format Style

/// Time format styles for internationalization
public enum TimeFormatStyle: String, CaseIterable, Sendable {
    case short = "short"
    case medium = "medium"
    case long = "long"
    case full = "full"
    case custom = "custom"
}

// MARK: - Number Format Style

/// Number format styles for internationalization
public enum NumberFormatStyle: String, CaseIterable, Sendable {
    case decimal = "decimal"
    case currency = "currency"
    case percent = "percent"
    case scientific = "scientific"
    case spellOut = "spellOut"
    case ordinal = "ordinal"
    case custom = "custom"
}

// MARK: - Currency Code

/// Currency codes for internationalization
public enum CurrencyCode: String, CaseIterable, Sendable {
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"
    case jpy = "JPY"
    case cad = "CAD"
    case aud = "AUD"
    case chf = "CHF"
    case cny = "CNY"
    case inr = "INR"
    case brl = "BRL"
    case rub = "RUB"
    case krw = "KRW"
    case mxn = "MXN"
    case sgd = "SGD"
    case hkd = "HKD"
    case nok = "NOK"
    case sek = "SEK"
    case dkk = "DKK"
    case pln = "PLN"
    case czk = "CZK"
    case huf = "HUF"
    case ron = "RON"
    case bgn = "BGN"
    case hrk = "HRK"
    case rsd = "RSD"
    case mkd = "MKD"
    case all = "ALL"
    case isk = "ISK"
    case mdl = "MDL"
    case uah = "UAH"
    case gel = "GEL"
    case amd = "AMD"
    case azn = "AZN"
    case kzt = "KZT"
    case kgs = "KGS"
    case tjs = "TJS"
    case tmt = "TMT"
    case uzs = "UZS"
    case sar = "SAR"
    case aed = "AED"
    case qar = "QAR"
    case kwd = "KWD"
    case bhd = "BHD"
    case omr = "OMR"
    case jod = "JOD"
    case ils = "ILS"
    case egp = "EGP"
    case lyd = "LYD"
    case dzd = "DZD"
    case mad = "MAD"
    case tun = "TUN"
    case xof = "XOF"
    case xaf = "XAF"
    case zar = "ZAR"
    case ngn = "NGN"
    case kes = "KES"
    case ugx = "UGX"
    case tzs = "TZS"
    case etb = "ETB"
    case ghs = "GHS"
    case xdr = "XDR"
    
    public var symbol: String {
        switch self {
        case .usd: return "$"
        case .eur: return "€"
        case .gbp: return "£"
        case .jpy: return "¥"
        case .cad: return "C$"
        case .aud: return "A$"
        case .chf: return "CHF"
        case .cny: return "¥"
        case .inr: return "₹"
        case .brl: return "R$"
        case .rub: return "₽"
        case .krw: return "₩"
        case .mxn: return "$"
        case .sgd: return "S$"
        case .hkd: return "HK$"
        case .nok: return "kr"
        case .sek: return "kr"
        case .dkk: return "kr"
        case .pln: return "zł"
        case .czk: return "Kč"
        case .huf: return "Ft"
        case .ron: return "lei"
        case .bgn: return "лв"
        case .hrk: return "kn"
        case .rsd: return "дин"
        case .mkd: return "ден"
        case .all: return "L"
        case .isk: return "kr"
        case .mdl: return "L"
        case .uah: return "₴"
        case .gel: return "₾"
        case .amd: return "֏"
        case .azn: return "₼"
        case .kzt: return "₸"
        case .kgs: return "с"
        case .tjs: return "SM"
        case .tmt: return "T"
        case .uzs: return "so'm"
        case .sar: return "ر.س"
        case .aed: return "د.إ"
        case .qar: return "ر.ق"
        case .kwd: return "د.ك"
        case .bhd: return "د.ب"
        case .omr: return "ر.ع."
        case .jod: return "د.أ"
        case .ils: return "₪"
        case .egp: return "£"
        case .lyd: return "ل.د"
        case .dzd: return "د.ج"
        case .mad: return "د.م."
        case .tun: return "د.ت"
        case .xof: return "CFA"
        case .xaf: return "FCFA"
        case .zar: return "R"
        case .ngn: return "₦"
        case .kes: return "KSh"
        case .ugx: return "USh"
        case .tzs: return "TSh"
        case .etb: return "Br"
        case .ghs: return "₵"
        case .xdr: return "SDR"
        }
    }
    
    public var displayName: String {
        switch self {
        case .usd: return "US Dollar"
        case .eur: return "Euro"
        case .gbp: return "British Pound"
        case .jpy: return "Japanese Yen"
        case .cad: return "Canadian Dollar"
        case .aud: return "Australian Dollar"
        case .chf: return "Swiss Franc"
        case .cny: return "Chinese Yuan"
        case .inr: return "Indian Rupee"
        case .brl: return "Brazilian Real"
        case .rub: return "Russian Ruble"
        case .krw: return "South Korean Won"
        case .mxn: return "Mexican Peso"
        case .sgd: return "Singapore Dollar"
        case .hkd: return "Hong Kong Dollar"
        case .nok: return "Norwegian Krone"
        case .sek: return "Swedish Krona"
        case .dkk: return "Danish Krone"
        case .pln: return "Polish Zloty"
        case .czk: return "Czech Koruna"
        case .huf: return "Hungarian Forint"
        case .ron: return "Romanian Leu"
        case .bgn: return "Bulgarian Lev"
        case .hrk: return "Croatian Kuna"
        case .rsd: return "Serbian Dinar"
        case .mkd: return "Macedonian Denar"
        case .all: return "Albanian Lek"
        case .isk: return "Icelandic Krona"
        case .mdl: return "Moldovan Leu"
        case .uah: return "Ukrainian Hryvnia"
        case .gel: return "Georgian Lari"
        case .amd: return "Armenian Dram"
        case .azn: return "Azerbaijani Manat"
        case .kzt: return "Kazakhstani Tenge"
        case .kgs: return "Kyrgyzstani Som"
        case .tjs: return "Tajikistani Somoni"
        case .tmt: return "Turkmenistani Manat"
        case .uzs: return "Uzbekistani Som"
        case .sar: return "Saudi Riyal"
        case .aed: return "UAE Dirham"
        case .qar: return "Qatari Riyal"
        case .kwd: return "Kuwaiti Dinar"
        case .bhd: return "Bahraini Dinar"
        case .omr: return "Omani Rial"
        case .jod: return "Jordanian Dinar"
        case .ils: return "Israeli Shekel"
        case .egp: return "Egyptian Pound"
        case .lyd: return "Libyan Dinar"
        case .dzd: return "Algerian Dinar"
        case .mad: return "Moroccan Dirham"
        case .tun: return "Tunisian Dinar"
        case .xof: return "West African CFA Franc"
        case .xaf: return "Central African CFA Franc"
        case .zar: return "South African Rand"
        case .ngn: return "Nigerian Naira"
        case .kes: return "Kenyan Shilling"
        case .ugx: return "Ugandan Shilling"
        case .tzs: return "Tanzanian Shilling"
        case .etb: return "Ethiopian Birr"
        case .ghs: return "Ghanaian Cedi"
        case .xdr: return "Special Drawing Rights"
        }
    }
}

// MARK: - Locale Information

/// Locale information for internationalization
public struct LocaleInfo: Sendable {
    public let identifier: String
    public let languageCode: String
    public let regionCode: String
    public let currencyCode: String
    public let isRTL: Bool
    public let numberFormat: NumberFormat
    public let dateFormat: DateFormat
    public let timeFormat: TimeFormat
    
    public init(
        identifier: String,
        languageCode: String,
        regionCode: String,
        currencyCode: String,
        isRTL: Bool,
        numberFormat: NumberFormat,
        dateFormat: DateFormat,
        timeFormat: TimeFormat
    ) {
        self.identifier = identifier
        self.languageCode = languageCode
        self.regionCode = regionCode
        self.currencyCode = currencyCode
        self.isRTL = isRTL
        self.numberFormat = numberFormat
        self.dateFormat = dateFormat
        self.timeFormat = timeFormat
    }
}

// MARK: - Number Format

/// Number format configuration
public struct NumberFormat: Sendable {
    public let decimalSeparator: String
    public let groupingSeparator: String
    public let currencySymbol: String
    public let currencyPosition: CurrencyPosition
    public let negativeFormat: NegativeFormat
    
    public init(
        decimalSeparator: String,
        groupingSeparator: String,
        currencySymbol: String,
        currencyPosition: CurrencyPosition,
        negativeFormat: NegativeFormat
    ) {
        self.decimalSeparator = decimalSeparator
        self.groupingSeparator = groupingSeparator
        self.currencySymbol = currencySymbol
        self.currencyPosition = currencyPosition
        self.negativeFormat = negativeFormat
    }
}

// MARK: - Currency Position

/// Currency symbol position
public enum CurrencyPosition: String, CaseIterable, Sendable {
    case before = "before"
    case after = "after"
    case beforeWithSpace = "beforeWithSpace"
    case afterWithSpace = "afterWithSpace"
}

// MARK: - Negative Format

/// Negative number format
public enum NegativeFormat: String, CaseIterable, Sendable {
    case parentheses = "parentheses"
    case minus = "minus"
    case minusWithSpace = "minusWithSpace"
}

// MARK: - Date Format

/// Date format configuration
public struct DateFormat: Sendable {
    public let shortFormat: String
    public let mediumFormat: String
    public let longFormat: String
    public let fullFormat: String
    public let firstWeekday: Int
    public let minimumDaysInFirstWeek: Int
    
    public init(
        shortFormat: String,
        mediumFormat: String,
        longFormat: String,
        fullFormat: String,
        firstWeekday: Int,
        minimumDaysInFirstWeek: Int
    ) {
        self.shortFormat = shortFormat
        self.mediumFormat = mediumFormat
        self.longFormat = longFormat
        self.fullFormat = fullFormat
        self.firstWeekday = firstWeekday
        self.minimumDaysInFirstWeek = minimumDaysInFirstWeek
    }
}

// MARK: - Time Format

/// Time format configuration
public struct TimeFormat: Sendable {
    public let shortFormat: String
    public let mediumFormat: String
    public let longFormat: String
    public let fullFormat: String
    public let is24Hour: Bool
    public let amSymbol: String
    public let pmSymbol: String
    
    public init(
        shortFormat: String,
        mediumFormat: String,
        longFormat: String,
        fullFormat: String,
        is24Hour: Bool,
        amSymbol: String,
        pmSymbol: String
    ) {
        self.shortFormat = shortFormat
        self.mediumFormat = mediumFormat
        self.longFormat = longFormat
        self.fullFormat = fullFormat
        self.is24Hour = is24Hour
        self.amSymbol = amSymbol
        self.pmSymbol = pmSymbol
    }
}

// MARK: - Pluralization Rules

/// Pluralization rules for different languages
public struct PluralizationRules: Sendable {
    public let zero: String?
    public let one: String?
    public let two: String?
    public let few: String?
    public let many: String?
    public let other: String
    
    public init(
        zero: String? = nil,
        one: String? = nil,
        two: String? = nil,
        few: String? = nil,
        many: String? = nil,
        other: String
    ) {
        self.zero = zero
        self.one = one
        self.two = two
        self.few = few
        self.many = many
        self.other = other
    }
    
    public func pluralize(for count: Int) -> String {
        switch count {
        case 0:
            return zero ?? other
        case 1:
            return one ?? other
        case 2:
            return two ?? other
        case 3...10:
            return few ?? other
        case 11...99:
            return many ?? other
        default:
            return other
        }
    }
}

// MARK: - Internationalization Errors

/// Errors that can occur during internationalization
public enum InternationalizationError: Error, LocalizedError {
    case invalidLocale
    case unsupportedLanguage
    case invalidCurrencyCode
    case formattingFailed
    case localizationNotFound
    case pluralizationFailed
    
    public var errorDescription: String? {
        switch self {
        case .invalidLocale:
            return "Invalid locale provided"
        case .unsupportedLanguage:
            return "Language not supported"
        case .invalidCurrencyCode:
            return "Invalid currency code"
        case .formattingFailed:
            return "Formatting operation failed"
        case .localizationNotFound:
            return "Localization not found"
        case .pluralizationFailed:
            return "Pluralization operation failed"
        }
    }
}
