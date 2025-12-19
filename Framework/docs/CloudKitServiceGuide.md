# CloudKit Service Guide

## Overview

The CloudKit service provides a framework-level abstraction for CloudKit operations, eliminating boilerplate code while allowing apps to provide app-specific configuration through a delegate pattern.

## Quick Start

### 1. Implement the Delegate

```swift
import SixLayerFramework
import CloudKit

class MyCloudKitDelegate: CloudKitServiceDelegate {
    // Required: Provide your container identifier
    func containerIdentifier() -> String {
        return "iCloud.com.yourapp.container"
    }
    
    // Optional: Custom conflict resolution
    func resolveConflict(local: CKRecord, remote: CKRecord) -> CKRecord? {
        // Your conflict resolution logic
        return remote // Default: server wins
    }
    
    // Optional: Record validation
    func validateRecord(_ record: CKRecord) throws {
        // Validate record before saving
        if record["requiredField"] == nil {
            throw CloudKitServiceError.missingRequiredField("requiredField")
        }
    }
}
```

### 2. Initialize the Service

```swift
let delegate = MyCloudKitDelegate()
let cloudKitService = CloudKitService(delegate: delegate)

// Or use public database
let publicService = CloudKitService(delegate: delegate, usePublicDatabase: true)
```

### 3. Use the Service

```swift
// Save a record
let record = CKRecord(recordType: "MyRecord")
record["name"] = "Example"
try await cloudKitService.save(record)

// Fetch a record
let fetched = try await cloudKitService.fetch(recordID: record.recordID)

// Query records
let query = CKQuery(recordType: "MyRecord", predicate: NSPredicate(value: true))
let records = try await cloudKitService.query(query)

// Delete a record
try await cloudKitService.delete(recordID: record.recordID)
```

## Features

### Offline Queue Management

The service automatically queues operations when the network is unavailable and flushes them when connectivity returns.

```swift
// Check queue status
let queuedCount = cloudKitService.queuedOperationCount

// Manually flush queue
try await cloudKitService.flushOfflineQueue()

// Clear queue
try cloudKitService.clearOfflineQueue()
```

### Queue Status Reporting

Get detailed information about the operation queue:

```swift
// Get comprehensive queue status
let status = try cloudKitService.queueStatus

print("Total operations: \(status.totalCount)")
print("Pending: \(status.pendingCount)")
print("Failed: \(status.failedCount)")
print("Retryable: \(status.retryableCount)")
if let oldestDate = status.oldestPendingDate {
    print("Oldest pending: \(oldestDate)")
}

// Retry failed operations that haven't exceeded max retries
try await cloudKitService.retryFailedOperations()

// Clear only failed operations (preserves pending operations)
try cloudKitService.clearFailedOperations()
```

**QueueStatus Properties:**
- `totalCount`: Total number of operations in the queue
- `pendingCount`: Operations with `status == "pending"`
- `failedCount`: Operations with `status == "failed"`
- `oldestPendingDate`: Date of the oldest pending operation (if any)
- `retryableCount`: Failed operations that can be retried (`status == "failed"` AND `retryCount < maxRetries`)

**Note:** `queueStatus` may be slow for large queues. Consider caching if called frequently.

### Sync Operations

```swift
// Manual sync
try await cloudKitService.sync()

// Sync specific record types
try await cloudKitService.sync(recordTypes: ["MyRecord", "OtherRecord"])
```

### Progress Tracking

The service provides `@Published` properties for UI binding:

```swift
@StateObject var cloudKitService: CloudKitService

var body: some View {
    VStack {
        // Status display
        platformCloudKitServiceStatus_L4(service: cloudKitService)
        
        // Sync button
        platformCloudKitSyncButton_L4(service: cloudKitService)
    }
}
```

## UI Components

### Status Display

```swift
// Complete status view
platformCloudKitServiceStatus_L4(service: cloudKitService)

// Individual components
platformCloudKitSyncStatus_L4(status: cloudKitService.syncStatus)
platformCloudKitAccountStatus_L4(status: cloudKitService.accountStatus)
platformCloudKitProgress_L4(progress: cloudKitService.syncProgress)
```

### Compact Badge

```swift
// For toolbars or compact spaces
platformCloudKitStatusBadge_L4(service: cloudKitService)
```

## Custom Queue Storage

By default, the service uses `UserDefaultsCloudKitQueueStorage`. You can provide your own implementation:

```swift
class MyQueueStorage: CloudKitQueueStorage {
    // Implement protocol methods
    func enqueue(_ operation: QueuedCloudKitOperation) throws { ... }
    func dequeue() throws -> QueuedCloudKitOperation? { ... }
    // ... other methods
}

let customStorage = MyQueueStorage()
let service = CloudKitService(delegate: delegate, queueStorage: customStorage)
```

## Error Handling

```swift
do {
    try await cloudKitService.save(record)
} catch CloudKitServiceError.networkUnavailable {
    // Operation was queued, handle UI feedback
} catch CloudKitServiceError.conflictDetected(let local, let remote) {
    // Handle conflict
} catch {
    // Other errors
}
```

## Platform Support

- **iOS/macOS/visionOS**: Full support (read and write)
- **tvOS/watchOS**: Read-only (write operations throw `writeNotSupportedOnPlatform`)

## Best Practices

1. **Always implement `containerIdentifier()`** - This is required
2. **Handle conflicts appropriately** - Implement `resolveConflict` for your data model
3. **Validate records** - Use `validateRecord` to ensure data integrity
4. **Monitor sync status** - Use `@Published` properties for UI updates
5. **Handle offline scenarios** - The service queues operations automatically

## Core Data Integration

The service provides platform-consistent wrappers for Core Data and Swift Data CloudKit integration.

### Core Data

Sync Core Data contexts with CloudKit using `NSPersistentCloudKitContainer`:

```swift
#if canImport(CoreData)
import CoreData

// Create your Core Data stack with NSPersistentCloudKitContainer
let container = NSPersistentCloudKitContainer(name: "MyModel")
// ... configure container ...

// Sync with CloudKit using the service
let context = container.viewContext
try await cloudKitService.syncWithCoreData(context: context)
#endif
```

**Platform-Specific Behavior:**
- **iPad**: Data from other devices may not appear until app restart. The wrapper triggers sync more reliably.
- **Mac**: May sync on launch but not while active. The wrapper triggers foreground sync when needed.
- **iPhone**: Generally better sync behavior, but wrapper ensures consistency.

**What's Covered:**
- Basic sync functionality via `NSPersistentCloudKitContainer`
- Thread safety (MainActor ↔ non-MainActor bridging)
- Platform-specific sync triggers (iPad/Mac workarounds)
- Error handling and propagation

**What's Not Covered (Edge Cases):**
- Complex relationship syncing issues
- Custom CloudKit schema migrations
- Advanced conflict resolution beyond `NSPersistentCloudKitContainer` defaults
- Network timeout handling (relies on `NSPersistentCloudKitContainer`)

These edge cases can be extended later if needed.

### Swift Data

Sync Swift Data contexts with CloudKit:

```swift
#if canImport(SwiftData)
import SwiftData

// Create your Swift Data container with CloudKit configuration
let schema = Schema([MyModel.self])
let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
configuration.cloudKitContainerIdentifier = "iCloud.com.yourapp.container"

let container = try ModelContainer(for: schema, configurations: [configuration])
let context = container.mainContext

// Sync with CloudKit using the service
try await cloudKitService.syncWithSwiftData(context: context)
#endif
```

**Platform-Specific Behavior:**
- Same platform workarounds as Core Data version
- Consistent API across both Core Data and Swift Data

**API Consistency:**
The Swift Data API mirrors the Core Data API structure for consistency. Both methods:
- Take a context parameter
- Are `async throws`
- Handle platform-specific workarounds
- Provide thread safety

**What's Covered:**
- Basic sync functionality via Swift Data's `.cloudKit` configuration
- Thread safety (MainActor ↔ Swift Data contexts)
- Platform-specific sync triggers (iPad/Mac workarounds)
- Error handling and propagation

**What's Not Covered (Edge Cases):**
- Complex relationship syncing issues
- Custom CloudKit schema migrations
- Advanced conflict resolution beyond Swift Data defaults
- Network timeout handling (relies on Swift Data's CloudKit integration)

## Migration from Existing CloudKit Code

See the [Migration Guide](.github/ISSUES/cloudkit_service.md#migration-guide) in the issue for detailed migration steps.







