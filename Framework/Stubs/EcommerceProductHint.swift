//
//  EcommerceProductHint.swift
//  SixLayer Framework Stub
//
//  Copy this file into your project and modify it for your needs.
//  This provides a starting point for e-commerce product hints.
//

import Foundation
import SixLayerFramework

// MARK: - E-commerce Product Hint

/// Custom hint for e-commerce product catalogs
/// Modify this class to match your e-commerce application's requirements
class EcommerceProductHint: CustomHint {
    
    // MARK: - Properties
    
    /// Product category
    let category: String
    
    /// Whether to show pricing information
    let showPricing: Bool
    
    /// Whether to show customer reviews
    let showReviews: Bool
    
    /// Preferred layout style
    let layoutStyle: String
    
    /// Whether to show wishlist functionality
    let showWishlist: Bool
    
    /// Whether to enable quick view
    let quickViewEnabled: Bool
    
    // MARK: - Initialization
    
    init(
        category: String,
        showPricing: Bool = true,
        showReviews: Bool = true,
        layoutStyle: String = "grid",
        showWishlist: Bool = true,
        quickViewEnabled: Bool = true
    ) {
        self.category = category
        self.showPricing = showPricing
        self.showReviews = showReviews
        self.layoutStyle = layoutStyle
        self.showWishlist = showWishlist
        self.quickViewEnabled = quickViewEnabled
        
        super.init(
            hintType: "ecommerce.product.\(category)",
            priority: .high,
            overridesDefault: false,
            customData: [
                "category": category,
                "showPricing": showPricing,
                "showReviews": showReviews,
                "layoutStyle": layoutStyle,
                "showWishlist": showWishlist,
                "quickViewEnabled": quickViewEnabled,
                "recommendedColumns": calculateOptimalColumns(for: category),
                "filteringEnabled": true,
                "sortingEnabled": true,
                "searchEnabled": true,
                "showStockStatus": true,
                "showShippingInfo": true
            ]
        )
    }
    
    // MARK: - Helper Methods
    
    /// Calculate optimal column count based on category
    private func calculateOptimalColumns(for category: String) -> Int {
        switch category.lowercased() {
        case "electronics", "clothing":
            return 3
        case "books", "music":
            return 4
        case "furniture", "appliances":
            return 2
        default:
            return 3
        }
    }
}

// MARK: - Enhanced Presentation Hints Extension

extension EnhancedPresentationHints {
    
    /// Create hints optimized for e-commerce product catalogs
    static func forEcommerceProducts(
        category: String,
        showPricing: Bool = true,
        showReviews: Bool = true,
        layoutStyle: String = "grid",
        showWishlist: Bool = true,
        quickViewEnabled: Bool = true
    ) -> EnhancedPresentationHints {
        let ecommerceHint = EcommerceProductHint(
            category: category,
            showPricing: showPricing,
            showReviews: showReviews,
            layoutStyle: layoutStyle,
            showWishlist: showWishlist,
            quickViewEnabled: quickViewEnabled
        )
        
        return EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .browse,
            extensibleHints: [ecommerceHint]
        )
    }
}

// MARK: - Usage Example

/*
 
 // In your e-commerce app, use it like this:
 
 struct ProductCatalogView: View {
     let products: [Product]
     
     var body: some View {
         let hints = EnhancedPresentationHints.forEcommerceProducts(
             category: "electronics",
             showPricing: true,
             showReviews: true,
             layoutStyle: "grid",
             showWishlist: true,
             quickViewEnabled: true
         )
         
         return platformPresentItemCollection_L1(
             items: products,
             hints: hints
         )
     }
 }
 
 // Or create hints manually:
 
 struct ProductDetailView: View {
     let product: Product
     
     var body: some View {
         let hints = EnhancedPresentationHints(
             dataType: .collection,
             presentationPreference: .cards,
             complexity: .simple,
             context: .detail,
             extensibleHints: [
                 EcommerceProductHint(
                     category: product.category,
                     showPricing: true,
                     showReviews: true,
                     layoutStyle: "detail",
                     showWishlist: true,
                     quickViewEnabled: false
                 )
             ]
         )
         
         return platformPresentItemCollection_L1(
             items: [product],
             hints: hints
         )
     }
 }
 
 */
