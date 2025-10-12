//
//  PlatformPhotoComponentsLayer4.swift
//  SixLayerFramework
//
//  Layer 4: Photo Component Implementation
//  Cross-platform photo capture, selection, display, and editing components
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - Layer 4: Photo Component Implementation

/// Cross-platform camera interface implementation
public func platformCameraInterface_L4(
    onImageCaptured: @escaping (PlatformImage) -> Void
) -> some View {
    #if os(iOS)
    return CameraView(onImageCaptured: onImageCaptured)
        .automaticAccessibilityIdentifiers()
    #elseif os(macOS)
    return MacOSCameraView(onImageCaptured: onImageCaptured)
        .automaticAccessibilityIdentifiers()
    #else
    return Text("Camera not available")
        .foregroundColor(.secondary)
        .automaticAccessibilityIdentifiers()
    #endif
}

/// Cross-platform photo picker implementation
public func platformPhotoPicker_L4(
    onImageSelected: @escaping (PlatformImage) -> Void
) -> some View {
    #if os(iOS)
    return PhotoPickerView(onImageSelected: onImageSelected)
        .automaticAccessibilityIdentifiers()
    #elseif os(macOS)
    return MacOSPhotoPickerView(onImageSelected: onImageSelected)
        .automaticAccessibilityIdentifiers()
    #else
    return Text("Photo picker not available")
        .foregroundColor(.secondary)
        .automaticAccessibilityIdentifiers()
    #endif
}

/// Cross-platform photo display component
public func platformPhotoDisplay_L4(
    image: PlatformImage?,
    style: PhotoDisplayStyle
) -> some View {
    Group {
        if let image = image {
            PhotoDisplayView(image: image, style: style)
        } else {
            PhotoPlaceholderView(style: style)
        }
    }
    .automaticAccessibilityIdentifiers()
}

/// Cross-platform photo editing interface
public func platformPhotoEditor_L4(
    image: PlatformImage,
    onImageEdited: @escaping (PlatformImage) -> Void
) -> some View {
    #if os(iOS)
    return PhotoEditorView(image: image, onImageEdited: onImageEdited)
        .automaticAccessibilityIdentifiers()
    #elseif os(macOS)
    return MacOSPhotoEditorView(image: image, onImageEdited: onImageEdited)
        .automaticAccessibilityIdentifiers()
    #else
    return Text("Photo editor not available")
        .foregroundColor(.secondary)
        .automaticAccessibilityIdentifiers()
    #endif
}

// MARK: - iOS Camera View

#if os(iOS)
struct CameraView: UIViewControllerRepresentable {
    let onImageCaptured: (PlatformImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No updates needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                let platformImage = PlatformImage(data: uiImage.pngData()!)!
                parent.onImageCaptured(platformImage)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
#endif

// MARK: - macOS Camera View

#if os(macOS)
import AVFoundation
import AppKit

struct MacOSCameraView: NSViewControllerRepresentable {
    let onImageCaptured: (PlatformImage) -> Void
    
    func makeNSViewController(context: Context) -> NSViewController {
        let controller = CameraViewController()
        controller.onImageCaptured = onImageCaptured
        return controller
    }
    
    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        // No updates needed
    }
}

class CameraViewController: NSViewController {
    var onImageCaptured: ((PlatformImage) -> Void)?
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var photoOutput: AVCapturePhotoOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupUI()
        
        // Apply accessibility identifier to the view controller's view
        view.setAccessibilityIdentifier("SixLayer.camera.interface")
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        previewLayer?.frame = view.bounds
    }
    
    private func setupCamera() {
        captureSession = AVCaptureSession()
        
        // Check camera permission
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.configureCamera()
                    } else {
                        self?.showError("Camera access denied")
                    }
                }
            }
        case .denied, .restricted:
            showError("Camera access denied")
        @unknown default:
            showError("Unknown camera authorization status")
        }
    }
    
    private func configureCamera() {
        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            showError("Camera not available")
            return
        }
        
        captureSession?.addInput(input)
        
        photoOutput = AVCapturePhotoOutput()
        captureSession?.addOutput(photoOutput!)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = view.bounds
        view.layer?.addSublayer(previewLayer!)
        
        captureSession?.startRunning()
    }
    
    private func setupUI() {
        let captureButton = NSButton(title: "Capture Photo", target: self, action: #selector(capturePhoto))
        captureButton.bezelStyle = .rounded
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(captureButton)
        
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    private func showError(_ message: String) {
        let alert = NSAlert()
        alert.messageText = "Camera Error"
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    deinit {
        captureSession?.stopRunning()
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let nsImage = NSImage(data: imageData) else { return }
        
        let platformImage = PlatformImage(nsImage: nsImage)
        onImageCaptured?(platformImage)
    }
}
#endif

#if os(iOS)
struct PhotoPickerView: UIViewControllerRepresentable {
    let onImageSelected: (PlatformImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No updates needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: PhotoPickerView
        
        init(_ parent: PhotoPickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                let platformImage = PlatformImage(data: uiImage.pngData()!)!
                parent.onImageSelected(platformImage)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
#endif

// MARK: - macOS Photo Picker View

#if os(macOS)
struct MacOSPhotoPickerView: View {
    let onImageSelected: (PlatformImage) -> Void
    @State private var showingFileImporter = false
    @State private var showingLegacyPicker = false

    var body: some View {
        if #available(macOS 11.0, *) {
            // Use SwiftUI's native fileImporter for modern macOS
            Button("Select Image") {
                showingFileImporter = true
            }
            .fileImporter(
                isPresented: $showingFileImporter,
                allowedContentTypes: [.image],
                allowsMultipleSelection: false
            ) { result in
                handleFileSelection(result)
            }
        } else {
            // Fallback for older macOS versions using NSViewControllerRepresentable
            LegacyMacOSPhotoPickerView(onImageSelected: onImageSelected)
        }
    }

    private func handleFileSelection(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            if let url = urls.first {
                loadImageFromURL(url)
            }
        case .failure(let error):
            print("Error selecting image: \(error.localizedDescription)")
        }
    }

    private func loadImageFromURL(_ url: URL) {
        do {
            let imageData = try Data(contentsOf: url)
            if let platformImage = PlatformImage(data: imageData) {
                onImageSelected(platformImage)
            }
        } catch {
            print("Error loading image: \(error.localizedDescription)")
        }
    }
}

// MARK: - Legacy macOS Photo Picker (for older macOS versions)

@available(macOS, deprecated: 11.0, message: "Use SwiftUI's fileImporter instead")
struct LegacyMacOSPhotoPickerView: NSViewControllerRepresentable {
    let onImageSelected: (PlatformImage) -> Void

    func makeNSViewController(context: Context) -> NSViewController {
        let controller = NSViewController()

        let button = NSButton(title: "Select Photo", target: context.coordinator, action: #selector(Coordinator.selectPhoto))
        button.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor)
        ])

        return controller
    }

    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        // No updates needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        let parent: LegacyMacOSPhotoPickerView

        init(_ parent: LegacyMacOSPhotoPickerView) {
            self.parent = parent
        }

        @objc func selectPhoto() {
            let panel = NSOpenPanel()
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = false
            panel.canChooseFiles = true
            panel.allowedContentTypes = [.image]

            // Use beginSheetModal instead of runModal to avoid blocking the main thread
            if let window = NSApplication.shared.keyWindow {
                panel.beginSheetModal(for: window) { response in
                    if response == .OK, let url = panel.url {
                        if let data = try? Data(contentsOf: url),
                           let platformImage = PlatformImage(data: data) {
                            self.parent.onImageSelected(platformImage)
                        }
                    }
                }
            } else {
                // Fallback to runModal only if no key window is available
                let response = panel.runModal()
                if response == .OK, let url = panel.url {
                    if let data = try? Data(contentsOf: url),
                       let platformImage = PlatformImage(data: data) {
                        parent.onImageSelected(platformImage)
                    }
                }
            }
        }
    }
}
#endif

// MARK: - Photo Display View

struct PhotoDisplayView: View {
    let image: PlatformImage
    let style: PhotoDisplayStyle
    
    var body: some View {
        #if os(iOS)
        Image(uiImage: image.uiImage)
            .resizable()
            .aspectRatio(contentMode: style.aspectRatio)
            .frame(maxWidth: style.maxWidth, maxHeight: style.maxHeight)
            .clipShape(style.clipShape)
        #elseif os(macOS)
        Image(nsImage: image.nsImage)
            .resizable()
            .aspectRatio(contentMode: style.aspectRatio)
            .frame(maxWidth: style.maxWidth, maxHeight: style.maxHeight)
            .clipShape(style.clipShape)
        #else
        Text("Image display not available")
            .foregroundColor(.secondary)
        #endif
    }
}

// MARK: - Photo Placeholder View

struct PhotoPlaceholderView: View {
    let style: PhotoDisplayStyle
    
    var body: some View {
        Rectangle()
            .fill(Color.platformSystemGray6)
            .frame(width: style.maxWidth, height: style.maxHeight)
            .overlay(
                Image(systemName: "photo")
                    .foregroundColor(.secondary)
                    .font(.largeTitle)
            )
            .clipShape(style.clipShape)
    }
}

// MARK: - iOS Photo Editor View

#if os(iOS)
struct PhotoEditorView: UIViewControllerRepresentable {
    let image: PlatformImage
    let onImageEdited: (PlatformImage) -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        // For now, return a simple view controller
        // In a real implementation, this would use a proper photo editing library
        let controller = UIViewController()
        let imageView = UIImageView(image: image.uiImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed
    }
}
#endif

// MARK: - macOS Photo Editor View

#if os(macOS)
struct MacOSPhotoEditorView: NSViewControllerRepresentable {
    let image: PlatformImage
    let onImageEdited: (PlatformImage) -> Void
    
    func makeNSViewController(context: Context) -> NSViewController {
        let controller = NSViewController()
        let imageView = NSImageView(image: image.nsImage)
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: controller.view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor)
        ])
        
        return controller
    }
    
    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        // No updates needed
    }
}
#endif

// MARK: - Photo Display Style Extensions

private extension PhotoDisplayStyle {
    var aspectRatio: ContentMode {
        switch self {
        case .thumbnail, .fullSize, .aspectFit:
            return .fit
        case .aspectFill:
            return .fill
        case .rounded:
            return .fit
        }
    }
    
    var maxWidth: CGFloat? {
        switch self {
        case .thumbnail:
            return 100
        case .fullSize:
            return nil
        case .aspectFit, .aspectFill, .rounded:
            return 300
        }
    }
    
    var maxHeight: CGFloat? {
        switch self {
        case .thumbnail:
            return 100
        case .fullSize:
            return nil
        case .aspectFit, .aspectFill, .rounded:
            return 300
        }
    }
    
    var clipShape: AnyShape {
        switch self {
        case .thumbnail, .fullSize, .aspectFit, .aspectFill:
            return AnyShape(Rectangle())
        case .rounded:
            return AnyShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

// MARK: - AnyShape Helper

struct AnyShape: Shape {
    private let _path: @Sendable (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        _path = { rect in
            shape.path(in: rect)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }
}
