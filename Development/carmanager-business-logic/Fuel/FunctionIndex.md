# Function Index

- **Directory**: Shared/Models/Fuel
- **Generated**: 2025-08-20 14:09:34 -0700
- **Script**: Scripts/generate_function_index.sh

This index lists function declarations and other Swift declarations found in this directory's Swift files.

Functions are categorized by access level and type for better organization.

Documentation comments are extracted when available.

Extension context is shown for functions that are part of extensions.

---

## Shared/Models/Fuel/FuelPurchase+Extensions.swift
### Internal Methods
- **L73:** ` static func groupByMonth(fuelPurchases: [FuelPurchase]) -> [String: [FuelPurchase]]`
  - *static function*
- **L94:** ` static func calculateAverageMPG(fuelPurchases: [FuelPurchase]) -> Double`
  - *static function*
- **L122:** ` static func calculateTotalCost(fuelPurchases: [FuelPurchase]) -> Double`
  - *static function*
- **L127:** ` static func calculateTotalGallons(fuelPurchases: [FuelPurchase]) -> Double`
  - *static function*
- **L131:** ` func recalculateMPG()`
  - *function*
- **L6:** ` var cost: Double`
  - *function|extension FuelPurchase*
- **L10:** ` var formattedDate: String`
  - *function|extension FuelPurchase*
- **L17:** ` var formattedOdometer: String`
  - *function|extension FuelPurchase*
- **L24:** ` var formattedGallons: String`
  - *function|extension FuelPurchase*
- **L31:** ` var formattedPricePerGallon: String`
  - *function|extension FuelPurchase*
- **L38:** ` var formattedTotalCost: String`
  - *function|extension FuelPurchase*
- **L45:** ` var formattedMPG: String`
  - *function|extension FuelPurchase*
- **L56:** ` var monthYear: String`
  - *function*
- **L63:** ` var previousOdometer: Double?`
  - *function*

## Shared/Models/Fuel/FuelPurchaseMPGManager.swift
### Internal Methods
- **L22:** ` func debouncedRecalculateMPG(for vehicle: Vehicle, in context: NSManagedObjectContext, immediate: Bool = false)`
  - *function*
  - *Triggers a debounced MPG calculation for all fuel purchases of a vehicle\n- Parameter vehicle: The vehicle whose fuel purchases should be recalculated\n- Parameter context: The Core Data context to use for calculations\n- Parameter immediate: If true, performs calculation immediately instead of debouncing\n*
- **L35:** ` func debouncedRecalculateAllMPG(in context: NSManagedObjectContext, immediate: Bool = false)`
  - *function*
  - *Triggers a debounced MPG calculation for all fuel purchases in the context\n- Parameter context: The Core Data context to use for calculations\n- Parameter immediate: If true, performs calculation immediately instead of debouncing\n*
- **L229:** ` func triggerDebouncedMPGCalculation(immediate: Bool = false)`
  - *function|extension FuelPurchase*
- **L242:** ` func triggerDebouncedMPGCalculation(immediate: Bool = false)`
  - *function|extension Vehicle*

### Private Implementation
- **L48:** ` private func performMPGCalculationImmediate(for vehicle: Vehicle, in context: NSManagedObjectContext)`
  - *function*
  - *Immediately performs MPG calculation for all fuel purchases of a vehicle (synchronous)\n- Parameter vehicle: The vehicle whose fuel purchases should be recalculated\n- Parameter context: The Core Data context to use for calculations\n*
- **L94:** ` private func performMPGCalculation(for vehicle: Vehicle, in context: NSManagedObjectContext)`
  - *function*
  - *Immediately performs MPG calculation for all fuel purchases of a vehicle (asynchronous)\n- Parameter vehicle: The vehicle whose fuel purchases should be recalculated\n- Parameter context: The Core Data context to use for calculations\n*
- **L117:** ` private func performAllMPGCalculationImmediate(in context: NSManagedObjectContext)`
  - *function*
  - *Immediately performs MPG calculation for all fuel purchases in the context (synchronous)\n- Parameter context: The Core Data context to use for calculations\n*
- **L184:** ` private func performAllMPGCalculation(in context: NSManagedObjectContext)`
  - *function*
  - *Immediately performs MPG calculation for all fuel purchases in the context (asynchronous)\n- Parameter context: The Core Data context to use for calculations\n*
- **L14:** ` private init()`
  - *function*

