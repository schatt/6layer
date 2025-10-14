//
//  PlatformColorEncodeExtensions.swift
//  SixLayerFramework
//
//  Platform-specific color encoding and decoding functions
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - Color Encoding Errors

/// Errors that can occur during color encoding/decoding
public enum ColorEncodingError: Error, LocalizedError {
    case platformNotSupported
    case encodingFailed(Error)
    case decodingFailed(Error)
    case invalidColorData
    case unsupportedColorType
    
    public var errorDescription: String? {
        switch self {
        case .platformNotSupported:
            return "Color encoding is not supported on this platform"
        case .encodingFailed(let error):
            return "Failed to encode color: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Failed to decode color: \(error.localizedDescription)"
        case .invalidColorData:
            return "Invalid color data provided"
        case .unsupportedColorType:
            return "Unsupported color type for encoding"
        }
    }
}

// MARK: - Platform Color Encoding

/// Encode a SwiftUI Color to platform-specific data using NSKeyedArchiver
/// - Parameter color: The SwiftUI Color to encode
/// - Returns: Encoded Data containing the platform-specific color
/// - Throws: ColorEncodingError if encoding fails
public func platformColorEncode(_ color: Color) throws -> Data {
    #if os(iOS)
    return try encodeUIColor(color)
    #elseif os(macOS)
    return try encodeNSColor(color)
    #else
    throw ColorEncodingError.platformNotSupported
    #endif
}

/// Decode a SwiftUI Color from platform-specific data using NSKeyedUnarchiver
/// - Parameter data: The encoded Data containing the platform-specific color
/// - Returns: Decoded SwiftUI Color
/// - Throws: ColorEncodingError if decoding fails
public func platformColorDecode(_ data: Data) throws -> Color {
    #if os(iOS)
    return try decodeUIColor(data)
    #elseif os(macOS)
    return try decodeNSColor(data)
    #else
    throw ColorEncodingError.platformNotSupported
    #endif
}

// MARK: - iOS Color Encoding

#if os(iOS)
/// Encode a SwiftUI Color to UIColor data
private func encodeUIColor(_ color: Color) throws -> Data {
    do {
        let uiColor = UIColor(color)
        let data = try NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: true)
        return data
    } catch {
        throw ColorEncodingError.encodingFailed(error)
    }
}

/// Decode a UIColor from data
private func decodeUIColor(_ data: Data) throws -> Color {
    do {
        guard let uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            throw ColorEncodingError.invalidColorData
        }
        return Color(uiColor)
    } catch {
        throw ColorEncodingError.decodingFailed(error)
    }
}
#endif

// MARK: - macOS Color Encoding

#if os(macOS)
/// Encode a SwiftUI Color to NSColor data
private func encodeNSColor(_ color: Color) throws -> Data {
    do {
        let nsColor = NSColor(color)
        let data = try NSKeyedArchiver.archivedData(withRootObject: nsColor, requiringSecureCoding: true)
        return data
    } catch {
        throw ColorEncodingError.encodingFailed(error)
    }
}

/// Decode an NSColor from data
private func decodeNSColor(_ data: Data) throws -> Color {
    do {
        guard let nsColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data) else {
            throw ColorEncodingError.invalidColorData
        }
        return Color(nsColor)
    } catch {
        throw ColorEncodingError.decodingFailed(error)
    }
}
#endif

// MARK: - Color Encoding Utilities

/// Check if color encoding is supported on the current platform
/// - Returns: True if color encoding is supported, false otherwise
public func isColorEncodingSupported() -> Bool {
    #if os(iOS) || os(macOS)
    return true
    #else
    return false
    #endif
}

/// Get platform-specific information about color encoding
/// - Returns: Platform information including support status and capabilities
public func getColorEncodingInfo() -> ColorEncodingInfo {
    #if os(iOS)
    return ColorEncodingInfo(
        platform: "iOS",
        isSupported: true,
        supportedColorTypes: ["UIColor"],
        encodingFormat: "NSKeyedArchiver",
        minVersion: "iOS 11.0"
    )
    #elseif os(macOS)
    return ColorEncodingInfo(
        platform: "macOS",
        isSupported: true,
        supportedColorTypes: ["NSColor"],
        encodingFormat: "NSKeyedArchiver",
        minVersion: "macOS 10.13"
    )
    #else
    return ColorEncodingInfo(
        platform: "Unknown",
        isSupported: false,
        supportedColorTypes: [],
        encodingFormat: "None",
        minVersion: "N/A"
    )
    #endif
}

// MARK: - Color Encoding Info

/// Information about color encoding capabilities on the current platform
public struct ColorEncodingInfo {
    public let platform: String
    public let isSupported: Bool
    public let supportedColorTypes: [String]
    public let encodingFormat: String
    public let minVersion: String
    
    public init(platform: String, isSupported: Bool, supportedColorTypes: [String], encodingFormat: String, minVersion: String) {
        self.platform = platform
        self.isSupported = isSupported
        self.supportedColorTypes = supportedColorTypes
        self.encodingFormat = encodingFormat
        self.minVersion = minVersion
    }
}

// MARK: - Color Encoding Validation

/// Validate that a color can be encoded successfully
/// - Parameter color: The color to validate
/// - Returns: True if the color can be encoded, false otherwise
public func validateColorEncoding(_ color: Color) -> Bool {
    do {
        _ = try platformColorEncode(color)
        return true
    } catch {
        return false
    }
}

/// Get detailed validation information for color encoding
/// - Parameter color: The color to validate
/// - Returns: Validation result with details
public func validateColorEncodingDetailed(_ color: Color) -> ColorValidationResult {
    do {
        let encodedData = try platformColorEncode(color)
        let _ = try platformColorDecode(encodedData)
        
        return ColorValidationResult(
            isValid: true,
            canEncode: true,
            canDecode: true,
            encodedDataSize: encodedData.count,
            error: nil
        )
    } catch {
        return ColorValidationResult(
            isValid: false,
            canEncode: false,
            canDecode: false,
            encodedDataSize: 0,
            error: error
        )
    }
}

// MARK: - Color Validation Result

/// Result of color encoding validation
public struct ColorValidationResult {
    public let isValid: Bool
    public let canEncode: Bool
    public let canDecode: Bool
    public let encodedDataSize: Int
    public let error: Error?
    
    public init(isValid: Bool, canEncode: Bool, canDecode: Bool, encodedDataSize: Int, error: Error?) {
        self.isValid = isValid
        self.canEncode = canEncode
        self.canDecode = canDecode
        self.encodedDataSize = encodedDataSize
        self.error = error
    }
}
