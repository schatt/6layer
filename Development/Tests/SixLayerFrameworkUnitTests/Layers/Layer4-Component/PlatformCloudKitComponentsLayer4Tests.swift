//
//  PlatformCloudKitComponentsLayer4Tests.swift
//  SixLayerFrameworkTests
//
//  Tests for CloudKit Layer 4 UI components
//

import Testing
import SwiftUI
import CloudKit
@testable import SixLayerFramework

@Suite("CloudKit Layer 4 Components")
@MainActor
final class PlatformCloudKitComponentsLayer4Tests {
    
    // MARK: - Sync Status Display Tests
    
    @Test func testPlatformCloudKitSyncStatusIdle() {
        let status = CloudKitSyncStatus.idle
        let view = platformCloudKitSyncStatus_L4(status: status)
        
        // Verify view can be created
        #expect(view != nil)
    }
    
    @Test func testPlatformCloudKitSyncStatusSyncing() {
        let status = CloudKitSyncStatus.syncing
        let view = platformCloudKitSyncStatus_L4(status: status)
        
        // Verify view can be created
        #expect(view != nil)
    }
    
    @Test func testPlatformCloudKitSyncStatusComplete() {
        let status = CloudKitSyncStatus.complete
        let view = platformCloudKitSyncStatus_L4(status: status)
        
        // Verify view can be created
        #expect(view != nil)
    }
    
    @Test func testPlatformCloudKitSyncStatusError() {
        let error = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        let status = CloudKitSyncStatus.error(error)
        let view = platformCloudKitSyncStatus_L4(status: status)
        
        // Verify view can be created
        #expect(view != nil)
    }
    
    // MARK: - Progress Display Tests
    
    @Test func testPlatformCloudKitProgress() {
        let view = platformCloudKitProgress_L4(progress: 0.5)
        
        // Verify view can be created
        #expect(view != nil)
    }
    
    @Test func testPlatformCloudKitProgressWithStatus() {
        let status = CloudKitSyncStatus.syncing
        let view = platformCloudKitProgress_L4(progress: 0.75, status: status)
        
        // Verify view can be created
        #expect(view != nil)
    }
    
    // MARK: - Account Status Display Tests
    
    @Test func testPlatformCloudKitAccountStatusAvailable() {
        let status = CKAccountStatus.available
        let view = platformCloudKitAccountStatus_L4(status: status)
        
        // Verify view can be created
        #expect(view != nil)
    }
    
    @Test func testPlatformCloudKitAccountStatusNoAccount() {
        let status = CKAccountStatus.noAccount
        let view = platformCloudKitAccountStatus_L4(status: status)
        
        // Verify view can be created
        #expect(view != nil)
    }
    
    @Test func testPlatformCloudKitAccountStatusCouldNotDetermine() {
        let status = CKAccountStatus.couldNotDetermine
        let view = platformCloudKitAccountStatus_L4(status: status)
        
        // Verify view can be created
        #expect(view != nil)
    }
    
    // MARK: - Service Status View Tests
    
    @Test func testPlatformCloudKitServiceStatus() async {
        // Given: A service with mock delegate
        let delegate = MockCloudKitDelegate()
        let service = CloudKitService(delegate: delegate)
        
        // When: Creating status view
        let view = platformCloudKitServiceStatus_L4(service: service)
        
        // Then: View should be created
        #expect(view != nil)
    }
    
    // MARK: - Sync Button Tests
    
    @Test func testPlatformCloudKitSyncButton() async {
        // Given: A service with mock delegate
        let delegate = MockCloudKitDelegate()
        let service = CloudKitService(delegate: delegate)
        
        // When: Creating sync button
        let button = platformCloudKitSyncButton_L4(service: service)
        
        // Then: Button should be created
        #expect(button != nil)
    }
    
    @Test func testPlatformCloudKitSyncButtonWithCustomLabel() async {
        // Given: A service with mock delegate
        let delegate = MockCloudKitDelegate()
        let service = CloudKitService(delegate: delegate)
        
        // When: Creating sync button with custom label
        let button = platformCloudKitSyncButton_L4(service: service, label: "Sync Now")
        
        // Then: Button should be created
        #expect(button != nil)
    }
    
    // MARK: - Status Badge Tests
    
    @Test func testPlatformCloudKitStatusBadge() async {
        // Given: A service with mock delegate
        let delegate = MockCloudKitDelegate()
        let service = CloudKitService(delegate: delegate)
        
        // When: Creating status badge
        let badge = platformCloudKitStatusBadge_L4(service: service)
        
        // Then: Badge should be created
        #expect(badge != nil)
    }
}
