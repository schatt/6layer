//
//  PlatformSemanticLayer1.swift
//  SixLayerFramework
//
//  Cross-platform semantic layer 1 implementation with fixed form handling
//

import SwiftUI
import Foundation

// MARK: - SimpleFormView

/// Form view that creates forms from generic form fields with proper bindings and validation
public struct SimpleFormView: View {
    let fields: [GenericFormField]
    let hints: PresentationHints
    let onSubmit: (([String: String]) -> Void)?
    let onReset: (() -> Void)?
    
    @State private var validationErrors: [String: String] = [:]
    @State private var isSubmitting = false
    
    public init(
        fields: [GenericFormField],
        hints: PresentationHints,
        onSubmit: (([String: String]) -> Void)? = nil,
        onReset: (() -> Void)? = nil
    ) {
        self.fields = fields
        self.hints = hints
        self.onSubmit = onSubmit
        self.onReset = onReset
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            // Form header
            HStack {
                Text(formTitle)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text("\(fields.count) fields")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            // Form fields
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(fields, id: \.id) { field in
                        createFieldView(for: field)
                    }
                }
                .padding(.horizontal)
            }
            
            // Form actions
            HStack {
                Button("Reset") {
                    resetForm()
                }
                .buttonStyle(.bordered)
                .disabled(isSubmitting)
                
                Spacer()
                
                Button("Submit") {
                    submitForm()
                }
                .buttonStyle(.borderedProminent)
                .disabled(isSubmitting || !isFormValid)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.platformBackground)
    }
    
    // MARK: - Computed Properties
    
    private var formTitle: String {
        hints.customPreferences["formTitle"] ?? "Form"
    }
    
    private var isFormValid: Bool {
        validationErrors.isEmpty
    }
    
    // MARK: - Form Actions
    
    private func resetForm() {
        for field in fields {
            field.value = ""
        }
        validationErrors.removeAll()
        onReset?()
    }
    
    private func submitForm() {
        guard validateForm() else { return }
        
        isSubmitting = true
        
        let formData = Dictionary(uniqueKeysWithValues: fields.map { ($0.label, $0.value) })
        
        onSubmit?(formData)
        
        // Reset submitting state after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isSubmitting = false
        }
    }
    
    // MARK: - Validation
    
    private func validateForm() -> Bool {
        var errors: [String: String] = [:]
        
        for field in fields {
            let fieldError = validateField(field)
            if let error = fieldError {
                errors[field.id.uuidString] = error
            }
        }
        
        validationErrors = errors
        return errors.isEmpty
    }
    
    private func validateField(_ field: GenericFormField) -> String? {
        let value = field.value
        
        // Required validation
        if field.isRequired && value.isEmpty {
            return "\(field.label) is required"
        }
        
        // Skip other validations if field is empty and not required
        if value.isEmpty {
            return nil
        }
        
        // Apply validation rules
        for rule in field.validationRules {
            if let error = validateRule(rule, value: value, fieldLabel: field.label) {
                return error
            }
        }
        
        return nil
    }
    
    private func validateRule(_ rule: ValidationRule, value: String, fieldLabel: String) -> String? {
        switch rule.rule {
        case .required:
            return value.isEmpty ? rule.message : nil
        case .email:
            let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
            return !matchesPattern(value, pattern: emailRegex) ? rule.message : nil
        case .phone:
            let phoneRegex = "^[+]?[0-9\\s\\-\\(\\)]{10,}$"
            return !matchesPattern(value, pattern: phoneRegex) ? rule.message : nil
        case .url:
            let urlRegex = "^(https?://)?[\\w\\-]+(\\.[\\w\\-]+)+([\\w\\-\\.,@?^=%&:/~\\+#]*[\\w\\-\\@?^=%&/~\\+#])?$"
            return !matchesPattern(value, pattern: urlRegex) ? rule.message : nil
        case .minLength(let min):
            return value.count < min ? rule.message : nil
        case .maxLength(let max):
            return value.count > max ? rule.message : nil
        case .pattern(let pattern):
            return !matchesPattern(value, pattern: pattern) ? rule.message : nil
        case .custom(let validator):
            return !validator(value) ? rule.message : nil
        }
    }
    
    private func matchesPattern(_ value: String, pattern: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: value.utf16.count)
        return regex?.firstMatch(in: value, options: [], range: range) != nil
    }
    
    @ViewBuilder
    private func createFieldView(for field: GenericFormField) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Field label with required indicator
            HStack {
                Text(field.label)
                    .font(.subheadline)
                    .fontWeight(.medium)
                if field.isRequired {
                    Text("*")
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                }
            }
            
            // Field input based on type
            Group {
                switch field.fieldType {
                case .text:
                    TextField(field.placeholder ?? "Enter text", text: field.$value)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: field.value) { _ in
                            clearFieldError(field)
                        }
                        
                case .email:
                    TextField(field.placeholder ?? "Enter email", text: field.$value)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .onChange(of: field.value) { _ in
                            clearFieldError(field)
                        }
                        
                case .password:
                    SecureField(field.placeholder ?? "Enter password", text: field.$value)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: field.value) { _ in
                            clearFieldError(field)
                        }
                        
                case .number:
                    TextField(field.placeholder ?? "Enter number", text: field.$value)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                        .onChange(of: field.value) { _ in
                            clearFieldError(field)
                        }
                        
                case .date:
                    DatePicker(
                        field.placeholder ?? "Select date",
                        selection: Binding(
                            get: { DateFormatter.iso8601.date(from: field.value) ?? Date() },
                            set: { field.value = DateFormatter.iso8601.string(from: $0) }
                        ),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    
                case .select:
                    Picker(field.placeholder ?? "Select option", selection: field.$value) {
                        Text("Select an option").tag("")
                        ForEach(field.options, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                    
                case .textarea:
                    TextEditor(text: field.$value)
                        .frame(minHeight: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .onChange(of: field.value) { _ in
                            clearFieldError(field)
                        }
                        
                case .checkbox:
                    Toggle(field.placeholder ?? "Toggle", isOn: Binding(
                        get: { field.value.lowercased() == "true" },
                        set: { field.value = $0 ? "true" : "false" }
                    ))
                    
                case .radio:
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(field.options, id: \.self) { option in
                            HStack {
                                Button(action: {
                                    field.value = option
                                    clearFieldError(field)
                                }) {
                                    HStack {
                                        Image(systemName: field.value == option ? "largecircle.fill.circle" : "circle")
                                            .foregroundColor(.accentColor)
                                        Text(option)
                                    }
                                }
                                .buttonStyle(.plain)
                                Spacer()
                            }
                        }
                    }
                    
                case .phone:
                    TextField(field.placeholder ?? "Enter phone", text: field.$value)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.phonePad)
                        .onChange(of: field.value) { _ in
                            clearFieldError(field)
                        }
                        
                case .time:
                    DatePicker(
                        field.placeholder ?? "Select time",
                        selection: Binding(
                            get: { DateFormatter.timeFormatter.date(from: field.value) ?? Date() },
                            set: { field.value = DateFormatter.timeFormatter.string(from: $0) }
                        ),
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.compact)
                    
                case .datetime:
                    DatePicker(
                        field.placeholder ?? "Select date and time",
                        selection: Binding(
                            get: { DateFormatter.iso8601.date(from: field.value) ?? Date() },
                            set: { field.value = DateFormatter.iso8601.string(from: $0) }
                        ),
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                    
                case .multiselect:
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(field.options, id: \.self) { option in
                            HStack {
                                Button(action: {
                                    toggleMultiSelectOption(field, option: option)
                                    clearFieldError(field)
                                }) {
                                    HStack {
                                        Image(systemName: field.value.contains(option) ? "checkmark.square.fill" : "square")
                                            .foregroundColor(.accentColor)
                                        Text(option)
                                    }
                                }
                                .buttonStyle(.plain)
                                Spacer()
                            }
                        }
                    }
                    
                case .file:
                    Button(action: {
                        // File picker implementation would go here
                        field.value = "File selected"
                    }) {
                        HStack {
                            Image(systemName: "paperclip")
                            Text(field.value.isEmpty ? "Select file" : field.value)
                            Spacer()
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    
                case .url:
                    TextField(field.placeholder ?? "Enter URL", text: field.$value)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .onChange(of: field.value) { _ in
                            clearFieldError(field)
                        }
                        
                case .color:
                    ColorPicker(field.placeholder ?? "Select color", selection: Binding(
                        get: { Color(hex: field.value) ?? .blue },
                        set: { field.value = $0.toHex() }
                    ))
                    
                case .range:
                    VStack {
                        Slider(
                            value: Binding(
                                get: { Double(field.value) ?? 0.0 },
                                set: { field.value = String($0) }
                            ),
                            in: 0...100
                        )
                        Text("Value: \(field.value)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                case .toggle:
                    Toggle(field.placeholder ?? "Toggle", isOn: Binding(
                        get: { field.value.lowercased() == "true" },
                        set: { field.value = $0 ? "true" : "false" }
                    ))
                    
                case .richtext:
                    TextEditor(text: field.$value)
                        .frame(minHeight: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .onChange(of: field.value) { _ in
                            clearFieldError(field)
                        }
                        
                case .autocomplete:
                    AutocompleteField(
                        placeholder: field.placeholder ?? "Type to search",
                        text: field.$value,
                        suggestions: field.options
                    )
                    
                case .custom:
                    TextField(field.placeholder ?? "Custom field", text: field.$value)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: field.value) { _ in
                            clearFieldError(field)
                        }
                }
            }
            
            // Error message display
            if let error = validationErrors[field.id.uuidString] {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func clearFieldError(_ field: GenericFormField) {
        validationErrors.removeValue(forKey: field.id.uuidString)
    }
    
    private func toggleMultiSelectOption(_ field: GenericFormField, option: String) {
        let currentValues = field.value.split(separator: ",").map(String.init)
        if currentValues.contains(option) {
            let newValues = currentValues.filter { $0 != option }
            field.value = newValues.joined(separator: ",")
        } else {
            let newValues = currentValues + [option]
            field.value = newValues.joined(separator: ",")
        }
    }
}

// MARK: - Supporting Extensions

extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
    
    func toHex() -> String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0
        return String(format: "#%06x", rgb)
    }
}

// MARK: - AutocompleteField

struct AutocompleteField: View {
    let placeholder: String
    @Binding var text: String
    let suggestions: [String]
    
    @State private var isShowingSuggestions = false
    @State private var filteredSuggestions: [String] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .onChange(of: text) { newValue in
                    filterSuggestions()
                    isShowingSuggestions = !newValue.isEmpty && !filteredSuggestions.isEmpty
                }
                .onTapGesture {
                    isShowingSuggestions = !text.isEmpty && !filteredSuggestions.isEmpty
                }
            
            if isShowingSuggestions {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(filteredSuggestions, id: \.self) { suggestion in
                        Button(action: {
                            text = suggestion
                            isShowingSuggestions = false
                        }) {
                            Text(suggestion)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }
    
    private func filterSuggestions() {
        if text.isEmpty {
            filteredSuggestions = []
        } else {
            filteredSuggestions = suggestions.filter { $0.localizedCaseInsensitiveContains(text) }
        }
    }
}
