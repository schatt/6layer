# Security Service Examples

## Basic Biometric Authentication

```swift
import SixLayerFramework
import SwiftUI

struct BiometricAuthView: View {
    @StateObject private var security = SecurityService()
    @State private var isAuthenticated = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            if security.isBiometricAvailable {
                Text("Biometric Type: \(security.biometricType.displayName)")
                
                Button("Authenticate with \(security.biometricType.displayName)") {
                    Task {
                        do {
                            isAuthenticated = try await security.authenticateWithBiometrics(
                                reason: "Authenticate to access secure content"
                            )
                            errorMessage = nil
                        } catch let error as SecurityServiceError {
                            errorMessage = error.errorDescription
                            isAuthenticated = false
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
            } else {
                Text("Biometric authentication not available")
            }
            
            if isAuthenticated {
                Text("✅ Authenticated")
                    .foregroundColor(.green)
            }
            
            if let error = errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .environmentObject(security)
    }
}
```

## Secure Data Storage

```swift
import SixLayerFramework
import SwiftUI

struct SecureStorageView: View {
    @StateObject private var security = SecurityService()
    @State private var secretData = ""
    @State private var storedData: String?
    @State private var message = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter secret data", text: $secretData)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                Button("Encrypt & Store") {
                    do {
                        // Encrypt the data
                        let data = secretData.data(using: .utf8)!
                        let encrypted = try security.encrypt(data)
                        
                        // Store in keychain
                        try security.storeInKeychain(
                            encrypted,
                            key: "my-app.secret-data",
                            accessibility: .whenUnlockedThisDeviceOnly
                        )
                        
                        message = "Data encrypted and stored successfully"
                    } catch {
                        message = "Error: \(error.localizedDescription)"
                    }
                }
                
                Button("Retrieve & Decrypt") {
                    do {
                        // Retrieve from keychain
                        guard let encrypted = try security.retrieveFromKeychain(
                            key: "my-app.secret-data"
                        ) else {
                            message = "No data found"
                            return
                        }
                        
                        // Decrypt
                        let decrypted = try security.decrypt(encrypted)
                        storedData = String(data: decrypted, encoding: .utf8)
                        message = "Data retrieved and decrypted"
                    } catch {
                        message = "Error: \(error.localizedDescription)"
                    }
                }
            }
            
            if let data = storedData {
                Text("Retrieved: \(data)")
                    .padding()
                    .background(Color.gray.opacity(0.2))
            }
            
            Text(message)
                .foregroundColor(message.contains("Error") ? .red : .green)
        }
        .padding()
        .environmentObject(security)
    }
}
```

## Privacy Permission Management

```swift
import SixLayerFramework
import SwiftUI

struct PrivacyPermissionsView: View {
    @StateObject private var security = SecurityService()
    
    var body: some View {
        List {
            ForEach(PrivacyPermissionType.allCases, id: \.self) { permissionType in
                HStack {
                    Text(permissionType.displayName)
                    Spacer()
                    Text(permissionStatus(permissionType))
                        .foregroundColor(statusColor(permissionType))
                }
                .onTapGesture {
                    Task {
                        let status = await security.requestPrivacyPermission(permissionType)
                        // Status updated automatically via @Published property
                    }
                }
            }
        }
        .navigationTitle("Privacy Permissions")
        .environmentObject(security)
    }
    
    private func permissionStatus(_ type: PrivacyPermissionType) -> String {
        let status = security.checkPrivacyPermission(type)
        switch status {
        case .authorized: return "Authorized"
        case .denied: return "Denied"
        case .notDetermined: return "Not Determined"
        case .restricted: return "Restricted"
        }
    }
    
    private func statusColor(_ type: PrivacyPermissionType) -> Color {
        let status = security.checkPrivacyPermission(type)
        switch status {
        case .authorized: return .green
        case .denied: return .red
        case .notDetermined: return .orange
        case .restricted: return .gray
        }
    }
}
```

## Using Layer 1 Functions

```swift
import SixLayerFramework
import SwiftUI

struct SecureContentView: View {
    @State private var password = ""
    @State private var isAuthenticated = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Present secure content with biometric authentication
            platformPresentSecureContent_L1(
                content: VStack {
                    Text("Secure Content")
                    Text("This content requires authentication")
                },
                hints: SecurityHints(
                    biometricPolicy: .required,
                    enablePrivacyIndicators: true
                )
            )
            
            // Present secure text field
            platformPresentSecureTextField_L1(
                title: "Password",
                text: $password,
                hints: SecurityHints(enableSecureTextEntry: true)
            )
            
            Button("Authenticate") {
                Task {
                    do {
                        isAuthenticated = try await platformRequestBiometricAuth_L1(
                            reason: "Access secure features",
                            hints: SecurityHints(biometricPolicy: .required)
                        )
                    } catch {
                        print("Authentication failed: \(error)")
                    }
                }
            }
            
            if isAuthenticated {
                Text("✅ Authenticated")
            }
        }
        .padding()
    }
}
```

## Integration with DynamicFormView

```swift
import SixLayerFramework
import SwiftUI

struct SecureFormView: View {
    @StateObject private var security = SecurityService(
        biometricPolicy: .optional,
        enablePrivacyIndicators: true
    )
    
    var body: some View {
        let configuration = DynamicFormConfiguration(
            id: "secure-form",
            title: "Secure Login",
            sections: [
                DynamicFormSection(
                    id: "credentials",
                    title: "Credentials",
                    fields: [
                        DynamicFormField(
                            id: "email",
                            contentType: .email,
                            label: "Email",
                            placeholder: "Enter your email"
                        ),
                        DynamicFormField(
                            id: "password",
                            contentType: .password,
                            label: "Password",
                            placeholder: "Enter your password"
                        )
                    ]
                )
            ]
        )
        
        DynamicFormView(
            configuration: configuration,
            onSubmit: { values in
                // Handle form submission
                print("Form submitted: \(values)")
            }
        )
        .environmentObject(security)
        .environment(\.securityService, security)
    }
}
```

## Complete Secure App Example

```swift
import SixLayerFramework
import SwiftUI

@main
struct SecureApp: App {
    @StateObject private var security = SecurityService(
        biometricPolicy: .optional,
        enablePrivacyIndicators: true
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(security)
                .environment(\.securityService, security)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var security: SecurityService
    @State private var isAuthenticated = false
    
    var body: some View {
        NavigationView {
            if isAuthenticated {
                SecureContentView()
            } else {
                AuthenticationView(isAuthenticated: $isAuthenticated)
            }
        }
    }
}

struct AuthenticationView: View {
    @EnvironmentObject var security: SecurityService
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome")
                .font(.largeTitle)
            
            if security.isBiometricAvailable {
                Button("Authenticate with \(security.biometricType.displayName)") {
                    Task {
                        do {
                            isAuthenticated = try await security.authenticateWithBiometrics(
                                reason: "Authenticate to access the app"
                            )
                        } catch {
                            print("Authentication failed: \(error)")
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

struct SecureContentView: View {
    @EnvironmentObject var security: SecurityService
    
    var body: some View {
        List {
            Section("Security Features") {
                NavigationLink("Biometric Settings") {
                    BiometricSettingsView()
                }
                NavigationLink("Privacy Permissions") {
                    PrivacyPermissionsView()
                }
                NavigationLink("Secure Storage") {
                    SecureStorageView()
                }
            }
        }
        .navigationTitle("Secure Content")
    }
}
```
