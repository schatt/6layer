//
//  BarcodeOverlayConfiguration.swift
//  SixLayerFramework
//
//  Layer 3: Strategy - Barcode Overlay Configuration
//
//  This configuration struct defines the strategy for barcode overlay behavior,
//  allowing different approaches based on user preferences and platform capabilities.

import SwiftUI

/// Configuration for barcode overlay display and interaction
public struct BarcodeOverlayConfiguration {
    public let showBoundingBoxes: Bool
    public let showConfidenceIndicators: Bool
    public let highlightColor: Color
    public let lowConfidenceThreshold: Float
    public let highConfidenceThreshold: Float
    public let showBarcodeType: Bool
    public let showPayload: Bool
    
    public init(
        showBoundingBoxes: Bool = true,
        showConfidenceIndicators: Bool = true,
        highlightColor: Color = .blue,
        lowConfidenceThreshold: Float = 0.7,
        highConfidenceThreshold: Float = 0.9,
        showBarcodeType: Bool = true,
        showPayload: Bool = true
    ) {
        self.showBoundingBoxes = showBoundingBoxes
        self.showConfidenceIndicators = showConfidenceIndicators
        self.highlightColor = highlightColor
        self.lowConfidenceThreshold = lowConfidenceThreshold
        self.highConfidenceThreshold = highConfidenceThreshold
        self.showBarcodeType = showBarcodeType
        self.showPayload = showPayload
    }
}
