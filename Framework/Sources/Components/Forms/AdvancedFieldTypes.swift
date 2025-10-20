import SwiftUI
import UniformTypeIdentifiers

// MARK: - Rich Text Editor Field

/// Rich text editor field with formatting capabilities
public struct RichTextEditorField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    @State private var isEditing = false
    @State private var selectedText: NSRange?
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(field.label)
                    .font(.headline)
                
                Spacer()
                
                Button(isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                }
                .buttonStyle(.bordered)
            }
            
            if isEditing {
                RichTextEditor(
                    text: Binding(
                        get: { formState.getValue(for: field.id) ?? "" },
                        set: { formState.setValue($0, for: field.id) }
                    ),
                    selectedText: $selectedText
                )
                .frame(minHeight: 150)
                .background(Color.secondaryBackground)
                .cornerRadius(8)
                
                RichTextToolbar(selectedText: $selectedText)
            } else {
                RichTextPreview(
                    text: formState.getValue(for: field.id) ?? ""
                )
                .frame(minHeight: 100)
                .background(Color.secondaryBackground)
                .cornerRadius(8)
            }
        }
    }
}

// MARK: - Rich Text Editor

/// Rich text editor with formatting capabilities
#if os(iOS)
public struct RichTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var selectedText: NSRange?
    
        public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.backgroundColor = UIColor.systemBackground
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.separator.cgColor
        
        // Enable rich text editing
        textView.allowsEditingTextAttributes = true
        textView.dataDetectorTypes = [.link, .phoneNumber]
        
        return textView
    }
    
        public func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }
    
        public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, UITextViewDelegate {
        var parent: RichTextEditor
        
        init(_ parent: RichTextEditor) {
            self.parent = parent
        }
        
            public func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
            public func textViewDidChangeSelection(_ textView: UITextView) {
            parent.selectedText = textView.selectedRange
        }
    }
}
#else
// macOS fallback - simple text editor
public struct RichTextEditor: View {
    @Binding var text: String
    @Binding var selectedText: NSRange?
    
    public var body: some View {
        TextEditor(text: $text)
            .font(.body)
            .frame(minHeight: 150)
            .padding(8)
            .background(Color.secondaryBackground)
            .cornerRadius(8)
                    .onChange(of: text) { _ in
            // Handle text changes
        }
    }
}
#endif

// MARK: - Rich Text Toolbar

/// Toolbar for rich text formatting
public struct RichTextToolbar: View {
    @Binding var selectedText: NSRange?
    
    public var body: some View {
        HStack(spacing: 12) {
            FormatButton(title: "B", action: { formatBold() })
            FormatButton(title: "I", action: { formatItalic() })
            FormatButton(title: "U", action: { formatUnderline() })
            
            Divider()
            
            FormatButton(title: "•", action: { formatBullet() })
            FormatButton(title: "1.", action: { formatNumbered() })
            
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.tertiaryBackground)
        .cornerRadius(6)
    }
    
    private func formatBold() {
        // Format bold implementation
        // This would apply bold formatting to the selected text
        // For now, this is a placeholder for the actual implementation
    }
    
    private func formatItalic() {
        // Format italic implementation
        // This would apply italic formatting to the selected text
        // For now, this is a placeholder for the actual implementation
    }
    
    private func formatUnderline() {
        // Format underline implementation
        // This would apply underline formatting to the selected text
        // For now, this is a placeholder for the actual implementation
    }
    
    private func formatBullet() {
        // Format bullet list implementation
        // This would apply bullet list formatting to the selected text
        // For now, this is a placeholder for the actual implementation
    }
    
    private func formatNumbered() {
        // Format numbered list implementation
        // This would apply numbered list formatting to the selected text
        // For now, this is a placeholder for the actual implementation
    }
}

// MARK: - Format Button

/// Button for text formatting
public struct FormatButton: View {
    let title: String
    let action: () -> Void
    
    public var body: some View {
        Button(title, action: action)
            .font(.system(.body, design: .monospaced))
            .frame(width: 32, height: 32)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(4)
    }
}

// MARK: - Rich Text Preview

/// Preview of rich text content
public struct RichTextPreview: View {
    let text: String
    
    public var body: some View {
        ScrollView {
            Text(text)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Autocomplete Field

/// Autocomplete text field with suggestions
public struct AutocompleteField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    let suggestions: [String]
    
    @State private var text: String = ""
    @State private var showSuggestions = false
    @State private var filteredSuggestions: [String] = []
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField(field.placeholder ?? field.label, text: $text)
                .textFieldStyle(.roundedBorder)
                .accessibilityLabel("Autocomplete field for \(field.label)")
                .accessibilityHint("Type to search and select from suggestions")
                .onChange(of: text) { newValue in
                    filterSuggestions(query: newValue)
                    formState.setValue(newValue, for: field.id)
                }
                .onAppear {
                    text = formState.getValue(for: field.id) ?? ""
                }
            
            if showSuggestions && !filteredSuggestions.isEmpty {
                AutocompleteSuggestions(
                    suggestions: filteredSuggestions,
                    onSelect: { suggestion in
                        text = suggestion
                        formState.setValue(suggestion, for: field.id)
                        showSuggestions = false
                    }
                )
            }
        }
    }
    
    private func filterSuggestions(query: String) {
        if query.isEmpty {
            filteredSuggestions = []
            showSuggestions = false
        } else {
            // Enhanced filtering with better matching
            filteredSuggestions = suggestions.filter { suggestion in
                suggestion.localizedCaseInsensitiveContains(query) ||
                suggestion.lowercased().hasPrefix(query.lowercased())
            }
            .sorted { suggestion1, suggestion2 in
                // Prioritize exact matches and prefix matches
                let queryLower = query.lowercased()
                let s1Lower = suggestion1.lowercased()
                let s2Lower = suggestion2.lowercased()
                
                if s1Lower.hasPrefix(queryLower) && !s2Lower.hasPrefix(queryLower) {
                    return true
                } else if !s1Lower.hasPrefix(queryLower) && s2Lower.hasPrefix(queryLower) {
                    return false
                } else {
                    return suggestion1 < suggestion2
                }
            }
            showSuggestions = !filteredSuggestions.isEmpty
        }
    }
}

// MARK: - Autocomplete Suggestions

/// Display autocomplete suggestions
public struct AutocompleteSuggestions: View {
    let suggestions: [String]
    let onSelect: (String) -> Void
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(suggestions, id: \.self) { suggestion in
                Button(action: { onSelect(suggestion) }) {
                    Text(suggestion)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
                .background(Color.secondaryBackground)
                
                if suggestion != suggestions.last {
                    Divider()
                }
            }
        }
        .background(Color.secondaryBackground)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

// MARK: - Enhanced File Upload Field

/// Enhanced file upload field with drag & drop support
public struct EnhancedFileUploadField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    let allowedTypes: [UTType]
    let maxFileSize: Int64? // in bytes
    
    @State private var isDragOver = false
    @State private var selectedFiles: [FileInfo] = []
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(field.label)
                .font(.headline)
            
            FileUploadArea(
                isDragOver: $isDragOver,
                selectedFiles: $selectedFiles,
                allowedTypes: allowedTypes,
                maxFileSize: maxFileSize,
                onFilesSelected: { files in
                    selectedFiles = files
                    updateFormState()
                }
            )
            
            if !selectedFiles.isEmpty {
                FileList(files: selectedFiles) { file in
                    selectedFiles.removeAll { $0.id == file.id }
                    updateFormState()
                }
            }
        }
    }
    
    private func updateFormState() {
        let fileData = selectedFiles.map { file in
            [
                "name": file.name,
                "size": file.size,
                "type": file.type.identifier,
                "url": file.url?.absoluteString ?? ""
            ]
        }
        formState.setValue(fileData, for: field.id)
    }
}

// MARK: - File Upload Area

/// Drag & drop file upload area
public struct FileUploadArea: View {
    @Binding var isDragOver: Bool
    @Binding var selectedFiles: [FileInfo]
    let allowedTypes: [UTType]
    let maxFileSize: Int64?
    let onFilesSelected: ([FileInfo]) -> Void
    
    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.badge.plus")
                .font(.system(size: 48))
                .foregroundColor(.accentColor)
            
            Text("Drag & drop files here")
                .font(.headline)
            
            Text("or")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button("Browse Files") {
                selectFiles()
            }
            .buttonStyle(.borderedProminent)
            
            Text("Supported types: \(allowedTypes.compactMap { $0.localizedDescription }.joined(separator: ", "))")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if let maxSize = maxFileSize {
                Text("Max file size: \(ByteCountFormatter.string(fromByteCount: maxSize, countStyle: .file))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, minHeight: 200)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isDragOver ? Color.accentColor.opacity(0.1) : Color.secondaryBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isDragOver ? Color.accentColor : Color.platformSeparator, lineWidth: 2)
        )
        .onDrop(of: allowedTypes.map { $0.identifier }, isTargeted: $isDragOver) { providers in
            handleDrop(providers: providers)
            return true
        }
        .accessibilityLabel("File upload area")
        .accessibilityHint("Drag and drop files here or tap to browse")
    }
    
    private func selectFiles() {
        // File picker implementation
        // This would integrate with the system file picker
        // For now, this is a placeholder for the actual implementation
        #if os(iOS)
        // iOS file picker implementation would go here
        #elseif os(macOS)
        // macOS file picker implementation would go here
        #endif
    }
    
    private func handleDrop(providers: [NSItemProvider]) {
        // Handle dropped files
        // This would process the dropped file providers
        // For now, this is a placeholder for the actual implementation
        var newFiles: [FileInfo] = []
        
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                // Handle image files
                provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { item, error in
                    if let url = item as? URL {
                        Task { @MainActor in
                            let fileInfo = FileInfo(
                                name: url.lastPathComponent,
                                size: Int64((try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0),
                                type: UTType.image,
                                url: url
                            )
                            newFiles.append(fileInfo)
                        }
                    }
                }
            } else if provider.hasItemConformingToTypeIdentifier(UTType.pdf.identifier) {
                // Handle PDF files
                provider.loadItem(forTypeIdentifier: UTType.pdf.identifier, options: nil) { item, error in
                    if let url = item as? URL {
                        Task { @MainActor in
                            let fileInfo = FileInfo(
                                name: url.lastPathComponent,
                                size: Int64((try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0),
                                type: UTType.pdf,
                                url: url
                            )
                            newFiles.append(fileInfo)
                        }
                    }
                }
            }
        }
        
        if !newFiles.isEmpty {
            onFilesSelected(newFiles)
        }
    }
}

// MARK: - File Info

/// Information about a selected file
public struct FileInfo: Identifiable, Sendable {
    public let id = UUID()
    public let name: String
    public let size: Int64
    public let type: UTType
    public let url: URL?
    
    public init(name: String, size: Int64, type: UTType, url: URL?) {
        self.name = name
        self.size = size
        self.type = type
        self.url = url
    }
}

// MARK: - File List

/// Display list of selected files
public struct FileList: View {
    let files: [FileInfo]
    let onRemove: (FileInfo) -> Void
    
    public var body: some View {
        VStack(spacing: 8) {
            ForEach(files) { file in
                FileRow(file: file, onRemove: onRemove)
            }
        }
    }
}

// MARK: - File Row

/// Individual file row in the file list
public struct FileRow: View {
    let file: FileInfo
    let onRemove: (FileInfo) -> Void
    
    public var body: some View {
        HStack {
            Image(systemName: "doc")
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(file.name)
                    .font(.subheadline)
                    .lineLimit(1)
                
                Text("\(ByteCountFormatter.string(fromByteCount: file.size, countStyle: .file)) • \(file.type.localizedDescription ?? "Unknown")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: { onRemove(file) }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
        .padding(8)
        .background(Color.tertiaryBackground)
        .cornerRadius(6)
    }
}

// MARK: - Date Picker Field

/// Date picker field for selecting dates
public struct DatePickerField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    @State private var selectedDate = Date()
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(field.label)
                .font(.headline)
            
            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .selfLabelingControl(label: field.label)
            .onChange(of: selectedDate) { newDate in
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formState.setValue(formatter.string(from: newDate), for: field.id)
            }
            .onAppear {
                // Load existing value if available
                if let existingValue: String = formState.getValue(for: field.id) {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    if let date = formatter.date(from: existingValue) {
                        selectedDate = date
                    }
                }
            }
        }
    }
}

// MARK: - Time Picker Field

/// Time picker field for selecting times
public struct TimePickerField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    @State private var selectedTime = Date()
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(field.label)
                .font(.headline)
            
            DatePicker(
                "",
                selection: $selectedTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.compact)
            .selfLabelingControl(label: field.label)
            .onChange(of: selectedTime) { newTime in
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                formState.setValue(formatter.string(from: newTime), for: field.id)
            }
            .onAppear {
                // Load existing value if available
                if let existingValue: String = formState.getValue(for: field.id) {
                    let formatter = DateFormatter()
                    formatter.timeStyle = .short
                    if let time = formatter.date(from: existingValue) {
                        selectedTime = time
                    }
                }
            }
        }
    }
}

// MARK: - Date Time Picker Field

/// Date and time picker field for selecting both date and time
public struct DateTimePickerField: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    @State private var selectedDateTime = Date()
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(field.label)
                .font(.headline)
            
            DatePicker(
                "",
                selection: $selectedDateTime,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.compact)
            .selfLabelingControl(label: field.label)
            .onChange(of: selectedDateTime) { newDateTime in
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                formState.setValue(formatter.string(from: newDateTime), for: field.id)
            }
            .onAppear {
                // Load existing value if available
                if let existingValue: String = formState.getValue(for: field.id) {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .short
                    if let dateTime = formatter.date(from: existingValue) {
                        selectedDateTime = dateTime
                    }
                }
            }
        }
    }
}

// MARK: - Custom Field View

/// Custom field view that uses the registry to find appropriate components
public struct CustomFieldView: View {
    let field: DynamicFormField
    @ObservedObject var formState: DynamicFormState
    
    public var body: some View {
        // For now, fallback to a basic text field for custom types
        // The registry system will be enhanced in future iterations
        TextField(field.placeholder ?? field.label, text: Binding(
            get: { formState.getValue(for: field.id) ?? "" },
            set: { formState.setValue($0, for: field.id) }
        ))
        .textFieldStyle(.roundedBorder)
    }
}

// MARK: - Custom Field Component Protocol

/// Protocol for custom field components
public protocol CustomFieldComponent: View {
    var field: DynamicFormField { get }
    var formState: DynamicFormState { get }
}

// MARK: - Custom Field Registry

/// Registry for custom field components
@MainActor
public class CustomFieldRegistry: ObservableObject, @unchecked Sendable {
    @MainActor
    public static let shared = CustomFieldRegistry()
    
    private var customFields: [String: any CustomFieldComponent.Type] = [:]
    
    private init() {}
    
        func register<T: CustomFieldComponent>(_ fieldType: String, component: T.Type) {
        customFields[fieldType] = component
    }
    
        func getComponent(for fieldType: String) -> (any CustomFieldComponent.Type)? {
        return customFields[fieldType]
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        RichTextEditorField(
            field: DynamicFormField(
                id: "richText",
                contentType: .richtext,
                label: "Rich Text Content",
                placeholder: "Enter rich text content"
            ),
            formState: DynamicFormState(configuration: DynamicFormConfiguration(
                id: "preview",
                title: "Preview Form",
                description: "Preview form for testing",
                sections: [],
                submitButtonText: "Submit",
                cancelButtonText: "Cancel"
            ))
        )
        
        AutocompleteField(
            field: DynamicFormField(
                id: "autocomplete",
                contentType: .autocomplete,
                label: "Search",
                placeholder: "Type to search..."
            ),
            formState: DynamicFormState(configuration: DynamicFormConfiguration(
                id: "preview",
                title: "Preview Form",
                description: "Preview form for testing",
                sections: [],
                submitButtonText: "Submit",
                cancelButtonText: "Cancel"
            )),
            suggestions: ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
        )
        
        EnhancedFileUploadField(
            field: DynamicFormField(
                id: "files",
                contentType: .file,
                label: "Upload Files",
                placeholder: "Select files to upload"
            ),
            formState: DynamicFormState(configuration: DynamicFormConfiguration(
                id: "preview",
                title: "Preview Form",
                description: "Preview form for testing",
                sections: [],
                submitButtonText: "Submit",
                cancelButtonText: "Cancel"
            )),
            allowedTypes: [.image, .pdf, .text],
            maxFileSize: 10 * 1024 * 1024 // 10MB
        )
    }
    .padding()
}
