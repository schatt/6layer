import CoreData
import CoreLocation
import Foundation
import SwiftUI

extension Location {
    var wrappedName: String {
        name ?? "Location"
    }

    var formattedDate: String {
        guard let date = date else { return "Unknown date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var wrappedNotes: String {
        notes ?? ""
    }

    // MARK: - Enhanced Location Properties

    var wrappedAccuracy: Double {
        accuracy
    }

    var wrappedLocationType: String {
        locationType ?? "Unknown"
    }

    var locationTypeEnum: LocationType {
        LocationType(from: locationType)
    }

    var wrappedTimestamp: Date {
        timestamp ?? date ?? Date()
    }

    var isLocationActive: Bool {
        isCurrentLocation
    }

    var accuracyDescription: String {
        if accuracy <= 0 {
            return "Unknown accuracy"
        } else if accuracy <= 5 {
            return "High accuracy (±\(Int(accuracy))m)"
        } else if accuracy <= 20 {
            return "Medium accuracy (±\(Int(accuracy))m)"
        } else {
            return "Low accuracy (±\(Int(accuracy))m)"
        }
    }

    var locationTypeDescription: String {
        return locationTypeEnum.description
    }

    var locationTypeIcon: String {
        return locationTypeEnum.iconName
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }

    // Calculate distance between two locations
    func distance(to otherLocation: Location) -> CLLocationDistance {
        return clLocation.distance(from: otherLocation.clLocation)
    }

    // Format distance in a human-readable way
    func formattedDistance(to otherLocation: Location) -> String {
        let distanceInMeters = distance(to: otherLocation)

        let formatter = MeasurementFormatter()
        formatter.unitOptions = .naturalScale
        formatter.unitStyle = .medium

        if Locale.current.measurementSystem == .metric {
            let measurement = Measurement(value: distanceInMeters, unit: UnitLength.meters)
            return formatter.string(from: measurement)
        } else {
            let measurement = Measurement(value: distanceInMeters / 1609.344, unit: UnitLength.miles)
            return formatter.string(from: measurement)
        }
    }

    // Get address from coordinates
    func getAddress(completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(clLocation) { placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                completion(nil)
                return
            }

            var addressComponents: [String] = []

            if let thoroughfare = placemark.thoroughfare {
                addressComponents.append(thoroughfare)
            }

            if let locality = placemark.locality {
                addressComponents.append(locality)
            }

            if let administrativeArea = placemark.administrativeArea {
                addressComponents.append(administrativeArea)
            }

            if let postalCode = placemark.postalCode {
                addressComponents.append(postalCode)
            }

            let address = addressComponents.joined(separator: ", ")
            completion(address)
        }
    }

    // Helper method to get locations grouped by month
    static func groupByMonth(locations: [Location]) -> [String: [Location]] {
        var groupedLocations: [String: [Location]] = [:]

        for location in locations {
            guard let date = location.date else { continue }

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM"
            let monthKey = formatter.string(from: date)

            if groupedLocations[monthKey] == nil {
                groupedLocations[monthKey] = []
            }

            groupedLocations[monthKey]?.append(location)
        }

        return groupedLocations
    }

    // MARK: - Enhanced Location Methods

    // Get current active location for a vehicle
    static func getCurrentLocation(for vehicle: Vehicle, in context: NSManagedObjectContext) -> Location? {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "vehicle == %@", vehicle),
            NSPredicate(format: "isCurrentLocation == YES")
        ])
        fetchRequest.fetchLimit = 1
        
        return try? context.fetch(fetchRequest).first
    }

    // Get locations with high accuracy (GPS)
    static func getHighAccuracyLocations(for vehicle: Vehicle, in context: NSManagedObjectContext) -> [Location] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "vehicle == %@", vehicle),
            NSPredicate(format: "locationType == %@", LocationType.gps.rawValue),
            NSPredicate(format: "accuracy <= %f", 5.0)
        ])
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Location.date, ascending: false)]
        
        return (try? context.fetch(fetchRequest)) ?? []
    }

    // Get locations within a specific accuracy range
    static func getLocations(withAccuracyRange minAccuracy: Double, maxAccuracy: Double, for vehicle: Vehicle, in context: NSManagedObjectContext) -> [Location] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "vehicle == %@", vehicle),
            NSPredicate(format: "accuracy >= %f", minAccuracy),
            NSPredicate(format: "accuracy <= %f", maxAccuracy)
        ])
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Location.date, ascending: false)]
        
        return (try? context.fetch(fetchRequest)) ?? []
    }

    // Get locations by type
    static func getLocations(byType locationType: LocationType, for vehicle: Vehicle, in context: NSManagedObjectContext) -> [Location] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "vehicle == %@", vehicle),
            NSPredicate(format: "locationType == %@", locationType.rawValue)
        ])
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Location.date, ascending: false)]
        
        return (try? context.fetch(fetchRequest)) ?? []
    }

    // Get locations by type string (for backward compatibility)
    static func getLocations(byTypeString locationTypeString: String, for vehicle: Vehicle, in context: NSManagedObjectContext) -> [Location] {
        let locationType = LocationType(from: locationTypeString)
        return getLocations(byType: locationType, for: vehicle, in: context)
    }

    // Get locations within a specific time range
    static func getLocations(inTimeRange startDate: Date, endDate: Date, for vehicle: Vehicle, in context: NSManagedObjectContext) -> [Location] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "vehicle == %@", vehicle),
            NSPredicate(format: "date >= %@", startDate as NSDate),
            NSPredicate(format: "date <= %@", endDate as NSDate)
        ])
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Location.date, ascending: true)]
        
        return (try? context.fetch(fetchRequest)) ?? []
    }

    // Get locations with accuracy better than a threshold
    static func getLocations(withAccuracyBetterThan threshold: Double, for vehicle: Vehicle, in context: NSManagedObjectContext) -> [Location] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "vehicle == %@", vehicle),
            NSPredicate(format: "accuracy > 0"),
            NSPredicate(format: "accuracy <= %f", threshold)
        ])
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Location.date, ascending: false)]
        
        return (try? context.fetch(fetchRequest)) ?? []
    }

    // Get average accuracy for a vehicle's locations
    static func getAverageAccuracy(for vehicle: Vehicle, in context: NSManagedObjectContext) -> Double {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "vehicle == %@", vehicle)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "vehicle == %@", vehicle),
            NSPredicate(format: "accuracy > 0")
        ])
        
        guard let locations = try? context.fetch(fetchRequest), !locations.isEmpty else {
            return 0.0
        }
        
        let totalAccuracy = locations.reduce(0.0) { $0 + $1.accuracy }
        return totalAccuracy / Double(locations.count)
    }

    // MARK: - Validation Methods

    // Validate location coordinates
    var hasValidCoordinates: Bool {
        return latitude >= -90.0 && latitude <= 90.0 &&
               longitude >= -180.0 && longitude <= 180.0
    }

    // Validate accuracy value
    var hasValidAccuracy: Bool {
        return accuracy >= 0.0
    }

    // Check if location is recent (within last 24 hours)
    var isRecent: Bool {
        let calendar = Calendar.current
        let now = Date()
        guard let date = date else { return false }
        return calendar.isDate(date, inSameDayAs: now) || 
               calendar.isDate(date, equalTo: now, toGranularity: .day)
    }

    // Check if location is stale (older than 7 days)
    var isStale: Bool {
        guard let date = date else { return true }
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return date < sevenDaysAgo
    }

    // MARK: - Convenience Methods

    // Update location with new data
    func updateLocation(
        name: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        accuracy: Double? = nil,
        locationType: LocationType? = nil,
        notes: String? = nil,
        isCurrentLocation: Bool? = nil
    ) {
        if let name = name {
            self.name = name
        }
        if let latitude = latitude {
            self.latitude = latitude
        }
        if let longitude = longitude {
            self.longitude = longitude
        }
        if let accuracy = accuracy {
            self.accuracy = accuracy
        }
        if let locationType = locationType {
            self.locationType = locationType.rawValue
        }
        if let notes = notes {
            self.notes = notes
        }
        if let isCurrentLocation = isCurrentLocation {
            self.isCurrentLocation = isCurrentLocation
        }
        
        // Update timestamp
        self.timestamp = Date()
    }

    // Mark as current location for vehicle
    func markAsCurrentLocation() {
        // First, unmark any other current locations for this vehicle
        if let vehicle = vehicle, let context = vehicle.managedObjectContext {
            let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "vehicle == %@", vehicle),
                NSPredicate(format: "isCurrentLocation == YES")
            ])
            
            if let existingCurrent = try? context.fetch(fetchRequest) {
                for location in existingCurrent {
                    location.isCurrentLocation = false
                }
            }
        }
        
        self.isCurrentLocation = true
        self.timestamp = Date()
    }

    // MARK: - Analysis Methods

    // Get location statistics for a vehicle
    static func getLocationStatistics(for vehicle: Vehicle, in context: NSManagedObjectContext) -> LocationStatistics {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "vehicle == %@", vehicle)
        
        guard let locations = try? context.fetch(fetchRequest) else {
            return LocationStatistics()
        }
        
        let totalLocations = locations.count
        let gpsLocations = locations.filter { $0.locationTypeEnum == .gps }.count
        let wifiLocations = locations.filter { $0.locationTypeEnum == .wifi }.count
        let cellularLocations = locations.filter { $0.locationTypeEnum == .cellular }.count
        let manualLocations = locations.filter { $0.locationTypeEnum == .manual }.count
        
        let averageAccuracy = getAverageAccuracy(for: vehicle, in: context)
        let totalDistance = calculateTotalDistance(locations: locations)
        
        return LocationStatistics(
            totalLocations: totalLocations,
            gpsLocations: gpsLocations,
            wifiLocations: wifiLocations,
            cellularLocations: cellularLocations,
            manualLocations: manualLocations,
            averageAccuracy: averageAccuracy,
            totalDistance: totalDistance
        )
    }

    // Get locations grouped by accuracy level
    static func groupByAccuracyLevel(locations: [Location]) -> [AccuracyLevel: [Location]] {
        var grouped: [AccuracyLevel: [Location]] = [:]
        
        for location in locations {
            let level = AccuracyLevel.from(accuracy: location.accuracy)
            if grouped[level] == nil {
                grouped[level] = []
            }
            grouped[level]?.append(location)
        }
        
        return grouped
    }

    // MARK: - Clustering and Analysis

    // Get locations within a specific radius of a coordinate
    static func getLocations(withinRadius radius: CLLocationDistance, of coordinate: CLLocationCoordinate2D, for vehicle: Vehicle, in context: NSManagedObjectContext) -> [Location] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "vehicle == %@", vehicle)
        
        guard let locations = try? context.fetch(fetchRequest) else {
            return []
        }
        
        let centerLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return locations.filter { location in
            let locationCoordinate = CLLocation(latitude: location.latitude, longitude: location.longitude)
            return centerLocation.distance(from: locationCoordinate) <= radius
        }
    }

    // Get locations clustered by proximity
    static func getClusteredLocations(for vehicle: Vehicle, clusterRadius: CLLocationDistance = 100.0, in context: NSManagedObjectContext) -> [[Location]] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "vehicle == %@", vehicle)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Location.date, ascending: false)]
        
        guard let locations = try? context.fetch(fetchRequest) else {
            return []
        }
        
        var clusters: [[Location]] = []
        var processedLocations: Set<Location> = []
        
        for location in locations {
            if processedLocations.contains(location) {
                continue
            }
            
            var cluster: [Location] = [location]
            processedLocations.insert(location)
            
            for otherLocation in locations {
                if processedLocations.contains(otherLocation) || otherLocation == location {
                    continue
                }
                
                let distance = location.distance(to: otherLocation)
                if distance <= clusterRadius {
                    cluster.append(otherLocation)
                    processedLocations.insert(otherLocation)
                }
            }
            
            clusters.append(cluster)
        }
        
        return clusters
    }

    // Get the most frequent location types for a vehicle
    static func getMostFrequentLocationTypes(for vehicle: Vehicle, in context: NSManagedObjectContext) -> [(LocationType, Int)] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "vehicle == %@", vehicle)
        
        guard let locations = try? context.fetch(fetchRequest) else {
            return []
        }
        
        var typeCounts: [LocationType: Int] = [:]
        
        for location in locations {
            let type = location.locationTypeEnum
            typeCounts[type, default: 0] += 1
        }
        
        return typeCounts.sorted { $0.value > $1.value }
    }

    // MARK: - Export and Import

    // Export locations to CSV format
    static func exportToCSV(locations: [Location]) -> String {
        var csv = "Name,Latitude,Longitude,Accuracy,Type,Date,Notes,IsCurrentLocation\n"
        
        for location in locations {
            let name = location.wrappedName.replacingOccurrences(of: ",", with: ";")
            let notes = location.wrappedNotes.replacingOccurrences(of: ",", with: ";")
            let date = location.formattedDate.replacingOccurrences(of: ",", with: ";")
            
            csv += "\(name),\(location.latitude),\(location.longitude),\(location.accuracy),\(location.wrappedLocationType),\(date),\(notes),\(location.isCurrentLocation)\n"
        }
        
        return csv
    }

    // Export locations to JSON format
    static func exportToJSON(locations: [Location]) -> Data? {
        let locationData = locations.map { location -> [String: Any] in
            var data: [String: Any] = [:]
            data["id"] = location.id?.uuidString
            data["name"] = location.name
            data["latitude"] = location.latitude
            data["longitude"] = location.longitude
            data["accuracy"] = location.accuracy
            data["locationType"] = location.locationType
            data["date"] = location.date?.timeIntervalSince1970
            data["timestamp"] = location.timestamp?.timeIntervalSince1970
            data["notes"] = location.notes
            data["isCurrentLocation"] = location.isCurrentLocation
            return data
        }
        
        return try? JSONSerialization.data(withJSONObject: locationData, options: .prettyPrinted)
    }

    // Validate location data before import
    static func validateLocationData(_ data: [String: Any]) -> Bool {
        guard let latitude = data["latitude"] as? Double,
              let longitude = data["longitude"] as? Double else {
            return false
        }
        
        // Check coordinate validity
        guard latitude >= -90.0 && latitude <= 90.0,
              longitude >= -180.0 && longitude <= 180.0 else {
            return false
        }
        
        // Check accuracy if present
        if let accuracy = data["accuracy"] as? Double {
            guard accuracy >= 0.0 else { return false }
        }
        
        return true
    }

    // MARK: - Notifications and Alerts

    // Check if location is near a specific point of interest
    func isNear(pointOfInterest: CLLocationCoordinate2D, radius: CLLocationDistance = 100.0) -> Bool {
        let poiLocation = CLLocation(latitude: pointOfInterest.latitude, longitude: pointOfInterest.longitude)
        return clLocation.distance(from: poiLocation) <= radius
    }

    // Get nearby locations within a radius
    static func getNearbyLocations(to location: Location, radius: CLLocationDistance = 100.0, in context: NSManagedObjectContext) -> [Location] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "vehicle == %@", location.vehicle ?? Vehicle())
        
        guard let locations = try? context.fetch(fetchRequest) else {
            return []
        }
        
        return locations.filter { otherLocation in
            otherLocation != location && location.distance(to: otherLocation) <= radius
        }
    }

    // Check if location represents a significant movement
    static func isSignificantMovement(from previousLocation: Location?, to currentLocation: Location, threshold: CLLocationDistance = 50.0) -> Bool {
        guard let previous = previousLocation else { return true }
        return currentLocation.distance(to: previous) > threshold
    }

    // Get location change rate (speed) between two locations
    static func getLocationChangeRate(from previousLocation: Location, to currentLocation: Location) -> Double? {
        guard let previousDate = previousLocation.date,
              let currentDate = currentLocation.date else {
            return nil
        }
        
        let timeDifference = currentDate.timeIntervalSince(previousDate)
        guard timeDifference > 0 else { return nil }
        
        let distance = currentLocation.distance(to: previousLocation)
        return distance / timeDifference // meters per second
    }

    // MARK: - Geofencing and Area Calculations

    // Check if location is within a circular geofence
    func isWithinGeofence(center: CLLocationCoordinate2D, radius: CLLocationDistance) -> Bool {
        let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        return clLocation.distance(from: centerLocation) <= radius
    }

    // Check if location is within a rectangular geofence
    func isWithinRectangularGeofence(northEast: CLLocationCoordinate2D, southWest: CLLocationCoordinate2D) -> Bool {
        return latitude <= northEast.latitude && latitude >= southWest.latitude &&
               longitude <= northEast.longitude && longitude >= southWest.longitude
    }

    // Calculate the area covered by a set of locations (convex hull approximation)
    static func calculateCoverageArea(for locations: [Location]) -> Double {
        guard locations.count >= 3 else { return 0.0 }
        
        // Simple convex hull area calculation
        let sortedLocations = locations.sorted { $0.latitude < $1.latitude }
        let minLat = sortedLocations.first!.latitude
        let maxLat = sortedLocations.last!.latitude
        
        let sortedByLon = locations.sorted { $0.longitude < $1.longitude }
        let minLon = sortedByLon.first!.longitude
        let maxLon = sortedByLon.last!.longitude
        
        // Approximate area using bounding box (this is a simplified calculation)
        let latSpan = maxLat - minLat
        let lonSpan = maxLon - minLon
        
        // Convert to approximate square meters (very rough approximation)
        let latMeters = latSpan * 111000 // 1 degree latitude ≈ 111km
        let lonMeters = lonSpan * 111000 * cos(minLat * .pi / 180) // Adjust for longitude
        
        return latMeters * lonMeters
    }

    // Get the centroid of a set of locations
    static func getCentroid(of locations: [Location]) -> CLLocationCoordinate2D? {
        guard !locations.isEmpty else { return nil }
        
        let totalLat = locations.reduce(0.0) { $0 + $1.latitude }
        let totalLon = locations.reduce(0.0) { $0 + $1.longitude }
        
        let avgLat = totalLat / Double(locations.count)
        let avgLon = totalLon / Double(locations.count)
        
        return CLLocationCoordinate2D(latitude: avgLat, longitude: avgLon)
    }

    // MARK: - Time-Based Analysis

    // Get locations grouped by time of day
    static func groupByTimeOfDay(locations: [Location]) -> [TimeOfDay: [Location]] {
        var grouped: [TimeOfDay: [Location]] = [:]
        
        for location in locations {
            guard let date = location.date else { continue }
            let timeOfDay = TimeOfDay.from(date: date)
            if grouped[timeOfDay] == nil {
                grouped[timeOfDay] = []
            }
            grouped[timeOfDay]?.append(location)
        }
        
        return grouped
    }

    // Get locations grouped by day of week
    static func groupByDayOfWeek(locations: [Location]) -> [DayOfWeek: [Location]] {
        var grouped: [DayOfWeek: [Location]] = [:]
        
        for location in locations {
            guard let date = location.date else { continue }
            let dayOfWeek = DayOfWeek.from(date: date)
            if grouped[dayOfWeek] == nil {
                grouped[dayOfWeek] = []
            }
            grouped[dayOfWeek]?.append(location)
        }
        
        return grouped
    }

    // Get the most active time periods for a vehicle
    static func getMostActiveTimePeriods(for vehicle: Vehicle, in context: NSManagedObjectContext) -> [TimeOfDay] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "vehicle == %@", vehicle)
        
        guard let locations = try? context.fetch(fetchRequest) else {
            return []
        }
        
        var timePeriodCounts: [TimeOfDay: Int] = [:]
        
        for location in locations {
            guard let date = location.date else { continue }
            let timeOfDay = TimeOfDay.from(date: date)
            timePeriodCounts[timeOfDay, default: 0] += 1
        }
        
        return timePeriodCounts.sorted { $0.value > $1.value }.map { $0.key }
    }

    // Get the most active days for a vehicle
    static func getMostActiveDays(for vehicle: Vehicle, in context: NSManagedObjectContext) -> [DayOfWeek] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "vehicle == %@", vehicle)
        
        guard let locations = try? context.fetch(fetchRequest) else {
            return []
        }
        
        var dayCounts: [DayOfWeek: Int] = [:]
        
        for location in locations {
            guard let date = location.date else { continue }
            let dayOfWeek = DayOfWeek.from(date: date)
            dayCounts[dayOfWeek, default: 0] += 1
        }
        
        return dayCounts.sorted { $0.value > $1.value }.map { $0.key }
    }

    // MARK: - Additional Utility Methods

    // Get locations that haven't been updated recently
    static func getStaleLocations(for vehicle: Vehicle, olderThan days: Int = 7, in context: NSManagedObjectContext) -> [Location] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "vehicle == %@", vehicle),
            NSPredicate(format: "date < %@", cutoffDate as NSDate)
        ])
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Location.date, ascending: false)]
        
        return (try? context.fetch(fetchRequest)) ?? []
    }

    // Get locations with low accuracy that might need re-acquisition
    static func getLowAccuracyLocations(for vehicle: Vehicle, accuracyThreshold: Double = 50.0, in context: NSManagedObjectContext) -> [Location] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "vehicle == %@", vehicle),
            NSPredicate(format: "accuracy > %f", accuracyThreshold),
            NSPredicate(format: "accuracy > 0")
        ])
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Location.date, ascending: false)]
        
        return (try? context.fetch(fetchRequest)) ?? []
    }

    // Get the most recent location for each vehicle
    static func getMostRecentLocations(for vehicles: [Vehicle], in context: NSManagedObjectContext) -> [Vehicle: Location] {
        var result: [Vehicle: Location] = [:]
        
        for vehicle in vehicles {
            let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "vehicle == %@", vehicle)
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Location.date, ascending: false)]
            fetchRequest.fetchLimit = 1
            
            if let mostRecent = try? context.fetch(fetchRequest).first {
                result[vehicle] = mostRecent
            }
        }
        
        return result
    }

    // Check if a location represents a significant change from the previous location
    static func isSignificantLocationChange(from previous: Location?, to current: Location, distanceThreshold: CLLocationDistance = 100.0, timeThreshold: TimeInterval = 300.0) -> Bool {
        guard let previous = previous else { return true }
        
        let distance = current.distance(to: previous)
        let timeDifference = current.date?.timeIntervalSince(previous.date ?? Date()) ?? 0
        
        return distance > distanceThreshold || timeDifference > timeThreshold
    }

    // MARK: - Reporting and Analytics

    // Generate a location activity report for a vehicle
    static func generateActivityReport(for vehicle: Vehicle, in context: NSManagedObjectContext) -> LocationActivityReport {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "vehicle == %@", vehicle)
        
        guard let locations = try? context.fetch(fetchRequest) else {
            return LocationActivityReport()
        }
        
        let totalLocations = locations.count
        let totalDistance = calculateTotalDistance(locations: locations)
        let averageAccuracy = getAverageAccuracy(for: vehicle, in: context)
        
        let timeOfDayGroups = groupByTimeOfDay(locations: locations)
        let dayOfWeekGroups = groupByDayOfWeek(locations: locations)
        let accuracyGroups = groupByAccuracyLevel(locations: locations)
        
        let mostActiveTime = getMostActiveTimePeriods(for: vehicle, in: context).first
        let mostActiveDay = getMostActiveDays(for: vehicle, in: context).first
        
        return LocationActivityReport(
            vehicle: vehicle,
            totalLocations: totalLocations,
            totalDistance: totalDistance,
            averageAccuracy: averageAccuracy,
            timeOfDayDistribution: timeOfDayGroups,
            dayOfWeekDistribution: dayOfWeekGroups,
            accuracyDistribution: accuracyGroups,
            mostActiveTime: mostActiveTime,
            mostActiveDay: mostActiveDay
        )
    }

    // Get location trends over time
    static func getLocationTrends(for vehicle: Vehicle, overDays days: Int = 30, in context: NSManagedObjectContext) -> [LocationTrend] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "vehicle == %@", vehicle),
            NSPredicate(format: "date >= %@", startDate as NSDate)
        ])
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Location.date, ascending: true)]
        
        guard let locations = try? context.fetch(fetchRequest) else {
            return []
        }
        
        var trends: [LocationTrend] = []
        let calendar = Calendar.current
        
        for dayOffset in 0..<days {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else { continue }
            let dayStart = calendar.startOfDay(for: date)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) ?? date
            
            let dayLocations = locations.filter { location in
                guard let locationDate = location.date else { return false }
                return locationDate >= dayStart && locationDate < dayEnd
            }
            
            let dayDistance = calculateTotalDistance(locations: dayLocations)
            let dayAccuracy = dayLocations.isEmpty ? 0.0 : dayLocations.reduce(0.0) { $0 + $1.accuracy } / Double(dayLocations.count)
            
            let trend = LocationTrend(
                date: dayStart,
                locationCount: dayLocations.count,
                totalDistance: dayDistance,
                averageAccuracy: dayAccuracy
            )
            
            trends.append(trend)
        }
        
        return trends.reversed() // Return in chronological order
    }

    // Calculate total distance between a series of locations
    static func calculateTotalDistance(locations: [Location]) -> CLLocationDistance {
        guard locations.count > 1 else { return 0 }

        // Sort locations by date
        let sortedLocations = locations.sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }

        var totalDistance: CLLocationDistance = 0

        for i in 0..<(sortedLocations.count - 1) {
            totalDistance += sortedLocations[i].distance(to: sortedLocations[i + 1])
        }

        return totalDistance
    }

    // Format total distance in a human-readable way
    static func formattedTotalDistance(locations: [Location]) -> String {
        let distanceInMeters = calculateTotalDistance(locations: locations)

        let formatter = MeasurementFormatter()
        formatter.unitOptions = .naturalScale
        formatter.unitStyle = .medium

        if Locale.current.measurementSystem == .metric {
            let measurement = Measurement(value: distanceInMeters, unit: UnitLength.meters)
            return formatter.string(from: measurement)
        } else {
            let measurement = Measurement(value: distanceInMeters / 1609.344, unit: UnitLength.miles)
            return formatter.string(from: measurement)
        }
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let addLocation = Notification.Name("addLocation")
    static let locationAdded = Notification.Name("locationAdded")
    static let locationUpdated = Notification.Name("locationUpdated")
    static let locationDeleted = Notification.Name("locationDeleted")
}
