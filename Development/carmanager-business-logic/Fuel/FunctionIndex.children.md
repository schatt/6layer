# Function Index (Immediate Children)

- **Directory**: ./Models/Fuel
- **Generated**: 2025-08-13 19:55:13 -0700
- **Script**: Scripts/generate_function_index.sh --children

This index lists function declarations found in this directory and its first-level subdirectories only.

---

## ./Models/Fuel
- L73: ` static func groupByMonth(fuelPurchases: [FuelPurchase]) -> [String: [FuelPurchase]]`
- L94: ` static func calculateAverageMPG(fuelPurchases: [FuelPurchase]) -> Double`
- L122: ` static func calculateTotalCost(fuelPurchases: [FuelPurchase]) -> Double`
- L127: ` static func calculateTotalGallons(fuelPurchases: [FuelPurchase]) -> Double`
- L131: ` func recalculateMPG()`
- L22: ` func debouncedRecalculateMPG(for vehicle: Vehicle, in context: NSManagedObjectContext, immediate: Bool = false)`
- L35: ` func debouncedRecalculateAllMPG(in context: NSManagedObjectContext, immediate: Bool = false)`
- L48: ` private func performMPGCalculationImmediate(for vehicle: Vehicle, in context: NSManagedObjectContext)`
- L94: ` private func performMPGCalculation(for vehicle: Vehicle, in context: NSManagedObjectContext)`
- L117: ` private func performAllMPGCalculationImmediate(in context: NSManagedObjectContext)`
- L184: ` private func performAllMPGCalculation(in context: NSManagedObjectContext)`
- L229: ` func triggerDebouncedMPGCalculation(immediate: Bool = false)`
- L242: ` func triggerDebouncedMPGCalculation(immediate: Bool = false)`

