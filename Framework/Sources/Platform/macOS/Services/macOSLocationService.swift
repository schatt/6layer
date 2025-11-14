//
//  macOSLocationService.swift
//  SixLayerFramework
//
//  macOS-specific location service implementation with proper Swift 6 actor isolation
//

import Foundation
import CoreLocation
import Combine

// MARK: - Location Service Protocol

/// Protocol defining the interface for location services
@MainActor
public protocol LocationServiceProtocol {
    /// Current authorization status
    var authorizationStatus: CLAuthorizationStatus { get }

    /// Whether location services are enabled
    var isLocationEnabled: Bool { get }

    /// Any error that occurred
    var error: Error? { get }

    /// Request location authorization
    func requestAuthorization() async throws

    /// Start location updates
    func startUpdatingLocation()

    /// Stop location updates
    func stopUpdatingLocation()

    /// Get current location
    func getCurrentLocation() async throws -> CLLocation
}

// MARK: - macOS Location Service

/// macOS-specific location service implementation
/// Properly handles actor isolation for Swift 6 strict concurrency
@MainActor
public final class macOSLocationService: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {

    // MARK: - Public Properties

    public private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined
    public private(set) var isLocationEnabled: Bool = false
    public private(set) var error: Error?

    // MARK: - Private Properties

    private let locationManager: CLLocationManager
    private var authorizationContinuation: CheckedContinuation<Void, Error>?
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?

    // MARK: - Initialization

    public override init() {
        self.locationManager = CLLocationManager()
        super.init()

        locationManager.delegate = self
        updateLocationEnabledStatus()
    }

    // MARK: - LocationServiceProtocol Implementation

    public func requestAuthorization() async throws {
        // Check if we can request authorization
        guard CLLocationManager.locationServicesEnabled() else {
            throw LocationServiceError.servicesDisabled
        }

        // On macOS, we need to request authorization
        locationManager.requestAlwaysAuthorization()

        // Wait for authorization response
        try await withCheckedThrowingContinuation { continuation in
            self.authorizationContinuation = continuation

            // Set a timeout in case the user doesn't respond
            Task {
                try await Task.sleep(nanoseconds: 30_000_000_000) // 30 seconds
                if let continuation = self.authorizationContinuation {
                    self.authorizationContinuation = nil
                    continuation.resume(throwing: LocationServiceError.authorizationTimeout)
                }
            }
        }
    }

    public func startUpdatingLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            error = LocationServiceError.servicesDisabled
            return
        }

        guard authorizationStatus == .authorizedAlways else {
            error = LocationServiceError.unauthorized
            return
        }

        locationManager.startUpdatingLocation()
    }

    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    public func getCurrentLocation() async throws -> CLLocation {
        guard CLLocationManager.locationServicesEnabled() else {
            throw LocationServiceError.servicesDisabled
        }

        guard authorizationStatus == .authorizedAlways else {
            throw LocationServiceError.unauthorized
        }

        // Start location updates temporarily
        locationManager.startUpdatingLocation()

        // Wait for a location update
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation

            // Set a timeout
            Task {
                try await Task.sleep(nanoseconds: 10_000_000_000) // 10 seconds
                if let continuation = self.locationContinuation {
                    self.locationContinuation = nil
                    continuation.resume(throwing: LocationServiceError.locationTimeout)
                }
            }
        }
    }

    // MARK: - CLLocationManagerDelegate

    nonisolated public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            authorizationStatus = status
            updateLocationEnabledStatus()

            // Resume authorization continuation if waiting
            if let continuation = authorizationContinuation {
                authorizationContinuation = nil
                switch authorizationStatus {
                case .authorizedAlways:
                    continuation.resume()
                #if os(iOS)
                case .authorizedWhenInUse:
                    continuation.resume()
                #endif
                case .denied:
                    continuation.resume(throwing: LocationServiceError.denied)
                case .restricted:
                    continuation.resume(throwing: LocationServiceError.restricted)
                case .notDetermined:
                    // Still waiting
                    break
                @unknown default:
                    continuation.resume(throwing: LocationServiceError.unknown)
                }
            }
        }
    }

    nonisolated public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            // Resume location continuation if waiting
            if let continuation = locationContinuation, let location = locations.last {
                locationContinuation = nil
                locationManager.stopUpdatingLocation()
                continuation.resume(returning: location)
            }
        }
    }

    nonisolated public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.error = error

            // Resume continuations with error
            if let continuation = authorizationContinuation {
                authorizationContinuation = nil
                continuation.resume(throwing: error)
            }

            if let continuation = locationContinuation {
                locationContinuation = nil
                continuation.resume(throwing: error)
            }
        }
    }

    // MARK: - Private Methods

    private func updateLocationEnabledStatus() {
        #if os(iOS)
        isLocationEnabled = CLLocationManager.locationServicesEnabled() &&
                           (authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse)
        #else
        isLocationEnabled = CLLocationManager.locationServicesEnabled() &&
                           (authorizationStatus == .authorizedAlways)
        #endif
    }
}

// MARK: - Location Service Errors

public enum LocationServiceError: LocalizedError {
    case servicesDisabled
    case unauthorized
    case denied
    case restricted
    case authorizationTimeout
    case locationTimeout
    case unknown

    public var errorDescription: String? {
        switch self {
        case .servicesDisabled:
            return "Location services are disabled on this device"
        case .unauthorized:
            return "Location access is not authorized"
        case .denied:
            return "Location access was denied by the user"
        case .restricted:
            return "Location access is restricted"
        case .authorizationTimeout:
            return "Authorization request timed out"
        case .locationTimeout:
            return "Location request timed out"
        case .unknown:
            return "An unknown location error occurred"
        }
    }
}

// MARK: - Thread Safety

// macOSLocationService is marked @MainActor and implements proper async/await patterns,
// making it safe to use within the main actor context
