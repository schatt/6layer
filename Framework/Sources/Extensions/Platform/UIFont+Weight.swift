//
//  UIFont+Weight.swift
//  SixLayerFramework
//
//  Provides a best-effort way to inspect the effective weight
//  of a UIFont for use in platform font tests and diagnostics.
//

#if os(iOS)
import UIKit

extension UIFont {
    /// Best-effort extraction of the font weight for this UIFont.
    /// Uses the font descriptor's traits when available and falls back to
    /// heuristic name-based detection before defaulting to `.regular`.
    var weight: UIFont.Weight {
        // 1. Try descriptor traits first (most accurate)
        if let traits = fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any],
           let weightValue = traits[.weight] as? CGFloat {
            return UIFont.Weight(rawValue: weightValue)
        }

        // 2. Heuristic based on the font name as a safe fallback
        let name = fontName.lowercased()
        if name.contains("ultralight") { return .ultraLight }
        if name.contains("thin")       { return .thin }
        if name.contains("light")      { return .light }
        if name.contains("medium")     { return .medium }
        if name.contains("semibold")
            || name.contains("demibold") { return .semibold }
        if name.contains("bold")       { return .bold }
        if name.contains("heavy")      { return .heavy }
        if name.contains("black")      { return .black }

        // 3. Default fallback
        return .regular
    }
}
#endif


