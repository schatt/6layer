# SixLayer Framework Examples

## Overview

This folder contains example types and implementations that demonstrate how to use the SixLayer Framework. These are **example implementations** that you can copy and modify for your own use cases.

## Available Examples

### **GenericTypes.swift**
Example types showing how to create custom data structures that work with the framework:

- **GenericVehicle**: Example vehicle type with CardDisplayable conformance
- **GenericDataItem**: Generic container for any identifiable data
- **VehicleType**: Enumeration for vehicle categorization

## How to Use Examples

1. **Copy the example files** you need into your project
2. **Modify the examples** to match your application's requirements
3. **Import SixLayerFramework** in your modified examples
4. **Use the framework functions** with your custom types

## Example Usage

```swift
import SixLayerFramework

// Copy GenericVehicle and modify for your needs
struct MyProduct: Identifiable, CardDisplayable {
    let id = UUID()
    let name: String
    let price: Double
    let category: String
    
    // Implement CardDisplayable protocol
    var cardTitle: String { name }
    var cardSubtitle: String? { category }
    var cardDescription: String? { "$\(price)" }
    var cardColor: Color? { .blue }
}

// Use with framework
let products = [MyProduct(name: "Widget", price: 19.99, category: "Tools")]
let hints = EnhancedPresentationHints.forEcommerceProducts(...)

return platformPresentItemCollection_L1(
    items: products,
    hints: hints
)
```

## Important Notes

- **These are examples** - modify them for your specific needs
- **Don't commit these to the framework** - they're for reference only
- **Test thoroughly** - ensure your types work with your data and requirements
- **Follow naming conventions** - use appropriate naming for your domain

## Framework Integration

These examples show how to:
- Implement `Identifiable` protocol
- Implement `CardDisplayable` protocol
- Work with the platform presentation functions
- Handle generic data in collections
- Create type-safe enums for categorization

## Support

For questions about using these examples:
- Check the main framework documentation
- Look at the framework source code for more patterns
- Refer to the test files for usage examples
