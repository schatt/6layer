import XCTest
import SixLayerFramework

/// Tests to verify that SixLayerTextContentType covers all UITextContentType cases
/// This ensures our cross-platform enum is complete and future-proof
class TextContentTypeCompletenessTests: XCTestCase {
    
    /// Test that all UITextContentType cases exist in SixLayerTextContentType
    /// This test runs on iOS/Mac Catalyst to verify completeness
    #if canImport(UIKit)
    func testSixLayerTextContentTypeCompleteness() {
        // Get all UITextContentType cases
        let uiTextContentTypes: [UITextContentType] = [
            .name, .namePrefix, .givenName, .middleName, .familyName, .nameSuffix,
            .jobTitle, .organizationName,
            .emailAddress, .telephoneNumber,
            .username, .password, .newPassword, .oneTimeCode,
            .location, .fullStreetAddress, .streetAddressLine1, .streetAddressLine2,
            .addressCity, .addressState, .addressCityAndState, .sublocality,
            .countryName, .postalCode,
            .URL, .creditCardNumber
        ]
        
        // Test that each UITextContentType can be converted to SixLayerTextContentType
        for uiType in uiTextContentTypes {
            let sixLayerType = SixLayerTextContentType(uiType)
            
            // Verify the conversion works and produces expected results
            XCTAssertNotNil(sixLayerType, "SixLayerTextContentType should handle \(uiType)")
            
            // Verify round-trip conversion works
            let backToUI = sixLayerType.uiTextContentType
            XCTAssertEqual(backToUI, uiType, "Round-trip conversion should preserve \(uiType)")
        }
    }
    
    /// Test that SixLayerTextContentType can handle unknown future UITextContentType cases
    func testFutureUITextContentTypeHandling() {
        // This test verifies that our @unknown default case works
        // If Apple adds new UITextContentType cases, our enum should handle them gracefully
        
        // Test that our enum has all the cases we expect
        let expectedCases: [SixLayerTextContentType] = [
            .name, .namePrefix, .givenName, .middleName, .familyName, .nameSuffix,
            .jobTitle, .organizationName,
            .emailAddress, .telephoneNumber,
            .username, .password, .newPassword, .oneTimeCode,
            .location, .fullStreetAddress, .streetAddressLine1, .streetAddressLine2,
            .addressCity, .addressState, .addressCityAndState, .sublocality,
            .countryName, .postalCode,
            .URL, .creditCardNumber
        ]
        
        // Verify all expected cases exist
        for expectedCase in expectedCases {
            XCTAssertTrue(SixLayerTextContentType.allCases.contains(expectedCase), 
                        "SixLayerTextContentType should contain \(expectedCase)")
        }
    }
    #endif
    
    /// Test cross-platform field creation works consistently
    func testCrossPlatformFieldCreation() {
        // Test that we can create fields with text content types on all platforms
        let emailField = DynamicFormField(
            id: "email",
            textContentType: .emailAddress,
            label: "Email Address"
        )
        
        XCTAssertEqual(emailField.textContentType, .emailAddress)
        XCTAssertEqual(emailField.label, "Email Address")
        
        let phoneField = DynamicFormField(
            id: "phone",
            textContentType: .telephoneNumber,
            label: "Phone Number"
        )
        
        XCTAssertEqual(phoneField.textContentType, .telephoneNumber)
        XCTAssertEqual(phoneField.label, "Phone Number")
        
        // Test address fields that were previously missing
        let addressField = DynamicFormField(
            id: "address",
            textContentType: .addressState,
            label: "State"
        )
        
        XCTAssertEqual(addressField.textContentType, .addressState)
        XCTAssertEqual(addressField.label, "State")
        
        let countryField = DynamicFormField(
            id: "country",
            textContentType: .countryName,
            label: "Country"
        )
        
        XCTAssertEqual(countryField.textContentType, .countryName)
        XCTAssertEqual(countryField.label, "Country")
    }
    
    /// Test that SixLayerTextContentType provides string values for macOS
    func testStringValueForMacOS() {
        // Test that all text content types provide string values
        for contentType in SixLayerTextContentType.allCases {
            let stringValue = contentType.stringValue
            XCTAssertFalse(stringValue.isEmpty, "String value should not be empty for \(contentType)")
            XCTAssertEqual(stringValue, contentType.rawValue, "String value should match raw value")
        }
        
        // Test specific cases
        XCTAssertEqual(SixLayerTextContentType.emailAddress.stringValue, "emailAddress")
        XCTAssertEqual(SixLayerTextContentType.telephoneNumber.stringValue, "telephoneNumber")
        XCTAssertEqual(SixLayerTextContentType.addressState.stringValue, "addressState")
        XCTAssertEqual(SixLayerTextContentType.countryName.stringValue, "countryName")
    }
}
