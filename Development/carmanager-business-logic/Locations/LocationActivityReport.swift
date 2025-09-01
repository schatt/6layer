import Foundation
import CoreLocation
import CoreData
import SwiftUI

// MARK: - Location Activity Report

/// Comprehensive activity report for vehicle locations
public struct LocationActivityReport {
    public let vehicle: Vehicle
    public let totalLocations: Int
    public let totalDistance: CLLocationDistance
    public let averageAccuracy: Double
    public let timeOfDayDistribution: [TimeOfDay: [Location]]
    public let dayOfWeekDistribution: [DayOfWeek: [Location]]
    public let accuracyDistribution: [AccuracyLevel: [Location]]
    public let mostActiveTime: TimeOfDay?
    public let mostActiveDay: DayOfWeek?
    
    public init(
        vehicle: Vehicle = Vehicle(),
        totalLocations: Int = 0,
        totalDistance: CLLocationDistance = 0.0,
        averageAccuracy: Double = 0.0,
        timeOfDayDistribution: [TimeOfDay: [Location]] = [:],
        dayOfWeekDistribution: [DayOfWeek: [Location]] = [:],
        accuracyDistribution: [AccuracyLevel: [Location]] = [:],
        mostActiveTime: TimeOfDay? = nil,
        mostActiveDay: DayOfWeek? = nil
    ) {
        self.vehicle = vehicle
        self.totalLocations = totalLocations
        self.totalDistance = totalDistance
        self.averageAccuracy = averageAccuracy
        self.timeOfDayDistribution = timeOfDayDistribution
        self.dayOfWeekDistribution = dayOfWeekDistribution
        self.accuracyDistribution = accuracyDistribution
        self.mostActiveTime = mostActiveTime
        self.mostActiveDay = mostActiveDay
    }
    
    // MARK: - Computed Properties
    
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
    
    /// Activity level based on total locations
    public var activityLevel: ActivityLevel {
        switch totalLocations {
        case 0:
            return .none
        case 1..<10:
            return .low
        case 10..<50:
            return .moderate
        case 50..<100:
            return .high
        default:
            return .veryHigh
        }
    }
    
    /// Data quality score based on accuracy distribution
    public var dataQualityScore: Int {
        var score = 0
        let total = accuracyDistribution.values.flatMap { $0 }.count
        
        guard total > 0 else { return 0 }
        
        for (level, locations) in accuracyDistribution {
            switch level {
            case .high:
                score += locations.count * 10
            case .medium:
                score += locations.count * 6
            case .low:
                score += locations.count * 3
            case .veryLow:
                score += locations.count * 1
            case .unknown:
                score += locations.count * 0
            }
        }
        
        return min(100, Int((Double(score) / Double(total * 10)) * 100.0))
    }
    
    /// Data quality description
    public var dataQualityDescription: String {
        let score = dataQualityScore
        
        switch score {
        case 80...100:
            return "Excellent"
        case 60..<80:
            return "Good"
        case 40..<60:
            return "Fair"
        case 20..<40:
            return "Poor"
        default:
            return "Very Poor"
        }
    }
    
    /// Most common location type
    public var mostCommonLocationType: LocationType? {
        var typeCounts: [LocationType: Int] = [:]
        
        for locations in timeOfDayDistribution.values {
            for location in locations {
                let type = location.locationTypeEnum
                typeCounts[type, default: 0] += 1
            }
        }
        
        return typeCounts.max(by: { $0.value < $1.value })?.key
    }
    
    /// Coverage area in square meters
    public var coverageArea: Double {
        let allLocations = timeOfDayDistribution.values.flatMap { $0 }
        return Location.calculateCoverageArea(for: allLocations)
    }
    
    /// Formatted coverage area
    public var formattedCoverageArea: String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .naturalScale
        formatter.unitStyle = .medium
        
        if Locale.current.measurementSystem == .metric {
            let measurement = Measurement(value: coverageArea, unit: UnitArea.squareMeters)
            return formatter.string(from: measurement)
        } else {
            let measurement = Measurement(value: coverageArea / 4046.86, unit: UnitArea.acres)
            return formatter.string(from: measurement)
        }
    }
}

// MARK: - Activity Level

/// Represents the level of location activity
public enum ActivityLevel: String, CaseIterable {
    case none = "None"
    case low = "Low"
    case moderate = "Moderate"
    case high = "High"
    case veryHigh = "Very High"
    
    /// Color representation for the activity level
    public var colorName: String {
        switch self {
        case .none:
            return "gray"
        case .low:
            return "blue"
        case .moderate:
            return "green"
        case .high:
            return "orange"
        case .veryHigh:
            return "red"
        }
    }
    
    /// Icon name for the activity level
    public var iconName: String {
        switch self {
        case .none:
            return "circle.slash"
        case .low:
            return "1.circle"
        case .moderate:
            return "2.circle"
        case .high:
            return "3.circle"
        case .veryHigh:
            return "exclamationmark.triangle"
        }
    }
}
