import Foundation
import CoreLocation
import SwiftUI

// MARK: - Time of Day

/// Represents different periods of the day
public enum TimeOfDay: String, CaseIterable, Codable {
    case earlyMorning = "Early Morning"
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case night = "Night"
    case lateNight = "Late Night"
    
    /// Human-readable description of the time period
    public var description: String {
        return rawValue
    }
    
    /// Icon name for the time period
    public var iconName: String {
        switch self {
        case .earlyMorning:
            return "sunrise"
        case .morning:
            return "sun.max"
        case .afternoon:
            return "sun.max.fill"
        case .evening:
            return "sunset"
        case .night:
            return "moon"
        case .lateNight:
            return "moon.stars"
        }
    }
    
    /// Color representation for the time period
    public var colorName: String {
        switch self {
        case .earlyMorning:
            return "orange"
        case .morning:
            return "yellow"
        case .afternoon:
            return "yellow"
        case .evening:
            return "orange"
        case .night:
            return "blue"
        case .lateNight:
            return "purple"
        }
    }
    
    /// Start hour for this time period (24-hour format)
    public var startHour: Int {
        switch self {
        case .earlyMorning:
            return 5
        case .morning:
            return 8
        case .afternoon:
            return 12
        case .evening:
            return 17
        case .night:
            return 20
        case .lateNight:
            return 23
        }
    }
    
    /// End hour for this time period (24-hour format)
    public var endHour: Int {
        switch self {
        case .earlyMorning:
            return 7
        case .morning:
            return 11
        case .afternoon:
            return 16
        case .evening:
            return 19
        case .night:
            return 22
        case .lateNight:
            return 4
        }
    }
    
    /// Create time of day from a date
    public static func from(date: Date) -> TimeOfDay {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        switch hour {
        case 5..<8:
            return .earlyMorning
        case 8..<12:
            return .morning
        case 12..<17:
            return .afternoon
        case 17..<20:
            return .evening
        case 20..<23:
            return .night
        case 23, 0..<5:
            return .lateNight
        default:
            return .morning
        }
    }
    
    /// Check if a given hour falls within this time period
    public func contains(hour: Int) -> Bool {
        if startHour <= endHour {
            return hour >= startHour && hour <= endHour
        } else {
            // Handles late night period that spans midnight
            return hour >= startHour || hour <= endHour
        }
    }
}
