import SwiftUI

/// Protocol for items that can be displayed in card components
/// This allows card components to extract meaningful data from generic items
public protocol CardDisplayable {
    /// The primary title to display in the card
    var cardTitle: String { get }
    
    /// Optional subtitle to display in the card
    var cardSubtitle: String? { get }
    
    /// Optional description to display in the card
    var cardDescription: String? { get }
    
    /// Optional icon name to display in the card
    var cardIcon: String? { get }
    
    /// Optional color to use for the card icon
    var cardColor: Color? { get }
}

/// Default implementation for CardDisplayable protocol
/// This provides a fallback for items that don't conform to the protocol
public extension CardDisplayable {
    var cardTitle: String { "Item" }
    var cardSubtitle: String? { nil }
    var cardDescription: String? { nil }
    var cardIcon: String? { "star.fill" }
    var cardColor: Color? { .blue }
}

/// Smart fallback helper for items that don't conform to CardDisplayable
/// Uses reflection to extract meaningful content instead of generic "Item"
public struct CardDisplayHelper {
    
    /// Extract meaningful title from any item using reflection
    public static func extractTitle(from item: Any) -> String {
        // First try CardDisplayable protocol
        if let displayable = item as? CardDisplayable {
            return displayable.cardTitle
        }
        
        // Use reflection to find common title properties
        let mirror = Mirror(reflecting: item)
        
        // Look for common title property names
        let titleProperties = ["title", "name", "label", "text", "heading", "caption"]
        for child in mirror.children {
            if let label = child.label,
               titleProperties.contains(label.lowercased()),
               let value = child.value as? String,
               !value.isEmpty {
                return value
            }
        }
        
        // Look for String properties that might be titles
        for child in mirror.children {
            if let value = child.value as? String,
               !value.isEmpty,
               value.count < 100 { // Reasonable title length
                return value
            }
        }
        
        // Last resort: use String(describing:) but clean it up
        let description = String(describing: item)
        if description.contains("(") {
            // Extract type name from "TypeName(properties)"
            let typeName = String(description.prefix(while: { $0 != "(" }))
            return typeName.isEmpty ? "Item" : typeName
        }
        
        return description.isEmpty ? "Item" : description
    }
    
    /// Extract meaningful subtitle from any item using reflection
    public static func extractSubtitle(from item: Any) -> String? {
        // First try CardDisplayable protocol
        if let displayable = item as? CardDisplayable {
            return displayable.cardSubtitle
        }
        
        // Use reflection to find common subtitle properties
        let mirror = Mirror(reflecting: item)
        
        // Look for common subtitle property names
        let subtitleProperties = ["subtitle", "description", "detail", "summary", "info"]
        for child in mirror.children {
            if let label = child.label,
               subtitleProperties.contains(label.lowercased()),
               let value = child.value as? String,
               !value.isEmpty {
                return value
            }
        }
        
        return nil
    }
    
    /// Extract meaningful icon from any item using reflection
    public static func extractIcon(from item: Any) -> String {
        // First try CardDisplayable protocol
        if let displayable = item as? CardDisplayable {
            return displayable.cardIcon ?? "star.fill"
        }
        
        // Use reflection to find icon-related properties
        let mirror = Mirror(reflecting: item)
        
        // Look for icon properties
        let iconProperties = ["icon", "image", "symbol", "emoji"]
        for child in mirror.children {
            if let label = child.label,
               iconProperties.contains(label.lowercased()),
               let value = child.value as? String,
               !value.isEmpty {
                return value
            }
        }
        
        // Default fallback
        return "star.fill"
    }
    
    /// Extract meaningful color from any item using reflection
    public static func extractColor(from item: Any) -> Color {
        // First try CardDisplayable protocol
        if let displayable = item as? CardDisplayable {
            return displayable.cardColor ?? .blue
        }
        
        // Use reflection to find color-related properties
        let mirror = Mirror(reflecting: item)
        
        // Look for color properties
        let colorProperties = ["color", "tint", "accent"]
        for child in mirror.children {
            if let label = child.label,
               colorProperties.contains(label.lowercased()),
               let value = child.value as? Color {
                return value
            }
        }
        
        // Default fallback
        return .blue
    }
}

/// Extension to make GenericDataItem conform to CardDisplayable
/// This is the minimal version used internally by the framework
extension GenericDataItem: CardDisplayable {
    public var cardTitle: String { title }
    public var cardSubtitle: String? { subtitle }
    public var cardDescription: String? { nil }
    public var cardIcon: String? { "doc.text" }
    public var cardColor: Color? { .blue }
}

// NOTE: Other generic type CardDisplayable extensions have been moved to 
// Framework/Examples/GenericTypes.swift. Those are example types and 
// should not be in the main framework sources.
