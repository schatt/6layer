import CoreData
import Foundation
import SwiftUI

extension FuelPurchase {
    var cost: Double {
        return totalCost
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

    var formattedGallons: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        return formatter.string(from: NSNumber(value: gallons)) ?? "0"
    }

    var formattedPricePerGallon: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: pricePerGallon)) ?? "$0.00"
    }

    var formattedTotalCost: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: totalCost)) ?? "$0.00"
    }

    var formattedMPG: String {
        if milesPerGallon <= 0 {
            return "N/A"
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: milesPerGallon)) ?? "0"
    }

    var monthYear: String {
        guard let date = date else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }

    var previousOdometer: Double? {
        guard let vehicle = self.vehicle, let date = self.date else { return nil }
        let previous = vehicle.fuelPurchasesArray
            .filter { $0 != self && $0.date != nil && $0.date! < date }
            .sorted { $0.date! > $1.date! }
            .first
        return previous?.odometer
    }

    // Helper method to get fuel purchases grouped by month
    static func groupByMonth(fuelPurchases: [FuelPurchase]) -> [String: [FuelPurchase]] {
        var groupedPurchases: [String: [FuelPurchase]] = [:]

        for purchase in fuelPurchases {
            guard let date = purchase.date else { continue }

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM"
            let monthKey = formatter.string(from: date)

            if groupedPurchases[monthKey] == nil {
                groupedPurchases[monthKey] = []
            }

            groupedPurchases[monthKey]?.append(purchase)
        }

        return groupedPurchases
    }

    // Helper method to calculate average MPG
    static func calculateAverageMPG(fuelPurchases: [FuelPurchase]) -> Double {
        let validPurchases = fuelPurchases.filter { $0.milesPerGallon > 0 && $0.gallons > 0 }
        guard validPurchases.count >= 2 else { return 0 }
        
        // Sort purchases by date to ensure proper order
        let sortedPurchases = validPurchases.sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
        
        // Calculate total miles and total gallons
        var totalMiles: Double = 0
        var totalGallons: Double = 0
        
        for i in 1..<sortedPurchases.count {
            let current = sortedPurchases[i]
            let previous = sortedPurchases[i-1]
            
            // Calculate miles driven between this fillup and the previous one
            let miles = current.odometer - previous.odometer
            if miles > 0 {
                totalMiles += miles
                totalGallons += current.gallons
            }
        }
        
        // Return total miles per total gallons (the correct way to calculate average MPG)
        return totalGallons > 0 ? totalMiles / totalGallons : 0
    }

    // Helper method to calculate total cost
    static func calculateTotalCost(fuelPurchases: [FuelPurchase]) -> Double {
        return fuelPurchases.reduce(0) { $0 + $1.totalCost }
    }

    // Helper method to calculate total gallons
    static func calculateTotalGallons(fuelPurchases: [FuelPurchase]) -> Double {
        return fuelPurchases.reduce(0) { $0 + $1.gallons }
    }

    func recalculateMPG() {
        guard let previousOdometer = self.previousOdometer, self.gallons > 0 else {
            self.milesPerGallon = 0
            return
        }
        let miles = self.odometer - previousOdometer
        self.milesPerGallon = miles > 0 ? miles / self.gallons : 0
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let addFuelPurchase = Notification.Name("addFuelPurchase")
    static let fuelPurchaseAdded = Notification.Name("fuelPurchaseAdded")
    static let fuelPurchaseUpdated = Notification.Name("fuelPurchaseUpdated")
    static let fuelPurchaseDeleted = Notification.Name("fuelPurchaseDeleted")
}
