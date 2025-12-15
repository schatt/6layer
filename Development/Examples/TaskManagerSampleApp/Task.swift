//
//  Task.swift
//  TaskManagerSampleApp
//
//  Task model for the sample app demonstrating CloudKit integration
//

import Foundation
import CloudKit

/// Task priority levels
public enum TaskPriority: String, Codable, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
}

/// Task model representing a single task item
/// Demonstrates CloudKit record conversion patterns
public struct Task: Identifiable, Codable, Equatable {
    public let id: UUID
    public var title: String
    public var description: String?
    public var dueDate: Date?
    public var priority: TaskPriority
    public var isCompleted: Bool
    public var createdAt: Date
    public var updatedAt: Date
    
    /// CloudKit record ID (if synced)
    public var cloudKitRecordID: CKRecord.ID?
    
    /// Initialize a new task
    public init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        dueDate: Date? = nil,
        priority: TaskPriority = .medium,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        cloudKitRecordID: CKRecord.ID? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.priority = priority
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.cloudKitRecordID = cloudKitRecordID
    }
    
    /// Convert task to CloudKit record
    public func toCloudKitRecord() -> CKRecord {
        let recordID: CKRecord.ID
        if let existingID = cloudKitRecordID {
            recordID = existingID
        } else {
            recordID = CKRecord.ID(recordName: id.uuidString)
        }
        
        let record = CKRecord(recordType: "Task", recordID: recordID)
        record["title"] = title
        record["description"] = description
        record["priority"] = priority.rawValue
        record["isCompleted"] = isCompleted
        record["createdAt"] = createdAt
        record["updatedAt"] = updatedAt
        
        return record
    }
    
    /// Initialize task from CloudKit record
    public init(from record: CKRecord) {
        self.id = UUID(uuidString: record.recordID.recordName) ?? UUID()
        self.title = record["title"] as? String ?? ""
        self.description = record["description"] as? String
        self.priority = TaskPriority(rawValue: record["priority"] as? String ?? "medium") ?? .medium
        self.isCompleted = record["isCompleted"] as? Bool ?? false
        self.createdAt = record["createdAt"] as? Date ?? Date()
        self.updatedAt = record["updatedAt"] as? Date ?? Date()
        self.cloudKitRecordID = record.recordID
    }
}
