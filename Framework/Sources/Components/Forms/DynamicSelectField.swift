import SwiftUI

/// A dynamic select field component that renders a picker based on DynamicFormField configuration
public struct DynamicSelectField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public init(field: DynamicFormField, formState: DynamicFormState) {
        self.field = field
        self.formState = formState
    }
    
    private var selectedValue: Binding<String> {
        Binding(
            get: { 
                let value: String? = formState.getValue(for: field.id)
                return value ?? ""
            },
            set: { formState.setValue($0, for: field.id) }
        )
    }
    
    /// Get picker options from hints (preferred) or field.options (fallback)
    private var pickerOptions: [(value: String, label: String)] {
        // Prefer pickerOptions from displayHints (has labels)
        if let hints = field.displayHints,
           let pickerOptions = hints.pickerOptions,
           !pickerOptions.isEmpty {
            return pickerOptions.map { ($0.value, $0.label) }
        }
        // Fallback to field.options (simple string array)
        if let options = field.options {
            return options.map { ($0, $0) } // Use same value for both value and label
        }
        return []
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Field label
            Text(field.label)
                .font(.headline)
                .foregroundColor(.primary)
            
            // Select picker - use hints if available, otherwise fallback to field.options
            if !pickerOptions.isEmpty {
                Picker(field.placeholder ?? "Select", selection: selectedValue) {
                    ForEach(pickerOptions, id: \.value) { option in
                        Text(option.label).tag(option.value)
                    }
                }
                .pickerStyle(.menu)
                .accessibilityIdentifier("SixLayer.main.element.select.\(field.id)")
            } else {
                // No options available
                Text("No options available")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Error message if any
            if let errors = formState.fieldErrors[field.id], !errors.isEmpty {
                Text(errors.first!)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.platformBackground)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(field.isRequired && (selectedValue.wrappedValue.isEmpty) ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
        )
        .automaticCompliance()
    }
}

#if ENABLE_PREVIEWS
#Preview {
    let formState = DynamicFormState(configuration: DynamicFormConfiguration(
        id: "test-form",
        title: "Test Form"
    ))
    let field = DynamicFormField(
        id: "test-select",
        contentType: .select,
        label: "Choose Option",
        placeholder: "Select an option",
        isRequired: true,
        options: ["Option 1", "Option 2", "Option 3", "Option 4"],
        defaultValue: ""
    )
    
    DynamicSelectField(field: field, formState: formState)
        .padding()
}
#endif
