import SwiftUI

#if os(iOS) && canImport(PhotosUI)
import PhotosUI
#endif

/// Layer 4: Component - Platform Photo Components
///
/// This layer provides platform-aware UI components specifically designed for displaying and interacting with photos.
/// It encapsulates the logic for rendering images, handling gestures (e.g., zoom, pan), and integrating
/// with platform-native photo libraries and image pickers.
///
/// The tests for this component need to be improved to verify:
/// - Correct display of images across different platforms and aspect ratios.
/// - Responsive handling of user gestures for image manipulation.
/// - Seamless integration with platform photo services.
/// - Accessibility features for image content and interactions.
@MainActor
public enum PlatformPhotoComponentsLayer4 {
    
    // MARK: - Camera Interface Components
    
    /// Creates a platform-specific camera interface
    @ViewBuilder
    public static func platformCameraInterface_L4(onImageCaptured: @escaping (PlatformImage) -> Void) -> some View {
        #if os(iOS)
        CameraView(onImageCaptured: onImageCaptured)
            .automaticCompliance()
        #elseif os(macOS)
        MacCameraView(onImageCaptured: onImageCaptured)
            .automaticCompliance()
        #else
        Text("Camera not available on this platform")
            .automaticCompliance()
        #endif
    }
    
    // MARK: - Photo Picker Components
    
    /// Creates a unified cross-platform photo picker
    /// Uses the same API on both iOS and macOS, returning PlatformImage consistently
    @ViewBuilder
    public static func platformPhotoPicker_L4(onImageSelected: @escaping (PlatformImage) -> Void) -> some View {
        UnifiedImagePicker(onImageSelected: onImageSelected)
            .automaticCompliance()
    }
    
    // MARK: - Photo Display Components
    
    /// Creates a platform-specific photo display
    @ViewBuilder
    public static func platformPhotoDisplay_L4(image: PlatformImage?, style: PhotoDisplayStyle) -> some View {
        Group {
            if let image = image {
                PhotoDisplayView(image: image, style: style)
            } else {
                PlaceholderPhotoView(style: style)
            }
        }
        .automaticCompliance(named: "platformPhotoDisplay_L4")
    }
}

// MARK: - Supporting Views

#if os(iOS)
import UIKit

public struct CameraView: UIViewControllerRepresentable {
    let onImageCaptured: (PlatformImage) -> Void
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImageCaptured(PlatformImage(image))  // Implicit conversion: UIImage → PlatformImage
            }
            picker.dismiss(animated: true)
        }
    }
}

public struct PhotoPickerView: View {
    let onImageSelected: (PlatformImage) -> Void
    
    public var body: some View {
        if #available(iOS 14.0, *) {
            ModernPhotoPickerView(onImageSelected: onImageSelected)
        } else {
            LegacyPhotoPickerView(onImageSelected: onImageSelected)
        }
    }
    .automaticCompliance(named: "PhotoPickerView")
}

// MARK: - Modern PHPickerViewController Implementation (iOS 14+)

@available(iOS 14.0, *)
private struct ModernPhotoPickerView: UIViewControllerRepresentable {
    let onImageSelected: (PlatformImage) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> ModernPhotoCoordinator {
        ModernPhotoCoordinator(self)
    }
    
    class ModernPhotoCoordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ModernPhotoPickerView
        
        init(_ parent: ModernPhotoPickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let result = results.first else {
                return
            }
            
            // Load the image from the result
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                    // Capture the UIImage before crossing concurrency boundary
                    guard let uiImage = object as? UIImage else {
                        return
                    }
                    Task { @MainActor in
                        guard let self = self else {
                            return
                        }
                        // System boundary conversion: UIImage → PlatformImage
                        let platformImage = PlatformImage(uiImage)
                        self.parent.onImageSelected(platformImage)
                    }
                }
            }
        }
    }
}

// MARK: - Legacy UIImagePickerController Implementation (iOS 13)

struct LegacyPhotoPickerView: UIViewControllerRepresentable {
    let onImageSelected: (PlatformImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> LegacyPhotoCoordinator {
        LegacyPhotoCoordinator(self)
    }
    
    class LegacyPhotoCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: LegacyPhotoPickerView
        
        init(_ parent: LegacyPhotoPickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImageSelected(PlatformImage(image))  // Implicit conversion: UIImage → PlatformImage
            }
            picker.dismiss(animated: true)
        }
    }
}

#elseif os(macOS)
import AppKit

public struct MacCameraView: NSViewControllerRepresentable {
    let onImageCaptured: (PlatformImage) -> Void
    
    public func makeNSViewController(context: Context) -> NSViewController {
        let controller = NSViewController()
        let button = NSButton(title: "Take Photo", target: context.coordinator, action: #selector(Coordinator.takePhoto))
        controller.view = button
        return controller
    }
    
    public func updateNSViewController(_ nsViewController: NSViewController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject {
        let parent: MacCameraView
        
        init(_ parent: MacCameraView) {
            self.parent = parent
        }
        
        @MainActor
        @objc func takePhoto() {
            // Stub implementation - would integrate with macOS camera APIs
            let image = PlatformImage.createPlaceholder()
            parent.onImageCaptured(image)
        }
    }
}

public struct MacPhotoPickerView: NSViewControllerRepresentable {
    let onImageSelected: (PlatformImage) -> Void
    
    public func makeNSViewController(context: Context) -> NSViewController {
        let controller = NSViewController()
        let button = NSButton(title: "Choose Photo", target: context.coordinator, action: #selector(Coordinator.choosePhoto))
        controller.view = button
        return controller
    }
    
    public func updateNSViewController(_ nsViewController: NSViewController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, @unchecked Sendable {
        let parent: MacPhotoPickerView
        
        init(_ parent: MacPhotoPickerView) {
            self.parent = parent
        }
        
        @MainActor
        @objc func choosePhoto() {
            // Stub implementation - would integrate with macOS photo picker APIs
            let image = PlatformImage.createPlaceholder()
            parent.onImageSelected(image)
        }
    }
}
#endif

// MARK: - Photo Display Views

struct PhotoDisplayView: View {
    let image: PlatformImage
    let style: PhotoDisplayStyle
    
    var body: some View {
        Image(platformImage: image)
            .resizable()
            .aspectRatio(contentMode: aspectRatioForStyle(style))
            .clipShape(clipShapeForStyle(style))
            .automaticCompliance(named: "PhotoDisplayView")
    }
    
    private func aspectRatioForStyle(_ style: PhotoDisplayStyle) -> ContentMode {
        switch style {
        case .aspectFit, .aspectFill:
            return .fit
        case .fullSize, .thumbnail, .rounded:
            return .fill
        }
    }
    
    private func clipShapeForStyle(_ style: PhotoDisplayStyle) -> AnyShape {
        switch style {
        case .rounded:
            return AnyShape(Circle())
        case .aspectFit, .aspectFill, .fullSize, .thumbnail:
            return AnyShape(Rectangle())
        }
    }
}

struct PlaceholderPhotoView: View {
    let style: PhotoDisplayStyle
    
    var body: some View {
        VStack {
            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("No Image")
                .foregroundColor(.secondary)
        }
        .frame(width: sizeForStyle(style).width, height: sizeForStyle(style).height)
        .background(Color.gray.opacity(0.1))
        .clipShape(clipShapeForStyle(style))
        .automaticCompliance(named: "PlaceholderPhotoView")
    }
    
    private func sizeForStyle(_ style: PhotoDisplayStyle) -> CGSize {
        switch style {
        case .thumbnail:
            return CGSize(width: 100, height: 100)
        case .fullSize:
            return CGSize(width: 300, height: 200)
        case .aspectFit, .aspectFill, .rounded:
            return CGSize(width: 200, height: 200)
        }
    }
    
    private func clipShapeForStyle(_ style: PhotoDisplayStyle) -> AnyShape {
        switch style {
        case .rounded:
            return AnyShape(Circle())
        case .aspectFit, .aspectFill, .fullSize, .thumbnail:
            return AnyShape(Rectangle())
        }
    }
}

// MARK: - Supporting Types

struct AnyShape: Shape, @unchecked Sendable {
    private let _path: (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        _path = shape.path(in:)
    }
    
    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }
}

// MARK: - Convenience Functions (Global)

/// Creates a platform-specific photo picker (convenience wrapper)
@ViewBuilder
@MainActor
public func platformPhotoPicker_L4(onImageSelected: @escaping (PlatformImage) -> Void) -> some View {
    PlatformPhotoComponentsLayer4.platformPhotoPicker_L4(onImageSelected: onImageSelected)
}

/// Creates a platform-specific camera interface (convenience wrapper)
@ViewBuilder
@MainActor
public func platformCameraInterface_L4(onImageCaptured: @escaping (PlatformImage) -> Void) -> some View {
    PlatformPhotoComponentsLayer4.platformCameraInterface_L4(onImageCaptured: onImageCaptured)
}

/// Creates a platform-specific photo display (convenience wrapper)
@ViewBuilder
@MainActor
public func platformPhotoDisplay_L4(image: PlatformImage?, style: PhotoDisplayStyle) -> some View {
    PlatformPhotoComponentsLayer4.platformPhotoDisplay_L4(image: image, style: style)
}
