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
