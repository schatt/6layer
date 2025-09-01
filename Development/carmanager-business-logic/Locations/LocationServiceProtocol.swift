import Foundation
import CoreLocation
import CoreData

// MARK: - Location Service Protocol

/// Protocol defining the interface for location services across platforms
/// This allows us to have platform-specific implementations while maintaining
/// a consistent API for views and other components
@MainActor
protocol LocationServiceProtocol {
    /// Current location if available
    var currentLocation: CLLocation? { get }
    
    /// Current authorization status for location services
    var authorizationStatus: CLAuthorizationStatus { get }
    
    /// Whether location services are enabled and authorized
    var isLocationEnabled: Bool { get }
    
    /// Any error that occurred during location operations
    var error: Error? { get }
    
    /// Request permission to use location services
    func requestLocationPermission() async
    
    /// Start continuous location updates (iOS only)
    func startLocationUpdates() async
    
    /// Stop continuous location updates
    func stopLocationUpdates() async
    
    /// Get current location and create/return a Place entity
    func getCurrentLocationPlace() async throws -> Place?
    
    /// Create a Place entity from a specific location
    func createPlaceFromLocation(_ location: CLLocation) async throws -> Place
    
    /// Get a human-readable name for a location using reverse geocoding
    func getLocationName(for location: CLLocation) async throws -> String?
}

// MARK: - Location Service Errors

enum LocationServiceError: Error, LocalizedError {
    case locationNotAvailable
    case permissionDenied
    case reverseGeocodingFailed
    case coreDataError(Error)
    
    var errorDescription: String? {
        switch self {
        case .locationNotAvailable:
            return "Location is not currently available"
        case .permissionDenied:
            return "Location permission was denied"
        case .reverseGeocodingFailed:
            return "Failed to get location name"
        case .coreDataError(let error):
            return "Core Data error: \(error.localizedDescription)"
        }
    }
}
