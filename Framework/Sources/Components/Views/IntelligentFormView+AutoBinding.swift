//
//  IntelligentFormView+AutoBinding.swift
//  SixLayerFramework
//
//  Automatic dataBinder creation with opt-out support
//
//  This extension provides automatic dataBinder creation for IntelligentFormView.
//  When enabled, a DataBinder is automatically created and can be used for
//  real-time model updates. Manual key path binding is still required for
//  full functionality, but the DataBinder instance is created automatically.
//

import Foundation
import SwiftUI

extension IntelligentFormView {
    
    /// Automatically create a dataBinder instance for the provided data
    /// 
    /// **Note**: This creates the DataBinder instance but does NOT automatically
    /// bind fields to key paths. Swift's type system requires compile-time key paths,
    /// so automatic binding of all fields is not possible. However, creating the
    /// DataBinder automatically reduces boilerplate.
    ///
    /// **When to use**:
    /// - You want real-time model updates
    /// - Your model has mutable properties (var, not let)
    /// - You're willing to manually bind key paths for full functionality
    ///
    /// **When NOT to use** (set autoBind: false):
    /// - Read-only forms (display only)
    /// - Immutable models (all let properties)
    /// - External state management (Redux, Combine publishers)
    /// - Batch updates (collect changes, apply on submit)
    /// - Performance concerns (too many real-time updates)
    ///
    /// - Parameters:
    ///   - data: The data model instance
    ///   - analysis: The data analysis result from DataIntrospectionEngine
    /// - Returns: A DataBinder instance, or nil if auto-binding is not supported
    @MainActor
    internal static func createAutoDataBinder<T>(for data: T, analysis: DataAnalysisResult) -> DataBinder<T>? {
        // Create DataBinder instance
        // Note: Actual field binding requires WritableKeyPath which must be
        // provided manually. This just creates the binder instance.
        let binder = DataBinder(data)
        
        // Return the binder - user can manually bind fields if needed
        // The binder will work for fields that are manually bound via bind(_:to:)
        return binder
    }
    
    /// Check if a model type likely supports data binding
    /// 
    /// This is a heuristic check - it doesn't guarantee binding will work,
    /// but helps determine if it's worth attempting.
    ///
    /// - Parameters:
    ///   - data: The data model instance
    ///   - analysis: The data analysis result
    /// - Returns: True if the model appears to have bindable properties
    internal static func supportsAutoBinding<T>(_ data: T, analysis: DataAnalysisResult) -> Bool {
        // Heuristic: If we can analyze it and it has fields, it might be bindable
        // Note: This doesn't check if properties are var vs let (requires reflection)
        // Full binding support requires manual key path specification
        return !analysis.fields.isEmpty
    }
}

