//
//  PhotoGalleryHint.swift
//  SixLayer Framework Stub
//
//  Copy this file into your project and modify it for your needs.
//  This provides a starting point for photo gallery hints.
//

import Foundation
import SixLayerFramework

// MARK: - Photo Gallery Hint

/// Custom hint for photo gallery applications
/// Modify this class to match your photo gallery application's requirements
class PhotoGalleryHint: CustomHint {
    
    // MARK: - Properties
    
    /// Whether to show photo metadata
    let showMetadata: Bool
    
    /// Whether to allow fullscreen viewing
    let allowFullscreen: Bool
    
    /// Grid style for photo layout
    let gridStyle: String
    
    /// Whether to enable lazy loading
    let lazyLoading: Bool
    
    /// Whether to enable zoom functionality
    let zoomEnabled: Bool
    
    /// Whether to enable sharing
    let shareEnabled: Bool
    
    /// Whether to enable downloads
    let downloadEnabled: Bool
    
    /// Whether to enable slideshow
    let slideshowEnabled: Bool
    
    // MARK: - Initialization
    
    init(
        showMetadata: Bool = true,
        allowFullscreen: Bool = true,
        gridStyle: String = "masonry",
        lazyLoading: Bool = true,
        zoomEnabled: Bool = true,
        shareEnabled: Bool = true,
        downloadEnabled: Bool = true,
        slideshowEnabled: Bool = true
    ) {
        self.showMetadata = showMetadata
        self.allowFullscreen = allowFullscreen
        self.gridStyle = gridStyle
        self.lazyLoading = lazyLoading
        self.zoomEnabled = zoomEnabled
        self.shareEnabled = shareEnabled
        self.downloadEnabled = downloadEnabled
        self.slideshowEnabled = slideshowEnabled
        
        super.init(
            hintType: "photo.gallery",
            priority: .high,
            overridesDefault: false,
            customData: [
                "showMetadata": showMetadata,
                "allowFullscreen": allowFullscreen,
                "gridStyle": gridStyle,
                "lazyLoading": lazyLoading,
                "zoomEnabled": zoomEnabled,
                "shareEnabled": shareEnabled,
                "downloadEnabled": downloadEnabled,
                "slideshowEnabled": slideshowEnabled,
                "recommendedColumns": calculateOptimalColumns(for: gridStyle),
                "thumbnailSize": calculateThumbnailSize(for: gridStyle),
                "searchEnabled": true,
                "filteringEnabled": true,
                "sortingEnabled": true,
                "albumsEnabled": true,
                "favoritesEnabled": true,
                "tagsEnabled": true
            ]
        )
    }
    
    // MARK: - Helper Methods
    
    /// Calculate optimal column count based on grid style
    private func calculateOptimalColumns(for gridStyle: String) -> Int {
        switch gridStyle.lowercased() {
        case "masonry":
            return 3
        case "grid":
            return 4
        case "list":
            return 1
        case "carousel":
            return 1
        default:
            return 3
        }
    }
    
    /// Calculate optimal thumbnail size based on grid style
    private func calculateThumbnailSize(for gridStyle: String) -> String {
        switch gridStyle.lowercased() {
        case "masonry":
            return "medium"
        case "grid":
            return "small"
        case "list":
            return "large"
        case "carousel":
            return "large"
        default:
            return "medium"
        }
    }
}

// MARK: - Enhanced Presentation Hints Extension

extension EnhancedPresentationHints {
    
    /// Create hints optimized for photo galleries
    static func forPhotoGallery(
        showMetadata: Bool = true,
        allowFullscreen: Bool = true,
        gridStyle: String = "masonry",
        lazyLoading: Bool = true,
        zoomEnabled: Bool = true
    ) -> EnhancedPresentationHints {
        let photoHint = PhotoGalleryHint(
            showMetadata: showMetadata,
            allowFullscreen: allowFullscreen,
            gridStyle: gridStyle,
            lazyLoading: lazyLoading,
            zoomEnabled: zoomEnabled
        )
        
        return EnhancedPresentationHints(
            dataType: .media,
            presentationPreference: .masonry,
            complexity: .moderate,
            context: .browse,
            extensibleHints: [photoHint]
        )
    }
}

// MARK: - Usage Example

/*
 
 // In your photo gallery app, use it like this:
 
 struct PhotoGalleryView: View {
     let photos: [Photo]
     
     var body: some View {
         let hints = EnhancedPresentationHints.forPhotoGallery(
             showMetadata: true,
             allowFullscreen: true,
             gridStyle: "masonry",
             lazyLoading: true,
             zoomEnabled: true
         )
         
         return platformPresentMediaData_L1(
             media: photos,
             hints: hints
         )
     }
 }
 
 // For different gallery contexts:
 
 struct PhotoAlbumView: View {
     let albumPhotos: [Photo]
     
     var body: some View {
         let hints = EnhancedPresentationHints(
             dataType: .media,
             presentationPreference: .grid,
             complexity: .moderate,
             context: .browse,
             extensibleHints: [
                 PhotoGalleryHint(
                     showMetadata: false,
                     allowFullscreen: true,
                     gridStyle: "grid",
                     lazyLoading: true,
                     zoomEnabled: true,
                     shareEnabled: true,
                     downloadEnabled: false,
                     slideshowEnabled: true
                 )
             ]
         )
         
         return platformPresentMediaData_L1(
             media: albumPhotos,
             hints: hints
         )
     }
 }
 
 // For photo search results:
 
 struct PhotoSearchResultsView: View {
     let searchResults: [Photo]
     
     var body: some View {
         let hints = EnhancedPresentationHints(
             dataType: .media,
             presentationPreference: .list,
             complexity: .moderate,
             context: .search,
             extensibleHints: [
                 PhotoGalleryHint(
                     showMetadata: true,
                     allowFullscreen: true,
                     gridStyle: "list",
                     lazyLoading: false,
                     zoomEnabled: false,
                     shareEnabled: true,
                     downloadEnabled: true,
                     slideshowEnabled: false
                 )
             ]
         )
         
         return platformPresentMediaData_L1(
             media: searchResults,
             hints: hints
         )
     }
 }
 
 */
