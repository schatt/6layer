//
//  BlogPostHint.swift
//  SixLayer Framework Stub
//
//  Copy this file into your project and modify it for your needs.
//  This provides a starting point for blog post hints.
//

import Foundation
import SixLayerFramework

// MARK: - Blog Post Hint

/// Custom hint for blog post applications
/// Modify this class to match your blog application's requirements
class BlogPostHint: CustomHint {
    
    // MARK: - Properties
    
    /// Whether to show post excerpts
    let showExcerpts: Bool
    
    /// Whether to show author information
    let showAuthor: Bool
    
    /// Whether to show publication dates
    let showDate: Bool
    
    /// Whether to show read more links
    let showReadMore: Bool
    
    /// Whether to show estimated reading time
    let estimatedReadingTime: Bool
    
    /// Whether to show categories
    let showCategories: Bool
    
    /// Whether to show tags
    let showTags: Bool
    
    // MARK: - Initialization
    
    init(
        showExcerpts: Bool = true,
        showAuthor: Bool = true,
        showDate: Bool = true,
        showReadMore: Bool = true,
        estimatedReadingTime: Bool = true,
        showCategories: Bool = true,
        showTags: Bool = true
    ) {
        self.showExcerpts = showExcerpts
        self.showAuthor = showAuthor
        self.showDate = showDate
        self.showReadMore = showReadMore
        self.estimatedReadingTime = estimatedReadingTime
        self.showCategories = showCategories
        self.showTags = showTags
        
        super.init(
            hintType: "blog.posts",
            priority: .normal,
            overridesDefault: false,
            customData: [
                "showExcerpts": showExcerpts,
                "showAuthor": showAuthor,
                "showDate": showDate,
                "showReadMore": showReadMore,
                "estimatedReadingTime": estimatedReadingTime,
                "showCategories": showCategories,
                "showTags": showTags,
                "layoutStyle": "list",
                "recommendedColumns": 1,
                "searchEnabled": true,
                "filteringEnabled": true,
                "sortingEnabled": true,
                "paginationEnabled": true,
                "socialSharingEnabled": true,
                "bookmarkingEnabled": true
            ]
        )
    }
}

// MARK: - Enhanced Presentation Hints Extension

extension EnhancedPresentationHints {
    
    /// Create hints optimized for blog posts
    static func forBlogPosts(
        showExcerpts: Bool = true,
        showAuthor: Bool = true,
        showDate: Bool = true,
        showReadMore: Bool = true,
        estimatedReadingTime: Bool = true
    ) -> EnhancedPresentationHints {
        let blogHint = BlogPostHint(
            showExcerpts: showExcerpts,
            showAuthor: showAuthor,
            showDate: showDate,
            showReadMore: showReadMore,
            estimatedReadingTime: estimatedReadingTime
        )
        
        return EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .list,
            complexity: .moderate,
            context: .browse,
            extensibleHints: [blogHint]
        )
    }
}

// MARK: - Usage Example

/*
 
 // In your blog app, use it like this:
 
 struct BlogListView: View {
     let blogPosts: [BlogPost]
     
     var body: some View {
         let hints = EnhancedPresentationHints.forBlogPosts(
             showExcerpts: true,
             showAuthor: true,
             showDate: true,
             showReadMore: true,
             estimatedReadingTime: true
         )
         
         return platformPresentItemCollection_L1(
             items: blogPosts,
             hints: hints
         )
     }
 }
 
 // For different blog contexts:
 
 struct BlogSearchResultsView: View {
     let searchResults: [BlogPost]
     
     var body: some View {
         let hints = EnhancedPresentationHints(
             dataType: .collection,
             presentationPreference: .list,
             complexity: .moderate,
             context: .search,
             extensibleHints: [
                 BlogPostHint(
                     showExcerpts: true,
                     showAuthor: false,
                     showDate: true,
                     showReadMore: true,
                     estimatedReadingTime: false,
                     showCategories: true,
                     showTags: true
                 )
             ]
         )
         
         return platformPresentItemCollection_L1(
             items: searchResults,
             hints: hints
         )
     }
 }
 
 // For blog categories:
 
 struct BlogCategoryView: View {
     let categoryPosts: [BlogPost]
     
     var body: some View {
         let hints = EnhancedPresentationHints(
             dataType: .collection,
             presentationPreference: .grid,
             complexity: .moderate,
             context: .browse,
             extensibleHints: [
                 BlogPostHint(
                     showExcerpts: false,
                     showAuthor: true,
                     showDate: true,
                     showReadMore: false,
                     estimatedReadingTime: true,
                     showCategories: false,
                     showTags: true
                 )
             ]
         )
         
         return platformPresentItemCollection_L1(
             items: categoryPosts,
             hints: hints
         )
     }
 }
 
 */
