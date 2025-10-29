//
//  FieldHintsFromDataExample.swift
//  SixLayerFramework
//
//  Example showing how field hints are discovered from the DATA,
//  not passed in separately
//

import SwiftUI
import SixLayerFramework

// MARK: - Field Hints Discovered from Data Example

struct FieldHintsFromDataExample: View {
    var body: some View {
        // Create fields with hints embedded in the data
        let fields = createFieldsWithHints()
        
        // Hints are automatically discovered from the fields!
        // No need to pass hints separately
        return platformPresentFormData_L1(
            fields: fields,
            hints: PresentationHints(
                dataType: .form,
                presentationPreference: .form,
                context: .create
            )
        )
    }
    
    func createFieldsWithHints() -> [DynamicFormField] {
        [
            // Username field with narrow width hint in metadata
            DynamicFormField(
                id: "username",
                contentType: .text,
                label: "Username",
                placeholder: "Enter username",
                metadata: [
                    "expectedLength": "20",
                    "displayWidth": "medium",
                    "maxLength": "50",
                    "minLength": "3",
                    "showCharacterCounter": "false"
                ]
            ),
            
            // Bio field with wide width and character counter
            DynamicFormField(
                id: "bio",
                contentType: .textarea,
                label: "Biography",
                placeholder: "Tell us about yourself",
                metadata: [
                    "expectedLength": "500",
                    "displayWidth": "wide",
                    "maxLength": "1000",
                    "showCharacterCounter": "true"
                ]
            ),
            
            // Postal code with narrow width
            DynamicFormField(
                id: "postalCode",
                textContentType: .postalCode,
                label: "Postal Code",
                placeholder: "Enter postal code",
                metadata: [
                    "expectedLength": "10",
                    "displayWidth": "narrow",
                    "maxLength": "10"
                ]
            )
        ]
    }
}

// MARK: - Key Points

/*
 
 KEY ARCHITECTURAL INSIGHT:
 
 Hints describe the DATA, so they should be discovered from the data itself,
 not passed in separately!
 
 BEFORE (wrong):
 
 let hints = PresentationHints(fieldHints: ["username": FieldDisplayHints(...)])
 let view = platformPresentFormData_L1(fields: fields, hints: hints)
 
 AFTER (right):
 
 let fields = [
     DynamicFormField(
         id: "username",
         contentType: .text,
         label: "Username",
         metadata: [
             "displayWidth": "medium",
             "expectedLength": "20"
         ]
     )
 ]
 // Hints automatically discovered from field.displayHints
 let view = platformPresentFormData_L1(fields: fields, hints: PresentationHints(...))
 
 This is like CoreData models - the model itself contains its metadata!
 
 */


