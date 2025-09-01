import Foundation
import CoreLocation
import CoreData
import SwiftUI

// MARK: - Location Statistics

/// Comprehensive statistics about location data for a vehicle
public struct LocationStatistics {
    public let totalLocations: Int
    public let gpsLocations: Int
    public let wifiLocations: Int
    public let cellularLocations: Int
    public let manualLocations: Int
    public let averageAccuracy: Double
    public let totalDistance: CLLocationDistance
    
    public init(
        totalLocations: Int = 0,
        gpsLocations: Int = 0,
        wifiLocations: Int = 0,
        cellularLocations: Int = 0,
        manualLocations: Int = 0,
        averageAccuracy: Double = 0.0,
        totalDistance: CLLocationDistance = 0.0
    ) {
        self.totalLocations = totalLocations
        self.gpsLocations = gpsLocations
        self.wifiLocations = wifiLocations
        self.cellularLocations = cellularLocations
        self.manualLocations = manualLocations
        self.averageAccuracy = averageAccuracy
        self.totalDistance = totalDistance
    }
    
    // MARK: - Computed Properties
    
    /// Percentage of GPS locations
    public var gpsPercentage: Double {
        guard totalLocations > 0 else { return 0.0 }
        return Double(gpsLocations) / Double(totalLocations) * 100.0
    }
    
    /// Percentage of WiFi locations
    public var wifiPercentage: Double {
        guard totalLocations > 0 else { return 0.0 }
        return Double(wifiLocations) / Double(totalLocations) * 100.0
    }
    
    /// Percentage of cellular locations
    public var cellularPercentage: Double {
        guard totalLocations > 0 else { return 0.0 }
        return Double(cellularLocations) / Double(totalLocations) * 100.0
    }
    
    /// Percentage of manual locations
    public var manualPercentage: Double {
        guard totalLocations > 0 else { return 0.0 }
        return Double(manualLocations) / Double(totalLocations) * 100.0
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
    
    /// Data quality score (0-100)
    public var dataQualityScore: Int {
        var score = 0
        
        // GPS locations get highest score
        score += gpsLocations * 10
        
        // WiFi locations get medium score
        score += wifiLocations * 6
        
        // Cellular locations get lower score
        score += cellularLocations * 3
        
        // Manual locations get lowest score
        score += manualLocations * 1
        
        // Normalize to 0-100 scale
        let maxPossibleScore = totalLocations * 10
        guard maxPossibleScore > 0 else { return 0 }
        
        return min(100, Int((Double(score) / Double(maxPossibleScore)) * 100.0))
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
}
