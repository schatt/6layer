//
//  CloudKitQueueStorage.swift
//  SixLayerFramework
//
//  Protocol-based storage for CloudKit offline queue operations
//  Allows apps to provide their own storage implementation
//

import Foundation
import CloudKit

// MARK: - Queued CloudKit Operation

/// Represents a queued CloudKit operation
public struct QueuedCloudKitOperation: Codable, Identifiable {
    public let id: UUID
    public let operationType: String // "save", "delete", "sync", etc.
    public let recordData: Data? // JSON-encoded CKRecord (for save operations)
    public let recordID: String?
    public let recordType: String?
    public let timestamp: Date
    public var retryCount: Int
    public var maxRetries: Int
    public var nextRetryAt: Date?
    public var status: String // "pending", "processing", "failed", "completed"
    public var errorMessage: String?
    
    public init(
        id: UUID = UUID(),
        operationType: String,
        recordData: Data? = nil,
        recordID: String? = nil,
        recordType: String? = nil,
        timestamp: Date = Date(),
        retryCount: Int = 0,
        maxRetries: Int = 3,
        nextRetryAt: Date? = nil,
        status: String = "pending",
        errorMessage: String? = nil
    ) {
        self.id = id
        self.operationType = operationType
        self.recordData = recordData
        self.recordID = recordID
        self.recordType = recordType
        self.timestamp = timestamp
        self.retryCount = retryCount
        self.maxRetries = maxRetries
        self.nextRetryAt = nextRetryAt
        self.status = status
        self.errorMessage = errorMessage
    }
}

// MARK: - CloudKit Queue Storage Protocol

/// Protocol for storing and retrieving queued CloudKit operations
@MainActor
public protocol CloudKitQueueStorage {
    /// Enqueue an operation
    func enqueue(_ operation: QueuedCloudKitOperation) throws
    
    /// Dequeue the next operation (removes it from storage)
    func dequeue() throws -> QueuedCloudKitOperation?
    
    /// Peek at the next operation (doesn't remove it)
    func peek() throws -> QueuedCloudKitOperation?
    
    /// Remove a specific operation
    func remove(_ operation: QueuedCloudKitOperation) throws
    
    /// Get count of pending operations
    func count() throws -> Int
    
    /// Clear all operations
    func clear() throws
}

// MARK: - UserDefaults Implementation (Default)

/// UserDefaults-based queue storage (simple, no setup needed)
@MainActor
public class UserDefaultsCloudKitQueueStorage: CloudKitQueueStorage {
    private let userDefaults: UserDefaults
    private let key: String
    
    public init(userDefaults: UserDefaults = .standard, key: String = "cloudkit_queue_operations") {
        self.userDefaults = userDefaults
        self.key = key
    }
    
    public func enqueue(_ operation: QueuedCloudKitOperation) throws {
        var operations = try loadOperations()
        operations.append(operation)
        try saveOperations(operations)
    }
    
    public func dequeue() throws -> QueuedCloudKitOperation? {
        var operations = try loadOperations()
        guard !operations.isEmpty else { return nil }
        
        // Sort by priority (timestamp for FIFO)
        operations.sort { $0.timestamp < $1.timestamp }
        
        let operation = operations.removeFirst()
        try saveOperations(operations)
        return operation
    }
    
    public func peek() throws -> QueuedCloudKitOperation? {
        let operations = try loadOperations()
        guard !operations.isEmpty else { return nil }
        
        // Return oldest pending operation
        let pending = operations.filter { $0.status == "pending" }
        return pending.sorted { $0.timestamp < $1.timestamp }.first
    }
    
    public func remove(_ operation: QueuedCloudKitOperation) throws {
        var operations = try loadOperations()
        operations.removeAll { $0.id == operation.id }
        try saveOperations(operations)
    }
    
    public func count() throws -> Int {
        let operations = try loadOperations()
        return operations.filter { $0.status == "pending" }.count
    }
    
    public func clear() throws {
        userDefaults.removeObject(forKey: key)
    }
    
    // MARK: - Private Helpers
    
    private func loadOperations() throws -> [QueuedCloudKitOperation] {
        guard let data = userDefaults.data(forKey: key) else {
            return []
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([QueuedCloudKitOperation].self, from: data)
    }
    
    private func saveOperations(_ operations: [QueuedCloudKitOperation]) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(operations)
        userDefaults.set(data, forKey: key)
    }
}

