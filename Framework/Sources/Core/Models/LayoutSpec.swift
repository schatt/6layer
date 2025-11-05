//
//  LayoutSpec.swift
//  SixLayerFramework
//
//  Layout specification type for explicit form layout overrides
//

import Foundation

// MARK: - Layout Specification

/// Explicit layout specification that overrides hints from data files
/// Used when a form needs a different layout than what's specified in hints
public struct LayoutSpec {
    /// Sections with explicit layout configuration
    public let sections: [DynamicFormSection]
    
    public init(sections: [DynamicFormSection]) {
        self.sections = sections
    }
}

