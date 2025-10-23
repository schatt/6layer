import Foundation

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
    
    /// Safe capability checker creation with validation
    static func createCapabilityCheckerSafely(_ name: String) -> Result<MockPlatformCapabilityChecker, ValidationError> {
        return validateCapabilityName(name).map { validatedName in
            switch validatedName {
            case "Touch Only":
                return TestPatterns.createTouchCapabilities()
            case "Hover Only":
                return TestPatterns.createHoverCapabilities()
            case "All Capabilities":
                return TestPatterns.createAllCapabilities()
            case "No Capabilities":
                return TestPatterns.createNoCapabilities()
            default:
                // This should never happen due to validation, but defensive programming
                fatalError("Unhandled validated capability name: \(validatedName)")
            }
        }
    }
    
    /// Safe accessibility checker creation with validation
    static func createAccessibilityCheckerSafely(_ name: String) -> Result<MockAccessibilityFeatureChecker, ValidationError> {
        return validateAccessibilityName(name).map { validatedName in
            switch validatedName {
            case "No Accessibility":
                return TestPatterns.createNoAccessibility()
            case "All Accessibility":
                return TestPatterns.createAllAccessibility()
            default:
                // This should never happen due to validation, but defensive programming
                fatalError("Unhandled validated accessibility name: \(validatedName)")
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
