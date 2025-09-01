import CoreData
import Foundation
import SwiftUI

extension Vehicle {
    // MARK: - Computed Properties

    @objc dynamic var displayName: String {
        let make = self.make?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let model = self.model?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return "\(self.year) \(make) \(model)".trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var fullName: String {
        let baseName = displayName
        if let plate = licensePlate, !plate.isEmpty {
            return "\(baseName) (\(plate))"
        }
        return baseName
    }

    var formattedPurchaseDate: String {
        guard let date = purchaseDate else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    var formattedPurchasePrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: purchasePrice)) ?? "$0.00"
    }

    var formattedCurrentOdometer: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: currentOdometer)) ?? "0"
    }

    var formattedFuelTankCapacity: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return "\(formatter.string(from: NSNumber(value: fuelTankCapacity)) ?? "0") gal"
    }

    var preferredOctaneValue: Int {
        Int(self.preferredOctane)
    }

    // MARK: - Relationship Arrays

    var fuelPurchasesArray: [FuelPurchase] {
        let set = fuelPurchases as? Set<FuelPurchase> ?? []
        return set.sorted(by: { ($0.date ?? Date.distantPast) > ($1.date ?? Date.distantPast) })
    }

    var maintenanceRecordsArray: [MaintenanceRecord] {
        let set = maintenanceRecords as? Set<MaintenanceRecord> ?? []
        return set.sorted(by: { ($0.date ?? Date.distantPast) > ($1.date ?? Date.distantPast) })
    }

    var expensesArray: [Expense] {
        let set = expenses as? Set<Expense> ?? []
        return set.sorted(by: { ($0.date ?? Date.distantPast) > ($1.date ?? Date.distantPast) })
    }

    var insurancePoliciesArray: [InsurancePolicy] {
        let set = insurancePolicies as? Set<InsurancePolicy> ?? []
        return set.sorted(by: { ($0.coverageStartDate ?? Date.distantPast) > ($1.coverageStartDate ?? Date.distantPast) })
    }

    var documentsArray: [Document] {
        let set = vehicleDocuments as? Set<Document> ?? []
        return set.sorted(by: { ($0.date ?? Date.distantPast) > ($1.date ?? Date.distantPast) })
    }

    var locationsArray: [Location] {
        let set = locations as? Set<Location> ?? []
        return set.sorted(by: { ($0.date ?? Date.distantPast) > ($1.date ?? Date.distantPast) })
    }

    var tireSetsArray: [TireSet] {
        let set = tireSets as? Set<TireSet> ?? []
        return set.sorted { ($0.installationDate ?? Date.distantPast) > ($1.installationDate ?? Date.distantPast) }
    }
    var tireChangesArray: [TireChange] {
        let set = tireChanges as? Set<TireChange> ?? []
        return set.sorted { ($0.date ?? Date.distantPast) > ($1.date ?? Date.distantPast) }
    }

    var vehiclePaymentsArray: [VehiclePayment] {
        let set = vehiclePayments as? Set<VehiclePayment> ?? []
        return set.sorted(by: { ($0.createdAt ?? Date.distantPast) > ($1.createdAt ?? Date.distantPast) })
    }

    // MARK: - Scheduled Maintenance
    var scheduledMaintenanceItemsArray: [ScheduledMaintenanceItem] {
        let set = scheduledMaintenanceItems as? Set<ScheduledMaintenanceItem> ?? []
        // Sort by predicted due date (soonest first)
        return set.sorted {
            let date1 = $0.predictedDueDate(vehicle: self) ?? Date.distantFuture
            let date2 = $1.predictedDueDate(vehicle: self) ?? Date.distantFuture
            return date1 < date2
        }
    }

    // MARK: - Statistics

    var totalExpenses: Double {
        return expensesArray.reduce(0) { $0 + $1.amount }
    }

    var totalFuelCost: Double {
        return fuelPurchasesArray.reduce(0) { $0 + $1.totalCost }
    }

    var totalMaintenanceCost: Double {
        return maintenanceRecordsArray.reduce(0) { $0 + $1.totalCost }
    }

    var averageMPG: Double {
        let validPurchases = fuelPurchasesArray.filter { $0.milesPerGallon > 0 && $0.gallons > 0 }
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
    
    /// Calculate MPG for a specific time period
    /// This is the correct method: total miles driven / total gallons used in the period
    func averageMPG(for timeFrame: ChartTimeFrame) -> Double {
        let calendar = Calendar.current
        let now = Date()
        let startDate: Date
        
        switch timeFrame {
        case .week:
            startDate = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .threeMonths:
            startDate = calendar.date(byAdding: .month, value: -3, to: now) ?? now
        case .sixMonths:
            startDate = calendar.date(byAdding: .month, value: -6, to: now) ?? now
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        case .all:
            return averageMPG // Use the overall average for all time
        }
        
        // Get fuel purchases within the time period
        let periodPurchases = fuelPurchasesArray.filter { purchase in
            guard let purchaseDate = purchase.date else { return false }
            return purchaseDate >= startDate && purchaseDate <= now && purchase.gallons > 0
        }
        
        guard periodPurchases.count >= 2 else { return 0 }
        
        // Sort by date
        let sortedPurchases = periodPurchases.sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
        
        // Calculate total miles and total gallons for the period
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
        
        // Return total miles per total gallons for the period
        return totalGallons > 0 ? totalMiles / totalGallons : 0
    }

    var formattedAverageMPG: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: averageMPG)) ?? "0"
    }

    var totalMilesDriven: Double {
        return currentOdometer - initialOdometer
    }

    var formattedTotalMilesDriven: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: totalMilesDriven)) ?? "0"
    }

    var costPerMile: Double {
        guard totalMilesDriven > 0 else { return 0 }
        return (totalExpenses + totalFuelCost + totalMaintenanceCost) / totalMilesDriven
    }

    var formattedCostPerMile: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: costPerMile)) ?? "$0.00"
    }

    // MARK: - Miles Per Day Calculation

    /// Running average miles per day over the last 10 full (non-partial) fuel fillups
    /// Handles same-day fill-ups by treating intervals < 1 hour as 1 day to avoid divide-by-zero errors.
    var milesPerDay: Double {
        let fullFillups = fuelPurchasesArray
            .filter { !$0.partialFillUp && $0.date != nil && $0.odometer > 0 }
            .sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
        guard fullFillups.count >= 2 else { return 0 }
        let recentFillups = fullFillups.suffix(10)
        var totalMiles: Double = 0
        var totalDays: Double = 0
        for pair in recentFillups.adjacentPairs() {
            let (prev, next) = pair
            guard let prevDate = prev.date, let nextDate = next.date else { continue }
            let miles = next.odometer - prev.odometer
            var days = nextDate.timeIntervalSince(prevDate) / 86400.0
            // If fill-ups are on the same day or within 1 hour, treat as 1 day to avoid divide-by-zero
            if days < (1.0 / 24.0) { days = 1.0 }
            if miles > 0 && days > 0 {
                totalMiles += miles
                totalDays += days
            }
        }
        guard totalDays > 0 else { return 0 }
        return totalMiles / totalDays
    }

    var formattedMilesPerDay: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: milesPerDay)) ?? "0"
    }

    // MARK: - Next Fuel-Up Prediction

    /// Predicts the next likely fuel-up date based on current fuel level, tank capacity, average MPG, and miles per day.
    var predictedNextFuelupDate: Date? {
        // Get all full fillups, sorted by date ascending
        let fullFillups = fuelPurchasesArray
            .filter { !$0.partialFillUp && $0.date != nil && $0.gallons > 0 }
            .sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
        guard let lastFillup = fullFillups.last, let lastDate = lastFillup.date else {
            return nil
        }

        // Estimate gallons used since last full fillup
        let purchasesSinceLastFull = fuelPurchasesArray
            .filter { ($0.date ?? Date.distantPast) > lastDate }
        let gallonsAdded = purchasesSinceLastFull.reduce(0.0) { $0 + $1.gallons }
        let gallonsLeft = max(0, fuelTankCapacity - gallonsAdded)

        // Use average MPG (or fallback to 20 if not available)
        let mpg = averageMPG > 0 ? averageMPG : 20.0
        let milesLeft = gallonsLeft * mpg

        // Use milesPerDay (or fallback to 30 if not available)
        let mpd = milesPerDay > 0 ? milesPerDay : 30.0
        guard mpd > 0 else { return nil }
        let daysLeft = milesLeft / mpd

        // Predict next fuel-up date
        return Calendar.current.date(byAdding: .day, value: Int(ceil(daysLeft)), to: Date())
    }

    var formattedPredictedNextFuelupDate: String {
        guard let date = predictedNextFuelupDate else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    /// Average gallons per full (non-partial) fill-up over the last 10 fill-ups.
    /// Excludes partial fill-ups and uses only valid gallons values.
    var averageGallonsPerFillup: Double {
        let fullFillups = fuelPurchasesArray
            .filter { !$0.partialFillUp && $0.gallons > 0 && $0.date != nil }
            .sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
        guard !fullFillups.isEmpty else { return 0 }
        let recentFillups = fullFillups.suffix(10)
        let totalGallons = recentFillups.reduce(0.0) { $0 + $1.gallons }
        return totalGallons / Double(recentFillups.count)
    }

    /// Average price per gallon over the last 10 full (non-partial) fill-ups.
    /// Excludes partial fill-ups and uses only valid pricePerGallon values.
    var averagePricePerGallon: Double {
        let fullFillups = fuelPurchasesArray
            .filter { !$0.partialFillUp && $0.pricePerGallon > 0 && $0.date != nil }
            .sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
        guard !fullFillups.isEmpty else { return 0 }
        let recentFillups = fullFillups.suffix(10)
        let totalPrice = recentFillups.reduce(0.0) { $0 + $1.pricePerGallon }
        return totalPrice / Double(recentFillups.count)
    }

    /// Formatted average gallons per fill-up for UI display
    var formattedAverageGallonsPerFillup: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: averageGallonsPerFillup)) ?? "0"
    }

    /// Formatted average price per gallon for UI display
    var formattedAveragePricePerGallon: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 3
        return formatter.string(from: NSNumber(value: averagePricePerGallon)) ?? "$0.00"
    }

    /// Average number of days between full (non-partial) fill-ups over the last 10 fill-ups.
    /// Returns a fractional value. If fewer than 2 fill-ups, returns 0.
    var averageDaysBetweenFillups: Double {
        let fullFillups = fuelPurchasesArray
            .filter { !$0.partialFillUp && $0.date != nil }
            .sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
        guard fullFillups.count >= 2 else { return 0 }
        let recentFillups = fullFillups.suffix(10)
        var intervals: [Double] = []
        for pair in recentFillups.adjacentPairs() {
            let (prev, next) = pair
            guard let prevDate = prev.date, let nextDate = next.date else { continue }
            let days = nextDate.timeIntervalSince(prevDate) / 86400.0
            if days > 0 { intervals.append(days) }
        }
        guard !intervals.isEmpty else { return 0 }
        return intervals.reduce(0, +) / Double(intervals.count)
    }

    /// Formatted average days between fill-ups for UI display
    var formattedAverageDaysBetweenFillups: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: averageDaysBetweenFillups)) ?? "0"
    }

    /// Returns the most common weekday for full fill-ups over the last 10 fill-ups, or nil if no clear pattern.
    var mostCommonFillupWeekday: String? {
        let fullFillups = fuelPurchasesArray
            .filter { !$0.partialFillUp && $0.date != nil }
            .sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
        guard !fullFillups.isEmpty else { return nil }
        let recentFillups = fullFillups.suffix(10)
        let weekdays = recentFillups.compactMap { $0.date.map { Calendar.current.component(.weekday, from: $0) } }
        guard !weekdays.isEmpty else { return nil }
        let counts = weekdays.reduce(into: [:]) { $0[$1, default: 0] += 1 }
        if let (mostCommon, count) = counts.max(by: { $0.value < $1.value }), count > 1 {
            let formatter = DateFormatter()
            return formatter.weekdaySymbols[(mostCommon - 1) % 7]
        }
        return nil
    }

    // MARK: - Lifecycle Methods

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        let now = Date()

        // Only set values if they haven't been set already
        if id == nil {
            id = UUID()
        }
        if createdAt == nil {
            createdAt = now
        }
        if updatedAt == nil {
            updatedAt = now
        }
        if primitiveValue(forKey: "modificationDate") == nil {
            setPrimitiveValue(now, forKey: "modificationDate")
        }
        // purchaseLocation string removed; vehicles may use purchasePlace relationship instead
        if primitiveValue(forKey: "make") == nil {
            setPrimitiveValue("", forKey: "make")
        }
        if primitiveValue(forKey: "model") == nil {
            setPrimitiveValue("", forKey: "model")
        }
        if primitiveValue(forKey: "vin") == nil {
            setPrimitiveValue("", forKey: "vin")
        }
        if primitiveValue(forKey: "licensePlate") == nil {
            setPrimitiveValue("", forKey: "licensePlate")
        }
        if primitiveValue(forKey: "color") == nil {
            setPrimitiveValue("", forKey: "color")
        }
        if primitiveValue(forKey: "fuelType") == nil {
            setPrimitiveValue("", forKey: "fuelType")
        }
        if primitiveValue(forKey: "notes") == nil {
            setPrimitiveValue("", forKey: "notes")
        }
        if primitiveValue(forKey: "purchasePrice") == nil {
            setPrimitiveValue(0.0, forKey: "purchasePrice")
        }
        if primitiveValue(forKey: "purchaseMileage") == nil {
            setPrimitiveValue(0.0, forKey: "purchaseMileage")
        }
        if primitiveValue(forKey: "currentOdometer") == nil {
            setPrimitiveValue(0.0, forKey: "currentOdometer")
        }
        if primitiveValue(forKey: "initialOdometer") == nil {
            setPrimitiveValue(0.0, forKey: "initialOdometer")
        }
        if primitiveValue(forKey: "year") == nil {
            setPrimitiveValue(0, forKey: "year")
        }
        if primitiveValue(forKey: "isArchived") == nil {
            setPrimitiveValue(false, forKey: "isArchived")
        }
        if primitiveValue(forKey: "purchaseDate") == nil {
            setPrimitiveValue(now, forKey: "purchaseDate")
        }
    }

    // Note: This is a simple flag to prevent recursive saves
    // In a production environment, you might want to use a more sophisticated approach
    private static let savingManager = SavingManager()
    
    private final class SavingManager: @unchecked Sendable {
        private let queue = DispatchQueue(label: "com.carmanager.vehicle.saving")
        private var _isSaving = false
        
        var isSaving: Bool {
            get { queue.sync { _isSaving } }
            set { queue.sync { _isSaving = newValue } }
        }
    }
    
    private static var isSaving: Bool {
        get { savingManager.isSaving }
        set { savingManager.isSaving = newValue }
    }

    public override func willSave() {
        super.willSave()

        // Prevent recursive saves
        guard !Self.isSaving else { return }

        // Only update if we have actual changes and they're not just timestamp changes
        let changes = self.changedValues()
        let timestampKeys = ["updatedAt", "modificationDate", "createdAt"]
        let hasNonTimestampChanges = changes.keys.contains { !timestampKeys.contains($0) }

        if self.hasChanges && hasNonTimestampChanges {
            Self.isSaving = true
            defer { Self.isSaving = false }

            // Only update timestamps if they haven't been set yet
            if updatedAt == nil {
                updatedAt = Date()
            }
            if primitiveValue(forKey: "modificationDate") == nil {
                setPrimitiveValue(Date(), forKey: "modificationDate")
            }
        }
    }
}

// TireSet and TireChange extensions will be generated by Core Data

// MARK: - Notification Names
extension Notification.Name {
    static let vehicleAdded = Notification.Name("vehicleAdded")
    static let vehicleUpdated = Notification.Name("vehicleUpdated")
    static let vehicleDeleted = Notification.Name("vehicleDeleted")
    static let vehicleSelected = Notification.Name("vehicleSelected")
}

// Helper for adjacent pairs
extension Collection {
    func adjacentPairs() -> [(Element, Element)] {
        var result: [(Element, Element)] = []
        var iterator = makeIterator()
        guard var previous = iterator.next() else { return result }
        while let current = iterator.next() {
            result.append((previous, current))
            previous = current
        }
        return result
    }
}
