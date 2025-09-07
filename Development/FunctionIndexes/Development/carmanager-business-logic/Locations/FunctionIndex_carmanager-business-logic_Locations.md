# Function Index

- **Directory**: ./Development/carmanager-business-logic/Locations
- **Generated**: 2025-09-06 16:40:49 -0700
- **Script**: Scripts/generate_function_index.sh

This index lists function declarations and other Swift declarations found in this directory's Swift files.

Functions are categorized by access level and type for better organization.

Documentation comments are extracted when available.

Extension context is shown for functions that are part of extensions.

---

## ./Development/carmanager-business-logic/Locations/TimeOfDay.swift
### Public Interface
- **L94:** ` public static func from(date: Date) -> TimeOfDay`
  - *static function*
  - *Create time of day from a date\n*
- **L117:** ` public func contains(hour: Int) -> Bool`
  - *function*
  - *Check if a given hour falls within this time period\n*
- **L17:** ` public var description: String`
  - *function*
  - *Human-readable description of the time period\n*
- **L22:** ` public var iconName: String`
  - *function*
  - *Icon name for the time period\n*
- **L40:** ` public var colorName: String`
  - *function*
  - *Color representation for the time period\n*
- **L58:** ` public var startHour: Int`
  - *function*
  - *Start hour for this time period (24-hour format)\n*
- **L76:** ` public var endHour: Int`
  - *function*
  - *End hour for this time period (24-hour format)\n*

## ./Development/carmanager-business-logic/Locations/LocationActivityReport.swift
### Public Interface
- **L45:** ` public var formattedTotalDistance: String`
  - *function*
  - *Formatted total distance\n*
- **L60:** ` public var formattedAverageAccuracy: String`
  - *function*
  - *Formatted average accuracy\n*
- **L73:** ` public var activityLevel: ActivityLevel`
  - *function*
  - *Activity level based on total locations\n*
- **L89:** ` public var dataQualityScore: Int`
  - *function*
  - *Data quality score based on accuracy distribution\n*
- **L114:** ` public var dataQualityDescription: String`
  - *function*
  - *Data quality description\n*
- **L132:** ` public var mostCommonLocationType: LocationType?`
  - *function*
  - *Most common location type\n*
- **L146:** ` public var coverageArea: Double`
  - *function*
  - *Coverage area in square meters\n*
- **L152:** ` public var formattedCoverageArea: String`
  - *function*
  - *Formatted coverage area\n*
- **L178:** ` public var colorName: String`
  - *function*
  - *Color representation for the activity level\n*
- **L194:** ` public var iconName: String`
  - *function*
  - *Icon name for the activity level\n*
- **L20:** ` public init(`
  - *function*

## ./Development/carmanager-business-logic/Locations/AccuracyLevel.swift
### Public Interface
- **L97:** ` public static func from(accuracy: Double) -> AccuracyLevel`
  - *static function*
  - *Create accuracy level from accuracy value\n*
- **L112:** ` public func isMet(by accuracy: Double) -> Bool`
  - *function*
  - *Check if a location meets this accuracy level\n*
- **L17:** ` public var description: String`
  - *function*
  - *Human-readable description of the accuracy level\n*
- **L33:** ` public var iconName: String`
  - *function*
  - *Icon name for the accuracy level\n*
- **L49:** ` public var colorName: String`
  - *function*
  - *Color representation for the accuracy level\n*
- **L65:** ` public var maxAccuracy: Double`
  - *function*
  - *Maximum accuracy value for this level\n*
- **L81:** ` public var minAccuracy: Double`
  - *function*
  - *Minimum accuracy value for this level\n*

## ./Development/carmanager-business-logic/Locations/LocationTrend.swift
### Public Interface
- **L30:** ` public var formattedDate: String`
  - *function*
  - *Formatted date\n*
- **L38:** ` public var dayOfWeek: DayOfWeek`
  - *function*
  - *Day of week\n*
- **L43:** ` public var timeOfDay: TimeOfDay`
  - *function*
  - *Time of day (using noon as representative)\n*
- **L49:** ` public var formattedTotalDistance: String`
  - *function*
  - *Formatted total distance\n*
- **L64:** ` public var formattedAverageAccuracy: String`
  - *function*
  - *Formatted average accuracy\n*
- **L77:** ` public var activityLevel: ActivityLevel`
  - *function*
  - *Activity level for this day\n*
- **L93:** ` public var dataQualityLevel: AccuracyLevel`
  - *function*
  - *Data quality level for this day\n*
- **L98:** ` public var hasActivity: Bool`
  - *function*
  - *Check if this day has any activity\n*
- **L103:** ` public var hasGoodDataQuality: Bool`
  - *function*
  - *Check if this day has good data quality\n*
- **L226:** ` public var iconName: String`
  - *function*
  - *Icon name for the trend direction\n*
- **L238:** ` public var colorName: String`
  - *function*
  - *Color representation for the trend direction\n*
- **L15:** ` public init(`
  - *function*

### Internal Methods
- **L114:** ` var locationCountTrend: TrendDirection`
  - *function*
  - *Analyze location count trends over the last 7 days\n*
- **L136:** ` var distanceTrend: TrendDirection`
  - *function*
  - *Analyze distance trends over the last 7 days\n*
- **L158:** ` var accuracyTrend: TrendDirection`
  - *function*
  - *Analyze accuracy trends over the last 7 days\n*
- **L181:** ` var mostActiveDay: DayOfWeek?`
  - *function*
  - *Get the most active day\n*
- **L187:** ` var mostActiveTime: TimeOfDay?`
  - *function*
  - *Get the most active time period\n*
- **L193:** ` var totalDistance: CLLocationDistance`
  - *function*
  - *Get the total distance over the trend period\n*
- **L198:** ` var averageDailyDistance: CLLocationDistance`
  - *function*
  - *Get the average daily distance\n*
- **L204:** ` var totalLocationCount: Int`
  - *function*
  - *Get the total location count over the trend period\n*
- **L209:** ` var averageDailyLocationCount: Double`
  - *function*
  - *Get the average daily location count\n*

## ./Development/carmanager-business-logic/Locations/Location+Extensions.swift
### Internal Methods
- **L74:** ` func distance(to otherLocation: Location) -> CLLocationDistance`
  - *function*
- **L79:** ` func formattedDistance(to otherLocation: Location) -> String`
  - *function*
- **L96:** ` func getAddress(completion: @escaping (String?) -> Void)`
  - *function*
- **L128:** ` static func groupByMonth(locations: [Location]) -> [String: [Location]]`
  - *static function*
- **L151:** ` static func getCurrentLocation(for vehicle: Vehicle, in context: NSManagedObjectContext) -> Location?`
  - *static function*
- **L163:** ` static func getHighAccuracyLocations(for vehicle: Vehicle, in context: NSManagedObjectContext) -> [Location]`
  - *static function*
- **L176:** ` static func getLocations(withAccuracyRange minAccuracy: Double, maxAccuracy: Double, for vehicle: Vehicle, in context: NSManagedObjectContext) -> [Location]`
  - *static function*
- **L189:** ` static func getLocations(byType locationType: LocationType, for vehicle: Vehicle, in context: NSManagedObjectContext) -> [Location]`
  - *static function*
- **L201:** ` static func getLocations(byTypeString locationTypeString: String, for vehicle: Vehicle, in context: NSManagedObjectContext) -> [Location]`
  - *static function*
- **L207:** ` static func getLocations(inTimeRange startDate: Date, endDate: Date, for vehicle: Vehicle, in context: NSManagedObjectContext) -> [Location]`
  - *static function*
- **L220:** ` static func getLocations(withAccuracyBetterThan threshold: Double, for vehicle: Vehicle, in context: NSManagedObjectContext) -> [Location]`
  - *static function*
- **L233:** ` static func getAverageAccuracy(for vehicle: Vehicle, in context: NSManagedObjectContext) -> Double`
  - *static function*
- **L281:** ` func updateLocation(`
  - *function*
- **L317:** ` func markAsCurrentLocation()`
  - *function*
- **L340:** ` static func getLocationStatistics(for vehicle: Vehicle, in context: NSManagedObjectContext) -> LocationStatistics`
  - *static function*
- **L369:** ` static func groupByAccuracyLevel(locations: [Location]) -> [AccuracyLevel: [Location]]`
  - *static function*
- **L386:** ` static func getLocations(withinRadius radius: CLLocationDistance, of coordinate: CLLocationCoordinate2D, for vehicle: Vehicle, in context: NSManagedObjectContext) -> [Location]`
  - *static function*
- **L402:** ` static func getClusteredLocations(for vehicle: Vehicle, clusterRadius: CLLocationDistance = 100.0, in context: NSManagedObjectContext) -> [[Location]]`
  - *static function*
- **L441:** ` static func getMostFrequentLocationTypes(for vehicle: Vehicle, in context: NSManagedObjectContext) -> [(LocationType, Int)]`
  - *static function*
- **L462:** ` static func exportToCSV(locations: [Location]) -> String`
  - *static function*
- **L477:** ` static func exportToJSON(locations: [Location]) -> Data?`
  - *static function*
- **L497:** ` static func validateLocationData(_ data: [String: Any]) -> Bool`
  - *static function*
- **L520:** ` func isNear(pointOfInterest: CLLocationCoordinate2D, radius: CLLocationDistance = 100.0) -> Bool`
  - *function*
- **L526:** ` static func getNearbyLocations(to location: Location, radius: CLLocationDistance = 100.0, in context: NSManagedObjectContext) -> [Location]`
  - *static function*
- **L540:** ` static func isSignificantMovement(from previousLocation: Location?, to currentLocation: Location, threshold: CLLocationDistance = 50.0) -> Bool`
  - *static function*
- **L546:** ` static func getLocationChangeRate(from previousLocation: Location, to currentLocation: Location) -> Double?`
  - *static function*
- **L562:** ` func isWithinGeofence(center: CLLocationCoordinate2D, radius: CLLocationDistance) -> Bool`
  - *function*
- **L568:** ` func isWithinRectangularGeofence(northEast: CLLocationCoordinate2D, southWest: CLLocationCoordinate2D) -> Bool`
  - *function*
- **L574:** ` static func calculateCoverageArea(for locations: [Location]) -> Double`
  - *static function*
- **L598:** ` static func getCentroid(of locations: [Location]) -> CLLocationCoordinate2D?`
  - *static function*
- **L613:** ` static func groupByTimeOfDay(locations: [Location]) -> [TimeOfDay: [Location]]`
  - *static function*
- **L629:** ` static func groupByDayOfWeek(locations: [Location]) -> [DayOfWeek: [Location]]`
  - *static function*
- **L645:** ` static func getMostActiveTimePeriods(for vehicle: Vehicle, in context: NSManagedObjectContext) -> [TimeOfDay]`
  - *static function*
- **L665:** ` static func getMostActiveDays(for vehicle: Vehicle, in context: NSManagedObjectContext) -> [DayOfWeek]`
  - *static function*
- **L687:** ` static func getStaleLocations(for vehicle: Vehicle, olderThan days: Int = 7, in context: NSManagedObjectContext) -> [Location]`
  - *static function*
- **L701:** ` static func getLowAccuracyLocations(for vehicle: Vehicle, accuracyThreshold: Double = 50.0, in context: NSManagedObjectContext) -> [Location]`
  - *static function*
- **L714:** ` static func getMostRecentLocations(for vehicles: [Vehicle], in context: NSManagedObjectContext) -> [Vehicle: Location]`
  - *static function*
- **L732:** ` static func isSignificantLocationChange(from previous: Location?, to current: Location, distanceThreshold: CLLocationDistance = 100.0, timeThreshold: TimeInterval = 300.0) -> Bool`
  - *static function*
- **L744:** ` static func generateActivityReport(for vehicle: Vehicle, in context: NSManagedObjectContext) -> LocationActivityReport`
  - *static function*
- **L777:** ` static func getLocationTrends(for vehicle: Vehicle, overDays days: Int = 30, in context: NSManagedObjectContext) -> [LocationTrend]`
  - *static function*
- **L821:** ` static func calculateTotalDistance(locations: [Location]) -> CLLocationDistance`
  - *static function*
- **L837:** ` static func formattedTotalDistance(locations: [Location]) -> String`
  - *static function*
- **L7:** ` var wrappedName: String`
  - *function|extension Location*
- **L11:** ` var formattedDate: String`
  - *function|extension Location*
- **L19:** ` var wrappedNotes: String`
  - *function|extension Location*
- **L25:** ` var wrappedAccuracy: Double`
  - *function|extension Location*
- **L29:** ` var wrappedLocationType: String`
  - *function|extension Location*
- **L33:** ` var locationTypeEnum: LocationType`
  - *function|extension Location*
- **L37:** ` var wrappedTimestamp: Date`
  - *function|extension Location*
- **L41:** ` var isLocationActive: Bool`
  - *function|extension Location*
- **L45:** ` var accuracyDescription: String`
  - *function|extension Location*
- **L57:** ` var locationTypeDescription: String`
  - *function*
- **L61:** ` var locationTypeIcon: String`
  - *function*
- **L65:** ` var coordinate: CLLocationCoordinate2D`
  - *function*
- **L69:** ` var clLocation: CLLocation`
  - *function*
- **L252:** ` var hasValidCoordinates: Bool`
  - *function*
- **L258:** ` var hasValidAccuracy: Bool`
  - *function*
- **L263:** ` var isRecent: Bool`
  - *function*
- **L272:** ` var isStale: Bool`
  - *function*

## ./Development/carmanager-business-logic/Locations/DayOfWeek.swift
### Public Interface
- **L133:** ` public static func from(date: Date) -> DayOfWeek`
  - *static function*
  - *Create day of week from a date\n*
- **L18:** ` public var description: String`
  - *function*
  - *Human-readable description of the day\n*
- **L23:** ` public var shortName: String`
  - *function*
  - *Short abbreviation of the day\n*
- **L43:** ` public var veryShortName: String`
  - *function*
  - *Very short abbreviation of the day\n*
- **L63:** ` public var iconName: String`
  - *function*
  - *Icon name for the day\n*
- **L83:** ` public var colorName: String`
  - *function*
  - *Color representation for the day\n*
- **L103:** ` public var weekdayValue: Int`
  - *function*
  - *Calendar weekday value (1 = Sunday, 2 = Monday, etc.)\n*
- **L123:** ` public var isWeekend: Bool`
  - *function*
  - *Check if this is a weekend day\n*
- **L128:** ` public var isWeekday: Bool`
  - *function*
  - *Check if this is a weekday\n*
- **L158:** ` public var next: DayOfWeek`
  - *function*
  - *Get the next day\n*
- **L178:** ` public var previous: DayOfWeek`
  - *function*
  - *Get the previous day\n*

## ./Development/carmanager-business-logic/Locations/LocationServiceFactory.swift
### Internal Methods
- **L16:** ` static func createLocationService(persistenceController: PersistenceController) -> LocationServiceProtocol`
  - *static function*
- **L58:** ` func requestLocationPermission() async`
  - *function*
- **L62:** ` func startLocationUpdates() async`
  - *function*
- **L66:** ` func stopLocationUpdates() async`
  - *function*
- **L70:** ` func getCurrentLocationPlace() async throws -> Place?`
  - *function*
- **L74:** ` func createPlaceFromLocation(_ location: CLLocation) async throws -> Place`
  - *function*
- **L78:** ` func getLocationName(for location: CLLocation) async throws -> String?`
  - *function*
- **L105:** ` func requestLocationPermission() async`
  - *function*
- **L109:** ` func startLocationUpdates() async`
  - *function*
- **L113:** ` func stopLocationUpdates() async`
  - *function*
- **L117:** ` func getCurrentLocationPlace() async throws -> Place?`
  - *function*
- **L121:** ` func createPlaceFromLocation(_ location: CLLocation) async throws -> Place`
  - *function*
- **L125:** ` func getLocationName(for location: CLLocation) async throws -> String?`
  - *function*
- **L42:** ` var currentLocation: CLLocation?`
  - *function*
- **L46:** ` var authorizationStatus: CLAuthorizationStatus`
  - *function*
- **L50:** ` var isLocationEnabled: Bool`
  - *function*
- **L54:** ` var error: Error?`
  - *function*
- **L98:** ` var currentLocation: CLLocation? { nil }`
  - *function*
- **L99:** ` var authorizationStatus: CLAuthorizationStatus { .denied }`
  - *function*
- **L100:** ` var isLocationEnabled: Bool { false }`
  - *function*
- **L101:** ` var error: Error? { LocationServiceError.permissionDenied }`
  - *function*
- **L36:** ` init(persistenceController: PersistenceController)`
  - *function*
- **L92:** ` init(persistenceController: PersistenceController)`
  - *function*

## ./Development/carmanager-business-logic/Locations/Place+Extensions.swift
### Internal Methods
- **L7:** ` var coordinate: CLLocationCoordinate2D?`
  - *function|extension Place*
  - *Computed property that converts the Place's latitude and longitude to a CLLocationCoordinate2D\n*
- **L15:** ` var hasValidCoordinates: Bool`
  - *function|extension Place*
  - *Check if the place has valid coordinates\n*
- **L20:** ` var formattedAddress: String`
  - *function|extension Place*
  - *Formatted address string\n*
- **L47:** ` var displayName: String`
  - *function|extension Place*
  - *Display name for the place\n*

## ./Development/carmanager-business-logic/Locations/LocationStatistics.swift
### Public Interface
- **L39:** ` public var gpsPercentage: Double`
  - *function*
  - *Percentage of GPS locations\n*
- **L45:** ` public var wifiPercentage: Double`
  - *function*
  - *Percentage of WiFi locations\n*
- **L51:** ` public var cellularPercentage: Double`
  - *function*
  - *Percentage of cellular locations\n*
- **L57:** ` public var manualPercentage: Double`
  - *function*
  - *Percentage of manual locations\n*
- **L63:** ` public var formattedTotalDistance: String`
  - *function*
  - *Formatted total distance\n*
- **L78:** ` public var formattedAverageAccuracy: String`
  - *function*
  - *Formatted average accuracy\n*
- **L91:** ` public var dataQualityScore: Int`
  - *function*
  - *Data quality score (0-100)\n*
- **L114:** ` public var dataQualityDescription: String`
  - *function*
  - *Data quality description\n*
- **L18:** ` public init(`
  - *function*

## ./Development/carmanager-business-logic/Locations/LocationServiceProtocol.swift
### Internal Methods
- **L25:** ` func requestLocationPermission() async`
  - *function*
  - *Request permission to use location services\n*
- **L28:** ` func startLocationUpdates() async`
  - *function*
  - *Start continuous location updates (iOS only)\n*
- **L31:** ` func stopLocationUpdates() async`
  - *function*
  - *Stop continuous location updates\n*
- **L34:** ` func getCurrentLocationPlace() async throws -> Place?`
  - *function*
  - *Get current location and create/return a Place entity\n*
- **L37:** ` func createPlaceFromLocation(_ location: CLLocation) async throws -> Place`
  - *function*
  - *Create a Place entity from a specific location\n*
- **L40:** ` func getLocationName(for location: CLLocation) async throws -> String?`
  - *function*
  - *Get a human-readable name for a location using reverse geocoding\n*
- **L13:** ` var currentLocation: CLLocation? { get }`
  - *function*
  - *Current location if available\n*
- **L16:** ` var authorizationStatus: CLAuthorizationStatus { get }`
  - *function*
  - *Current authorization status for location services\n*
- **L19:** ` var isLocationEnabled: Bool { get }`
  - *function*
  - *Whether location services are enabled and authorized\n*
- **L22:** ` var error: Error? { get }`
  - *function*
  - *Any error that occurred during location operations\n*
- **L51:** ` var errorDescription: String?`
  - *function*

## ./Development/carmanager-business-logic/Locations/LocationType.swift
### Public Interface
- **L17:** ` public var description: String`
  - *function*
  - *Human-readable description of the location type\n*
- **L33:** ` public var iconName: String`
  - *function*
  - *Icon name for the location type\n*
- **L49:** ` public var typicalAccuracy: Double`
  - *function*
  - *Accuracy level associated with this location type\n*
- **L65:** ` public init(from string: String?)`
  - *function*
  - *Initialize from a string value\n*

