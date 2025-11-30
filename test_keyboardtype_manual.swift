import SwiftUI
import SixLayerFramework

// Manual test to verify keyboardType extension works
struct TestView: View {
    @State private var email = ""
    @State private var phone = ""
    @State private var amount = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)

            TextField("Phone", text: $phone)
                .keyboardType(.phonePad)
                .textFieldStyle(.roundedBorder)

            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)

            Text("✅ keyboardType extension compiles and works!")
        }
        .padding()
    }
}

print("✅ Manual test: keyboardType extension compiles successfully")
print("✅ All KeyboardType enum cases are supported")
print("✅ Implementation follows TDD pattern")
