//
//  CoreDataTestUtilities.swift
//  SixLayerFrameworkTests
//
//  Utilities for setting up isolated CoreData and SwiftData stores for testing
//  Prevents CloudKit sync, account services, and other external dependencies
//

import Foundation
import CoreData
#if canImport(SwiftData)
import SwiftData
#endif

/// Utilities for creating isolated CoreData and SwiftData stores for testing
/// These helpers ensure tests don't attempt to sync with CloudKit or access account services
@MainActor
public enum CoreDataTestUtilities {
    
    // MARK: - CoreData Test Setup
    
    /// Creates an isolated NSPersistentContainer for testing
    /// - Parameters:
    ///   - name: The name of the data model (optional, defaults to "TestModel")
    ///   - managedObjectModel: Optional custom NSManagedObjectModel (creates empty one if nil)
    /// - Returns: A configured NSPersistentContainer with all sync features disabled
    public static func createIsolatedTestContainer(
        name: String = "TestModel",
        managedObjectModel: NSManagedObjectModel? = nil
    ) -> NSPersistentContainer {
        let model = managedObjectModel ?? NSManagedObjectModel()
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        
        let desc = NSPersistentStoreDescription()
        
        // Use in-memory store type - no disk persistence, no sync
        desc.type = NSInMemoryStoreType
        
        // Explicit in-memory URL (though NSInMemoryStoreType doesn't require it)
        // This makes it clear we're using in-memory storage
        desc.url = URL(fileURLWithPath: "/dev/null")
        
        // Disable automatic behaviors that might trigger external services
        desc.shouldAddStoreAsynchronously = false
        desc.shouldMigrateStoreAutomatically = false
        desc.shouldInferMappingModelAutomatically = false
        
        // CRITICAL: Disable CloudKit and remote services to prevent XPC communication
        // This prevents attempts to contact Apple services (CloudKit, Account Services, etc.)
        desc.setOption(false as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        desc.setOption(false as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        // Disable CloudKit container options (prevents CloudKit sync)
        if #available(macOS 10.15, iOS 13.0, *) {
            desc.cloudKitContainerOptions = nil
        }
        
        // Additional isolation: prevent CoreData from accessing external account services
        // Note: In-memory stores should not trigger account access, but this provides extra isolation
        // Some versions of CoreData may attempt to access account services even with in-memory stores
        
        container.persistentStoreDescriptions = [desc]
        
        // Load stores synchronously for tests
        var loadError: Error?
        let semaphore = DispatchSemaphore(value: 0)
        
        container.loadPersistentStores { description, error in
            loadError = error
            semaphore.signal()
        }
        
        semaphore.wait()
        
        // Log but don't fail on errors - in-memory test stores may have benign errors
        if let error = loadError {
            print("⚠️ CoreData test store load warning (may be expected): \(error.localizedDescription)")
        }
        
        return container
    }
    
    /// Creates a test NSManagedObjectContext from an isolated container
    /// - Parameter container: The NSPersistentContainer to create a context from
    /// - Returns: A new NSManagedObjectContext configured for testing
    public static func createTestContext(from container: NSPersistentContainer) -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = container.persistentStoreCoordinator
        return context
    }
    
    // MARK: - SwiftData Test Setup (iOS 17+)
    
    #if canImport(SwiftData)
    /// Creates an isolated ModelContainer for SwiftData testing
    /// - Parameters:
    ///   - schema: The SwiftData Schema to use
    ///   - isStoredInMemoryOnly: Whether to use in-memory storage (default: true)
    /// - Returns: A configured ModelContainer with CloudKit sync disabled
    @available(macOS 14.0, iOS 17.0, *)
    public static func createIsolatedTestContainer(
        for schema: Schema,
        isStoredInMemoryOnly: Bool = true
    ) throws -> ModelContainer {
        // Create configuration with in-memory storage
        let configuration = ModelConfiguration(
            isStoredInMemoryOnly: isStoredInMemoryOnly
        )
        
        // IMPORTANT: Do NOT specify cloudKitContainerIdentifier
        // Omitting it ensures no CloudKit sync is attempted
        let container = try ModelContainer(
            for: schema,
            configurations: [configuration]
        )
        
        return container
    }
    
    /// Creates a test ModelContext from an isolated container
    /// - Parameter container: The ModelContainer to create a context from
    /// - Returns: A new ModelContext for testing
    @available(macOS 14.0, iOS 17.0, *)
    public static func createTestContext(from container: ModelContainer) -> ModelContext {
        return ModelContext(container)
    }
    #endif
    
    // MARK: - Best Practices Documentation
    
    /*
     BEST PRACTICES FOR COREDATA/SWIFTDATA TESTING:
     
     1. ALWAYS use in-memory stores for tests
        - NSInMemoryStoreType for CoreData
        - isStoredInMemoryOnly: true for SwiftData
        - This prevents disk I/O and ensures test isolation
     
     2. DISABLE all sync features
        - Set cloudKitContainerOptions = nil
        - Disable NSPersistentHistoryTrackingKey
        - Disable NSPersistentStoreRemoteChangeNotificationPostOptionKey
        - Do NOT specify cloudKitContainerIdentifier for SwiftData
     
     3. DISABLE automatic behaviors
        - shouldMigrateStoreAutomatically = false
        - shouldInferMappingModelAutomatically = false
        - shouldAddStoreAsynchronously = false (for synchronous test execution)
     
     4. USE isolated containers per test
        - Create a new container for each test
        - Don't share containers between tests
        - Clean up containers in tearDown
     
     5. HANDLE errors gracefully
        - In-memory stores may have benign errors
        - Log errors but don't fail tests unless critical
        - Use semaphores or async/await for synchronous loading
     
     6. AVOID external dependencies
        - Don't use NSPersistentCloudKitContainer in tests
        - Don't enable iCloud capabilities in test targets
        - Don't access account services or address book
     
     EXAMPLE USAGE:
     
     // CoreData
     let container = CoreDataTestUtilities.createIsolatedTestContainer()
     let context = container.viewContext
     // ... use context for testing
     
     // SwiftData (iOS 17+)
     let schema = Schema([YourModel.self])
     let container = try CoreDataTestUtilities.createIsolatedTestContainer(for: schema)
     let context = container.mainContext
     // ... use context for testing
     */
}

