import SwiftUI
import SixLayerFramework

/**
 * Enhanced Breadcrumb System Example
 * 
 * This example demonstrates the enhanced breadcrumb system for UI testing,
 * including view hierarchy tracking, screen context, and automatic UI test code generation.
 */

struct EnhancedBreadcrumbExample: View {
    
    @State private var enableViewHierarchyTracking = false
    @State private var enableUITestIntegration = false
    @State private var currentScreen = "UserProfile"
    @State private var navigationState = "ProfileEditMode"
    
    // Sample data
    let users = [
        User(id: "user-1", name: "Alice", role: "Developer"),
        User(id: "user-2", name: "Bob", role: "Designer"),
        User(id: "user-3", name: "Charlie", role: "Manager")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // Screen context
                Text("User Profile Screen")
                    .screenContext(currentScreen)
                
                // Navigation state
                Text("Current State: \(navigationState)")
                    .navigationState(navigationState)
                
                // Enhanced debugging controls
                VStack(alignment: .leading, spacing: 12) {
                    Text("Enhanced Debugging Controls")
                        .font(.headline)
                    
                    Toggle("Enable View Hierarchy Tracking", isOn: $enableViewHierarchyTracking)
                        .onChange(of: enableViewHierarchyTracking) { newValue in
                            Task { @MainActor in
                                AccessibilityIdentifierConfig.shared.enableViewHierarchyTracking = newValue
                            }
                        }
                    
                    Toggle("Enable UI Test Integration", isOn: $enableUITestIntegration)
                        .onChange(of: enableUITestIntegration) { newValue in
                            Task { @MainActor in
                                AccessibilityIdentifierConfig.shared.enableUITestIntegration = newValue
                            }
                        }
                    
                    HStack {
                        Button("Generate UI Test Code") {
                            Task { @MainActor in
                                AccessibilityIdentifierConfig.shared.printUITestCode()
                            }
                        }
                        
                        Button("Save UI Test Code to File") {
                            do {
                                let filePath = try AccessibilityIdentifierConfig.shared.generateUITestCodeToFile()
                                print("✅ UI test code saved to: \(filePath)")
                            } catch {
                                print("❌ Failed to save UI test code: \(error)")
                            }
                        }
                        
                        Button("Copy UI Test Code to Clipboard") {
                            AccessibilityIdentifierConfig.shared.generateUITestCodeToClipboard()
                            print("📋 UI test code copied to clipboard")
                        }
                        
                        Button("Show Breadcrumb Trail") {
                            Task { @MainActor in
                                AccessibilityIdentifierConfig.shared.printBreadcrumbTrail()
                            }
                        }
                        
                        Button("Clear Logs") {
                            Task { @MainActor in
                                AccessibilityIdentifierConfig.shared.clearDebugLog()
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                .trackViewHierarchy("DebugControls")
                
                // Profile information section with hierarchy tracking
                VStack(alignment: .leading, spacing: 12) {
                    Text("Profile Information")
                        .font(.headline)
                        .trackViewHierarchy("ProfileInfoHeader")
                    
                    Button("Edit Profile") { }
                        .trackViewHierarchy("EditButton")
                    
                    Button("Save Changes") { }
                        .trackViewHierarchy("SaveButton")
                    
                    Button("Cancel") { }
                        .trackViewHierarchy("CancelButton")
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                .trackViewHierarchy("ProfileSection")
                
                // User list with hierarchy tracking
                VStack(alignment: .leading, spacing: 12) {
                    Text("Team Members")
                        .font(.headline)
                        .trackViewHierarchy("TeamHeader")
                    
                    // This will generate accessibility IDs with hierarchy context
                    platformPresentItemCollection_L1(
                        items: users,
                        hints: PresentationHints(
                            dataType: .generic,
                            presentationPreference: .list,
                            complexity: .simple,
                            context: .list,
                            customPreferences: [:]
                        )
                    )
                    .trackViewHierarchy("UserList")
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
                .trackViewHierarchy("TeamSection")
                
                // Form with hierarchy tracking
                VStack(alignment: .leading, spacing: 12) {
                    Text("Settings")
                        .font(.headline)
                        .trackViewHierarchy("SettingsHeader")
                    
                    Button("Notifications") { }
                        .trackViewHierarchy("NotificationsButton")
                    
                    Button("Privacy") { }
                        .trackViewHierarchy("PrivacyButton")
                    
                    Button("Account") { }
                        .trackViewHierarchy("AccountButton")
                }
                .padding()
                .background(Color.purple.opacity(0.1))
                .cornerRadius(8)
                .trackViewHierarchy("SettingsSection")
                
                Spacer()
            }
            .padding()
            .navigationTitle("Enhanced Breadcrumb Demo")
        }
        .trackViewHierarchy("NavigationView")
        .onAppear {
            // Enable enhanced debugging
            AccessibilityIdentifierConfig.shared.enableDebugLogging = true
            AccessibilityIdentifierConfig.shared.enableViewHierarchyTracking = enableViewHierarchyTracking
            AccessibilityIdentifierConfig.shared.enableUITestIntegration = enableUITestIntegration
        }
    }
}

// MARK: - UI Test Code Generation Example

struct UITestCodeGenerationExample: View {
    
    var body: some View {
        VStack(spacing: 20) {
            Text("UI Test Code Generation")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("This example shows how the enhanced breadcrumb system generates UI test code:")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Generated UI Test Code:")
                        .font(.headline)
                    
                    Text("""
                    // Generated UI Test Code
                    // Generated at: 2025-01-15 10:30:45
                    
                    // Screen: UserProfile
                    func test_app_profile_info_edit_button() {
                        let element = app.otherElements["app.profile.info.edit-button"]
                        XCTAssertTrue(element.exists, "Element 'app.profile.info.edit-button' should exist") // Hierarchy: NavigationView → ProfileSection → ProfileInfo → EditButton
                    }
                    
                    func test_app_profile_info_save_button() {
                        let element = app.otherElements["app.profile.info.save-button"]
                        XCTAssertTrue(element.exists, "Element 'app.profile.info.save-button' should exist") // Hierarchy: NavigationView → ProfileSection → ProfileInfo → SaveButton
                    }
                    
                    func test_app_list_item_user_1() {
                        let element = app.otherElements["app.list.item.user-1"]
                        XCTAssertTrue(element.exists, "Element 'app.list.item.user-1' should exist") // Hierarchy: NavigationView → TeamSection → UserList
                    }
                    """)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(4)
                }
            }
            .frame(maxHeight: 300)
            
            Text("Breadcrumb Trail:")
                .font(.headline)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("""
                    🍞 Accessibility ID Breadcrumb Trail:
                    
                    📱 Screen: UserProfile
                      10:30:45.123 - app.profile.info.edit-button
                        📍 Path: NavigationView → ProfileSection → ProfileInfo → EditButton
                        🧭 Navigation: ProfileEditMode
                      
                      10:30:45.124 - app.profile.info.save-button
                        📍 Path: NavigationView → ProfileSection → ProfileInfo → SaveButton
                        🧭 Navigation: ProfileEditMode
                      
                      10:30:45.125 - app.list.item.user-1
                        📍 Path: NavigationView → TeamSection → UserList
                        🧭 Navigation: ProfileEditMode
                    """)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(4)
                }
            }
            .frame(maxHeight: 300)
        }
        .padding()
    }
}

// MARK: - Test Data

struct User: Identifiable {
    let id: String
    let name: String
    let role: String
}

// MARK: - Preview

#Preview {
    EnhancedBreadcrumbExample()
}

#Preview("UI Test Code Generation") {
    UITestCodeGenerationExample()
}
