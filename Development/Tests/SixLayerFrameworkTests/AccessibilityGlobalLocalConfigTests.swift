import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Test that accessibility functions respect both global and local configuration options
@MainActor
final class AccessibilityGlobalLocalConfigTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
