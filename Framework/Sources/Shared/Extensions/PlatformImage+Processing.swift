//
//  PlatformImage+Processing.swift
//  SixLayerFramework
//
//  PlatformImage extensions for image processing
//  Provides additional functionality for image analysis and processing
//

import Foundation
import SwiftUI

// MARK: - PlatformImage Processing Extensions

extension PlatformImage {
    
    /// Check if the image is empty
    public var isEmpty: Bool {
        #if os(iOS)
        return uiImage.size == .zero
        #elseif os(macOS)
        return nsImage.size == .zero
        #endif
    }
    
    /// Get the size of the image
    public var size: CGSize {
        #if os(iOS)
        return uiImage.size
        #elseif os(macOS)
        return nsImage.size
        #endif
    }
    
    /// Create an empty PlatformImage
    public init() {
        #if os(iOS)
        self.init(uiImage: UIImage())
        #elseif os(macOS)
        self.init(nsImage: NSImage())
        #endif
    }
}

// MARK: - PlatformImage Equatable Conformance

extension PlatformImage: Equatable {
    public static func == (lhs: PlatformImage, rhs: PlatformImage) -> Bool {
        #if os(iOS)
        return lhs.uiImage == rhs.uiImage
        #elseif os(macOS)
        return lhs.nsImage == rhs.nsImage
        #endif
    }
}
