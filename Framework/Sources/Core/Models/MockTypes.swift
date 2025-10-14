//
//  MockTypes.swift
//  SixLayerFramework
//
//  Mock types for cross-platform testing and development
//

import Foundation

// MARK: - Mock Types for Cross-Platform Testing

/// Mock image type for testing across platforms
public struct MockImage: Equatable {
    public let id: String
    public let data: Data
    
    public init(id: String = UUID().uuidString, data: Data = Data()) {
        self.id = id
        self.data = data
    }
}

/// Mock URL type for testing
public struct MockURL: Equatable {
    public let absoluteString: String
    
    public init(_ string: String) {
        self.absoluteString = string
    }
}

/// Mock enum for testing enum field support
public enum MockUserStatus: String, CaseIterable, Equatable {
    case active = "active"
    case inactive = "inactive"
    case pending = "pending"
}

/// Mock data container for testing
public struct MockDataContainer: Equatable {
    public let id: String
    public let content: String
    
    public init(id: String = UUID().uuidString, content: String = "test") {
        self.id = id
        self.content = content
    }
}
