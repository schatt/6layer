# Function Index

- **Directory**: ./carmanager-business-logic/Vehicles
- **Generated**: 2025-09-04 14:11:36 -0700
- **Script**: Scripts/generate_function_index.sh

This index lists function declarations and other Swift declarations found in this directory's Swift files.

Functions are categorized by access level and type for better organization.

Documentation comments are extracted when available.

Extension context is shown for functions that are part of extensions.

---

## ./carmanager-business-logic/Vehicles/Vehicle+Extensions.swift
### Internal Methods
- **L154:** ` func averageMPG(for timeFrame: ChartTimeFrame) -> Double`
  - *function*
  - *Calculate MPG for a specific time period\nThis is the correct method: total miles driven / total gallons used in the period\n*
- **L513:** ` func adjacentPairs() -> [(Element, Element)]`
  - *function|extension Collection*
- **L14:** ` var fullName: String`
  - *function|extension Vehicle*
- **L22:** ` var formattedPurchaseDate: String`
  - *function|extension Vehicle*
- **L29:** ` var formattedPurchasePrice: String`
  - *function|extension Vehicle*
- **L36:** ` var formattedCurrentOdometer: String`
  - *function|extension Vehicle*
- **L43:** ` var formattedFuelTankCapacity: String`
  - *function|extension Vehicle*
- **L50:** ` var preferredOctaneValue: Int`
  - *function|extension Vehicle*
- **L56:** ` var fuelPurchasesArray: [FuelPurchase]`
  - *function*
- **L61:** ` var maintenanceRecordsArray: [MaintenanceRecord]`
  - *function*
- **L66:** ` var expensesArray: [Expense]`
  - *function*
- **L71:** ` var insurancePoliciesArray: [InsurancePolicy]`
  - *function*
- **L76:** ` var documentsArray: [Document]`
  - *function*
- **L81:** ` var locationsArray: [Location]`
  - *function*
- **L86:** ` var tireSetsArray: [TireSet]`
  - *function*
- **L90:** ` var tireChangesArray: [TireChange]`
  - *function*
- **L95:** ` var vehiclePaymentsArray: [VehiclePayment]`
  - *function*
- **L101:** ` var scheduledMaintenanceItemsArray: [ScheduledMaintenanceItem]`
  - *function*
- **L113:** ` var totalExpenses: Double`
  - *function*
- **L117:** ` var totalFuelCost: Double`
  - *function*
- **L121:** ` var totalMaintenanceCost: Double`
  - *function*
- **L125:** ` var averageMPG: Double`
  - *function*
- **L205:** ` var formattedAverageMPG: String`
  - *function*
- **L212:** ` var totalMilesDriven: Double`
  - *function*
- **L216:** ` var formattedTotalMilesDriven: String`
  - *function*
- **L223:** ` var costPerMile: Double`
  - *function*
- **L228:** ` var formattedCostPerMile: String`
  - *function*
- **L239:** ` var milesPerDay: Double`
  - *function*
  - *Running average miles per day over the last 10 full (non-partial) fuel fillups\nHandles same-day fill-ups by treating intervals < 1 hour as 1 day to avoid divide-by-zero errors.\n*
- **L263:** ` var formattedMilesPerDay: String`
  - *function*
- **L273:** ` var predictedNextFuelupDate: Date?`
  - *function*
  - *Predicts the next likely fuel-up date based on current fuel level, tank capacity, average MPG, and miles per day.\n*
- **L301:** ` var formattedPredictedNextFuelupDate: String`
  - *function*
- **L310:** ` var averageGallonsPerFillup: Double`
  - *function*
  - *Average gallons per full (non-partial) fill-up over the last 10 fill-ups.\nExcludes partial fill-ups and uses only valid gallons values.\n*
- **L322:** ` var averagePricePerGallon: Double`
  - *function*
  - *Average price per gallon over the last 10 full (non-partial) fill-ups.\nExcludes partial fill-ups and uses only valid pricePerGallon values.\n*
- **L333:** ` var formattedAverageGallonsPerFillup: String`
  - *function*
  - *Formatted average gallons per fill-up for UI display\n*
- **L341:** ` var formattedAveragePricePerGallon: String`
  - *function*
  - *Formatted average price per gallon for UI display\n*
- **L350:** ` var averageDaysBetweenFillups: Double`
  - *function*
  - *Average number of days between full (non-partial) fill-ups over the last 10 fill-ups.\nReturns a fractional value. If fewer than 2 fill-ups, returns 0.\n*
- **L368:** ` var formattedAverageDaysBetweenFillups: String`
  - *function*
  - *Formatted average days between fill-ups for UI display\n*
- **L376:** ` var mostCommonFillupWeekday: String?`
  - *function*
  - *Returns the most common weekday for full fill-ups over the last 10 fill-ups, or nil if no clear pattern.\n*
- **L464:** ` var isSaving: Bool`
  - *function*

### Private Implementation
- **L470:** ` private static var isSaving: Bool`
  - *static function*

## ./carmanager-business-logic/Vehicles/TireSet+Extensions.swift
### Internal Methods
- **L7:** ` var fromTireChangesArray: [TireChange]`
  - *function|extension TireSet*
- **L11:** ` var toTireChangesArray: [TireChange]`
  - *function|extension TireSet*
- **L17:** ` var displayName: String`
  - *function|extension TireSet*
- **L34:** ` var formattedInstallationDate: String`
  - *function|extension TireSet*
- **L41:** ` var formattedCurrentMileage: String`
  - *function|extension TireSet*
- **L48:** ` var formattedTotalMileage: String`
  - *function|extension TireSet*
- **L55:** ` var isWarrantyExpired: Bool`
  - *function*
- **L64:** ` var warrantyStatus: String`
  - *function*

## ./carmanager-business-logic/Vehicles/Vehicle+ComparisonExtensions.swift
### Internal Methods
- **L7:** ` var totalCost: Double`
  - *function|extension Vehicle*
- **L11:** ` var totalOtherExpenses: Double`
  - *function|extension Vehicle*
- **L17:** ` var fuelCostPerMile: Double`
  - *function|extension Vehicle*
- **L22:** ` var maintenanceCostPerMile: Double`
  - *function|extension Vehicle*
- **L27:** ` var monthlyAverageCost: Double`
  - *function|extension Vehicle*
- **L35:** ` var bestMPG: Double`
  - *function|extension Vehicle*
- **L40:** ` var worstMPG: Double`
  - *function|extension Vehicle*
- **L45:** ` var totalGallons: Double`
  - *function|extension Vehicle*
- **L51:** ` var averageFuelEconomy: Double`
  - *function|extension Vehicle*
- **L76:** ` var averageFuelCost: Double`
  - *function*
- **L83:** ` var averageMaintenanceCost: Double`
  - *function*
- **L88:** ` var lastMaintenanceDate: Date?`
  - *function*
- **L92:** ` var nextScheduledService: MaintenanceRecord?`
  - *function*
- **L100:** ` var upcomingMaintenance: [MaintenanceRecord]`
  - *function*
- **L108:** ` var fuelPurchaseHistory: [FuelPurchase]`
  - *function*
- **L112:** ` var maintenanceHistory: [MaintenanceRecord]`
  - *function*
- **L124:** ` var recentMPGData: [MPGData]`
  - *function*
- **L140:** ` var maintenanceCostTrends: [MaintenanceCostData]`
  - *function*

## ./carmanager-business-logic/Vehicles/TireChange+Extensions.swift
### Internal Methods
- **L7:** ` var displayName: String`
  - *function|extension TireChange*
- **L13:** ` var formattedDate: String`
  - *function|extension TireChange*
- **L20:** ` var formattedOdometer: String`
  - *function|extension TireChange*
- **L27:** ` var changeType: String`
  - *function|extension TireChange*

## ./carmanager-business-logic/Vehicles/VehicleSelectionManager.swift
### Public Interface
- **L44:** ` public func selectVehicle(_ vehicle: Vehicle)`
  - *function*
- **L49:** ` public func clearSelection()`
  - *function*
- **L54:** ` public func getSelectedVehicle(in context: NSManagedObjectContext) -> Vehicle?`
  - *function*

### Private Implementation
- **L19:** ` private init()`
  - *function*

