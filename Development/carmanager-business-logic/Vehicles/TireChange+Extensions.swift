import CoreData
import Foundation

extension TireChange {
    // MARK: - Computed Properties
    
    var displayName: String {
        let fromName = fromTireSet?.displayName ?? "Unknown"
        let toName = toTireSet?.displayName ?? "None"
        return "\(fromName) → \(toName)"
    }
    
    var formattedDate: String {
        guard let date = date else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var formattedOdometer: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: odometer)) ?? "0"
    }
    
    var changeType: String {
        if toTireSet == nil {
            return "Removal"
        } else if fromTireSet == nil {
            return "Installation"
        } else {
            return "Change"
        }
    }
} 