import CoreData
import Foundation
import SwiftUI

extension MaintenanceRecord {
    var wrappedTitle: String {
        title ?? "Maintenance"
    }

    var formattedDate: String {
        guard let date = date else { return "Unknown date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    var formattedOdometer: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: odometer)) ?? "0"
    }

    var totalCost: Double {
        let items = lineItemsArray
        return items.reduce(0) { $0 + $1.cost }
    }

    var formattedTotalCost: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: totalCost)) ?? "$0.00"
    }

    var monthYear: String {
        guard let date = date else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }

    var lineItemsArray: [MaintenanceLineItem] {
        let set = lineItems as? Set<MaintenanceLineItem> ?? []
        return set.sorted(by: { ($0.itemDescription ?? "") < ($1.itemDescription ?? "") })
    }

    // Helper method to get maintenance records grouped by month
    static func groupByMonth(records: [MaintenanceRecord]) -> [String: [MaintenanceRecord]] {
        var groupedRecords: [String: [MaintenanceRecord]] = [:]

        for record in records {
            guard let date = record.date else { continue }

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM"
            let monthKey = formatter.string(from: date)

            if groupedRecords[monthKey] == nil {
                groupedRecords[monthKey] = []
            }

            groupedRecords[monthKey]?.append(record)
        }

        return groupedRecords
    }

    // Helper method to get maintenance records grouped by type
    static func groupByType(records: [MaintenanceRecord]) -> [String: [MaintenanceRecord]] {
        var groupedRecords: [String: [MaintenanceRecord]] = [:]

        for record in records {
            let title = record.wrappedTitle

            if groupedRecords[title] == nil {
                groupedRecords[title] = []
            }

            groupedRecords[title]?.append(record)
        }

        return groupedRecords
    }

    // Helper method to calculate total cost
    static func calculateTotalCost(records: [MaintenanceRecord]) -> Double {
        return records.reduce(0) { $0 + $1.totalCost }
    }

    // Helper method to calculate average cost
    static func calculateAverageCost(records: [MaintenanceRecord]) -> Double {
        guard !records.isEmpty else { return 0 }
        return calculateTotalCost(records: records) / Double(records.count)
    }
}

extension MaintenanceLineItem {
    var formattedCost: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: cost)) ?? "$0.00"
    }

    var formattedWarranty: String {
        var parts: [String] = []

        if warrantyMonths > 0 {
            parts.append("\(warrantyMonths) months")
        }

        if warrantyMiles > 0 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            if let miles = formatter.string(from: NSNumber(value: warrantyMiles)) {
                parts.append("\(miles) miles")
            }
        }

        if let expirationDate = warrantyExpirationDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            parts.append("until \(formatter.string(from: expirationDate))")
        }

        return parts.isEmpty ? "No warranty" : parts.joined(separator: ", ")
    }

    var isWarrantyValid: Bool {
        if let expirationDate = warrantyExpirationDate {
            return expirationDate > Date()
        }
        return warrantyMonths > 0 || warrantyMiles > 0
    }

    var categoryName: String {
        category?.name ?? "Uncategorized"
    }
}

extension MaintenanceCategory {
    var wrappedName: String {
        name ?? "Uncategorized"
    }

    var lineItemsArray: [MaintenanceLineItem] {
        let set = lineItems as? Set<MaintenanceLineItem> ?? []
        return set.sorted(by: { ($0.itemDescription ?? "") < ($1.itemDescription ?? "") })
    }

    static func createDefaultCategories(in context: NSManagedObjectContext) {
        let categories = [
            "Parts","Labor","Tax","Fluids","Tires","Brakes","Electrical","Body","Other"
        ]

        var didChange = false
        for name in categories {
            let req: NSFetchRequest<MaintenanceCategory> = MaintenanceCategory.fetchRequest()
            req.predicate = NSPredicate(format: "name ==[c] %@", name)
            req.fetchLimit = 1
            let existing = try? context.fetch(req).first

            if let cat = existing {
                if cat.name != name { cat.name = name; didChange = true }
                if cat.isDefault == false { cat.isDefault = true; didChange = true }
            } else {
                let cat = MaintenanceCategory(context: context)
                cat.id = UUID()
                cat.name = name
                cat.isDefault = true
                didChange = true
            }
        }

        if didChange {
            do { try context.save() } catch { print("Error saving default maintenance categories: \(error)") }
        }
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let addMaintenanceRecord = Notification.Name("addMaintenanceRecord")
    static let maintenanceRecordAdded = Notification.Name("maintenanceRecordAdded")
    static let maintenanceRecordUpdated = Notification.Name("maintenanceRecordUpdated")
    static let maintenanceRecordDeleted = Notification.Name("maintenanceRecordDeleted")
}
