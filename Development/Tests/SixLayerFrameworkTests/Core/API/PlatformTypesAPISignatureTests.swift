import Testing

import Foundation
import SwiftUI
@testable import SixLayerFramework

/// NOTE: Not marked @MainActor on class to allow parallel execution
open class PlatformTypesAPISignatureTests: BaseTestClass {
    // MARK: - SixLayerPlatform API
    @Test func testSixLayerPlatformCasesExist() {
        let all = SixLayerPlatform.allCases
        #expect(all.contains(.iOS))
        #expect(all.contains(.macOS))
        #expect(all.contains(.watchOS))
        #expect(all.contains(.tvOS))
        #expect(all.contains(.visionOS))
    }

    @Test func testSixLayerPlatformCurrentAvailable() {
        // compile-time current
        let platform = SixLayerPlatform.current
        // non-optional assertion ensures API exists
        let _ = platform
    }

    @Test @MainActor func testSixLayerPlatformCurrentPlatformAvailable() {
        initializeTestConfig()
        // runtime-aware accessor
        let platform = SixLayerPlatform.currentPlatform
        let _ = platform
    }

    // MARK: - DeviceType API
    @Test func testDeviceTypeCasesExist() {
        let all = DeviceType.allCases
        #expect(!all.isEmpty)
        #expect(all.contains(.phone))
        #expect(all.contains(.pad))
        #expect(all.contains(.mac))
        #expect(all.contains(.tv))
        #expect(all.contains(.watch))
        #expect(all.contains(.car))
        #expect(all.contains(.vision))
    }

    @Test @MainActor func testDeviceTypeCurrentAvailable() {
        initializeTestConfig()
        let deviceType = DeviceType.current
        let _ = deviceType
    }
}


