//
//  GenericDataItem.swift
//  SixLayerFramework
//
//  Minimal GenericDataItem for internal framework use
//  This is a simplified version used only for fallback data conversion
//  For examples and demonstrations, see Framework/Examples/GenericTypes.swift
//

import Foundation

/// Minimal generic data item for internal framework fallback use
/// This is used internally by the framework for data conversion
/// For examples and demonstrations, see Framework/Examples/GenericTypes.swift
public struct GenericDataItem: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let subtitle: String?
    public let data: [String: Any]
    
    public init(title: String, subtitle: String? = nil, data: [String: Any] = [:]) {
        self.title = title
        self.subtitle = subtitle
        self.data = data
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: GenericDataItem, rhs: GenericDataItem) -> Bool {
        return lhs.id == rhs.id
    }
}
