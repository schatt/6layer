//
//  PlatformImagePhase3Examples.swift
//  SixLayerFramework
//
//  Example code demonstrating PlatformImage Phase 3 features
//  Implements GitHub Issue #33: Add PlatformImage export and processing methods
//
//  These examples show practical usage of:
//  - Export methods (PNG, JPEG, Bitmap)
//  - Image processing (resize, crop, rotate, color adjustments, filters)
//  - Metadata extraction
//

import Foundation
import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - Export Examples

/// Examples demonstrating image export to various formats
struct ImageExportExamples {
    
    /// Export image to different formats
    static func exportToAllFormats(_ image: PlatformImage) {
        // Export to PNG (lossless)
        if let pngData = image.exportPNG() {
            print("PNG data size: \(pngData.count) bytes")
        }
        
        // Export to JPEG with default quality
        if let jpegData = image.exportJPEG() {
            print("JPEG data size: \(jpegData.count) bytes")
        }
        
        // Export to JPEG with custom quality
        if let highQualityJPEG = image.exportJPEG(quality: 1.0) {
            print("High quality JPEG: \(highQualityJPEG.count) bytes")
        }
        
        // Export to bitmap
        if let bitmapData = image.exportBitmap() {
            print("Bitmap data size: \(bitmapData.count) bytes")
        }
    }
    
    /// Export with quality optimization based on use case
    static func exportForUseCase(_ image: PlatformImage, useCase: ExportUseCase) -> Data? {
        switch useCase {
        case .photo:
            return image.exportJPEG(quality: 0.9)
        case .thumbnail:
            let thumbnail = image.resized(to: CGSize(width: 150, height: 150))
            return thumbnail.exportJPEG(quality: 0.7)
        case .archive:
            return image.exportPNG()
        case .preview:
            return image.exportJPEG(quality: 0.5)
        }
    }
    
    enum ExportUseCase {
        case photo      // High quality for photos
        case thumbnail  // Lower quality for thumbnails
        case archive    // Lossless for archiving
        case preview    // Low quality for previews
    }
}

// MARK: - Processing Examples

/// Examples demonstrating image processing operations
struct ImageProcessingExamples {
    
    /// Resize image to different sizes
    static func resizeExamples(_ image: PlatformImage) {
        let originalSize = image.size
        print("Original size: \(originalSize)")
        
        // Resize to specific dimensions
        let thumbnail = image.resized(to: CGSize(width: 100, height: 100))
        print("Thumbnail size: \(thumbnail.size)")
        
        // Resize to larger size
        let enlarged = image.resized(to: CGSize(width: 500, height: 500))
        print("Enlarged size: \(enlarged.size)")
        
        // Invalid sizes are handled gracefully
        let invalid = image.resized(to: CGSize(width: -10, height: -10))
        print("Invalid resize result: \(invalid.size)")  // Returns original
    }
    
    /// Crop image to specific regions
    static func cropExamples(_ image: PlatformImage) {
        let imageSize = image.size
        
        // Crop center region
        let centerCrop = CGRect(
            x: imageSize.width * 0.25,
            y: imageSize.height * 0.25,
            width: imageSize.width * 0.5,
            height: imageSize.height * 0.5
        )
        let cropped = image.cropped(to: centerCrop)
        print("Cropped size: \(cropped.size)")
        
        // Invalid crop rectangles are clamped
        let invalidCrop = CGRect(x: -10, y: -10, width: 200, height: 200)
        let safeCropped = image.cropped(to: invalidCrop)
        print("Safe cropped size: \(safeCropped.size)")
    }
    
    /// Rotate images by different angles
    static func rotateExamples(_ image: PlatformImage) {
        let originalSize = image.size
        
        // Rotate 90 degrees (width and height swap)
        let rotated90 = image.rotated(by: 90.0)
        print("90° rotation: \(rotated90.size)")
        
        // Rotate 180 degrees
        let rotated180 = image.rotated(by: 180.0)
        print("180° rotation: \(rotated180.size)")
        
        // Rotate 45 degrees (diagonal)
        let rotated45 = image.rotated(by: 45.0)
        print("45° rotation: \(rotated45.size)")
    }
    
    /// Apply color adjustments
    static func colorAdjustmentExamples(_ image: PlatformImage) {
        // Brightness adjustments
        let brighter = image.adjustedBrightness(by: 0.3)
        let darker = image.adjustedBrightness(by: -0.2)
        
        // Contrast adjustments
        let moreContrast = image.adjustedContrast(by: 1.5)
        let lessContrast = image.adjustedContrast(by: 0.7)
        
        // Saturation adjustments
        let moreSaturated = image.adjustedSaturation(by: 1.3)
        let desaturated = image.adjustedSaturation(by: 0.5)
        
        // Chain adjustments
        let enhanced = image
            .adjustedBrightness(by: 0.1)
            .adjustedContrast(by: 1.2)
            .adjustedSaturation(by: 1.1)
        
        print("Enhanced image size: \(enhanced.size)")
    }
    
    /// Apply visual effect filters
    static func filterExamples(_ image: PlatformImage) {
        // Grayscale filter
        let grayscale = image.applyingFilter(.grayscale)
        
        // Blur filter with different radii
        let lightBlur = image.applyingFilter(.blur(radius: 2.0))
        let mediumBlur = image.applyingFilter(.blur(radius: 5.0))
        let heavyBlur = image.applyingFilter(.blur(radius: 10.0))
        
        // Sepia tone filter
        let sepia = image.applyingFilter(.sepia)
        
        // Chain filters
        let combined = image
            .applyingFilter(.grayscale)
            .applyingFilter(.blur(radius: 3.0))
        
        print("Combined filter size: \(combined.size)")
    }
}

// MARK: - Metadata Examples

/// Examples demonstrating metadata extraction
struct ImageMetadataExamples {
    
    /// Extract and display image properties
    static func displayProperties(_ image: PlatformImage) {
        let properties = image.properties
        
        print("Image Properties:")
        print("  Width: \(properties.width)")
        print("  Height: \(properties.height)")
        print("  Size: \(properties.size)")
        
        if let colorSpace = properties.colorSpace {
            print("  Color Space: \(colorSpace)")
        }
        
        if let pixelFormat = properties.pixelFormat {
            print("  Pixel Format: \(pixelFormat)")
        }
    }
    
    /// Analyze image and recommend export format
    static func recommendFormat(_ image: PlatformImage) -> (format: String, quality: Double) {
        let props = image.properties
        let isLarge = props.width > 2000 || props.height > 2000
        
        if isLarge {
            return ("JPEG", 0.8)  // Compressed for large images
        } else {
            return ("PNG", 1.0)   // Lossless for smaller images
        }
    }
}

// MARK: - Pipeline Examples

/// Examples demonstrating complete image processing pipelines
struct ImagePipelineExamples {
    
    /// Process image through multiple operations
    static func processImage(_ image: PlatformImage) -> PlatformImage {
        // Step 1: Resize to thumbnail
        let thumbnail = image.resized(to: CGSize(width: 200, height: 200))
        
        // Step 2: Enhance colors
        let enhanced = thumbnail
            .adjustedBrightness(by: 0.1)
            .adjustedContrast(by: 1.2)
            .adjustedSaturation(by: 1.1)
        
        // Step 3: Apply filter
        let filtered = enhanced.applyingFilter(.sepia)
        
        return filtered
    }
    
    /// Optimize image for network upload
    static func optimizeForUpload(_ image: PlatformImage, maxDimension: CGFloat = 1920) -> Data? {
        let currentSize = image.size
        let needsResize = currentSize.width > maxDimension || currentSize.height > maxDimension
        
        // Step 1: Resize if too large
        let resized = needsResize
            ? image.resized(to: CGSize(width: maxDimension, height: maxDimension))
            : image
        
        // Step 2: Enhance for web display
        let enhanced = resized
            .adjustedBrightness(by: 0.05)
            .adjustedContrast(by: 1.1)
            .adjustedSaturation(by: 1.05)
        
        // Step 3: Export as JPEG (smaller than PNG)
        return enhanced.exportJPEG(quality: 0.85)
    }
    
    /// Generate thumbnail with consistent quality
    static func generateThumbnail(_ image: PlatformImage, size: CGSize = CGSize(width: 150, height: 150)) -> Data? {
        let thumbnail = image.resized(to: size)
        return thumbnail.exportJPEG(quality: 0.7)
    }
    
    /// Process multiple images efficiently
    static func processBatch(_ images: [PlatformImage]) -> [PlatformImage] {
        return images.map { image in
            image
                .resized(to: CGSize(width: 200, height: 200))
                .adjustedBrightness(by: 0.1)
                .applyingFilter(.sepia)
        }
    }
    
    /// Convert image between formats
    static func convertFormat(_ image: PlatformImage, to format: String) -> Data? {
        switch format.lowercased() {
        case "png":
            return image.exportPNG()
        case "jpeg", "jpg":
            return image.exportJPEG(quality: 0.8)
        case "bitmap":
            return image.exportBitmap()
        default:
            return nil
        }
    }
}

// MARK: - Image Editor Class

/// Full-featured image editor with undo capability
class ImageEditor {
    private var history: [PlatformImage] = []
    private(set) var currentImage: PlatformImage
    
    init(image: PlatformImage) {
        self.currentImage = image
        self.history.append(image)
    }
    
    func adjustBrightness(by amount: Double) {
        currentImage = currentImage.adjustedBrightness(by: amount)
        history.append(currentImage)
    }
    
    func adjustContrast(by amount: Double) {
        currentImage = currentImage.adjustedContrast(by: amount)
        history.append(currentImage)
    }
    
    func adjustSaturation(by amount: Double) {
        currentImage = currentImage.adjustedSaturation(by: amount)
        history.append(currentImage)
    }
    
    func applyFilter(_ filter: PlatformImage.ImageFilter) {
        currentImage = currentImage.applyingFilter(filter)
        history.append(currentImage)
    }
    
    func rotate(by degrees: Double) {
        currentImage = currentImage.rotated(by: degrees)
        history.append(currentImage)
    }
    
    func resize(to size: CGSize) {
        currentImage = currentImage.resized(to: size)
        history.append(currentImage)
    }
    
    func crop(to rect: CGRect) {
        currentImage = currentImage.cropped(to: rect)
        history.append(currentImage)
    }
    
    func undo() -> PlatformImage? {
        guard history.count > 1 else { return nil }
        history.removeLast()
        currentImage = history.last!
        return currentImage
    }
    
    func canUndo() -> Bool {
        return history.count > 1
    }
    
    func exportPNG() -> Data? {
        return currentImage.exportPNG()
    }
    
    func exportJPEG(quality: Double = 0.8) -> Data? {
        return currentImage.exportJPEG(quality: quality)
    }
    
    func getHistoryCount() -> Int {
        return history.count
    }
}

// MARK: - Usage Examples

/// Example usage demonstrating how to use the organized example structs
struct ExampleUsage {
    
    /// Run all export examples
    static func runExportExamples() {
        let image = PlatformImage.createPlaceholder()
        ImageExportExamples.exportToAllFormats(image)
        
        // Export for specific use case
        if let photoData = ImageExportExamples.exportForUseCase(image, useCase: .photo) {
            print("Photo export: \(photoData.count) bytes")
        }
    }
    
    /// Run all processing examples
    static func runProcessingExamples() {
        let image = PlatformImage.createPlaceholder()
        ImageProcessingExamples.resizeExamples(image)
        ImageProcessingExamples.cropExamples(image)
        ImageProcessingExamples.rotateExamples(image)
        ImageProcessingExamples.colorAdjustmentExamples(image)
        ImageProcessingExamples.filterExamples(image)
    }
    
    /// Run metadata examples
    static func runMetadataExamples() {
        let image = PlatformImage.createPlaceholder()
        ImageMetadataExamples.displayProperties(image)
        let recommendation = ImageMetadataExamples.recommendFormat(image)
        print("Recommended: \(recommendation.format) at quality \(recommendation.quality)")
    }
    
    /// Run pipeline examples
    static func runPipelineExamples() {
        let image = PlatformImage.createPlaceholder()
        
        // Process image
        let processed = ImagePipelineExamples.processImage(image)
        print("Processed image size: \(processed.size)")
        
        // Optimize for upload
        if let uploadData = ImagePipelineExamples.optimizeForUpload(image) {
            print("Upload data: \(uploadData.count) bytes")
        }
        
        // Generate thumbnail
        if let thumbnailData = ImagePipelineExamples.generateThumbnail(image) {
            print("Thumbnail: \(thumbnailData.count) bytes")
        }
    }
    
    /// Demonstrate ImageEditor usage
    static func runEditorExample() {
        let image = PlatformImage.createPlaceholder()
        let editor = ImageEditor(image: image)
        
        // Make some edits
        editor.adjustBrightness(by: 0.2)
        editor.adjustContrast(by: 1.3)
        editor.applyFilter(.sepia)
        
        print("History count: \(editor.getHistoryCount())")
        
        // Undo last operation
        if editor.canUndo() {
            _ = editor.undo()
            print("Undone, history count: \(editor.getHistoryCount())")
        }
        
        // Export final result
        if let finalData = editor.exportJPEG(quality: 0.9) {
            print("Final export: \(finalData.count) bytes")
        }
    }
}

