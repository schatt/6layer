import Foundation
import CoreData
import CoreLocation

// MARK: - Location Service Factory

/// Factory for creating platform-appropriate location service implementations
/// This provides a clean abstraction for views to get the right location service
/// without needing to know about platform differences
enum LocationServiceFactory {

    /// Creates the appropriate location service for the current platform
    /// - Parameter persistenceController: The Core Data persistence controller
    /// - Returns: A location service that implements LocationServiceProtocol
    @MainActor
    static func createLocationService(persistenceController: PersistenceController) -> LocationServiceProtocol {
        #if os(iOS)
        return iOSLocationService(persistenceController: persistenceController)
        #elseif os(macOS)
        return macOSLocationService(persistenceController: persistenceController)
        #else
        return NoLocationService(persistenceController: persistenceController)
        #endif
    }
}

// MARK: - Observable Location Service Wrapper

/// Wrapper class that conforms to ObservableObject and holds a LocationServiceProtocol implementation
/// This allows views to use @StateObject while still getting platform-specific functionality
final class ObservableLocationService: ObservableObject, LocationServiceProtocol {

    private let wrappedService: LocationServiceProtocol

    @MainActor
    init(persistenceController: PersistenceController) {
        self.wrappedService = LocationServiceFactory.createLocationService(persistenceController: persistenceController)
    }
    
    // MARK: - LocationServiceProtocol Implementation
    
    var currentLocation: CLLocation? {
        wrappedService.currentLocation
    }
    
    var authorizationStatus: CLAuthorizationStatus {
        wrappedService.authorizationStatus
    }
    
    var isLocationEnabled: Bool {
        wrappedService.isLocationEnabled
    }
    
    var error: Error? {
        wrappedService.error
    }
    
    func requestLocationPermission() async {
        await wrappedService.requestLocationPermission()
    }
    
    func startLocationUpdates() async {
        await wrappedService.startLocationUpdates()
    }
    
    func stopLocationUpdates() async {
        await wrappedService.stopLocationUpdates()
    }
    
    func getCurrentLocationPlace() async throws -> Place? {
        try await wrappedService.getCurrentLocationPlace()
    }
    
    func createPlaceFromLocation(_ location: CLLocation) async throws -> Place {
        try await wrappedService.createPlaceFromLocation(location)
    }
    
    func getLocationName(for location: CLLocation) async throws -> String? {
        try await wrappedService.getLocationName(for: location)
    }
}

// MARK: - No Location Service (Fallback)

/// Fallback location service for unsupported platforms
/// Provides stub implementations that don't crash the app
@Observable
final class NoLocationService: LocationServiceProtocol {
    
    private let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }
    
    // MARK: - Properties
    
    var currentLocation: CLLocation? { nil }
    var authorizationStatus: CLAuthorizationStatus { .denied }
    var isLocationEnabled: Bool { false }
    var error: Error? { LocationServiceError.permissionDenied }
    
    // MARK: - Methods
    
    func requestLocationPermission() async {
        // No-op for unsupported platforms
    }
    
    func startLocationUpdates() async {
        // No-op for unsupported platforms
    }
    
    func stopLocationUpdates() async {
        // No-op for unsupported platforms
    }
    
    func getCurrentLocationPlace() async throws -> Place? {
        throw LocationServiceError.locationNotAvailable
    }
    
    func createPlaceFromLocation(_ location: CLLocation) async throws -> Place {
        throw LocationServiceError.locationNotAvailable
    }
    
    func getLocationName(for location: CLLocation) async throws -> String? {
        throw LocationServiceError.locationNotAvailable
    }
}
