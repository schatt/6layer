import Foundation
import CoreLocation

extension Place {
    
    /// Computed property that converts the Place's latitude and longitude to a CLLocationCoordinate2D
    var coordinate: CLLocationCoordinate2D? {
        guard latitude != 0.0, longitude != 0.0 else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// Check if the place has valid coordinates
    var hasValidCoordinates: Bool {
        return coordinate != nil
    }
    
    /// Formatted address string
    var formattedAddress: String {
        var components: [String] = []
        
        if let streetAddress = streetAddress, !streetAddress.isEmpty {
            components.append(streetAddress)
        }
        
        if let city = city, !city.isEmpty {
            components.append(city)
        }
        
        if let stateProvince = stateProvince, !stateProvince.isEmpty {
            components.append(stateProvince)
        }
        
        if let postalCode = postalCode, !postalCode.isEmpty {
            components.append(postalCode)
        }
        
        if let country = country, !country.isEmpty {
            components.append(country)
        }
        
        return components.isEmpty ? "Unknown Location" : components.joined(separator: ", ")
    }
    
    /// Display name for the place
    var displayName: String {
        if let name = name, !name.isEmpty {
            return name
        }
        return formattedAddress
    }
}
