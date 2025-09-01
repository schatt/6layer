import Foundation
import CoreLocation
import SwiftUI

// MARK: - Day of Week

/// Represents days of the week
public enum DayOfWeek: String, CaseIterable, Codable {
    case sunday = "Sunday"
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    
    /// Human-readable description of the day
    public var description: String {
        return rawValue
    }
    
    /// Short abbreviation of the day
    public var shortName: String {
        switch self {
        case .sunday:
            return "Sun"
        case .monday:
            return "Mon"
        case .tuesday:
            return "Tue"
        case .wednesday:
            return "Wed"
        case .thursday:
            return "Thu"
        case .friday:
            return "Fri"
        case .saturday:
            return "Sat"
        }
    }
    
    /// Very short abbreviation of the day
    public var veryShortName: String {
        switch self {
        case .sunday:
            return "S"
        case .monday:
            return "M"
        case .tuesday:
            return "T"
        case .wednesday:
            return "W"
        case .thursday:
            return "T"
        case .friday:
            return "F"
        case .saturday:
            return "S"
        }
    }
    
    /// Icon name for the day
    public var iconName: String {
        switch self {
        case .sunday:
            return "sun.max"
        case .monday:
            return "1.circle"
        case .tuesday:
            return "2.circle"
        case .wednesday:
            return "3.circle"
        case .thursday:
            return "4.circle"
        case .friday:
            return "5.circle"
        case .saturday:
            return "6.circle"
        }
    }
    
    /// Color representation for the day
    public var colorName: String {
        switch self {
        case .sunday:
            return "red"
        case .monday:
            return "blue"
        case .tuesday:
            return "green"
        case .wednesday:
            return "purple"
        case .thursday:
            return "orange"
        case .friday:
            return "pink"
        case .saturday:
            return "indigo"
        }
    }
    
    /// Calendar weekday value (1 = Sunday, 2 = Monday, etc.)
    public var weekdayValue: Int {
        switch self {
        case .sunday:
            return 1
        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wednesday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        }
    }
    
    /// Check if this is a weekend day
    public var isWeekend: Bool {
        return self == .saturday || self == .sunday
    }
    
    /// Check if this is a weekday
    public var isWeekday: Bool {
        return !isWeekend
    }
    
    /// Create day of week from a date
    public static func from(date: Date) -> DayOfWeek {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        
        switch weekday {
        case 1:
            return .sunday
        case 2:
            return .monday
        case 3:
            return .tuesday
        case 4:
            return .wednesday
        case 5:
            return .thursday
        case 6:
            return .friday
        case 7:
            return .saturday
        default:
            return .monday
        }
    }
    
    /// Get the next day
    public var next: DayOfWeek {
        switch self {
        case .sunday:
            return .monday
        case .monday:
            return .tuesday
        case .tuesday:
            return .wednesday
        case .wednesday:
            return .thursday
        case .thursday:
            return .friday
        case .friday:
            return .saturday
        case .saturday:
            return .sunday
        }
    }
    
    /// Get the previous day
    public var previous: DayOfWeek {
        switch self {
        case .sunday:
            return .saturday
        case .monday:
            return .sunday
        case .tuesday:
            return .monday
        case .wednesday:
            return .tuesday
        case .thursday:
            return .wednesday
        case .friday:
            return .thursday
        case .saturday:
            return .friday
        }
    }
}
