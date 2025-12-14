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

## Migration from Existing CloudKit Code

See the [Migration Guide](.github/ISSUES/cloudkit_service.md#migration-guide) in the issue for detailed migration steps.



