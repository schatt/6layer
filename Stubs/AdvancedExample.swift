//
//  AdvancedExample.swift
//  SixLayer Framework Stub
//
//  Copy this file into your project and modify it for your needs.
//  This shows advanced hint usage patterns and combinations.
//

import Foundation
import SixLayerFramework

// MARK: - Advanced Hint System Example

/// This example shows how to create complex hint systems
/// by combining multiple hints and creating domain-specific patterns
class AdvancedHintSystem {
    
    // MARK: - Complex E-commerce Hint
    
    /// Advanced e-commerce hint that combines multiple concerns
    static func createEcommerceHint(
        userRole: UserRole,
        deviceType: DeviceType,
        contentComplexity: ContentComplexity,
        showAdvancedFeatures: Bool = false
    ) -> EnhancedPresentationHints {
        
        // Create role-specific hint
        let roleHint = UserRoleHint(
            role: userRole,
            showAdvancedFeatures: showAdvancedFeatures
        )
        
        // Create device-specific hint
        let deviceHint = DeviceOptimizationHint(
            deviceType: deviceType,
            contentComplexity: contentComplexity
        )
        
        // Create performance hint
        let performanceHint = PerformanceHint(
            priority: userRole == .admin ? .critical : .normal,
            enableCaching: true,
            enableLazyLoading: true
        )
        
        // Combine all hints
        return EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .grid,
            complexity: contentComplexity,
            context: .browse,
            extensibleHints: [roleHint, deviceHint, performanceHint]
        )
    }
    
    // MARK: - Multi-Context Dashboard Hint
    
    /// Dashboard hint that adapts to multiple contexts
    static func createAdaptiveDashboardHint(
        timeOfDay: TimeOfDay,
        userActivity: UserActivity,
        deviceCapabilities: DeviceCapabilities
    ) -> EnhancedPresentationHints {
        
        // Time-based hint
        let timeHint = TimeBasedHint(
            timeOfDay: timeOfDay,
            showDetailedMetrics: timeOfDay == .morning
        )
        
        // Activity-based hint
        let activityHint = ActivityBasedHint(
            userActivity: userActivity,
            showQuickActions: userActivity == .active
        )
        
        // Device capability hint
        let capabilityHint = DeviceCapabilityHint(
            deviceCapabilities: deviceCapabilities,
            enableAdvancedFeatures: deviceCapabilities.supportsAdvancedFeatures
        )
        
        return EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .dashboard,
            extensibleHints: [timeHint, activityHint, capabilityHint]
        )
    }
}

// MARK: - Supporting Hint Types

/// User role hint for role-based UI customization
class UserRoleHint: CustomHint {
    let role: UserRole
    let showAdvancedFeatures: Bool
    
    init(role: UserRole, showAdvancedFeatures: Bool) {
        self.role = role
        self.showAdvancedFeatures = showAdvancedFeatures
        
        super.init(
            hintType: "user.role.\(role.rawValue)",
            priority: .high,
            overridesDefault: false,
            customData: [
                "userRole": role.rawValue,
                "showAdvancedFeatures": showAdvancedFeatures,
                "permissions": role.permissions,
                "customizationLevel": role.customizationLevel,
                "theme": role.preferredTheme
            ]
        )
    }
}

/// Device optimization hint for device-specific optimizations
class DeviceOptimizationHint: CustomHint {
    let deviceType: DeviceType
    let contentComplexity: ContentComplexity
    
    init(deviceType: DeviceType, contentComplexity: ContentComplexity) {
        self.deviceType = deviceType
        self.contentComplexity = contentComplexity
        
        super.init(
            hintType: "device.optimization.\(deviceType.rawValue)",
            priority: .normal,
            overridesDefault: false,
            customData: [
                "deviceType": deviceType.rawValue,
                "contentComplexity": contentComplexity.rawValue,
                "recommendedColumns": calculateColumns(for: deviceType, complexity: contentComplexity),
                "touchOptimized": deviceType == .phone,
                "keyboardOptimized": deviceType == .mac,
                "responsiveBehavior": determineResponsiveBehavior(for: deviceType)
            ]
        )
    }
    
    private func calculateColumns(for device: DeviceType, complexity: ContentComplexity) -> Int {
        switch (device, complexity) {
        case (.phone, .simple): return 1
        case (.phone, .moderate): return 2
        case (.phone, .complex): return 1
        case (.pad, .simple): return 3
        case (.pad, .moderate): return 4
        case (.pad, .complex): return 2
        case (.mac, .simple): return 4
        case (.mac, .moderate): return 6
        case (.mac, .complex): return 3
        default: return 2
        }
    }
    
    private func determineResponsiveBehavior(for device: DeviceType) -> String {
        switch device {
        case .phone: return "adaptive"
        case .pad: return "responsive"
        case .mac: return "breakpoint"
        default: return "adaptive"
        }
    }
}

/// Performance hint for performance optimization
class PerformanceHint: CustomHint {
    let priority: HintPriority
    let enableCaching: Bool
    let enableLazyLoading: Bool
    
    init(priority: HintPriority, enableCaching: Bool, enableLazyLoading: Bool) {
        self.priority = priority
        self.enableCaching = enableCaching
        self.enableLazyLoading = enableLazyLoading
        
        super.init(
            hintType: "performance.optimization",
            priority: priority,
            overridesDefault: false,
            customData: [
                "enableCaching": enableCaching,
                "enableLazyLoading": enableLazyLoading,
                "refreshRate": priority == .critical ? 5 : 30,
                "batchSize": priority == .critical ? 10 : 50,
                "preloadDistance": priority == .critical ? 2 : 1
            ]
        )
    }
}

/// Time-based hint for time-sensitive UI adjustments
class TimeBasedHint: CustomHint {
    let timeOfDay: TimeOfDay
    let showDetailedMetrics: Bool
    
    init(timeOfDay: TimeOfDay, showDetailedMetrics: Bool) {
        self.timeOfDay = timeOfDay
        self.showDetailedMetrics = showDetailedMetrics
        
        super.init(
            hintType: "time.based.\(timeOfDay.rawValue)",
            priority: .low,
            overridesDefault: false,
            customData: [
                "timeOfDay": timeOfDay.rawValue,
                "showDetailedMetrics": showDetailedMetrics,
                "refreshRate": timeOfDay == .morning ? 15 : 60,
                "showNotifications": timeOfDay == .morning,
                "theme": timeOfDay == .night ? "dark" : "light"
            ]
        )
    }
}

/// Activity-based hint for user activity context
class ActivityBasedHint: CustomHint {
    let userActivity: UserActivity
    let showQuickActions: Bool
    
    init(userActivity: UserActivity, showQuickActions: Bool) {
        self.userActivity = userActivity
        self.showQuickActions = showQuickActions
        
        super.init(
            hintType: "activity.based.\(userActivity.rawValue)",
            priority: .normal,
            overridesDefault: false,
            customData: [
                "userActivity": userActivity.rawValue,
                "showQuickActions": showQuickActions,
                "autoRefresh": userActivity == .active,
                "showSuggestions": userActivity == .active,
                "interactionLevel": userActivity == .active ? "high" : "low"
            ]
        )
    }
}

/// Device capability hint for capability-based features
class DeviceCapabilityHint: CustomHint {
    let deviceCapabilities: DeviceCapabilities
    let enableAdvancedFeatures: Bool
    
    init(deviceCapabilities: DeviceCapabilities, enableAdvancedFeatures: Bool) {
        self.deviceCapabilities = deviceCapabilities
        self.enableAdvancedFeatures = enableAdvancedFeatures
        
        super.init(
            hintType: "device.capability",
            priority: .normal,
            overridesDefault: false,
            customData: [
                "supportsAdvancedFeatures": enableAdvancedFeatures,
                "maxConcurrentOperations": deviceCapabilities.maxConcurrentOperations,
                "memoryLimit": deviceCapabilities.memoryLimit,
                "graphicsCapability": deviceCapabilities.graphicsCapability,
                "networkCapability": deviceCapabilities.networkCapability
            ]
        )
    }
}

// MARK: - Supporting Types

enum UserRole: String, CaseIterable {
    case viewer, editor, admin, powerUser
    
    var permissions: [String] {
        switch self {
        case .viewer: return ["read"]
        case .editor: return ["read", "write"]
        case .admin: return ["read", "write", "delete"]
        case .powerUser: return ["read", "write", "delete", "configure"]
        }
    }
    
    var customizationLevel: String {
        switch self {
        case .viewer: return "none"
        case .editor: return "basic"
        case .admin: return "advanced"
        case .powerUser: return "full"
        }
    }
    
    var preferredTheme: String {
        switch self {
        case .viewer: return "default"
        case .editor: return "default"
        case .admin: return "professional"
        case .powerUser: return "custom"
        }
    }
}

enum TimeOfDay: String, CaseIterable {
    case morning, afternoon, evening, night
}

enum UserActivity: String, CaseIterable {
    case active, idle, inactive
}

struct DeviceCapabilities {
    let maxConcurrentOperations: Int
    let memoryLimit: String
    let graphicsCapability: String
    let networkCapability: String
    
    var supportsAdvancedFeatures: Bool {
        return maxConcurrentOperations >= 4 && memoryLimit != "low"
    }
}

// MARK: - Usage Examples

/*
 
 // Use the advanced hint system in your app:
 
 struct AdvancedEcommerceView: View {
     let products: [Product]
     @State private var userRole: UserRole = .viewer
     @State private var deviceType: DeviceType = .phone
     
     var body: some View {
         let hints = AdvancedHintSystem.createEcommerceHint(
             userRole: userRole,
             deviceType: deviceType,
             contentComplexity: .moderate,
             showAdvancedFeatures: userRole == .admin
         )
         
         return platformPresentItemCollection_L1(
             items: products,
             hints: hints
         )
     }
 }
 
 struct AdaptiveDashboardView: View {
     @State private var timeOfDay: TimeOfDay = .morning
     @State private var userActivity: UserActivity = .active
     
     var body: some View {
         let hints = AdvancedHintSystem.createAdaptiveDashboardHint(
             timeOfDay: timeOfDay,
             userActivity: userActivity,
             deviceCapabilities: DeviceCapabilities(
                 maxConcurrentOperations: 6,
                 memoryLimit: "high",
                 graphicsCapability: "high",
                 networkCapability: "high"
             )
         )
         
         return platformPresentItemCollection_L1(
             items: dashboardItems,
             hints: hints
         )
     }
 }
 
 // Create custom hints for your specific domain:
 
 class MyDomainHint: CustomHint {
     init(mySetting: String, myValue: Int) {
         super.init(
             hintType: "mydomain.custom",
             priority: .high,
             overridesDefault: false,
             customData: [
                 "mySetting": mySetting,
                 "myValue": myValue,
                 "customBehavior": "special"
             ]
         )
     }
 }
 
 // Combine with existing hints:
 
 let combinedHints = EnhancedPresentationHints(
     dataType: .collection,
     presentationPreference: .grid,
     complexity: .moderate,
     context: .dashboard,
     extensibleHints: [
         HintFactories.forDashboard(),
         MyDomainHint(mySetting: "custom", myValue: 42)
     ]
 )
 
 */
