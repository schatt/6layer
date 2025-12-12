# Add CloudKit Service with Delegate Pattern

## Overview

Add a CloudKit service to the SixLayer Framework that eliminates boilerplate code while allowing apps to provide app-specific configuration and business logic through a delegate/callback pattern.

## Motivation

CloudKit is commonly used in iOS/macOS apps but requires significant boilerplate code:
- Container initialization
- Record CRUD operations
- Conflict resolution
- Progress tracking
- Error handling
- Account status checking

However, CloudKit also requires app-specific configuration:
- Container identifier (app-specific)
- Entitlements (app-specific)
- Schema (app-specific data models)
- Conflict resolution strategies (varies by app)
- Business logic around sync

**Solution**: Provide a framework service that handles the boilerplate, while apps provide app-specific logic through a delegate protocol.

## Architecture Pattern

This follows existing framework patterns:
- **Protocol-based extensibility**: Similar to `FormStateStorage` protocol
- **Callback patterns**: Similar to `onComplete`, `onItemSelected` callbacks in Layer 1
- **Service pattern**: Similar to `LocationService`, `OCRService`, `BarcodeService`
- **UI components**: Similar to `platformPrint_L4()` for progress bars and sync status

## Proposed API Design

### Error Types

```swift
public enum CloudKitServiceError: LocalizedError {
    case containerNotFound
    case accountUnavailable
    case networkUnavailable
    case writeNotSupportedOnPlatform
    case missingRequiredField(String)
    case recordNotFound
    case conflictDetected(local: CKRecord, remote: CKRecord)
    case quotaExceeded
    case permissionDenied
    case invalidRecord
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .containerNotFound:
            return "CloudKit container not found"
        case .accountUnavailable:
            return "iCloud account is not available"
        case .networkUnavailable:
            return "Network is not available"
        case .writeNotSupportedOnPlatform:
            return "Write operations are not supported on this platform"
        case .missingRequiredField(let field):
            return "Required field '\(field)' is missing"
        case .recordNotFound:
            return "Record not found"
        case .conflictDetected:
            return "Record conflict detected"
        case .quotaExceeded:
            return "CloudKit quota exceeded"
        case .permissionDenied:
            return "Permission denied"
        case .invalidRecord:
            return "Invalid record"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}

public enum CloudKitSyncStatus {
    case idle
    case syncing
    case paused
    case error(Error)
    case complete
}
```

### Core Service

```swift
@MainActor
public class CloudKitService: ObservableObject {
    // Published properties for UI binding
    @Published public var syncStatus: CloudKitSyncStatus = .idle
    @Published public var syncProgress: Double = 0.0
    @Published public var accountStatus: CKAccountStatus = .couldNotDetermine
    @Published public var lastError: Error?
    
    // Delegate for app-specific logic
    public weak var delegate: CloudKitServiceDelegate?
    
    // Container (initialized via delegate)
    private var container: CKContainer?
    
    // Database selection (default: private)
    public var database: CKDatabase { get }
    
    // Initialization
    public init(delegate: CloudKitServiceDelegate, usePublicDatabase: Bool = false) {
        self.delegate = delegate
        initializeContainer()
        self.database = usePublicDatabase ? container.publicCloudDatabase : container.privateCloudDatabase
    }
    
    // Basic CRUD operations
    public func save(_ record: CKRecord) async throws -> CKRecord
    public func fetch(recordID: CKRecord.ID) async throws -> CKRecord?
    public func delete(recordID: CKRecord.ID) async throws
    public func query(_ query: CKQuery) async throws -> [CKRecord]
    
    // Batch operations (more efficient)
    public func save(_ records: [CKRecord]) async throws -> [CKRecord]
    public func delete(_ recordIDs: [CKRecord.ID]) async throws
    
    // Sync operations
    public func sync() async throws
    public func startPeriodicSync(interval: TimeInterval)
    public func stopPeriodicSync()
    
    // Account management
    public func checkAccountStatus() async throws -> CKAccountStatus
    public func requestAccountStatus() async throws
}
```

### Delegate Protocol

```swift
@MainActor
public protocol CloudKitServiceDelegate: AnyObject {
    // Required: Container identifier
    func containerIdentifier() -> String
    
    // Optional: Conflict resolution
    func resolveConflict(local: CKRecord, remote: CKRecord) -> CKRecord?
    
    // Optional: Record validation
    func validateRecord(_ record: CKRecord) throws
    
    // Optional: Record transformation
    func transformRecord(_ record: CKRecord) -> CKRecord
    
    // Optional: Custom error handling
    func handleError(_ error: Error) -> Bool // returns true if handled
    
    // Optional: Sync completion notification
    func syncDidComplete(success: Bool, recordsChanged: Int)
}
```

### Default Implementation (Framework Provides)

**The framework provides default implementations for all optional methods via a protocol extension.** Developers only need to implement methods they want to customize.

The framework provides default implementations for all optional methods via a protocol extension. Developers only need to implement methods they want to customize.

**Note**: `containerIdentifier()` is **required** and has no default - you must implement it.

```swift
// Framework provides these defaults (developers don't need to implement unless customizing)
extension CloudKitServiceDelegate {
    public func resolveConflict(local: CKRecord, remote: CKRecord) -> CKRecord? {
        // Default: Use remote (server wins)
        return remote
    }
    
    public func validateRecord(_ record: CKRecord) throws {
        // Default: No validation
    }
    
    public func transformRecord(_ record: CKRecord) -> CKRecord {
        // Default: No transformation
        return record
    }
    
    public func handleError(_ error: Error) -> Bool {
        // Default: Framework handles errors
        return false
    }
    
    public func syncDidComplete(success: Bool, recordsChanged: Int) {
        // Default: No action
    }
}
```

### Minimal Developer Implementation

With framework defaults, developers only need to implement the required method:

```swift
class MyAppCloudKitDelegate: CloudKitServiceDelegate {
    // REQUIRED: Only this method must be implemented
    func containerIdentifier() -> String {
        return "iCloud.com.example.myapp"
    }
    
    // Optional: Override only if you need custom conflict resolution
    func resolveConflict(local: CKRecord, remote: CKRecord) -> CKRecord? {
        // Custom logic: merge timestamps, prefer local, etc.
        return mergeRecords(local, remote)
    }
    
    // All other methods use framework defaults unless overridden
}
```

### Layer 4 UI Components

```swift
// Sync status indicator
func platformCloudKitSyncStatus_L4(
    service: CloudKitService
) -> some View

// Progress bar
func platformCloudKitProgress_L4(
    progress: Binding<Double>,
    status: CloudKitSyncStatus
) -> some View

// Account status view
func platformCloudKitAccountStatus_L4(
    status: CKAccountStatus,
    onSignIn: (() -> Void)? = nil
) -> some View
```

## Implementation Details

### Framework Provides (Boilerplate Elimination)

1. **Container Management**
   - Initialization from delegate-provided identifier
   - Database selection (private/public)
   - Account status checking

2. **Progress Tracking**
   - `@Published` properties for UI binding
   - Progress calculation from CloudKit operations
   - Status state machine (idle, syncing, error, complete)

3. **Basic CRUD Operations**
   - Save, fetch, delete, query operations
   - Error handling infrastructure
   - Retry logic for transient errors

4. **Sync Operations**
   - Manual sync trigger
   - Periodic sync with configurable interval
   - Conflict detection and delegate notification

5. **UI Components**
   - Sync status indicator
   - Progress bar
   - Account status view
   - Error display components

### App Provides (Via Delegate)

1. **Container Identifier** (Required)
   - App-specific CloudKit container identifier

2. **Conflict Resolution** (Optional)
   - App-specific conflict resolution logic
   - Can choose: server wins, client wins, merge, custom

3. **Record Validation** (Optional)
   - Validate records before save
   - Throw errors for invalid records

4. **Record Transformation** (Optional)
   - Transform records before save/fetch
   - Useful for data migration or normalization

5. **Custom Error Handling** (Optional)
   - Handle specific errors app-specifically
   - Return `true` if handled, `false` to use framework defaults

6. **Sync Completion** (Optional)
   - Notification when sync completes
   - Useful for UI updates or analytics

## Usage Example

```swift
// App implements delegate
class MyAppCloudKitDelegate: CloudKitServiceDelegate {
    func containerIdentifier() -> String {
        return "iCloud.com.example.myapp"
    }
    
    func resolveConflict(local: CKRecord, remote: CKRecord) -> CKRecord? {
        // Custom conflict resolution: merge timestamps
        let merged = local.copy() as! CKRecord
        if let remoteDate = remote.modificationDate,
           let localDate = local.modificationDate,
           remoteDate > localDate {
            // Remote is newer, use remote values
            return remote
        }
        return local
    }
    
    func validateRecord(_ record: CKRecord) throws {
        // Ensure required fields exist
        guard record["title"] != nil else {
            throw CloudKitServiceError.missingRequiredField("title")
        }
    }
}

// Initialize service
let delegate = MyAppCloudKitDelegate()
let cloudKitService = CloudKitService(delegate: delegate)

// Use in SwiftUI
struct MyView: View {
    @StateObject var cloudKit = CloudKitService(delegate: MyAppCloudKitDelegate())
    
    var body: some View {
        VStack {
            // Sync status indicator
            platformCloudKitSyncStatus_L4(service: cloudKit)
            
            // Progress bar
            platformCloudKitProgress_L4(
                progress: $cloudKit.syncProgress,
                status: cloudKit.syncStatus
            )
            
            // Account status
            platformCloudKitAccountStatus_L4(
                status: cloudKit.accountStatus
            )
        }
    }
}

// Save a record
Task {
    let record = CKRecord(recordType: "Task")
    record["title"] = "My Task"
    try await cloudKitService.save(record)
}
```

## Cross-Platform Considerations

### iOS
- ✅ **Full CloudKit support**
- ✅ Private and public databases
- ✅ Background sync support
- ✅ Account status checking
- ✅ All CRUD operations

### macOS
- ✅ **Full CloudKit support**
- ✅ Private and public databases
- ✅ Same API as iOS
- ✅ Account status checking
- ✅ All CRUD operations

### visionOS
- ✅ **Full CloudKit support** (based on iOS)
- ✅ Private and public databases
- ✅ Account status checking
- ✅ All CRUD operations

### tvOS
- ⚠️ **Limited CloudKit support**
- ✅ Public database (read-only)
- ❌ No private database
- ❌ No write operations (save/delete)
- ✅ Read operations (fetch/query)
- ✅ Account status checking
- **Note**: Service should detect platform and disable write operations on tvOS

### watchOS
- ⚠️ **Limited CloudKit support**
- ✅ Public database (read-only)
- ❌ No private database
- ❌ No write operations (save/delete)
- ✅ Read operations (fetch/query)
- ✅ Account status checking
- **Note**: Service should detect platform and disable write operations on watchOS

### Platform Detection in Service

The service should automatically detect the platform and adjust behavior:

```swift
private var isReadOnlyPlatform: Bool {
    #if os(tvOS) || os(watchOS)
    return true
    #else
    return false
    #endif
}

// In save/delete methods:
public func save(_ record: CKRecord) async throws -> CKRecord {
    guard !isReadOnlyPlatform else {
        throw CloudKitServiceError.writeNotSupportedOnPlatform
    }
    // ... save implementation
}
```

### Testing
- Framework tests should avoid CloudKit (see `CoreDataTestUtilities`)
- Service should be mockable via protocol
- Apps can provide mock delegates for testing
- Platform-specific behavior should be testable

## Implementation Checklist

### Phase 1: Core Service
- [ ] Create `CloudKitService` class
- [ ] Define `CloudKitServiceDelegate` protocol
- [ ] Implement container initialization
- [ ] Implement basic CRUD operations
- [ ] Add progress tracking
- [ ] Add error handling infrastructure
- [ ] Define `CloudKitQueueStorage` protocol
- [ ] Implement `UserDefaultsCloudKitQueueStorage` (default, no setup)

### Phase 2: Sync Operations & Offline Queue
- [ ] Implement manual sync
- [ ] Implement periodic sync
- [ ] Add conflict detection
- [ ] Integrate with delegate for conflict resolution
- [ ] Implement offline queue management
- [ ] Add network reachability monitoring
- [ ] Implement automatic queue flushing when network returns
- [ ] Provide example Core Data entity
- [ ] Provide example SwiftData model
- [ ] Implement `CoreDataCloudKitQueueStorage`
- [ ] Implement `SwiftDataCloudKitQueueStorage`

### Phase 3: UI Components (Layer 4)
- [ ] Create `platformCloudKitSyncStatus_L4()`
- [ ] Create `platformCloudKitProgress_L4()`
- [ ] Create `platformCloudKitAccountStatus_L4()`
- [ ] Add error display components

### Phase 4: Testing & Documentation
- [ ] Write tests (using mock delegates)
- [ ] Create usage guide
- [ ] Add examples
- [ ] Update framework documentation

## Design Decisions

### Why Delegate Pattern?
- **Flexibility**: Apps provide only what they need
- **Testability**: Easy to mock for testing
- **Separation of Concerns**: Framework handles boilerplate, app handles business logic
- **Consistency**: Matches existing framework patterns (`FormStateStorage`, callbacks)

### Why Not Full Abstraction?
- **App-Specific Requirements**: Container identifiers, entitlements, schemas are app-specific
- **Business Logic**: Conflict resolution, validation vary by app
- **Flexibility**: Apps need control over sync behavior

### Why UI Components?
- **Progress Bars**: User-visible sync progress
- **Status Indicators**: Visual feedback for sync state
- **Account Status**: Handle signed-out states gracefully
- **Framework Focus**: UI abstraction is core to framework

## Related

- `LocationService.swift` - Similar service pattern
- `OCRService.swift` - Similar service pattern with protocol
- `FormStateStorage` - Protocol-based extensibility pattern
- `platformPrint_L4()` - Similar UI component pattern
- `CoreDataTestUtilities.swift` - Notes on avoiding CloudKit in tests

## Reference Implementation Patterns

A reference implementation provides useful patterns to learn from:

### Key Patterns to Learn From:

1. **Offline Queue with Core Data Entity**
   - Queue entity stores queued operations with status, priority, retry count
   - Network monitoring with `NWPathMonitor`
   - Automatic queue processing when network returns
   - Retry logic with exponential backoff (1min, 2min, 4min, 8min...)
   - Priority-based queue processing

2. **Comprehensive Error Handling**
   - Error enum mapping all `CKError` codes
   - Detailed error descriptions
   - Error conversion from `CKError` to framework errors

3. **Conflict Resolution System**
   - Conflict structure with field-level conflict detection
   - Multiple resolution strategies (keepLocal, keepRemote, merge, keepBoth)
   - Conflict UI for user resolution
   - Bulk resolution options

4. **Sync Status & Progress Tracking**
   - Detailed sync status with progress, item counts, ETA
   - Statistics for tracking sync performance
   - Real-time status updates during sync

5. **Consistency Verification**
   - Separate consistency verifier service
   - Detects and repairs data inconsistencies
   - Separate from core sync logic

### Differences from Framework Design:

- **Reference uses Core Data directly** - Framework should use protocol-based storage
- **Reference is app-specific** - Framework should be generic
- **Reference has singleton pattern** - Framework should allow multiple instances
- **Reference integrates with specific entities** - Framework should work with any data model

### What to Adopt:

- ✅ Network monitoring pattern (`NWPathMonitor`)
- ✅ Queue entity structure (as example for apps)
- ✅ Retry logic with exponential backoff
- ✅ Comprehensive error mapping
- ✅ Conflict detection patterns
- ✅ Progress tracking approach

### What to Adapt:

- ⚠️ Replace singleton with instance-based service
- ⚠️ Replace Core Data dependency with protocol-based storage
- ⚠️ Make conflict resolution more generic (delegate-based)
- ⚠️ Simplify for framework use (reference has app-specific complexity)

## Additional Considerations

### Database Selection
- Service supports both private and public databases
- Default: private database (most common use case)
- Can be specified at initialization: `CloudKitService(delegate: delegate, usePublicDatabase: true)`

### Batch Operations
- CloudKit supports batch operations for efficiency
- Service provides batch save/delete methods
- Reduces network round-trips

### Network Handling & Offline Queue Management

**CloudKit's Built-in Behavior:**
- CloudKit automatically retries failed operations (with exponential backoff)
- Handles transient network errors
- **Operations fail immediately if network is unavailable** (no automatic queuing)
- No persistent queue across app restarts

**The Problem:**
If an app wants true offline support (queue operations when offline, execute when back online), they need to:
1. Detect network unavailability
2. Store operations locally (UserDefaults, Core Data, SQLite, etc.)
3. Monitor network reachability
4. Retry queued operations when network returns
5. Handle conflicts when operations finally execute (records may have changed)
6. Clean up successful operations from queue
7. Handle app restarts (queue must persist)

**This is complex and error-prone** - most apps either:
- Don't support offline (operations fail when offline)
- Use NSPersistentCloudKitContainer (which handles this automatically)
- Implement custom queue logic (significant development effort)

**Framework Service Options:**

**Option 1: No Queue (Simplest)**
- Operations fail with `networkUnavailable` error when offline
- Apps handle retries themselves (or don't support offline)
- **Pros**: Simplest implementation, no storage needed
- **Cons**: Poor offline experience, apps must implement complex queue logic themselves

**Option 2: Framework Provides Queue (Recommended)**
- Service queues operations when network unavailable
- Automatically executes queued operations when network returns
- Uses persistent storage (UserDefaults or lightweight storage)
- Handles conflicts via delegate
- **Pros**: Better offline experience, eliminates app complexity
- **Cons**: More framework code, requires storage, potential for stale operations

**Recommendation**: **Option 2** - Framework should provide offline queue management because:
- It's a common need (most apps want offline support)
- It's complex to implement correctly (conflict handling, persistence, retries)
- Framework can provide a robust, tested implementation
- Apps can opt-out if they don't need it

**Implementation Approach:**

**Option 2A: Framework Manages Storage (Simpler for Apps)**
- Framework uses UserDefaults or lightweight storage
- Apps don't need to set up anything
- **Pros**: Zero setup, works out of the box
- **Cons**: Less flexible, can't integrate with app's existing data model

**Option 2B: Apps Provide Storage Entity (More Flexible)**
- Framework provides example Core Data/SwiftData/SQLite entities
- Apps add the entity to their existing schema
- Framework uses app's storage via protocol
- **Pros**: Integrates with app's data model, more flexible, follows framework's protocol pattern
- **Cons**: Apps need to set up entity, framework needs storage protocol

**Recommendation: Option 2B** - Follows framework's extensibility pattern (like `FormStateStorage`)

**Implementation:**
```swift
// Protocol for queue storage (apps implement or use provided examples)
public protocol CloudKitQueueStorage {
    func enqueue(_ operation: QueuedCloudKitOperation) throws
    func dequeue() throws -> QueuedCloudKitOperation?
    func peek() throws -> QueuedCloudKitOperation?
    func remove(_ operation: QueuedCloudKitOperation) throws
    func count() throws -> Int
    func clear() throws
}

// Framework provides example implementations:
// - CoreDataCloudKitQueueStorage (example Core Data entity included)
// - SwiftDataCloudKitQueueStorage (example SwiftData model included)
// - UserDefaultsCloudKitQueueStorage (simple, no setup needed)

// Service uses storage protocol
public init(
    delegate: CloudKitServiceDelegate,
    usePublicDatabase: Bool = false,
    queueStorage: CloudKitQueueStorage? = nil // Default: UserDefaultsCloudKitQueueStorage()
)
```

**Example Entity (Core Data):**
```swift
// Framework provides example .xcdatamodeld entity (apps can rename it):
// Entity: CloudKitQueuedOperation (or whatever the app names it)
// Attributes:
//   - id: UUID
//   - operationType: String (save, delete)
//   - recordData: Data (JSON-encoded CKRecord)
//   - recordID: String
//   - recordType: String
//   - timestamp: Date
//   - retryCount: Int
//
// Apps can rename the entity to anything - framework just needs the name
```

**Example Model (SwiftData):**
```swift
// Framework provides example SwiftData model (apps can rename it):
@Model
public class CloudKitQueuedOperation { // Apps can rename this class
    public var id: UUID
    public var operationType: String
    public var recordData: Data
    public var recordID: String
    public var recordType: String
    public var timestamp: Date
    public var retryCount: Int
}

// Apps can rename the class to anything - framework uses the entity name
// For SwiftData, the entity name is typically the class name, but can be customized
```

**Usage:**
```swift
// App adds example entity to their Core Data model
// Entity can be named anything - "CloudKitQueuedOperation", "BobsLocalCloudQueuesRUs", etc.
// Then provides storage with the entity name:
let coreDataStorage = CoreDataCloudKitQueueStorage(
    context: persistentContainer.viewContext,
    entityName: "BobsLocalCloudQueuesRUs" // Whatever the app named it
)

let service = CloudKitService(
    delegate: delegate,
    queueStorage: coreDataStorage
)
```

**Important**: The entity/model name is **completely configurable** - apps can name it whatever they want. The framework just needs:
1. The entity/model to exist in the app's schema
2. The entity/model to have the required attributes (id, operationType, recordData, etc.)
3. The app to tell the framework the entity/model name

This allows apps to:
- Use their own naming conventions
- Integrate with existing data models
- Have multiple queue entities if needed (e.g., different queues for different record types)

### Account Switching
- Service should detect account changes
- Notify delegate when account status changes
- Handle data migration if needed (app responsibility)

### Subscriptions (Future Enhancement)
- Real-time updates via CloudKit subscriptions
- Could be added in Phase 2 or later
- Requires subscription management

### Zones (Future Enhancement)
- Custom zones for organizing records
- Could be added if needed
- Most apps use default zone

### Query Helpers (Optional)
- Helper methods for common query patterns
- Could reduce boilerplate for simple queries
- Not critical for initial implementation

### Retry Limits & Queue Management
- Queued operations should have retry limits (e.g., max 3-5 retries)
- After max retries, operation should be marked as failed
- Failed operations should be accessible to apps (for manual retry or user notification)
- Consider exponential backoff for retries

### Record Size Limits
- CloudKit has 1MB limit per record
- Service should validate record size before queuing/saving
- Return appropriate error if record exceeds limit
- Consider delegate method for handling large records (split, compress, etc.)

### Background Sync (iOS)
- Periodic sync can use iOS background tasks
- Service should integrate with `BGTaskScheduler` for background sync
- Apps may need to register background task identifiers
- Consider delegate method for background sync configuration

### Multiple Containers
- Service handles one container per instance
- Apps can create multiple service instances for multiple containers
- Each instance has its own delegate and queue storage
- Consider if shared queue storage across containers makes sense (probably not)

### Initial Implementation Scope
**Phase 1 (MVP) should include:**
- ✅ Core CRUD operations
- ✅ Delegate pattern
- ✅ Basic sync
- ✅ Offline queue with protocol-based storage
- ✅ Error handling
- ✅ UI components
- ✅ Cross-platform support

**Defer to later phases:**
- ⏳ Subscriptions (real-time updates)
- ⏳ Custom zones
- ⏳ Query helpers
- ⏳ Advanced background sync configuration

## Migration Guide

### Migrating from Reference Implementation

For apps currently using a custom CloudKit implementation (like the reference implementation), here's how to migrate to the framework service:

#### Step 1: Replace Service Initialization

**Before (Reference Implementation):**
```swift
// Singleton pattern
let syncService = CloudKitSyncService.shared
```

**After (Framework):**
```swift
// Instance-based with delegate
let delegate = MyAppCloudKitDelegate()
let cloudKitService = CloudKitService(delegate: delegate)
```

#### Step 2: Implement Delegate

**Before:**
```swift
// App-specific container identifier hardcoded
let containerIdentifier = "iCloud.com.example.app"
```

**After:**
```swift
class MyAppCloudKitDelegate: CloudKitServiceDelegate {
    func containerIdentifier() -> String {
        return "iCloud.com.example.app" // Same identifier
    }
    
    // Optionally override conflict resolution if you had custom logic
    func resolveConflict(local: CKRecord, remote: CKRecord) -> CKRecord? {
        // Your existing conflict resolution logic
        return remote // or custom merge logic
    }
}
```

#### Step 3: Migrate Offline Queue

**Before (Reference Implementation with Core Data Entity):**
```swift
// Uses CloudKitSyncQueueOperation Core Data entity
let queue = CloudKitOfflineQueue.shared
```

**After (Framework with Protocol):**
```swift
// Option 1: Use framework's default (UserDefaults)
let service = CloudKitService(delegate: delegate)

// Option 2: Use your existing Core Data entity
let coreDataStorage = CoreDataCloudKitQueueStorage(
    context: persistentContainer.viewContext,
    entityName: "CloudKitSyncQueueOperation" // Your existing entity name
)
let service = CloudKitService(
    delegate: delegate,
    queueStorage: coreDataStorage
)
```

**Note**: Your existing `CloudKitSyncQueueOperation` entity should work with `CoreDataCloudKitQueueStorage` if it has the required attributes (id, operationType, status, priority, etc.)

#### Step 4: Replace Sync Calls

**Before:**
```swift
try await syncService.syncNow()
try await syncService.uploadLocalChanges()
try await syncService.downloadRemoteChanges()
```

**After:**
```swift
try await cloudKitService.sync()
// Upload/download are handled internally by sync()
// Or use individual operations:
try await cloudKitService.save(record)
try await cloudKitService.fetch(recordID: recordID)
```

#### Step 5: Update UI Components

**Before:**
```swift
// Custom sync status views
syncService.syncStatus
syncService.isSyncing
```

**After:**
```swift
// Framework UI components
platformCloudKitSyncStatus_L4(service: cloudKitService)
platformCloudKitProgress_L4(
    progress: $cloudKitService.syncProgress,
    status: cloudKitService.syncStatus
)
```

#### Step 6: Handle Conflicts

**Before:**
```swift
// Custom conflict resolution UI
syncService.detectedConflicts
syncService.applyConflictResolutions()
```

**After:**
```swift
// Conflicts handled via delegate
// Framework detects conflicts and calls delegate.resolveConflict()
// Or use framework's default (server wins)
```

#### Step 7: Error Handling

**Before:**
```swift
catch CloudKitSyncError.cloudKitUnavailable {
    // Handle error
}
```

**After:**
```swift
catch CloudKitServiceError.networkUnavailable {
    // Handle error (similar error types)
}
// Or implement custom error handling in delegate:
func handleError(_ error: Error) -> Bool {
    // Your custom error handling
    return true // if handled, false to use framework defaults
}
```

#### Migration Checklist

- [ ] Create `CloudKitServiceDelegate` implementation
- [ ] Replace singleton service with framework instance
- [ ] Migrate offline queue (use existing entity or framework default)
- [ ] Update sync calls to use framework API
- [ ] Replace custom UI with framework components
- [ ] Update error handling
- [ ] Test conflict resolution
- [ ] Verify offline queue functionality
- [ ] Test on all platforms (iOS, macOS, tvOS, watchOS, visionOS)

#### Benefits of Migration

- ✅ Less boilerplate code
- ✅ Consistent API across apps
- ✅ Built-in UI components
- ✅ Better error handling
- ✅ Cross-platform support
- ✅ Protocol-based (easier to test)
- ✅ Framework-maintained (updates and improvements)

## Notes

- **Testing**: Framework tests should avoid CloudKit (see existing test utilities)
- **Mocking**: Service should be easily mockable via protocol
- **Defaults**: Provide sensible defaults for optional delegate methods
- **Async/Await**: Use modern async/await patterns (CloudKit supports this)
- **Error Handling**: Comprehensive error handling with delegate hooks for custom handling
- **Error Types**: Define `CloudKitServiceError` enum following framework patterns (like `LocationServiceError`, `OCRError`)
- **Sync Status**: Define `CloudKitSyncStatus` enum for state machine
- **Migration**: Provide migration guide for apps with existing CloudKit implementations
