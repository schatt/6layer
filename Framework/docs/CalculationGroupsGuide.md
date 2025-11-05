# 🤖 **Calculation Groups Guide - Advanced OCR Form Intelligence**

*Advanced mathematical relationship processing for intelligent OCR form-filling with conflict resolution.*

## 🎯 **Overview**

Calculation Groups enable **intelligent form-filling** where the system can calculate missing field values from partial OCR data using mathematical relationships. Unlike simple single-field calculations, this system supports:

- **Multiple calculation paths** for the same field
- **Priority-based conflict resolution**
- **Data quality assurance** through confidence scoring
- **Complex form relationships** across multiple fields

## 📋 **Key Concepts**

### **Calculation Groups**
Fields can belong to multiple calculation groups, each defining a mathematical relationship and priority level.

### **Priority System**
- Lower priority numbers = Higher precedence
- Priority 1 > Priority 2 > Priority 3
- Used for conflict resolution when multiple calculations disagree

### **Confidence Levels**
- **High Confidence**: Single calculation or multiple agreeing calculations
- **Very Low Confidence**: Multiple calculations that produce different results

## 🚀 **Quick Start**

### **Basic Usage**
```swift
let field = DynamicFormField(
    id: "total",
    contentType: .number,
    label: "Total Amount",
    calculationGroups: [
        CalculationGroup(
            id: "multiply",
            formula: "total = price * quantity",
            dependentFields: ["price", "quantity"],
            priority: 1
        )
    ]
)

// With OCR data: price=10, quantity=5
// System calculates: total = 10 * 5 = 50 (high confidence)
```

### **Multiple Groups with Conflict Resolution**
```swift
let field = DynamicFormField(
    id: "total",
    contentType: .number,
    label: "Total Amount",
    calculationGroups: [
        CalculationGroup(
            id: "multiply",
            formula: "total = price * quantity",
            dependentFields: ["price", "quantity"],
            priority: 1
        ),
        CalculationGroup(
            id: "add_tax",
            formula: "total = subtotal + tax",
            dependentFields: ["subtotal", "tax"],
            priority: 2
        )
    ]
)

// With OCR data: price=10, quantity=5, subtotal=50, tax=5
// Group 1 calculates: total = 10 * 5 = 50
// Group 2 calculates: total = 50 + 5 = 55
// Result: total = 50 (highest priority) with VERY LOW confidence (conflict detected)
```

## 📖 **Detailed API Reference**

### **CalculationGroup Struct**
```swift
public struct CalculationGroup {
    public let id: String                    // Unique identifier
    public let formula: String               // Mathematical formula (e.g., "total = price * quantity")
    public let dependentFields: [String]     // Field IDs this formula depends on
    public let priority: Int                 // Calculation priority (lower = higher priority)

    public init(id: String, formula: String, dependentFields: [String], priority: Int)
}
```

### **CalculationConfidence Enum**
```swift
public enum CalculationConfidence {
    case high       // Single calculation or multiple agreeing calculations
    case medium     // Some uncertainty but generally reliable
    case veryLow    // Multiple calculations produced conflicting results
}
```

### **GroupCalculationResult Struct**
```swift
public struct GroupCalculationResult {
    public let calculatedValue: Double       // The calculated value
    public let confidence: CalculationConfidence // Confidence level
    public let usedGroupId: String?          // ID of the calculation group used (for high confidence single calculations)
}
```

### **DynamicFormField Properties**
```swift
public struct DynamicFormField {
    // ... existing properties ...

    // NEW: Calculation groups for this field
    public let calculationGroups: [CalculationGroup]?

    // NEW: OCR keyword hints for field identification
    public let ocrHints: [String]?
}
```

### **DynamicFormState Methods**
```swift
public class DynamicFormState {
    // Calculate field value using calculation groups with conflict resolution
    public func calculateFieldFromGroups(
        fieldId: String,
        calculationGroups: [CalculationGroup]
    ) -> GroupCalculationResult?
}
```

## 🎯 **Usage Patterns**

### **Pattern 1: Fuel Receipt Calculation**
```swift
// Fuel receipt: gallons, price_per_gallon, total_price
let gallonsField = DynamicFormField(
    id: "gallons",
    contentType: .number,
    label: "Gallons",
    calculationGroups: [
        CalculationGroup(
            id: "from_price_total",
            formula: "gallons = total_price / price_per_gallon",
            dependentFields: ["total_price", "price_per_gallon"],
            priority: 1
        )
    ]
)

let pricePerGallonField = DynamicFormField(
    id: "price_per_gallon",
    contentType: .number,
    label: "Price per Gallon",
    calculationGroups: [
        CalculationGroup(
            id: "from_gallons_total",
            formula: "price_per_gallon = total_price / gallons",
            dependentFields: ["total_price", "gallons"],
            priority: 1
        )
    ]
)

let totalPriceField = DynamicFormField(
    id: "total_price",
    contentType: .number,
    label: "Total Price",
    calculationGroups: [
        CalculationGroup(
            id: "from_gallons_price",
            formula: "total_price = gallons * price_per_gallon",
            dependentFields: ["gallons", "price_per_gallon"],
            priority: 1
        )
    ]
)

// OCR finds: gallons=15.5, total_price=47.93
// System calculates: price_per_gallon = 47.93 / 15.5 = 3.092
```

### **Pattern 2: Invoice with Tax Calculation**
```swift
let totalField = DynamicFormField(
    id: "total",
    contentType: .number,
    label: "Total Amount",
    calculationGroups: [
        CalculationGroup(
            id: "subtotal_plus_tax",
            formula: "total = subtotal + tax",
            dependentFields: ["subtotal", "tax"],
            priority: 1
        ),
        CalculationGroup(
            id: "subtotal_with_tax_rate",
            formula: "total = subtotal * (1 + tax_rate)",
            dependentFields: ["subtotal", "tax_rate"],
            priority: 2
        ),
        CalculationGroup(
            id: "quantity_times_price",
            formula: "total = quantity * unit_price",
            dependentFields: ["quantity", "unit_price"],
            priority: 3
        )
    ]
)
```

### **Pattern 3: Complex Business Rules**
```swift
let discountField = DynamicFormField(
    id: "discount_amount",
    contentType: .number,
    label: "Discount Amount",
    calculationGroups: [
        CalculationGroup(
            id: "percentage_discount",
            formula: "discount_amount = subtotal * discount_percentage",
            dependentFields: ["subtotal", "discount_percentage"],
            priority: 1
        ),
        CalculationGroup(
            id: "fixed_discount",
            formula: "discount_amount = fixed_discount_value",
            dependentFields: ["fixed_discount_value"],
            priority: 2
        ),
        CalculationGroup(
            id: "tiered_discount",
            formula: "discount_amount = quantity >= 10 ? subtotal * 0.1 : quantity >= 5 ? subtotal * 0.05 : 0",
            dependentFields: ["subtotal", "quantity"],
            priority: 3
        )
    ]
)
```

## 🔧 **Formula Syntax**

### **Supported Operations**
- **Arithmetic**: `+`, `-`, `*`, `/`
- **Parentheses**: `(`, `)` for grouping
- **Field References**: Use field IDs directly (e.g., `price`, `quantity`)
- **Assignment**: `field_name = expression`

### **Formula Examples**
```swift
// Basic arithmetic
"total = price * quantity"

// With parentheses
"discounted_total = (subtotal - discount) * (1 + tax_rate)"

// Complex business logic
"final_price = base_price + (shipping_weight * shipping_rate) + (insurance_value * 0.02)"
```

### **Field Dependencies**
Dependencies are automatically extracted from formulas, but you must explicitly list them in `dependentFields`:

```swift
CalculationGroup(
    id: "complex_calc",
    formula: "result = (a + b) * c / d",  // Uses fields: a, b, c, d
    dependentFields: ["a", "b", "c", "d"], // Must list ALL dependencies
    priority: 1
)
```

## ⚠️ **Conflict Resolution Strategy**

### **Priority-Based Resolution**
1. **Sort groups by priority** (lower numbers first)
2. **Calculate values** in priority order
3. **Check for conflicts** among calculated values
4. **Return result** with appropriate confidence level

### **Confidence Logic**
```swift
if calculatedResults.count == 1 {
    return .high  // Single calculation
} else if allResultsAgree {
    return .high  // Multiple groups agree
} else {
    return .veryLow  // Groups disagree - data inconsistency
}
```

### **Handling Conflicts**
When conflicts occur, the system:
- Uses the **highest priority** (lowest number) result
- Marks confidence as **very low** to flag data quality issues
- Forces user review of potentially incorrect data

## 🧪 **Testing with Calculation Groups**

### **Basic Testing Pattern**
```swift
@Test func testCalculationGroupsBasicFunctionality() {
    let formState = DynamicFormState(configuration: config)

    // Set up field with calculation groups
    let field = DynamicFormField(
        id: "result",
        contentType: .number,
        label: "Result",
        calculationGroups: [
            CalculationGroup(
                id: "multiply",
                formula: "result = a * b",
                dependentFields: ["a", "b"],
                priority: 1
            )
        ]
    )

    // Set input values
    formState.setValue(3.0, for: "a")
    formState.setValue(4.0, for: "b")

    // Test calculation
    let result = formState.calculateFieldFromGroups(
        fieldId: "result",
        calculationGroups: field.calculationGroups!
    )

    #expect(result?.calculatedValue == 12.0)
    #expect(result?.confidence == .high)
}
```

### **Conflict Testing**
```swift
@Test func testCalculationGroupsConflictResolution() {
    let formState = DynamicFormState(configuration: config)

    let groups = [
        CalculationGroup(id: "high", formula: "x = 10", dependentFields: [], priority: 1),
        CalculationGroup(id: "low", formula: "x = 20", dependentFields: [], priority: 2)
    ]

    let result = formState.calculateFieldFromGroups(
        fieldId: "x",
        calculationGroups: groups
    )

    #expect(result?.calculatedValue == 10.0)  // Highest priority wins
    #expect(result?.confidence == .veryLow)   // But conflict detected
}
```

## 🎯 **Best Practices**

### **Design Principles**
1. **Single Responsibility**: Each calculation group should have one clear mathematical relationship
2. **Priority Logic**: Higher priority (lower numbers) for more reliable calculations
3. **Dependency Clarity**: Explicitly list all field dependencies
4. **Formula Simplicity**: Keep formulas focused and understandable

### **Performance Considerations**
1. **Dependency Ordering**: Calculate independent groups first to enable dependent calculations
2. **Conflict Prevention**: Design formulas that shouldn't conflict in normal business scenarios
3. **Validation**: Always validate calculated results against business rules

### **Error Handling**
1. **Missing Dependencies**: Groups with missing dependencies are skipped
2. **Invalid Formulas**: Malformed formulas return nil
3. **Division by Zero**: Protected against runtime mathematical errors

## 🔄 **Integration with OCR**

### **OCR Processing Flow**
1. **Extract text** from scanned document
2. **Map to fields** using `ocrHints` keywords
3. **Populate available values** in form state
4. **Run calculation groups** to fill missing fields
5. **Flag confidence issues** for user review

### **Combined Usage Example**
```swift
let fuelForm = DynamicFormConfiguration(
    id: "fuel_receipt",
    title: "Fuel Receipt",
    sections: [
        DynamicFormSection(id: "fuel_data", title: "Fuel Information", fields: [
            DynamicFormField(
                id: "gallons",
                contentType: .number,
                label: "Gallons",
                supportsOCR: true,
                ocrHints: ["gallons", "gal", "fuel quantity", "liters", "litres"],
                calculationGroups: [
                    CalculationGroup(
                        id: "from_price_total",
                        formula: "gallons = total_price / price_per_gallon",
                        dependentFields: ["total_price", "price_per_gallon"],
                        priority: 1
                    )
                ]
            ),
            // ... other fields
        ])
    ]
)
```

## 📚 **Related Documentation**

- **[OCR Field Hints Guide](OCRFieldHintsGuide.md)** - Improving OCR recognition accuracy
- **[Dynamic Forms Guide](DynamicFormsGuide.md)** - Complete form configuration
- **[AI Agent Guide](AI_AGENT_GUIDE.md)** - Framework usage for AI assistants

## 🎯 **Migration from Simple Calculations**

### **From Single Formulas**
```swift
// Old: Simple single calculation
let field = DynamicFormField(
    id: "total",
    calculationFormula: "price * quantity",
    calculationDependencies: ["price", "quantity"]
)

// New: Calculation groups (more powerful)
let field = DynamicFormField(
    id: "total",
    calculationGroups: [
        CalculationGroup(
            id: "multiply",
            formula: "total = price * quantity",
            dependentFields: ["price", "quantity"],
            priority: 1
        )
    ]
)
```

### **Backward Compatibility**
Existing `calculationFormula` and `calculationDependencies` properties are still supported for simple cases, but calculation groups provide much more power and flexibility.

---

*This guide covers the advanced calculation groups system introduced in SixLayer v5.0.0 for intelligent OCR form-filling with mathematical relationship processing and conflict resolution.*
