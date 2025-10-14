//
 //  PlatformGraphicsExtensions.swift
 //  SixLayerFramework
 //
 //  Cross-platform graphics extensions for unified drawing operations
 //

 import SwiftUI

 #if os(iOS)
 import UIKit
 #elseif os(macOS)
 import AppKit
 #endif

 // MARK: - Cross-Platform Graphics Context Extensions

 public extension CGContext {

     /// Cross-platform setFill method for SwiftUI Color
     /// - Parameter color: SwiftUI Color to use for filling
     func setFillColor(_ color: Color) {
         #if os(iOS)
         // On iOS, we can use the Color directly with CGContext
         let uiColor = UIColor(color)
         setFillColor(uiColor.cgColor)
         #elseif os(macOS)
         // On macOS, we need to convert through NSColor
         let nsColor = NSColor(color)
         setFillColor(nsColor.cgColor)
         #endif
     }
 }

 // MARK: - Context-Specific Extensions

#if os(iOS)
public extension UIGraphicsImageRendererContext {
    /// Cross-platform setFill method for SwiftUI Color
    /// - Parameter color: SwiftUI Color to use for filling
    func setFillColor(_ color: Color) {
        let uiColor = UIColor(color)
        uiColor.setFill()
    }
}
#elseif os(macOS)
public extension NSGraphicsContext {
    /// Cross-platform setFill method for SwiftUI Color
    /// - Parameter color: SwiftUI Color to use for filling
    func setFillColor(_ color: Color) {
        let nsColor = NSColor(color)
        nsColor.setFill()
    }
}
#endif

// MARK: - Convenience Extensions for Common Graphics Operations

public extension CGContext {

    /// Fill rectangle with SwiftUI Color
    /// - Parameters:
    ///   - color: SwiftUI Color to use for filling
    ///   - rect: Rectangle to fill
    func fill(_ rect: CGRect, with color: Color) {
        saveGState()
        setFillColor(color)
        fill(rect)
        restoreGState()
    }

    /// Fill path with SwiftUI Color
    /// - Parameter color: SwiftUI Color to use for filling
    func fillPath(with color: Color) {
        saveGState()
        setFillColor(color)
        fillPath()
        restoreGState()
    }
}
