# Function Index

- **Directory**: Shared/Models/Maintenance
- **Generated**: 2025-08-20 14:09:59 -0700
- **Script**: Scripts/generate_function_index.sh

This index lists function declarations and other Swift declarations found in this directory's Swift files.

Functions are categorized by access level and type for better organization.

Documentation comments are extracted when available.

Extension context is shown for functions that are part of extensions.

---

## Shared/Models/Maintenance/ScheduledMaintenanceItem+Extensions.swift
### Internal Methods
- **L27:** ` func predictedDueDate(vehicle: Vehicle) -> Date?`
  - *function|extension ScheduledMaintenanceItem*
  - *Predicts the next due date, considering both mileage and time intervals, and returns the sooner of the two.\nRequires the vehicle's current odometer and miles per day.\n*
- **L64:** ` func isOverdue(vehicle: Vehicle) -> Bool`
  - *function*
  - *Returns true if the maintenance is overdue (by date or mileage)\n*
- **L86:** ` func nextDueSummary(vehicle: Vehicle) -> String`
  - *function*
  - *Returns a user-friendly summary of the next due maintenance\n*
- **L6:** ` var nextDueOdometer: Double?`
  - *function|extension ScheduledMaintenanceItem*
  - *Returns the next due odometer reading, or nil if not set.\n*
- **L16:** ` var nextDueDate: Date?`
  - *function|extension ScheduledMaintenanceItem*
  - *Returns the next due date, or nil if not set.\n*

## Shared/Models/Maintenance/MaintenanceRecord+Extensions.swift
### Internal Methods
- **L49:** ` static func groupByMonth(records: [MaintenanceRecord]) -> [String: [MaintenanceRecord]]`
  - *static function|extension MaintenanceRecord*
- **L70:** ` static func groupByType(records: [MaintenanceRecord]) -> [String: [MaintenanceRecord]]`
  - *static function*
- **L87:** ` static func calculateTotalCost(records: [MaintenanceRecord]) -> Double`
  - *static function*
- **L92:** ` static func calculateAverageCost(records: [MaintenanceRecord]) -> Double`
  - *static function*
- **L153:** ` static func createDefaultCategories(in context: NSManagedObjectContext)`
  - *static function|extension MaintenanceCategory*
- **L6:** ` var wrappedTitle: String`
  - *function|extension MaintenanceRecord*
- **L10:** ` var formattedDate: String`
  - *function|extension MaintenanceRecord*
- **L17:** ` var formattedOdometer: String`
  - *function|extension MaintenanceRecord*
- **L24:** ` var totalCost: Double`
  - *function|extension MaintenanceRecord*
- **L29:** ` var formattedTotalCost: String`
  - *function|extension MaintenanceRecord*
- **L36:** ` var monthYear: String`
  - *function|extension MaintenanceRecord*
- **L43:** ` var lineItemsArray: [MaintenanceLineItem]`
  - *function|extension MaintenanceRecord*
- **L99:** ` var formattedCost: String`
  - *function|extension MaintenanceLineItem*
- **L106:** ` var formattedWarranty: String`
  - *function|extension MaintenanceLineItem*
- **L131:** ` var isWarrantyValid: Bool`
  - *function|extension MaintenanceLineItem*
- **L138:** ` var categoryName: String`
  - *function|extension MaintenanceLineItem*
- **L144:** ` var wrappedName: String`
  - *function|extension MaintenanceCategory*
- **L148:** ` var lineItemsArray: [MaintenanceLineItem]`
  - *function|extension MaintenanceCategory*

