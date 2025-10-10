import XCTest
import SwiftUI
import ViewInspector
@testable import SixLayerFramework

/// Test what happens when automatic accessibility IDs are disabled
@MainActor
final class AccessibilityIdentifierDisabledTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
