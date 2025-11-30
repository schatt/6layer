import Foundation
import SixLayerFramework

/// Defensive validation utilities to prevent runtime crashes
struct DefensiveValidation {
    
    /// Validates capability names and provides helpful error messages
    static func validateCapabilityName(_ name: String) -> Result<String, ValidationError> {
        let validNames = ["Touch Only", "Hover Only", "All Capabilities", "No Capabilities"]
        
        if validNames.contains(name) {
            return .success(name)
        } else {
            return .failure(.invalidCapabilityName(
                provided: name,
                validOptions: validNames
            ))
        }
    }
    
    /// Validates accessibility names and provides helpful error messages
    static func validateAccessibilityName(_ name: String) -> Result<String, ValidationError> {
        let validNames = ["No Accessibility", "All Accessibility"]
        
        if validNames.contains(name) {
            return .success(name)
        } else {
            return .failure(.invalidAccessibilityName(
                provided: name,
                validOptions: validNames
            ))
        }
    }
    
    /// Safe platform setting with validation using RuntimeCapabilityDetection
    static func setPlatformSafely(_ name: String) -> Result<Void, ValidationError> {
        return validateCapabilityName(name).map { validatedName in
            switch validatedName {
            case "Touch Only":
                RuntimeCapabilityDetection.setTestTouchSupport(true); RuntimeCapabilityDetection.setTestHapticFeedback(true); RuntimeCapabilityDetection.setTestHover(false)
            case "Hover Only":
                RuntimeCapabilityDetection.setTestTouchSupport(false); RuntimeCapabilityDetection.setTestHapticFeedback(false); RuntimeCapabilityDetection.setTestHover(true)
            case "All Capabilities":
                RuntimeCapabilityDetection.setTestTouchSupport(true); RuntimeCapabilityDetection.setTestHapticFeedback(true); RuntimeCapabilityDetection.setTestHover(false)
            case "No Capabilities":
                RuntimeCapabilityDetection.setTestTouchSupport(false); RuntimeCapabilityDetection.setTestHapticFeedback(false); RuntimeCapabilityDetection.setTestHover(false)
            default:
                // Should never happen due to validation; no-op defensively
                print("Warning: Unhandled validated capability name: \(validatedName)")
            }
        }
    }
    
    /// Safe accessibility platform setting with validation using RuntimeCapabilityDetection
    static func setAccessibilityPlatformSafely(_ name: String) -> Result<Void, ValidationError> {
        return validateAccessibilityName(name).map { validatedName in
            switch validatedName {
            case "No Accessibility":
                RuntimeCapabilityDetection.setTestTouchSupport(false); RuntimeCapabilityDetection.setTestHapticFeedback(false); RuntimeCapabilityDetection.setTestHover(false) // Minimal accessibility
            case "All Accessibility":
                RuntimeCapabilityDetection.setTestTouchSupport(true); RuntimeCapabilityDetection.setTestHapticFeedback(true); RuntimeCapabilityDetection.setTestHover(false) // Full accessibility
            default:
                // Should never happen due to validation; no-op defensively
                print("Warning: Unhandled validated accessibility name: \(validatedName)")
            }
        }
    }
}

/// Detailed error types for better debugging
enum ValidationError: Error, CustomStringConvertible {
    case invalidCapabilityName(provided: String, validOptions: [String])
    case invalidAccessibilityName(provided: String, validOptions: [String])
    
    var description: String {
        switch self {
        case .invalidCapabilityName(let provided, let validOptions):
            return """
            Invalid capability name: "\(provided)"
            Valid options: \(validOptions.joined(separator: ", "))
            """
        case .invalidAccessibilityName(let provided, let validOptions):
            return """
            Invalid accessibility name: "\(provided)"
            Valid options: \(validOptions.joined(separator: ", "))
            """
        }
    }
}
