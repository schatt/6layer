import Foundation
import CoreLocation
import CoreData
import SwiftUI

// MARK: - Location Trend

/// Represents location trends over time
public struct LocationTrend {
    public let date: Date
    public let locationCount: Int
    public let totalDistance: CLLocationDistance
    public let averageAccuracy: Double
    
    public init(
        date: Date,
        locationCount: Int,
        totalDistance: CLLocationDistance,
        averageAccuracy: Double
    ) {
        self.date = date
        self.locationCount = locationCount
        self.totalDistance = totalDistance
        self.averageAccuracy = averageAccuracy
    }
    
    // MARK: - Computed Properties
    
    /// Formatted date
    public var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    /// Day of week
    public var dayOfWeek: DayOfWeek {
        return DayOfWeek.from(date: date)
    }
    
    /// Time of day (using noon as representative)
    public var timeOfDay: TimeOfDay {
        let noon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: date) ?? date
        return TimeOfDay.from(date: noon)
    }
    
    /// Formatted total distance
    public var formattedTotalDistance: String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .naturalScale
        formatter.unitStyle = .medium
        
        if Locale.current.measurementSystem == .metric {
            let measurement = Measurement(value: totalDistance, unit: UnitLength.meters)
            return formatter.string(from: measurement)
        } else {
            let measurement = Measurement(value: totalDistance / 1609.344, unit: UnitLength.miles)
            return formatter.string(from: measurement)
        }
    }
    
    /// Formatted average accuracy
    public var formattedAverageAccuracy: String {
        if averageAccuracy <= 0 {
            return "Unknown"
        } else if averageAccuracy <= 5 {
            return "High (±\(String(format: "%.1f", averageAccuracy))m)"
        } else if averageAccuracy <= 20 {
            return "Medium (±\(String(format: "%.1f", averageAccuracy))m)"
        } else {
            return "Low (±\(String(format: "%.1f", averageAccuracy))m)"
        }
    }
    
    /// Activity level for this day
    public var activityLevel: ActivityLevel {
        switch locationCount {
        case 0:
            return .none
        case 1..<3:
            return .low
        case 3..<10:
            return .moderate
        case 10..<20:
            return .high
        default:
            return .veryHigh
        }
    }
    
    /// Data quality level for this day
    public var dataQualityLevel: AccuracyLevel {
        return AccuracyLevel.from(accuracy: averageAccuracy)
    }
    
    /// Check if this day has any activity
    public var hasActivity: Bool {
        return locationCount > 0
    }
    
    /// Check if this day has good data quality
    public var hasGoodDataQuality: Bool {
        return averageAccuracy > 0 && averageAccuracy <= 20
    }
}

// MARK: - Trend Analysis

/// Helper methods for analyzing location trends
public extension Array where Element == LocationTrend {
    
    /// Analyze location count trends over the last 7 days
    var locationCountTrend: TrendDirection {
        guard count >= 2 else { return .stable }
        
        let recent = Array(suffix(Swift.min(7, count))) // Last 7 days or less
        let older = Array(prefix(Swift.max(0, count - 7))) // Days before that
        
        guard !recent.isEmpty && !older.isEmpty else { return .stable }
        
        let recentCounts = recent.map { Double($0.locationCount) }
        let olderCounts = older.map { Double($0.locationCount) }
        let recentAvg = recentCounts.reduce(0, +) / Double(recent.count)
        let olderAvg = olderCounts.reduce(0, +) / Double(older.count)
        
        let change = recentAvg - olderAvg
        let threshold = olderAvg * 0.1 // 10% change threshold
        
        if change > threshold { return .increasing }
        if change < -threshold { return .decreasing }
        return .stable
    }
    
    /// Analyze distance trends over the last 7 days
    var distanceTrend: TrendDirection {
        guard count >= 2 else { return .stable }
        
        let recent = Array(suffix(Swift.min(7, count))) // Last 7 days or less
        let older = Array(prefix(Swift.max(0, count - 7))) // Days before that
        
        guard !recent.isEmpty && !older.isEmpty else { return .stable }
        
        let recentDistances = recent.map { $0.totalDistance }
        let olderDistances = older.map { $0.totalDistance }
        let recentAvg = recentDistances.reduce(0, +) / Double(recent.count)
        let olderAvg = olderDistances.reduce(0, +) / Double(older.count)
        
        let change = recentAvg - olderAvg
        let threshold = olderAvg * 0.1 // 10% change threshold
        
        if change > threshold { return .increasing }
        if change < -threshold { return .decreasing }
        return .stable
    }
    
    /// Analyze accuracy trends over the last 7 days
    var accuracyTrend: TrendDirection {
        guard count >= 2 else { return .stable }
        
        let recent = Array(suffix(Swift.min(7, count))) // Last 7 days or less
        let older = Array(prefix(Swift.max(0, count - 7))) // Days before that
        
        guard !recent.isEmpty && !older.isEmpty else { return .stable }
        
        let recentAccuracies = recent.map { $0.averageAccuracy }
        let olderAccuracies = older.map { $0.averageAccuracy }
        let recentAvg = recentAccuracies.reduce(0, +) / Double(recent.count)
        let olderAvg = olderAccuracies.reduce(0, +) / Double(older.count)
        
        // Lower accuracy values are better, so we invert the logic
        let change = olderAvg - recentAvg
        let threshold = olderAvg * 0.1 // 10% change threshold
        
        if change > threshold { return .improving }
        if change < -threshold { return .declining }
        return .stable
    }
    
    /// Get the most active day
    var mostActiveDay: DayOfWeek? {
        let dayGroups = Dictionary(grouping: self) { $0.dayOfWeek }
        return dayGroups.max(by: { $0.value.count < $1.value.count })?.key
    }
    
    /// Get the most active time period
    var mostActiveTime: TimeOfDay? {
        let timeGroups = Dictionary(grouping: self) { $0.timeOfDay }
        return timeGroups.max(by: { $0.value.count < $1.value.count })?.key
    }
    
    /// Get the total distance over the trend period
    var totalDistance: CLLocationDistance {
        return reduce(0) { $0 + $1.totalDistance }
    }
    
    /// Get the average daily distance
    var averageDailyDistance: CLLocationDistance {
        guard !isEmpty else { return 0 }
        return totalDistance / Double(count)
    }
    
    /// Get the total location count over the trend period
    var totalLocationCount: Int {
        return reduce(0) { $0 + $1.locationCount }
    }
    
    /// Get the average daily location count
    var averageDailyLocationCount: Double {
        guard !isEmpty else { return 0 }
        return Double(totalLocationCount) / Double(count)
    }
}

// MARK: - Trend Direction

/// Represents the direction of a trend
public enum TrendDirection: String, CaseIterable {
    case increasing = "Increasing"
    case decreasing = "Decreasing"
    case stable = "Stable"
    case improving = "Improving"
    case declining = "Declining"
    
    /// Icon name for the trend direction
    public var iconName: String {
        switch self {
        case .increasing, .improving:
            return "arrow.up.circle.fill"
        case .decreasing, .declining:
            return "arrow.down.circle.fill"
        case .stable:
            return "arrow.right.circle.fill"
        }
    }
    
    /// Color representation for the trend direction
    public var colorName: String {
        switch self {
        case .increasing, .improving:
            return "green"
        case .decreasing, .declining:
            return "red"
        case .stable:
            return "blue"
        }
    }
}
