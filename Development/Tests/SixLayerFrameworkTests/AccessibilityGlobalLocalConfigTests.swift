import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Test that accessibility functions respect both global and local configuration options
@MainActor
final class AccessibilityGlobalLocalConfigTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        await AccessibilityTestUtilities.setupAccessibilityTestEnvironment()
    }
    
    override func tearDown() async throws {
        await AccessibilityTestUtilities.cleanupAccessibilityTestEnvironment()
        try await super.tearDown()
    }
