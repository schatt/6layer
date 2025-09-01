import CoreData
import Foundation

extension TireSet {
    // MARK: - Computed Properties for Relationship Arrays
    
    var fromTireChangesArray: [TireChange] {
        (fromTireChanges as? Set<TireChange>)?.sorted { ($0.date ?? .distantPast) < ($1.date ?? .distantPast) } ?? []
    }
    
    var toTireChangesArray: [TireChange] {
        (toTireChanges as? Set<TireChange>)?.sorted { ($0.date ?? .distantPast) < ($1.date ?? .distantPast) } ?? []
    }
    
    // MARK: - Computed Properties
    
    var displayName: String {
        let brand = self.brand?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let model = self.model?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let size = self.size?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        var components: [String] = []
        if !brand.isEmpty { components.append(brand) }
        if !model.isEmpty { components.append(model) }
        if !size.isEmpty { components.append(size) }
        
        if components.isEmpty {
            return name ?? "Unnamed Tire Set"
        }
        
        return components.joined(separator: " ")
    }
    
    var formattedInstallationDate: String {
        guard let date = installationDate else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var formattedCurrentMileage: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: currentMileage)) ?? "0"
    }
    
    var formattedTotalMileage: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: totalMileage)) ?? "0"
    }
    
    var isWarrantyExpired: Bool {
        guard let installationDate = installationDate else { return false }
        
        let now = Date()
        let warrantyEndDate = Calendar.current.date(byAdding: .year, value: 6, to: installationDate) ?? now
        
        return now > warrantyEndDate || totalMileage > warrantyMiles
    }
    
    var warrantyStatus: String {
        if isWarrantyExpired {
            return "Expired"
        } else {
            return "Active"
        }
    }
} 