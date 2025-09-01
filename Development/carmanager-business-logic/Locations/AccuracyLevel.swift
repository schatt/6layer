import Foundation
import CoreLocation
import CoreData
import SwiftUI

// MARK: - Accuracy Level

/// Represents different levels of location accuracy
public enum AccuracyLevel: String, CaseIterable, Codable {
    case unknown = "Unknown"
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    case veryLow = "Very Low"
    
    /// Human-readable description of the accuracy level
    public var description: String {
        switch self {
        case .unknown:
            return "Unknown Accuracy"
        case .high:
            return "High Accuracy (±5m)"
        case .medium:
            return "Medium Accuracy (±20m)"
        case .low:
            return "Low Accuracy (±100m)"
        case .veryLow:
            return "Very Low Accuracy (>100m)"
        }
    }
    
    /// Icon name for the accuracy level
    public var iconName: String {
        switch self {
        case .unknown:
            return "questionmark.circle"
        case .high:
            return "checkmark.circle.fill"
        case .medium:
            return "checkmark.circle"
        case .low:
            return "exclamationmark.circle"
        case .veryLow:
            return "xmark.circle"
        }
    }
    
    /// Color representation for the accuracy level
    public var colorName: String {
        switch self {
        case .unknown:
            return "secondary"
        case .high:
            return "green"
        case .medium:
            return "blue"
        case .low:
            return "orange"
        case .veryLow:
            return "red"
        }
    }
    
    /// Maximum accuracy value for this level
    public var maxAccuracy: Double {
        switch self {
        case .unknown:
            return 0.0
        case .high:
            return 5.0
        case .medium:
            return 20.0
        case .low:
            return 100.0
        case .veryLow:
            return Double.greatestFiniteMagnitude
        }
    }
    
    /// Minimum accuracy value for this level
    public var minAccuracy: Double {
        switch self {
        case .unknown:
            return 0.0
        case .high:
            return 0.0
        case .medium:
            return 5.0
        case .low:
            return 20.0
        case .veryLow:
            return 100.0
        }
    }
    
    /// Create accuracy level from accuracy value
    public static func from(accuracy: Double) -> AccuracyLevel {
        if accuracy <= 0 {
            return .unknown
        } else if accuracy <= 5 {
            return .high
        } else if accuracy <= 20 {
            return .medium
        } else if accuracy <= 100 {
            return .low
        } else {
            return .veryLow
        }
    }
    
    /// Check if a location meets this accuracy level
    public func isMet(by accuracy: Double) -> Bool {
        if self == .unknown {
            return accuracy <= 0
        } else if self == .veryLow {
            return accuracy > 100
        } else {
            return accuracy >= minAccuracy && accuracy <= maxAccuracy
        }
    }
}
