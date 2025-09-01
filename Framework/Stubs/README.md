# SixLayer Framework Stubs

## Overview

These stub files provide working starting points for extending the SixLayer Framework's hints system. **Copy these files into your project** and modify them to suit your needs.

## How to Use

1. **Copy the stub files** you need into your project
2. **Modify the stubs** to match your application's requirements
3. **Import SixLayerFramework** in your modified stubs
4. **Use the framework functions** with your custom hints

## Available Stubs

### **Basic Hints**
- `BasicCustomHint.swift` - Simple custom hint implementation

### **E-commerce**
- `EcommerceProductHint.swift` - Product catalog hints

### **Business Applications**
- `FinancialDashboardHint.swift` - Financial data hints
- `TaskManagementHint.swift` - Task management hints
- `BlogPostHint.swift` - Content management hints

### **Media**
- `PhotoGalleryHint.swift` - Photo gallery hints

### **Utilities**
- `HintFactories.swift` - Factory methods for common hint patterns

### **Advanced Examples**
- `AdvancedExample.swift` - Complex hint system examples with multiple hint combinations

## Example Usage

```swift
// 1. Copy the stub files you need
// 2. Modify them for your use case
// 3. Use them in your views

import SixLayerFramework

struct MyProductView: View {
    let products: [Product]
    
    var body: some View {
        // Use your modified stub
        let hints = EnhancedPresentationHints.forEcommerceProducts(
            category: "electronics",
            showPricing: true,
            showReviews: true
        )
        
        return platformPresentItemCollection_L1(
            items: products,
            hints: hints
        )
    }
}
```

## Important Notes

- **These are starting points** - modify them for your specific needs
- **Don't commit these to the framework** - they're for users, not the framework
- **Test thoroughly** - ensure your hints work with your data and requirements
- **Follow naming conventions** - use reverse domain notation for hint types

## Support

For questions about extending the hints system, refer to:
- `docs/HintsSystemExtensibility.md` - Complete extensibility guide
- Framework source code - See how the system works internally
- GitHub issues - Report bugs or request features
