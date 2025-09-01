import Foundation
import CoreLocation
import CoreData
import SwiftUI

// MARK: - Location Type Enum

/// Represents the type of location data source
public enum LocationType: String, CaseIterable, Codable {
    case gps = "GPS"
    case wifi = "WiFi"
    case cellular = "Cellular"
    case manual = "Manual"
    case unknown = "Unknown"
    
    /// Human-readable description of the location type
    public var description: String {
        switch self {
        case .gps:
            return "GPS Location"
        case .wifi:
            return "WiFi Location"
        case .cellular:
            return "Cellular Location"
        case .manual:
            return "Manual Entry"
        case .unknown:
            return "Unknown Type"
        }
    }
    
    /// Icon name for the location type
    public var iconName: String {
        switch self {
        case .gps:
            return "location.circle.fill"
        case .wifi:
            return "wifi"
        case .cellular:
            return "antenna.radiowaves.left.and.right"
        case .manual:
            return "hand.point.up"
        case .unknown:
            return "questionmark.circle"
        }
    }
    
    /// Accuracy level associated with this location type
    public var typicalAccuracy: Double {
        switch self {
        case .gps:
            return 5.0 // 5 meters
        case .wifi:
            return 20.0 // 20 meters
        case .cellular:
            return 100.0 // 100 meters
        case .manual:
            return 0.0 // Unknown accuracy
        case .unknown:
            return 0.0 // Unknown accuracy
        }
    }
    
    /// Initialize from a string value
    public init(from string: String?) {
        if let string = string, let type = LocationType(rawValue: string) {
            self = type
        } else {
            self = .unknown
        }
    }
}
