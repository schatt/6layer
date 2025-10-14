//
//  PlatformLocationExtensions.swift
//  SixLayerFramework
//
//  Cross-platform location services extensions
//

import Foundation
import SwiftUI
import CoreLocation

// MARK: - Cross-Platform Location Extensions

public extension CLLocationManager {
    /// Cross-platform authorization status check
    var platformAuthorizationStatus: PlatformLocationAuthorizationStatus {
        #if os(iOS)
        switch authorizationStatus {
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        case .authorizedWhenInUse:
            return .authorizedWhenInUse
        case .authorizedAlways:
            return .authorizedAlways
        @unknown default:
            return .notDetermined
        }
        #elseif os(macOS)
        switch authorizationStatus {
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        case .authorized:
            return .authorized
        case .authorizedAlways:
            return .authorizedAlways
        @unknown default:
            return .notDetermined
        }
        #else
        return .notDetermined
        #endif
    }
}
