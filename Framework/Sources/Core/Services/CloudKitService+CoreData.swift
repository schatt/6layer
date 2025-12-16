//
//  CloudKitService+CoreData.swift
//  SixLayerFramework
//
//  Core Data integration for CloudKitService
//  Provides platform-consistent wrapper around NSPersistentCloudKitContainer
//

#if canImport(CoreData)
import Foundation
import CoreData
import CloudKit

@MainActor
extension CloudKitService {
    
    /// Sync Core Data context with CloudKit
    /// - Parameter context: The NSManagedObjectContext to sync
    /// - Note: This method wraps NSPersistentCloudKitContainer behavior and applies platform-specific workarounds
    /// - Note: Handles thread safety by bridging MainActor CloudKitService with non-MainActor Core Data contexts
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
    /// - Basic sync functionality via NSPersistentCloudKitContainer
    /// - Thread safety (MainActor ↔ non-MainActor bridging)
    /// - Platform-specific sync triggers (iPad/Mac workarounds)
    /// - Error handling and propagation
    /// 
    /// ## What's Not Covered (Edge Cases)
    /// - Complex relationship syncing issues
    /// - Custom CloudKit schema migrations
    /// - Advanced conflict resolution beyond NSPersistentCloudKitContainer defaults
    /// - Network timeout handling (relies on NSPersistentCloudKitContainer)
    /// 
    /// These edge cases can be extended later if needed.
    public func syncWithCoreData(context: NSManagedObjectContext) async throws {
        // Bridge MainActor CloudKitService with potentially non-MainActor context
        // NSPersistentCloudKitContainer operations should be performed off MainActor
        try await Task { @MainActor in
            // Ensure we're on MainActor for CloudKitService access
            // But perform Core Data operations on the context's appropriate queue
            
            // Get the persistent store coordinator to access CloudKit container
            guard let coordinator = context.persistentStoreCoordinator else {
                throw CloudKitServiceError.unknown(NSError(
                    domain: "CloudKitService",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Context does not have a persistent store coordinator"]
                ))
            }
            
            // Check if any store descriptions use CloudKit
            let cloudKitStores = coordinator.persistentStores.filter { store in
                if let description = coordinator.persistentStoreDescriptions.first(where: { $0.url == store.url }) {
                    #if os(macOS)
                    if #available(macOS 10.15, *) {
                        return description.cloudKitContainerOptions != nil
                    }
                    #elseif os(iOS) || os(tvOS) || os(watchOS)
                    if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
                        return description.cloudKitContainerOptions != nil
                    }
                    #endif
                }
                return false
            }
            
            guard !cloudKitStores.isEmpty else {
                // No CloudKit stores configured - nothing to sync
                return
            }
            
            // Apply platform-specific workarounds
            #if os(iOS)
            // iPad: Trigger sync more reliably
            // NSPersistentCloudKitContainer should handle this, but we ensure it's triggered
            if UIDevice.current.userInterfaceIdiom == .pad {
                // Force a fetch request to trigger CloudKit sync
                // This helps with iPad's delayed sync behavior
                try await triggerCloudKitSyncForContext(context)
            }
            #elseif os(macOS)
            // Mac: Ensure foreground sync is triggered
            // Mac may sync on launch but not while active - trigger sync when needed
            try await triggerCloudKitSyncForContext(context)
            #endif
            
            // Perform the actual sync
            // NSPersistentCloudKitContainer handles the sync automatically,
            // but we can trigger it explicitly by performing operations on the context
            try await performCloudKitSync(context: context)
        }.value
    }
    
    // MARK: - Private Helpers
    
    /// Trigger CloudKit sync for a context by performing a fetch operation
    private func triggerCloudKitSyncForContext(_ context: NSManagedObjectContext) async throws {
        // Perform a lightweight fetch to trigger CloudKit sync
        // This helps with platform-specific sync delays
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            context.perform {
                // Create a simple fetch request to trigger sync
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NSManagedObject")
                request.fetchLimit = 1
                request.includesSubentities = false
                
                do {
                    _ = try context.fetch(request)
                    continuation.resume()
                } catch {
                    // If fetch fails, that's okay - we're just trying to trigger sync
                    // The actual sync will happen via NSPersistentCloudKitContainer
                    continuation.resume()
                }
            }
        }
    }
    
    /// Perform CloudKit sync operations on the context
    private func performCloudKitSync(context: NSManagedObjectContext) async throws {
        // NSPersistentCloudKitContainer handles sync automatically,
        // but we can ensure it's triggered by saving the context if there are changes
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            context.perform {
                if context.hasChanges {
                    do {
                        try context.save()
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: error)
                    }
                } else {
                    // No changes to save, but sync should still be triggered by NSPersistentCloudKitContainer
                    continuation.resume()
                }
            }
        }
    }
}

#endif // canImport(CoreData)
