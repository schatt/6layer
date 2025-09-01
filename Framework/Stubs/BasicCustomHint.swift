//
//  BasicCustomHint.swift
//  SixLayer Framework Stub
//
//  Copy this file into your project and modify it for your needs.
//  This provides a simple starting point for custom hints.
//

import Foundation
import SixLayerFramework

// MARK: - Basic Custom Hint

/// Basic custom hint implementation
/// Modify this class to match your application's requirements
class BasicCustomHint: CustomHint {
    
    // MARK: - Properties
    
    /// Your custom setting
    let myCustomSetting: Bool
    
    /// Your custom behavior preference
    let behaviorPreference: String
    
    // MARK: - Initialization
    
    init(
        myCustomSetting: Bool = true,
        behaviorPreference: String = "standard"
    ) {
        self.myCustomSetting = myCustomSetting
        self.behaviorPreference = behaviorPreference
        
        super.init(
            hintType: "myapp.basic", // Change this to match your app
            priority: .normal,
            overridesDefault: false,
            customData: [
                "myCustomSetting": myCustomSetting,
                "behaviorPreference": behaviorPreference,
                "recommendedLayout": "adaptive",
                "showAdvancedFeatures": myCustomSetting,
                "customBehavior": behaviorPreference
            ]
        )
    }
}

// MARK: - Usage Example

/*
 
 // In your app, use it like this:
 
 struct MyView: View {
     let items: [MyItem]
     
     var body: some View {
         let hints = EnhancedPresentationHints(
             dataType: .collection,
             presentationPreference: .cards,
             complexity: .moderate,
             context: .dashboard,
             extensibleHints: [
                 BasicCustomHint(
                     myCustomSetting: true,
                     behaviorPreference: "enhanced"
                 )
             ]
         )
         
         return platformPresentItemCollection_L1(
             items: items,
             hints: hints
         )
     }
 }
 
 */
