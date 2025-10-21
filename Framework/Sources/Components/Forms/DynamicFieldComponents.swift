import SwiftUI

// MARK: - Dynamic Field Components (TDD Red Phase Stubs)

/// Color picker field component
/// TDD RED PHASE: This is a stub implementation for testing
@MainActor
public struct DynamicColorField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(field.label)
                .font(.subheadline)
            
            Rectangle()
                .fill(Color.blue)
                .frame(height: 30)
                .overlay(
                    Text("Color Field - TDD Red Phase Stub")
                        .foregroundColor(.white)
                        .font(.caption)
                )
        }
        .padding()
        .automaticAccessibilityIdentifiers()
    }
}

/// Toggle field component
/// TDD RED PHASE: This is a stub implementation for testing
@MainActor
public struct DynamicToggleField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(field.label)
                .font(.subheadline)
            
            Toggle("Toggle Field - TDD Red Phase Stub", isOn: .constant(false))
        }
        .padding()
        .automaticAccessibilityIdentifiers()
    }
}

/// Checkbox field component
/// TDD RED PHASE: This is a stub implementation for testing
@MainActor
public struct DynamicCheckboxField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(field.label)
                .font(.subheadline)
            
            HStack {
                Image(systemName: "checkmark.square")
                Text("Checkbox Field - TDD Red Phase Stub")
            }
        }
        .padding()
        .automaticAccessibilityIdentifiers()
    }
}

/// Text area field component
/// TDD RED PHASE: This is a stub implementation for testing
@MainActor
public struct DynamicTextAreaField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(field.label)
                .font(.subheadline)
            
            TextEditor(text: .constant("Text Area Field - TDD Red Phase Stub"))
                .frame(height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
        .padding()
        .automaticAccessibilityIdentifiers()
    }
}
