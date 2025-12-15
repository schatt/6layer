//
//  LocationServiceMock.swift
//  SixLayerTestKit
//
//  Mock implementation of LocationService for testing
//

import Foundation
import CoreLocation
import SixLayerFramework

/// Mock implementation of LocationService for testing
/// Mock implementation of LocationService for testing
/// Note: This is a standalone test utility
public class LocationServiceMock {

    // MARK: - Configuration

    public enum MockMode {
        case success
        case failure(error: Error)
        case custom(handler: (LocationOperation) async throws -> Any)
    }

    private var mode: MockMode = .success

    // MARK: - Mock State Tracking

    public private(set) var requestLocationWasCalled = false
    public private(set) var mockLocation: CLLocation = CLLocation(
        latitude: 37.7749,
        longitude: -122.4194
    )

    public private(set) var requestPermissionWasCalled = false
    public private(set) var permissionStatus: CLAuthorizationStatus = {
        #if os(iOS)
        return .authorizedWhenInUse
        #else
        return .authorizedAlways
        #endif
    }()

    public private(set) var startMonitoringWasCalled = false
    public private(set) var stopMonitoringWasCalled = false

    // MARK: - Configuration Methods

    /// Configure mock to return success for all operations
    public func configureSuccessResponse() {
        mode = .success
    }

    /// Configure mock to return failure for all operations
    public func configureFailureResponse(error: Error = NSError(domain: "LocationError", code: 1, userInfo: nil)) {
        mode = .failure(error: error)
    }

    /// Configure custom response handler
    public func configureCustomResponse(handler: @escaping (LocationOperation) async throws -> Any) {
        mode = .custom(handler: handler)
    }

    /// Configure mock location
    public func configureLocation(latitude: Double, longitude: Double) {
        mockLocation = CLLocation(latitude: latitude, longitude: longitude)
    }

    /// Configure permission status
    public func configurePermissionStatus(_ status: CLAuthorizationStatus) {
        permissionStatus = status
    }

    /// Reset all tracking state
    public func reset() {
        requestLocationWasCalled = false
        requestPermissionWasCalled = false
        startMonitoringWasCalled = false
        stopMonitoringWasCalled = false
        mode = .success
    }

    // MARK: - LocationServiceDelegate Implementation

    public var authorizationStatus: CLAuthorizationStatus {
        return permissionStatus
    }

    public func requestLocationPermission() async throws {
        requestPermissionWasCalled = true

        switch mode {
        case .success:
            return
        case .failure(let error):
            throw error
        case .custom(let handler):
            _ = try await handler(.requestPermission)
        }
    }

    public func requestCurrentLocation() async throws -> CLLocation {
        requestLocationWasCalled = true

        switch mode {
        case .success:
            return mockLocation
        case .failure(let error):
            throw error
        case .custom(let handler):
            let result = try await handler(.requestLocation)
            guard let location = result as? CLLocation else {
                throw NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"])
            }
            return location
        }
    }

    public func startMonitoringLocation() {
        startMonitoringWasCalled = true
    }

    public func stopMonitoringLocation() {
        stopMonitoringWasCalled = true
    }
}

// MARK: - Location Operation Types

/// Simplified location operation types for testing
public enum LocationOperation {
    case requestPermission
    case requestLocation
    case startMonitoring
    case stopMonitoring
}