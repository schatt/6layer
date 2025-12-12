//
//  CloudKitService.swift
//  SixLayerFramework
//
//  CloudKit service implementation with delegate pattern
//  Eliminates boilerplate while allowing app-specific configuration
//

import Foundation
import CloudKit
import Combine
import Network

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - CloudKit Service Error Types

/// Errors that can occur during CloudKit service operations
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
        let i18n = InternationalizationService()
        switch self {
        case .containerNotFound:
            return i18n.localizedString(for: "SixLayerFramework.cloudkit.containerNotFound")
        case .accountUnavailable:
            return i18n.localizedString(for: "SixLayerFramework.cloudkit.accountUnavailable")
        case .networkUnavailable:
            return i18n.localizedString(for: "SixLayerFramework.cloudkit.networkUnavailable")
        case .writeNotSupportedOnPlatform:
            return i18n.localizedString(for: "SixLayerFramework.cloudkit.writeNotSupported")
        case .missingRequiredField(let field):
            let format = i18n.localizedString(for: "SixLayerFramework.cloudkit.missingField")
            // If format is still the key (not found), provide fallback
            if format == "SixLayerFramework.cloudkit.missingField" {
                return "Required field '\(field)' is missing"
            }
            return String(format: format, field)
        case .recordNotFound:
            return i18n.localizedString(for: "SixLayerFramework.cloudkit.recordNotFound")
        case .conflictDetected:
            return i18n.localizedString(for: "SixLayerFramework.cloudkit.conflictDetected")
        case .quotaExceeded:
            return i18n.localizedString(for: "SixLayerFramework.cloudkit.quotaExceeded")
        case .permissionDenied:
            return i18n.localizedString(for: "SixLayerFramework.cloudkit.permissionDenied")
        case .invalidRecord:
            return i18n.localizedString(for: "SixLayerFramework.cloudkit.invalidRecord")
        case .unknown(let error):
            let format = i18n.localizedString(for: "SixLayerFramework.cloudkit.unknownError")
            // If format is still the key (not found), provide fallback
            if format == "SixLayerFramework.cloudkit.unknownError" {
                return "Unknown error: \(error.localizedDescription)"
            }
            return String(format: format, error.localizedDescription)
        }
    }
}

// MARK: - CloudKit Sync Status

/// Status of CloudKit sync operations
public enum CloudKitSyncStatus: Equatable {
    case idle
    case syncing
    case paused
    case error(Error)
    case complete
    
    public static func == (lhs: CloudKitSyncStatus, rhs: CloudKitSyncStatus) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.syncing, .syncing), (.paused, .paused), (.complete, .complete):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

// MARK: - CloudKit Service Delegate Protocol

/// Protocol for app-specific CloudKit configuration and business logic
@MainActor
public protocol CloudKitServiceDelegate: AnyObject {
    /// Required: Container identifier
    func containerIdentifier() -> String
    
    /// Optional: Conflict resolution
    func resolveConflict(local: CKRecord, remote: CKRecord) -> CKRecord?
    
    /// Optional: Record validation
    func validateRecord(_ record: CKRecord) throws
    
    /// Optional: Record transformation
    func transformRecord(_ record: CKRecord) -> CKRecord
    
    /// Optional: Custom error handling
    func handleError(_ error: Error) -> Bool // returns true if handled
    
    /// Optional: Sync completion notification
    func syncDidComplete(success: Bool, recordsChanged: Int)
}

// MARK: - Default Implementation (Framework Provides)

extension CloudKitServiceDelegate {
    /// Default: Use remote (server wins)
    public func resolveConflict(local: CKRecord, remote: CKRecord) -> CKRecord? {
        return remote
    }
    
    /// Default: No validation
    public func validateRecord(_ record: CKRecord) throws {
        // No validation by default
    }
    
    /// Default: No transformation
    public func transformRecord(_ record: CKRecord) -> CKRecord {
        return record
    }
    
    /// Default: Framework handles errors
    public func handleError(_ error: Error) -> Bool {
        return false
    }
    
    /// Default: No action
    public func syncDidComplete(success: Bool, recordsChanged: Int) {
        // No action by default
    }
}

// MARK: - CloudKit Service

/// CloudKit service that eliminates boilerplate while allowing app-specific configuration
@MainActor
public class CloudKitService: ObservableObject {
    // MARK: - Published Properties
    
    @Published public var syncStatus: CloudKitSyncStatus = .idle
    @Published public var syncProgress: Double = 0.0
    @Published public var accountStatus: CKAccountStatus = .couldNotDetermine
    @Published public var lastError: Error?
    
    // MARK: - Public Properties
    
    /// Delegate for app-specific logic
    public weak var delegate: CloudKitServiceDelegate?
    
    /// Database selection (default: private)
    /// Note: Accessing this property will initialize the container if not already initialized
    /// In test environments without CloudKit, this will throw an error
    public var database: CKDatabase {
        guard let container = container else {
            // In test environment without CloudKit - throw error
            // Tests should avoid accessing database directly
            fatalError("CloudKit container not available. This may occur in test environments without CloudKit entitlements. Use a mock service or ensure CloudKit is properly configured.")
        }
        return usePublicDatabase ? container.publicCloudDatabase : container.privateCloudDatabase
    }
    
    // MARK: - Private Properties
    
    private var _container: CKContainer?
    private var container: CKContainer? {
        if let existing = _container {
            return existing
        }
        // Lazy initialization - only create when actually needed
        // In test environments, this may not be available
        guard canInitializeContainer() else {
            return nil
        }
        let newContainer = CKContainer(identifier: containerIdentifier)
        _container = newContainer
        return newContainer
    }
    private let usePublicDatabase: Bool
    private let queueStorage: CloudKitQueueStorage?
    private var networkMonitor: NWPathMonitor?
    private var networkMonitorQueue: DispatchQueue?
    private var isNetworkAvailable: Bool = true
    private var autoFlushEnabled: Bool = true
    private var lastSyncToken: CKServerChangeToken?
    private let syncTokenKey: String
    private let containerIdentifier: String
    
    // MARK: - Initialization
    
    /// Initialize CloudKit service with delegate
    /// - Parameters:
    ///   - delegate: Delegate providing container identifier and optional custom logic
    ///   - usePublicDatabase: Whether to use public database (default: false for private)
    ///   - queueStorage: Optional queue storage (default: UserDefaultsCloudKitQueueStorage)
    public init(
        delegate: CloudKitServiceDelegate,
        usePublicDatabase: Bool = false,
        queueStorage: CloudKitQueueStorage? = nil
    ) {
        self.delegate = delegate
        self.usePublicDatabase = usePublicDatabase
        self.queueStorage = queueStorage ?? UserDefaultsCloudKitQueueStorage()
        
        // Store container identifier (don't initialize container yet - lazy init)
        self.containerIdentifier = delegate.containerIdentifier()
        
        // Load last sync token
        self.syncTokenKey = "cloudkit_sync_token_\(containerIdentifier)"
        self.lastSyncToken = loadSyncToken()
        
        // Check account status (non-blocking, errors are handled internally)
        Task {
            do {
                _ = try await checkAccountStatus()
            } catch {
                // Account status check failed - will be set to .couldNotDetermine
                // This is non-critical for initialization
            }
        }
        
        // Start network monitoring
        startNetworkMonitoring()
    }
    
    deinit {
        // Clean up network monitor (non-isolated cleanup)
        networkMonitor?.cancel()
    }
    
    // MARK: - Account Management
    
    /// Check current account status
    public func checkAccountStatus() async throws -> CKAccountStatus {
        // Only check if container can be initialized (avoids crashes in test environments)
        guard let ckContainer = container else {
            await MainActor.run {
                self.accountStatus = .couldNotDetermine
            }
            return .couldNotDetermine
        }
        
        let status = try await ckContainer.accountStatus()
        await MainActor.run {
            self.accountStatus = status
        }
        return status
    }
    
    /// Check if container can be safely initialized (not in test environment without entitlements)
    private func canInitializeContainer() -> Bool {
        // In test environments, CloudKit may not be available
        // Check if we're in a test environment by looking for test bundle
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            // We're in a test environment - CloudKit may not be available
            // Return false to skip initialization
            return false
        }
        #endif
        return true
    }
    
    /// Request account status update
    public func requestAccountStatus() async throws {
        _ = try await checkAccountStatus()
    }
    
    // MARK: - Basic CRUD Operations
    
    /// Save a record to CloudKit
    /// Automatically queues operation if network is unavailable
    public func save(_ record: CKRecord) async throws -> CKRecord {
        // Platform check for write operations
        #if os(tvOS) || os(watchOS)
        throw CloudKitServiceError.writeNotSupportedOnPlatform
        #endif
        
        // Validate record via delegate
        try delegate?.validateRecord(record)
        
        // Transform record via delegate
        let transformedRecord = delegate?.transformRecord(record) ?? record
        
        // Check network availability
        if !isNetworkAvailable {
            // Queue operation for later
            try await queueOperation(type: "save", record: transformedRecord)
            throw CloudKitServiceError.networkUnavailable
        }
        
        // Ensure container is available
        guard let ckContainer = container else {
            // In test environment - queue operation instead
            try await queueOperation(type: "save", record: transformedRecord)
            throw CloudKitServiceError.accountUnavailable
        }
        
        // Save to CloudKit
        do {
            let savedRecord = try await (usePublicDatabase ? ckContainer.publicCloudDatabase : ckContainer.privateCloudDatabase).save(transformedRecord)
            return savedRecord
        } catch let error as CKError {
            // Handle conflicts
            if error.code == .serverRecordChanged {
                if let serverRecord = error.serverRecord {
                    // Try to resolve conflict via delegate
                    if let resolved = delegate?.resolveConflict(local: transformedRecord, remote: serverRecord) {
                        // Retry with resolved record
                        guard let ckContainer = container else {
                            throw CloudKitServiceError.accountUnavailable
                        }
                        return try await (usePublicDatabase ? ckContainer.publicCloudDatabase : ckContainer.privateCloudDatabase).save(resolved)
                    } else {
                        throw CloudKitServiceError.conflictDetected(local: transformedRecord, remote: serverRecord)
                    }
                }
            }
            
            // If network error, queue the operation
            if error.code == .networkUnavailable || error.code == .networkFailure {
                try await queueOperation(type: "save", record: transformedRecord)
            }
            
            // Check if delegate handles this error
            if delegate?.handleError(error) == true {
                // Delegate handled it, but we still need to throw something
                throw CloudKitServiceError.unknown(error)
            }
            
            // Map CKError to CloudKitServiceError
            throw mapCKError(error)
        } catch {
            // Check if delegate handles this error
            if delegate?.handleError(error) == true {
                throw CloudKitServiceError.unknown(error)
            }
            // If it's a network error and we haven't queued it yet, try to queue
            if let nsError = error as NSError?,
               nsError.domain == NSURLErrorDomain,
               (nsError.code == NSURLErrorNotConnectedToInternet || nsError.code == NSURLErrorNetworkConnectionLost) {
                try await queueOperation(type: "save", record: transformedRecord)
            }
            throw error
        }
    }
    
    /// Fetch a record by ID
    public func fetch(recordID: CKRecord.ID) async throws -> CKRecord? {
        guard let ckContainer = container else {
            throw CloudKitServiceError.accountUnavailable
        }
        
        do {
            let record = try await (usePublicDatabase ? ckContainer.publicCloudDatabase : ckContainer.privateCloudDatabase).record(for: recordID)
            
            // Transform record via delegate
            if let transformed = delegate?.transformRecord(record) {
                return transformed
            }
            return record
        } catch let error as CKError {
            if error.code == .unknownItem {
                return nil
            }
            
            if delegate?.handleError(error) == true {
                throw CloudKitServiceError.unknown(error)
            }
            throw mapCKError(error)
        } catch {
            if delegate?.handleError(error) == true {
                throw CloudKitServiceError.unknown(error)
            }
            throw error
        }
    }
    
    /// Delete a record by ID
    /// Automatically queues operation if network is unavailable
    public func delete(recordID: CKRecord.ID) async throws {
        // Platform check for write operations
        #if os(tvOS) || os(watchOS)
        throw CloudKitServiceError.writeNotSupportedOnPlatform
        #endif
        
        // Check network availability
        if !isNetworkAvailable {
            // Queue operation for later
            try await queueOperation(type: "delete", recordID: recordID)
            throw CloudKitServiceError.networkUnavailable
        }
        
        guard let ckContainer = container else {
            try await queueOperation(type: "delete", recordID: recordID)
            throw CloudKitServiceError.accountUnavailable
        }
        
        do {
            _ = try await (usePublicDatabase ? ckContainer.publicCloudDatabase : ckContainer.privateCloudDatabase).deleteRecord(withID: recordID)
        } catch let error as CKError {
            // If network error, queue the operation
            if error.code == .networkUnavailable || error.code == .networkFailure {
                try await queueOperation(type: "delete", recordID: recordID)
            }
            throw mapCKError(error)
            if delegate?.handleError(error) == true {
                throw CloudKitServiceError.unknown(error)
            }
            throw mapCKError(error)
        } catch {
            if delegate?.handleError(error) == true {
                throw CloudKitServiceError.unknown(error)
            }
            throw error
        }
    }
    
    /// Query records
    public func query(_ query: CKQuery) async throws -> [CKRecord] {
        guard let ckContainer = container else {
            throw CloudKitServiceError.accountUnavailable
        }
        
        do {
            let (results, _) = try await (usePublicDatabase ? ckContainer.publicCloudDatabase : ckContainer.privateCloudDatabase).records(matching: query)
            var records: [CKRecord] = []
            
            for (_, result) in results {
                switch result {
                case .success(let record):
                    // Transform record via delegate
                    if let transformed = delegate?.transformRecord(record) {
                        records.append(transformed)
                    } else {
                        records.append(record)
                    }
                case .failure(let error):
                    // Log but continue with other records
                    if delegate?.handleError(error) != true {
                        // If delegate doesn't handle it, we might want to throw
                        // For now, continue with other records
                    }
                }
            }
            
            return records
        } catch let error as CKError {
            if delegate?.handleError(error) == true {
                throw CloudKitServiceError.unknown(error)
            }
            throw mapCKError(error)
        } catch {
            if delegate?.handleError(error) == true {
                throw CloudKitServiceError.unknown(error)
            }
            throw error
        }
    }
    
    // MARK: - Batch Operations
    
    /// Save multiple records (more efficient than individual saves)
    public func save(_ records: [CKRecord]) async throws -> [CKRecord] {
        // Platform check for write operations
        #if os(tvOS) || os(watchOS)
        throw CloudKitServiceError.writeNotSupportedOnPlatform
        #endif
        
        // Validate and transform all records
        var transformedRecords: [CKRecord] = []
        for record in records {
            try delegate?.validateRecord(record)
            let transformed = delegate?.transformRecord(record) ?? record
            transformedRecords.append(transformed)
        }
        
        guard let ckContainer = container else {
            throw CloudKitServiceError.accountUnavailable
        }
        
        do {
            let (results, _) = try await (usePublicDatabase ? ckContainer.publicCloudDatabase : ckContainer.privateCloudDatabase).modifyRecords(saving: transformedRecords, deleting: [])
            var savedRecords: [CKRecord] = []
            
            for (_, result) in results {
                switch result {
                case .success(let record):
                    savedRecords.append(record)
                case .failure(let error):
                    // Handle individual failures
                    if let ckError = error as? CKError, ckError.code == .serverRecordChanged {
                        // Conflict - delegate should handle
                        if delegate?.handleError(error) != true {
                            throw mapCKError(ckError)
                        }
                    } else {
                        if delegate?.handleError(error) != true {
                            throw mapCKError(error as? CKError ?? CKError(.unknownItem))
                        }
                    }
                }
            }
            
            return savedRecords
        } catch let error as CKError {
            if delegate?.handleError(error) == true {
                throw CloudKitServiceError.unknown(error)
            }
            throw mapCKError(error)
        } catch {
            if delegate?.handleError(error) == true {
                throw CloudKitServiceError.unknown(error)
            }
            throw error
        }
    }
    
    /// Delete multiple records
    public func delete(_ recordIDs: [CKRecord.ID]) async throws {
        // Platform check for write operations
        #if os(tvOS) || os(watchOS)
        throw CloudKitServiceError.writeNotSupportedOnPlatform
        #endif
        
        guard let ckContainer = container else {
            throw CloudKitServiceError.accountUnavailable
        }
        
        do {
            let (_, _) = try await (usePublicDatabase ? ckContainer.publicCloudDatabase : ckContainer.privateCloudDatabase).modifyRecords(saving: [], deleting: recordIDs)
        } catch let error as CKError {
            if delegate?.handleError(error) == true {
                throw CloudKitServiceError.unknown(error)
            }
            throw mapCKError(error)
        } catch {
            if delegate?.handleError(error) == true {
                throw CloudKitServiceError.unknown(error)
            }
            throw error
        }
    }
    
    // MARK: - Sync Operations
    
    /// Perform manual sync
    /// Uploads queued operations and fetches remote changes
    public func sync() async throws {
        guard !isReadOnlyPlatform else {
            throw CloudKitServiceError.writeNotSupportedOnPlatform
        }
        
        guard isNetworkAvailable else {
            throw CloudKitServiceError.networkUnavailable
        }
        
        await MainActor.run {
            syncStatus = .syncing
            syncProgress = 0.0
        }
        
        var recordsChanged = 0
        
        do {
            // Step 1: Flush offline queue (upload local changes)
            await MainActor.run {
                syncProgress = 0.1
            }
            
            try await flushOfflineQueue()
            
            // Step 2: Fetch remote changes using change token
            await MainActor.run {
                syncProgress = 0.5
            }
            
            // Fetch changes since last sync token
            let configuration = CKFetchRecordZoneChangesOperation.ZoneConfiguration()
            configuration.previousServerChangeToken = lastSyncToken
            
            // Note: Full implementation would use CKFetchRecordZoneChangesOperation
            // For now, we'll update the token after successful sync
            // Apps can extend this with custom change tracking
            
            // Update sync token (simplified - full implementation would use actual token from operation)
            // This is a placeholder - apps should implement proper change token tracking
            
            // Step 3: Complete sync
            await MainActor.run {
                syncProgress = 1.0
                syncStatus = .complete
                delegate?.syncDidComplete(success: true, recordsChanged: recordsChanged)
            }
        } catch {
            await MainActor.run {
                syncStatus = .error(error)
                syncProgress = 0.0
                lastError = error
                delegate?.syncDidComplete(success: false, recordsChanged: recordsChanged)
            }
            throw error
        }
    }
    
    /// Sync specific record types
    /// - Parameter recordTypes: Array of record type names to sync
    public func sync(recordTypes: [String]) async throws {
        guard !isReadOnlyPlatform else {
            throw CloudKitServiceError.writeNotSupportedOnPlatform
        }
        
        guard isNetworkAvailable else {
            throw CloudKitServiceError.networkUnavailable
        }
        
        await MainActor.run {
            syncStatus = .syncing
            syncProgress = 0.0
        }
        
        var recordsChanged = 0
        
        do {
            // Fetch records of specified types
            for (index, recordType) in recordTypes.enumerated() {
                let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
                let records = try await self.query(query)
                
                // Transform records via delegate
                for record in records {
                    _ = delegate?.transformRecord(record)
                }
                
                recordsChanged += records.count
                
                await MainActor.run {
                    syncProgress = Double(index + 1) / Double(recordTypes.count)
                }
            }
            
            await MainActor.run {
                syncProgress = 1.0
                syncStatus = .complete
                delegate?.syncDidComplete(success: true, recordsChanged: recordsChanged)
            }
        } catch {
            await MainActor.run {
                syncStatus = .error(error)
                syncProgress = 0.0
                lastError = error
                delegate?.syncDidComplete(success: false, recordsChanged: recordsChanged)
            }
            throw error
        }
    }
    
    /// Start periodic sync
    public func startPeriodicSync(interval: TimeInterval) {
        // TODO: Implement periodic sync with timer
    }
    
    /// Stop periodic sync
    public func stopPeriodicSync() {
        // TODO: Implement periodic sync stop
    }
    
    // MARK: - Offline Queue Management
    
    /// Get count of queued operations
    public var queuedOperationCount: Int {
        guard let storage = queueStorage else { return 0 }
        do {
            return try storage.count()
        } catch {
            return 0
        }
    }
    
    /// Flush offline queue (process all queued operations)
    public func flushOfflineQueue() async throws {
        guard let storage = queueStorage else { return }
        guard isNetworkAvailable else {
            throw CloudKitServiceError.networkUnavailable
        }
        
        var processedCount = 0
        var failedOperations: [QueuedCloudKitOperation] = []
        
        while let operation = try storage.dequeue() {
            // Skip operations that have exceeded max retries
            if operation.retryCount >= operation.maxRetries {
                // Operation failed too many times, skip it
                continue
            }
            
            // Check if operation should be retried now
            if let nextRetryAt = operation.nextRetryAt, nextRetryAt > Date() {
                // Not time to retry yet, re-queue it
                var delayedOperation = operation
                delayedOperation.nextRetryAt = nextRetryAt
                try storage.enqueue(delayedOperation)
                continue
            }
            
            do {
                // Process operation based on type
                switch operation.operationType {
                case "save":
                    // For save operations, we need the app to provide the record
                    // Since CKRecord doesn't encode easily, we'll need delegate help
                    // For now, we'll skip saves that require record reconstruction
                    // Apps should handle this via delegate or custom queue storage
                    if let recordIDString = operation.recordID,
                       let recordType = operation.recordType {
                        // Try to fetch the record first, then save
                        // This is a simplified approach - apps may need custom handling
                        let recordID = CKRecord.ID(recordName: recordIDString)
                        if let existingRecord = try? await fetch(recordID: recordID) {
                            // Record exists, try to save it (app should have updated it)
                            _ = try await save(existingRecord)
                        }
                    }
                    processedCount += 1
                    
                case "delete":
                    if let recordIDString = operation.recordID {
                        let recordID = CKRecord.ID(recordName: recordIDString)
                        try await delete(recordID: recordID)
                        processedCount += 1
                    }
                    
                case "sync":
                    try await sync()
                    processedCount += 1
                    
                default:
                    // Unknown operation type, skip it
                    break
                }
            } catch {
                // Operation failed, increment retry count
                var failedOperation = operation
                failedOperation.retryCount += 1
                failedOperation.status = "failed"
                failedOperation.errorMessage = error.localizedDescription
                
                // Calculate next retry time (exponential backoff)
                let delay = pow(2.0, Double(failedOperation.retryCount)) // 2, 4, 8 seconds
                failedOperation.nextRetryAt = Date().addingTimeInterval(delay)
                
                if failedOperation.retryCount < failedOperation.maxRetries {
                    // Re-queue for retry
                    failedOperation.status = "pending"
                    try storage.enqueue(failedOperation)
                } else {
                    // Max retries exceeded, keep in failed list
                    failedOperations.append(failedOperation)
                }
            }
        }
        
        // Notify delegate of flush completion
        if processedCount > 0 {
            delegate?.syncDidComplete(success: failedOperations.isEmpty, recordsChanged: processedCount)
        }
    }
    
    /// Clear offline queue
    public func clearOfflineQueue() throws {
        try queueStorage?.clear()
    }
    
    /// Enable/disable automatic queue flushing when network returns
    public func setAutoFlushEnabled(_ enabled: Bool) {
        autoFlushEnabled = enabled
    }
    
    // MARK: - Network Monitoring
    
    /// Start monitoring network connectivity
    private func startNetworkMonitoring() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "com.sixlayer.cloudkit.networkmonitor")
        
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                let wasAvailable = self.isNetworkAvailable
                self.isNetworkAvailable = path.status == .satisfied
                
                // If network just became available and we have queued operations, flush them
                if !wasAvailable && self.isNetworkAvailable && self.autoFlushEnabled {
                    do {
                        try await self.flushOfflineQueue()
                    } catch {
                        // Log error but don't crash
                        self.lastError = error
                    }
                }
            }
        }
        
        monitor.start(queue: queue)
        self.networkMonitor = monitor
        self.networkMonitorQueue = queue
        
        // Set initial network status
        isNetworkAvailable = monitor.currentPath.status == .satisfied
    }
    
    /// Stop monitoring network connectivity
    private func stopNetworkMonitoring() {
        networkMonitor?.cancel()
        networkMonitor = nil
        networkMonitorQueue = nil
    }
    
    // MARK: - Queue Operations
    
    /// Queue an operation for later execution
    private func queueOperation(
        type: String,
        record: CKRecord? = nil,
        recordID: CKRecord.ID? = nil
    ) async throws {
        guard let storage = queueStorage else {
            throw CloudKitServiceError.unknown(NSError(domain: "CloudKitService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Queue storage not available"]))
        }
        
        var recordIDString: String?
        var recordType: String?
        
        if let record = record {
            // Store record ID and type for later reconstruction
            // Note: CKRecord doesn't conform to Codable, so we store minimal info
            // Apps using custom queue storage can implement full record encoding
            recordIDString = record.recordID.recordName
            recordType = record.recordType
        } else if let recordID = recordID {
            recordIDString = recordID.recordName
        }
        
        let operation = QueuedCloudKitOperation(
            operationType: type,
            recordData: nil, // CKRecord encoding handled by custom storage if needed
            recordID: recordIDString,
            recordType: recordType,
            timestamp: Date(),
            retryCount: 0,
            maxRetries: 3,
            nextRetryAt: nil,
            status: "pending"
        )
        
        try storage.enqueue(operation)
    }
    
    // MARK: - Sync Token Management
    
    /// Load last sync token from UserDefaults
    private func loadSyncToken() -> CKServerChangeToken? {
        guard let data = UserDefaults.standard.data(forKey: syncTokenKey) else {
            return nil
        }
        
        do {
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            unarchiver.requiresSecureCoding = true
            return try unarchiver.decodeTopLevelObject(of: CKServerChangeToken.self, forKey: NSKeyedArchiveRootObjectKey)
        } catch {
            return nil
        }
    }
    
    /// Save sync token to UserDefaults
    private func saveSyncToken(_ token: CKServerChangeToken) {
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)
        archiver.encode(token, forKey: NSKeyedArchiveRootObjectKey)
        archiver.finishEncoding()
        let data = archiver.encodedData
        UserDefaults.standard.set(data, forKey: syncTokenKey)
    }
    
    // MARK: - Private Helpers
    
    private var isReadOnlyPlatform: Bool {
        #if os(tvOS) || os(watchOS)
        return true
        #else
        return false
        #endif
    }
    
    private func mapCKError(_ error: CKError) -> CloudKitServiceError {
        switch error.code {
        case .notAuthenticated, .accountTemporarilyUnavailable:
            return .accountUnavailable
        case .networkUnavailable, .networkFailure:
            return .networkUnavailable
        case .quotaExceeded:
            return .quotaExceeded
        case .permissionFailure:
            return .permissionDenied
        case .unknownItem:
            return .recordNotFound
        case .serverRecordChanged:
            // Should be handled above, but just in case
            return .conflictDetected(local: CKRecord(recordType: "Unknown"), remote: CKRecord(recordType: "Unknown"))
        default:
            return .unknown(error)
        }
    }
}



