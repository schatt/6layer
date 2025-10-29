//
//  AutoLoadHintsExample.swift
//  SixLayerFramework
//
//  Example showing how apps using 6Layer create .hints files
//  and 6Layer automatically reads and uses them
//

import SwiftUI
import SixLayerFramework

// MARK: - Example: App Using 6Layer

struct AutoLoadHintsExample: View {
    @State private var fields: [DynamicFormField] = createUserFields()
    
    var body: some View {
        // 6Layer automatically reads User.hints file and uses it!
        // The model name matches the .hints file (User.hints)
        platformPresentFormData_L1(
            fields: fields,
            hints: EnhancedPresentationHints(
                dataType: .form,
                presentationPreference: .form,
                context: .create
            ),
            modelName: "User"  // 6Layer looks for User.hints file
        )
    }
    
    static func createUserFields() -> [DynamicFormField] {
        [
            DynamicFormField(
                id: "username",
                contentType: .text,
                label: "Username",
                placeholder: "Enter username",
                isRequired: true
            ),
            DynamicFormField(
                id: "email",
                contentType: .email,
                label: "Email",
                placeholder: "Enter email",
                isRequired: true
            ),
            DynamicFormField(
                id: "bio",
                contentType: .textarea,
                label: "Biography",
                placeholder: "Tell us about yourself"
            ),
            DynamicFormField(
                id: "postalCode",
                textContentType: .postalCode,
                label: "Postal Code",
                placeholder: "Enter postal code"
            ),
            DynamicFormField(
                id: "phone",
                textContentType: .telephoneNumber,
                label: "Phone",
                placeholder: "Enter phone number"
            )
        ]
    }
}

// MARK: - How It Works

/*
 
 ARCHITECTURE:
 
 1. App creates a data model (e.g., User struct)
 2. App creates a corresponding User.hints file that describes how to present it
 3. App calls 6Layer with modelName: "User"
 4. 6Layer automatically reads User.hints and applies the display hints
 
 THE HINTS FILE (User.hints):
 {
   "username": {
     "displayWidth": "medium",
     "expectedLength": 20
   },
   "email": {
     "displayWidth": "wide"
   }
 }
 
 NO MANUAL HINT PASSING NEEDED!
 The hints describe the data, so 6Layer discovers them automatically.
 
 */

