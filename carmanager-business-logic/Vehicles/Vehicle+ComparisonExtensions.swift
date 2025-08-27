import CoreData
import Foundation

extension Vehicle {
    // MARK: - Cost Calculations

    var totalCost: Double {
        return purchasePrice + totalFuelCost + totalMaintenanceCost + totalOtherExpenses
    }

    var totalOtherExpenses: Double {
        return expensesArray.reduce(into: 0) { result, expense in
            result += expense.amount
        }
    }

    var fuelCostPerMile: Double {
        let milesDriven = currentOdometer - Double(initialOdometer)
        return milesDriven > 0 ? totalFuelCost / milesDriven : 0
    }

    var maintenanceCostPerMile: Double {
        let milesDriven = currentOdometer - Double(initialOdometer)
        return milesDriven > 0 ? totalMaintenanceCost / milesDriven : 0
    }

    var monthlyAverageCost: Double {
        guard let purchaseDate = self.purchaseDate else { return 0 }
        let months = Calendar.current.dateComponents([.month], from: purchaseDate, to: Date()).month ?? 1
        return months > 0 ? (totalFuelCost + totalMaintenanceCost + totalOtherExpenses) / Double(months) : 0
    }

    // MARK: - Fuel Calculations

    var bestMPG: Double {
        let validMPGs = fuelPurchasesArray.compactMap { $0.milesPerGallon > 0 ? $0.milesPerGallon : nil }
        return validMPGs.isEmpty ? 0 : validMPGs.max() ?? 0
    }

    var worstMPG: Double {
        let validMPGs = fuelPurchasesArray.compactMap { $0.milesPerGallon > 0 ? $0.milesPerGallon : nil }
        return validMPGs.isEmpty ? 0 : validMPGs.min() ?? 0
    }

    var totalGallons: Double {
        return fuelPurchasesArray.reduce(into: 0) { result, purchase in
            result += purchase.gallons
        }
    }

    var averageFuelEconomy: Double {
        guard !fuelPurchasesArray.isEmpty else { return 0 }
        
        // Calculate total miles driven and total gallons used
        let sortedPurchases = fuelPurchasesArray
            .filter { $0.odometer > 0 && $0.gallons > 0 }
            .sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
        
        guard sortedPurchases.count >= 2 else { return 0 }
        
        var totalMiles: Double = 0
        var totalGallons: Double = 0
        
        for pair in sortedPurchases.adjacentPairs() {
            let (prev, next) = pair
            let miles = next.odometer - prev.odometer
            if miles > 0 {
                totalMiles += miles
                totalGallons += next.gallons
            }
        }
        
        return totalGallons > 0 ? totalMiles / totalGallons : 0
    }

    var averageFuelCost: Double {
        guard !fuelPurchasesArray.isEmpty else { return 0 }
        return totalFuelCost / totalGallons
    }

    // MARK: - Maintenance Calculations

    var averageMaintenanceCost: Double {
        guard !maintenanceRecordsArray.isEmpty else { return 0 }
        return totalMaintenanceCost / Double(maintenanceRecordsArray.count)
    }

    var lastMaintenanceDate: Date? {
        return maintenanceRecordsArray.sorted(by: { ($0.date ?? Date.distantPast) > ($1.date ?? Date.distantPast) }).first?.date
    }

    var nextScheduledService: MaintenanceRecord? {
        let futureRecords = maintenanceRecordsArray.filter { record in
            guard let date = record.date else { return false }
            return date > Date()
        }
        return futureRecords.sorted(by: { ($0.date ?? Date.distantFuture) < ($1.date ?? Date.distantFuture) }).first
    }

    var upcomingMaintenance: [MaintenanceRecord] {
        let futureRecords = maintenanceRecordsArray.filter { record in
            guard let date = record.date else { return false }
            return date > Date()
        }
        return futureRecords.sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
    }

    var fuelPurchaseHistory: [FuelPurchase] {
        return fuelPurchasesArray
    }

    var maintenanceHistory: [MaintenanceRecord] {
        return maintenanceRecordsArray
    }

    // MARK: - Trend Data

    struct MPGData: Identifiable {
        let id = UUID()
        let date: Date
        let mpg: Double
    }

    var recentMPGData: [MPGData] {
        return fuelPurchasesArray
            .filter { $0.milesPerGallon > 0 && $0.date != nil }
            .sorted(by: { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) })
            .compactMap { purchase in
                guard let date = purchase.date else { return nil }
                return MPGData(date: date, mpg: purchase.milesPerGallon)
            }
    }

    struct MaintenanceCostData: Identifiable {
        let id = UUID()
        let date: Date
        let cost: Double
    }

    var maintenanceCostTrends: [MaintenanceCostData] {
        return maintenanceRecordsArray
            .filter { $0.date != nil }
            .sorted(by: { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) })
            .compactMap { record in
                guard let date = record.date else { return nil }
                return MaintenanceCostData(date: date, cost: record.totalCost)
            }
    }
}
