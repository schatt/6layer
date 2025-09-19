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
extension GenericDataItem: CardDisplayable {
    public var cardTitle: String { title }
    public var cardSubtitle: String? { subtitle }
    public var cardDescription: String? { nil }
    public var cardIcon: String? { "doc.text" }
    public var cardColor: Color? { .blue }
}

/// Extension to make GenericVehicle conform to CardDisplayable
extension GenericVehicle: CardDisplayable {
    public var cardTitle: String { name }
    public var cardSubtitle: String? { type.rawValue }
    public var cardDescription: String? { description }
    public var cardIcon: String? { 
        switch type {
        case .car: return "car.fill"
        case .truck: return "truck.box.fill"
        case .motorcycle: return "motorcycle.fill"
        case .boat: return "sailboat.fill"
        case .aircraft: return "airplane"
        case .other: return "questionmark.circle.fill"
        case .generic: return "star.fill"
        }
    }
    public var cardColor: Color? { 
        switch type {
        case .car: return .blue
        case .truck: return .orange
        case .motorcycle: return .red
        case .boat: return .cyan
        case .aircraft: return .purple
        case .other: return .gray
        case .generic: return .blue
        }
    }
}

/// Extension to make GenericMediaItem conform to CardDisplayable
extension GenericMediaItem: CardDisplayable {
    public var cardTitle: String { title }
    public var cardSubtitle: String? { mediaType.rawValue.capitalized }
    public var cardDescription: String? { description }
    public var cardIcon: String? { 
        switch mediaType {
        case .image: return "photo.fill"
        case .video: return "video.fill"
        case .audio: return "music.note"
        case .document: return "doc.fill"
        case .other: return "questionmark.circle.fill"
        }
    }
    public var cardColor: Color? { 
        switch mediaType {
        case .image: return .green
        case .video: return .red
        case .audio: return .purple
        case .document: return .blue
        case .other: return .gray
        }
    }
}

/// Extension to make GenericTemporalData conform to CardDisplayable
extension GenericTemporalData: CardDisplayable {
    public var cardTitle: String { title }
    public var cardSubtitle: String? { 
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    public var cardDescription: String? { description }
    public var cardIcon: String? { "calendar" }
    public var cardColor: Color? { .orange }
}

/// Extension to make GenericHierarchicalData conform to CardDisplayable
extension GenericHierarchicalData: CardDisplayable {
    public var cardTitle: String { title }
    public var cardSubtitle: String? { nil }
    public var cardDescription: String? { nil }
    public var cardIcon: String? { "folder.fill" }
    public var cardColor: Color? { .brown }
}
