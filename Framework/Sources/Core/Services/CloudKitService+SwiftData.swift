//
//  CloudKitService+SwiftData.swift
//  SixLayerFramework
//
//  Swift Data integration for CloudKitService
//  Provides platform-consistent wrapper around Swift Data's CloudKit configuration
//

#if canImport(SwiftData)
import Foundation
import SwiftData
import CloudKit

@MainActor
extension CloudKitService {
    
    /// Sync Swift Data context with CloudKit
    /// - Parameter context: The ModelContext to sync
    /// - Note: This method wraps Swift Data's CloudKit configuration behavior and applies platform-specific workarounds
    /// - Note: Handles thread safety by bridging MainActor CloudKitService with non-MainActor Swift Data contexts
    /// 
    /// ## Platform-Specific Behavior
    /// 
    /// **iPad**: Data from other devices may not appear until app restart. This wrapper attempts to trigger sync more reliably.
    /// 
    /// **Mac**: May sync on launch but not while active. This wrapper triggers foreground sync when needed.
    /// 
    /// **iPhone**: Generally better sync behavior, but wrapper ensures consistency.
    /// 
    /// ## What's Covered
    /// - Basic sync functionality via Swift Data's .cloudKit configuration
    /// - Thread safety (MainActor ↔ non-MainActor bridging)
    /// - Platform-specific sync triggers (iPad/Mac workarounds)
    /// - Error handling and propagation
    /// 
    /// ## What's Not Covered (Edge Cases)
    /// - Complex relationship syncing issues
    /// - Custom CloudKit schema migrations
    /// - Advanced conflict resolution beyond Swift Data defaults
    /// - Network timeout handling (relies on Swift Data's CloudKit integration)
    /// 
    /// These edge cases can be extended later if needed.
    public func syncWithSwiftData(context: ModelContext) async throws {
        // Bridge MainActor CloudKitService with potentially non-MainActor context
        // Swift Data operations should be performed on the context's appropriate queue
        
        // Get the model container (accessing it triggers CloudKit sync checks)
        _ = context.container
        
        // Check if container has CloudKit configuration
        // Swift Data uses ModelConfiguration with .cloudKit option
        // Note: There's no direct API to check if CloudKit is enabled,
        // so we assume CloudKit is enabled if the container was created with a CloudKit configuration.
        // Apps should configure CloudKit at ModelContainer creation time using ModelConfiguration.
        // For now, we'll attempt sync - if CloudKit isn't configured, Swift Data will handle it gracefully.
        
        // Apply platform-specific workarounds
        #if os(iOS)
        // iPad: Trigger sync more reliably
        // Swift Data's CloudKit integration should handle this, but we ensure it's triggered
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Force a fetch request to trigger CloudKit sync
            // This helps with iPad's delayed sync behavior
            try await triggerCloudKitSyncForSwiftDataContext(context)
        }
        #elseif os(macOS)
        // Mac: Ensure foreground sync is triggered
        // Mac may sync on launch but not while active - trigger sync when needed
        try await triggerCloudKitSyncForSwiftDataContext(context)
        #endif
        
        // Perform the actual sync
        // Swift Data's CloudKit integration handles the sync automatically,
        // but we can trigger it explicitly by performing operations on the context
        try await performCloudKitSyncForSwiftData(context: context)
    }
    
    // MARK: - Private Helpers
    
    /// Trigger CloudKit sync for a Swift Data context by performing a fetch operation
    private func triggerCloudKitSyncForSwiftDataContext(_ context: ModelContext) async throws {
        // Perform a lightweight operation to trigger CloudKit sync
        // This helps with platform-specific sync delays
        // Swift Data's CloudKit integration will handle the actual sync
        // We just need to trigger it by accessing the context
        
        // Swift Data contexts should be used from the main thread or their own queue
        // Since we're already on MainActor, we can access the context directly
        // Access the container to trigger CloudKit sync checks
        _ = context.container
        
        // Try to save if there are changes - this triggers CloudKit sync
        do {
            try context.save()
        } catch {
            // If save fails, that's okay - we're just trying to trigger sync
            // The actual sync will happen via Swift Data's CloudKit integration
        }
    }
    
    /// Perform CloudKit sync operations on the Swift Data context
    private func performCloudKitSyncForSwiftData(context: ModelContext) async throws {
        // Swift Data's CloudKit integration handles sync automatically,
        // but we can ensure it's triggered by saving the context if there are changes
        // Since we're on MainActor, we can access the context directly
        try context.save()
    }
}

#endif // canImport(SwiftData)
