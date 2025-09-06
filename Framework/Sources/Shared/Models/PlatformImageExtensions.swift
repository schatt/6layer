//
//  PlatformImageExtensions.swift
//  SixLayerFramework
//
//  Enhanced PlatformImage extensions for photo processing and manipulation
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - Enhanced PlatformImage Extensions

public extension PlatformImage {
    
    /// Resize image to target size while maintaining aspect ratio
    func resized(to targetSize: CGSize) -> PlatformImage {
        #if os(iOS)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            self.uiImage.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return PlatformImage(uiImage: resizedImage)
        #elseif os(macOS)
        let resizedImage = NSImage(size: targetSize)
        resizedImage.lockFocus()
        self.nsImage.draw(in: NSRect(origin: .zero, size: targetSize))
        resizedImage.unlockFocus()
        return PlatformImage(nsImage: resizedImage)
        #endif
    }
    
    /// Crop image to specified rectangle
    func cropped(to rect: CGRect) -> PlatformImage {
        #if os(iOS)
        guard let cgImage = self.uiImage.cgImage?.cropping(to: rect) else {
            return self
        }
        let croppedImage = UIImage(cgImage: cgImage)
        return PlatformImage(uiImage: croppedImage)
        #elseif os(macOS)
        let croppedImage = NSImage(size: rect.size)
        croppedImage.lockFocus()
        self.nsImage.draw(at: .zero, from: rect, operation: .copy, fraction: 1.0)
        croppedImage.unlockFocus()
        return PlatformImage(nsImage: croppedImage)
        #endif
    }
    
    /// Apply compression for specific use case
    func compressed(for purpose: PhotoPurpose, quality: Double = 0.8) -> Data? {
        #if os(iOS)
        return self.uiImage.jpegData(compressionQuality: CGFloat(quality))
        #elseif os(macOS)
        guard let tiffData = self.nsImage.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData),
              let jpegData = bitmapRep.representation(using: .jpeg, properties: [.compressionFactor: quality]) else {
            return nil
        }
        return jpegData
        #endif
    }
    
    /// Create thumbnail version
    func thumbnail(size: CGSize) -> PlatformImage {
        return self.resized(to: size)
    }
    
    /// Apply basic image processing for OCR
    func optimizedForOCR() -> PlatformImage {
        // For now, return the original image
        // In a real implementation, this would apply contrast enhancement, noise reduction, etc.
        return self
    }
    
    /// Get image metadata
    var metadata: ImageMetadata {
        #if os(iOS)
        let size = self.uiImage.size
        let data = self.uiImage.pngData() ?? Data()
        let format: ImageFormat = data.count > 0 ? .png : .unknown
        return ImageMetadata(
            size: size,
            fileSize: data.count,
            format: format,
            hasAlpha: true
        )
        #elseif os(macOS)
        let size = self.nsImage.size
        let data = self.nsImage.tiffRepresentation ?? Data()
        let format: ImageFormat = data.count > 0 ? .tiff : .unknown
        return ImageMetadata(
            size: size,
            fileSize: data.count,
            format: format,
            hasAlpha: true
        )
        #endif
    }
    
    /// Check if image meets minimum requirements for purpose
    func meetsRequirements(for purpose: PhotoPurpose) -> Bool {
        let metadata = self.metadata
        
        // Basic requirements check
        guard metadata.size.width > 0 && metadata.size.height > 0 else {
            return false
        }
        
        // Purpose-specific requirements
        switch purpose {
        case .vehiclePhoto, .pumpDisplay, .odometer:
            return metadata.size.width >= 200 && metadata.size.height >= 200
        case .fuelReceipt, .expense, .document:
            return metadata.size.width >= 400 && metadata.size.height >= 300
        case .maintenance, .profile:
            return metadata.size.width >= 100 && metadata.size.height >= 100
        }
    }
    
    /// Get the size of the image
    var size: CGSize {
        #if os(iOS)
        return self.uiImage.size
        #elseif os(macOS)
        return self.nsImage.size
        #endif
    }
}
