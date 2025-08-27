//
//  HintFactories.swift
//  SixLayer Framework Stub
//
//  Copy this file into your project and modify it for your needs.
//  This provides factory methods for common hint patterns.
//

import Foundation
import SixLayerFramework

// MARK: - Hint Factory Methods

/// Factory methods for creating common hint patterns
/// Modify these methods to match your application's requirements
public struct HintFactories {
    
    // MARK: - Dashboard Hints
    
    /// Create hints for dashboard views
    static func forDashboard(
        showCharts: Bool = true,
        showMetrics: Bool = true,
        refreshRate: Int = 60
    ) -> EnhancedPresentationHints {
        let dashboardHint = CustomHint(
            hintType: "dashboard.main",
            priority: .high,
            overridesDefault: false,
            customData: [
                "showCharts": showCharts,
                "showMetrics": showMetrics,
                "refreshRate": refreshRate,
                "layoutStyle": "grid",
                "recommendedColumns": 2,
                "realTimeUpdates": true,
                "interactiveElements": true,
                "drillDownEnabled": true
            ]
        )
        
        return EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .dashboard,
            extensibleHints: [dashboardHint]
        )
    }
    
    // MARK: - List Hints
    
    /// Create hints for list views
    static func forList(
        showSearch: Bool = true,
        showFilters: Bool = true,
        showSorting: Bool = true,
        paginationEnabled: Bool = false
    ) -> EnhancedPresentationHints {
        let listHint = CustomHint(
            hintType: "list.standard",
            priority: .normal,
            overridesDefault: false,
            customData: [
                "showSearch": showSearch,
                "showFilters": showFilters,
                "showSorting": showSorting,
                "paginationEnabled": paginationEnabled,
                "layoutStyle": "list",
                "recommendedColumns": 1,
                "selectionEnabled": true,
                "swipeActions": true,
                "pullToRefresh": true
            ]
        )
        
        return EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .list,
            complexity: .moderate,
            context: .browse,
            extensibleHints: [listHint]
        )
    }
    
    // MARK: - Grid Hints
    
    /// Create hints for grid views
    static func forGrid(
        columns: Int = 3,
        showMetadata: Bool = true,
        showActions: Bool = true
    ) -> EnhancedPresentationHints {
        let gridHint = CustomHint(
            hintType: "grid.standard",
            priority: .normal,
            overridesDefault: false,
            customData: [
                "columns": columns,
                "showMetadata": showMetadata,
                "showActions": showActions,
                "layoutStyle": "grid",
                "recommendedColumns": columns,
                "selectionEnabled": true,
                "dragAndDrop": true,
                "infiniteScroll": true
            ]
        )
        
        return EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .grid,
            complexity: .moderate,
            context: .browse,
            extensibleHints: [gridHint]
        )
    }
    
    // MARK: - Form Hints
    
    /// Create hints for form views
    static func forForm(
        fieldCount: Int,
        showValidation: Bool = true,
        showProgress: Bool = false,
        multiStep: Bool = false
    ) -> EnhancedPresentationHints {
        let formHint = CustomHint(
            hintType: "form.standard",
            priority: .high,
            overridesDefault: false,
            customData: [
                "fieldCount": fieldCount,
                "showValidation": showValidation,
                "showProgress": showProgress,
                "multiStep": multiStep,
                "layoutStyle": "form",
                "recommendedColumns": 1,
                "autoSave": true,
                "draftSupport": true,
                "accessibility": true
            ]
        )
        
        return EnhancedPresentationHints(
            dataType: .form,
            presentationPreference: .form,
            complexity: fieldCount > 10 ? .complex : .moderate,
            context: .edit,
            extensibleHints: [formHint]
        )
    }
    
    // MARK: - Detail Hints
    
    /// Create hints for detail views
    static func forDetail(
        showActions: Bool = true,
        showRelated: Bool = true,
        showSharing: Bool = true
    ) -> EnhancedPresentationHints {
        let detailHint = CustomHint(
            hintType: "detail.standard",
            priority: .normal,
            overridesDefault: false,
            customData: [
                "showActions": showActions,
                "showRelated": showRelated,
                "showSharing": showSharing,
                "layoutStyle": "detail",
                "recommendedColumns": 1,
                "fullScreenEnabled": true,
                "navigationEnabled": true,
                "accessibility": true
            ]
        )
        
        return EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .cards,
            complexity: .simple,
            context: .detail,
            extensibleHints: [detailHint]
        )
    }
    
    // MARK: - Search Hints
    
    /// Create hints for search results
    static func forSearch(
        resultCount: Int,
        showFilters: Bool = true,
        showSorting: Bool = true
    ) -> EnhancedPresentationHints {
        let searchHint = CustomHint(
            hintType: "search.results",
            priority: .normal,
            overridesDefault: false,
            customData: [
                "resultCount": resultCount,
                "showFilters": showFilters,
                "showSorting": showSorting,
                "layoutStyle": "list",
                "recommendedColumns": 1,
                "searchHighlighting": true,
                "quickActions": true,
                "recentSearches": true
            ]
        )
        
        return EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .list,
            complexity: resultCount > 50 ? .complex : .moderate,
            context: .search,
            extensibleHints: [searchHint]
        )
    }
    
    // MARK: - Settings Hints
    
    /// Create hints for settings views
    static func forSettings(
        showCategories: Bool = true,
        showSearch: Bool = true,
        showAdvanced: Bool = false
    ) -> EnhancedPresentationHints {
        let settingsHint = CustomHint(
            hintType: "settings.main",
            priority: .normal,
            overridesDefault: false,
            customData: [
                "showCategories": showCategories,
                "showSearch": showSearch,
                "showAdvanced": showAdvanced,
                "layoutStyle": "list",
                "recommendedColumns": 1,
                "groupingEnabled": true,
                "resetOptions": true,
                "exportSettings": true
            ]
        )
        
        return EnhancedPresentationHints(
            dataType: .collection,
            presentationPreference: .list,
            complexity: .moderate,
            context: .edit,
            extensibleHints: [settingsHint]
        )
    }
}

// MARK: - Usage Examples

/*
 
 // Use the factory methods in your app:
 
 struct DashboardView: View {
     var body: some View {
         let hints = HintFactories.forDashboard(
             showCharts: true,
             showMetrics: true,
             refreshRate: 30
         )
         
         return platformPresentItemCollection_L1(
             items: dashboardItems,
             hints: hints
         )
     }
 }
 
 struct UserListView: View {
     var body: some View {
         let hints = HintFactories.forList(
             showSearch: true,
             showFilters: true,
             showSorting: true,
             paginationEnabled: true
         )
         
         return platformPresentItemCollection_L1(
             items: users,
             hints: hints
         )
     }
 }
 
 struct ProductGridView: View {
     var body: some View {
         let hints = HintFactories.forGrid(
             columns: 4,
             showMetadata: true,
             showActions: true
         )
         
         return platformPresentItemCollection_L1(
             items: products,
             hints: hints
         )
     }
 }
 
 struct UserProfileFormView: View {
     var body: some View {
         let hints = HintFactories.forForm(
             fieldCount: 8,
             showValidation: true,
             showProgress: false,
             multiStep: false
         )
         
         return platformPresentFormData_L1(
             fields: formFields,
             hints: hints
         )
     }
 }
 
 */
