# Hints File OCR and Calculations Guide - v5.3.0

## Overview

**NEW in v5.3.0**: You can now define **OCR hints** and **calculation groups** directly in your `.hints` files! This extends the hints system to support intelligent OCR form-filling and automatic field calculations, all configured declaratively in JSON.

**Key Benefits:**
- **DRY**: Define OCR hints and calculations once in hints files, use everywhere
- **Internationalization**: Language-specific OCR hints with automatic fallback
- **Declarative**: All configuration in JSON, no code changes needed
- **Backward Compatible**: Existing hints files continue to work

## Quick Start

### Basic OCR Hints

Add `ocrHints` to any field in your hints file:

```json
{
  "gallons": {
    "expectedLength": 10,
    "displayWidth": "medium",
    "ocrHints": ["gallons", "gal", "fuel quantity", "liters", "litres"]
  }
}
```

### Basic Calculation Groups

Add `calculationGroups` to fields that can be calculated:

```json
{
  "total": {
    "expectedLength": 10,
    "calculationGroups": [
      {
        "id": "multiply",
        "formula": "total = price * quantity",
        "dependentFields": ["price", "quantity"],
        "priority": 1
      }
    ]
  }
}
```

### Combined OCR + Calculations

Combine both for intelligent form-filling:

```json
{
  "gallons": {
    "expectedLength": 10,
    "ocrHints": ["gallons", "gal", "fuel quantity"],
    "calculationGroups": [
      {
        "id": "from_price_total",
        "formula": "gallons = total_price / price_per_gallon",
        "dependentFields": ["total_price", "price_per_gallon"],
        "priority": 1
      }
    ]
  }
}
```

## OCR Hints

### Purpose

OCR hints are **keywords** that help the OCR system identify which text regions in a scanned document belong to which form fields. This dramatically improves OCR accuracy, especially for complex documents with multiple numeric values.

### Format

OCR hints can be specified as:
- **Array of strings** (recommended): `["gallons", "gal", "fuel quantity"]`
- **Comma-separated string**: `"gallons,gal,fuel quantity"`

### Example: Fuel Receipt Form

**FuelReceipt.hints**:
```json
{
  "gallons": {
    "expectedLength": 10,
    "displayWidth": "medium",
    "ocrHints": ["gallons", "gal", "fuel quantity", "liters", "litres"]
  },
  "pricePerGallon": {
    "expectedLength": 10,
    "displayWidth": "medium",
    "ocrHints": ["price per gallon", "price/gal", "ppg", "per gallon"]
  },
  "totalPrice": {
    "expectedLength": 10,
    "displayWidth": "medium",
    "ocrHints": ["total", "total price", "amount", "sum"]
  }
}
```

### How It Works

1. **OCR extracts text** from scanned document
2. **Framework searches** for OCR hint keywords in the text
3. **Maps text regions** to form fields based on keyword matches
4. **Populates form** with recognized values

### Best Practices

1. **Include variations**: Add common abbreviations, plurals, and synonyms
   ```json
   "ocrHints": ["gallons", "gal", "gals", "fuel quantity", "liters", "litres"]
   ```

2. **Use descriptive phrases**: Include multi-word phrases that appear in documents
   ```json
   "ocrHints": ["price per gallon", "price/gal", "ppg", "cost per gallon"]
   ```

3. **Order by frequency**: Put most common terms first
   ```json
   "ocrHints": ["total", "total price", "grand total", "amount due"]
   ```

## Calculation Groups

### Purpose

Calculation groups define **mathematical relationships** between form fields. When OCR extracts partial data, the framework can automatically calculate missing field values using these relationships.

### Format

Each calculation group requires:
- **`id`** (string): Unique identifier for this calculation
- **`formula`** (string): Mathematical formula (e.g., `"total = price * quantity"`)
- **`dependentFields`** (array): Field IDs this calculation depends on
- **`priority`** (number): Lower numbers = higher priority (used for conflict resolution)

### Example: Invoice Form

**Invoice.hints**:
```json
{
  "price": {
    "expectedLength": 10,
    "displayWidth": "medium",
    "ocrHints": ["price", "unit price", "cost"]
  },
  "quantity": {
    "expectedLength": 10,
    "displayWidth": "medium",
    "ocrHints": ["quantity", "qty", "amount"]
  },
  "subtotal": {
    "expectedLength": 10,
    "displayWidth": "medium",
    "ocrHints": ["subtotal", "sub-total", "before tax"]
  },
  "tax": {
    "expectedLength": 10,
    "displayWidth": "medium",
    "ocrHints": ["tax", "sales tax", "VAT"]
  },
  "total": {
    "expectedLength": 10,
    "displayWidth": "medium",
    "ocrHints": ["total", "grand total", "amount due"],
    "calculationGroups": [
      {
        "id": "multiply",
        "formula": "total = price * quantity",
        "dependentFields": ["price", "quantity"],
        "priority": 1
      },
      {
        "id": "add_tax",
        "formula": "total = subtotal + tax",
        "dependentFields": ["subtotal", "tax"],
        "priority": 2
      }
    ]
  }
}
```

### How It Works

1. **OCR extracts available values** from document
2. **Framework identifies missing fields** that have calculation groups
3. **Runs calculations** using available dependent fields
4. **Resolves conflicts** if multiple calculations produce different results (uses priority)
5. **Provides confidence scores** for calculated values

### Priority System

- **Lower priority = Higher precedence**
- Priority 1 > Priority 2 > Priority 3
- Used when multiple calculation groups produce different results

**Example**:
```json
{
  "total": {
    "calculationGroups": [
      {
        "id": "primary_method",
        "formula": "total = price * quantity",
        "dependentFields": ["price", "quantity"],
        "priority": 1  // Highest priority
      },
      {
        "id": "fallback_method",
        "formula": "total = subtotal + tax",
        "dependentFields": ["subtotal", "tax"],
        "priority": 2  // Lower priority (fallback)
      }
    ]
  }
}
```

### Best Practices

1. **Use descriptive IDs**: Make calculation group IDs meaningful
   ```json
   "id": "from_price_total"  // ✅ Good
   "id": "calc1"            // ❌ Avoid
   ```

2. **Order by priority**: List higher priority calculations first
3. **Validate formulas**: Ensure formulas use valid field IDs
4. **Handle edge cases**: Consider division by zero, negative values, etc.

## Internationalization

### Language-Specific OCR Hints

**NEW in v5.3.0**: Support for language-specific OCR hints with automatic fallback!

### Format

Use language-specific keys: `ocrHints.{languageCode}`

```json
{
  "gallons": {
    "expectedLength": 10,
    "ocrHints": ["gallons", "gal"],  // Default/fallback (English)
    "ocrHints.es": ["galones", "gal"],  // Spanish
    "ocrHints.fr": ["gallons", "litres"],  // French
    "ocrHints.de": ["gallonen", "liter"]  // German
  }
}
```

### Fallback Chain

The framework uses this fallback order:
1. **`ocrHints.{currentLanguage}`** (e.g., `ocrHints.es` for Spanish)
2. **`ocrHints`** (default/fallback)
3. **`nil`** (no OCR hints)

### Example: Multi-Language Receipt Form

**Receipt.hints**:
```json
{
  "total": {
    "expectedLength": 10,
    "displayWidth": "medium",
    "ocrHints": ["total", "amount due", "grand total"],
    "ocrHints.es": ["total", "importe debido", "total general"],
    "ocrHints.fr": ["total", "montant dû", "total général"],
    "ocrHints.de": ["gesamt", "fälliger Betrag", "Gesamtsumme"]
  },
  "tax": {
    "expectedLength": 10,
    "displayWidth": "medium",
    "ocrHints": ["tax", "sales tax", "VAT"],
    "ocrHints.es": ["impuesto", "IVA", "impuesto sobre ventas"],
    "ocrHints.fr": ["taxe", "TVA", "taxe sur les ventes"],
    "ocrHints.de": ["Steuer", "MwSt", "Umsatzsteuer"]
  }
}
```

### Usage

The framework automatically uses the correct language based on the current locale:

```swift
// Spanish locale - uses ocrHints.es
let loader = FileBasedDataHintsLoader()
let result = loader.loadHintsResult(for: "Receipt", locale: Locale(identifier: "es"))
// result.fieldHints["total"]?.ocrHints == ["total", "importe debido", "total general"]

// French locale - uses ocrHints.fr
let result = loader.loadHintsResult(for: "Receipt", locale: Locale(identifier: "fr"))
// result.fieldHints["total"]?.ocrHints == ["total", "montant dû", "total général"]

// English locale (or no language-specific hints) - uses ocrHints
let result = loader.loadHintsResult(for: "Receipt", locale: Locale(identifier: "en"))
// result.fieldHints["total"]?.ocrHints == ["total", "amount due", "grand total"]
```

### Backward Compatibility

**Existing hints files continue to work!** If you only have `ocrHints` (no language-specific keys), the framework uses that for all locales.

```json
{
  "total": {
    "ocrHints": ["total", "amount due"]  // Works for all languages
  }
}
```

## Complete Example: Fuel Receipt Form

**FuelReceipt.hints**:
```json
{
  "gallons": {
    "expectedLength": 10,
    "displayWidth": "medium",
    "maxLength": 20,
    "ocrHints": ["gallons", "gal", "fuel quantity", "liters", "litres"],
    "ocrHints.es": ["galones", "gal", "cantidad de combustible", "litros"],
    "ocrHints.fr": ["gallons", "litres", "quantité de carburant"],
    "calculationGroups": [
      {
        "id": "from_price_total",
        "formula": "gallons = total_price / price_per_gallon",
        "dependentFields": ["total_price", "price_per_gallon"],
        "priority": 1
      }
    ]
  },
  "pricePerGallon": {
    "expectedLength": 10,
    "displayWidth": "medium",
    "ocrHints": ["price per gallon", "price/gal", "ppg", "per gallon"],
    "ocrHints.es": ["precio por galón", "precio/gal", "ppg"],
    "ocrHints.fr": ["prix par gallon", "prix/gal", "ppg"]
  },
  "totalPrice": {
    "expectedLength": 10,
    "displayWidth": "medium",
    "ocrHints": ["total", "total price", "amount", "sum"],
    "ocrHints.es": ["total", "precio total", "importe", "suma"],
    "ocrHints.fr": ["total", "prix total", "montant", "somme"],
    "calculationGroups": [
      {
        "id": "multiply",
        "formula": "total_price = gallons * price_per_gallon",
        "dependentFields": ["gallons", "price_per_gallon"],
        "priority": 1
      }
    ]
  },
  "_sections": [
    {
      "id": "fuel_data",
      "title": "Fuel Information",
      "fields": ["gallons", "pricePerGallon", "totalPrice"],
      "layoutStyle": "vertical"
    }
  ]
}
```

## Integration with Code

### Applying Hints to Fields

The framework automatically applies hints when you use `modelName`:

```swift
let fields = [
    DynamicFormField(
        id: "gallons",
        contentType: .number,
        label: "Gallons"
    ),
    DynamicFormField(
        id: "totalPrice",
        contentType: .number,
        label: "Total Price"
    )
]

// Hints are automatically loaded and applied!
platformPresentFormData_L1(
    fields: fields,
    hints: EnhancedPresentationHints(
        dataType: .form,
        context: .create
    ),
    modelName: "FuelReceipt"  // Loads FuelReceipt.hints automatically
)
```

### Manual Application

You can also apply hints manually:

```swift
let loader = FileBasedDataHintsLoader()
let result = loader.loadHintsResult(for: "FuelReceipt", locale: Locale.current)

// Apply hints to fields
let fieldsWithHints = fields.map { field in
    if let hints = result.fieldHints[field.id] {
        return field.applying(hints: hints)
    }
    return field
}
```

## Migration Guide

### From Code-Based OCR Hints

**Before (v5.2.0)**:
```swift
let field = DynamicFormField(
    id: "gallons",
    contentType: .number,
    label: "Gallons",
    supportsOCR: true,
    ocrHints: ["gallons", "gal", "fuel quantity"]
)
```

**After (v5.3.0)**:
```json
// FuelReceipt.hints
{
  "gallons": {
    "ocrHints": ["gallons", "gal", "fuel quantity"]
  }
}
```

```swift
// Code - hints applied automatically!
let field = DynamicFormField(
    id: "gallons",
    contentType: .number,
    label: "Gallons"
)
// Use modelName to load hints
```

### From Code-Based Calculation Groups

**Before (v5.2.0)**:
```swift
let field = DynamicFormField(
    id: "total",
    contentType: .number,
    label: "Total",
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

**After (v5.3.0)**:
```json
// Invoice.hints
{
  "total": {
    "calculationGroups": [
      {
        "id": "multiply",
        "formula": "total = price * quantity",
        "dependentFields": ["price", "quantity"],
        "priority": 1
      }
    ]
  }
}
```

## Best Practices

### 1. Organize by Model

Create separate hints files for each data model:
- `FuelReceipt.hints` - Fuel receipt forms
- `Invoice.hints` - Invoice forms
- `ExpenseReport.hints` - Expense reports

### 2. Use Descriptive IDs

Make calculation group IDs meaningful:
```json
"id": "from_price_total"  // ✅ Good - describes the calculation
"id": "calc1"            // ❌ Avoid - not descriptive
```

### 3. Include Common Variations

Add common abbreviations and synonyms to OCR hints:
```json
"ocrHints": ["total", "total price", "grand total", "amount due", "sum", "total amount"]
```

### 4. Test Language-Specific Hints

Verify OCR hints work for all supported languages:
```json
"ocrHints": ["total"],  // Default
"ocrHints.es": ["total", "importe"],  // Spanish
"ocrHints.fr": ["total", "montant"]   // French
```

### 5. Validate Calculation Formulas

Ensure formulas reference valid field IDs:
```json
{
  "total": {
    "calculationGroups": [
      {
        "formula": "total = price * quantity",  // ✅ price and quantity must exist
        "dependentFields": ["price", "quantity"]
      }
    ]
  }
}
```

## Related Documentation

- **[Field Hints Guide](FieldHintsGuide.md)** - Complete field hints reference
- **[Calculation Groups Guide](CalculationGroupsGuide.md)** - Advanced calculation features
- **[OCR Field Hints Guide](OCRFieldHintsGuide.md)** - OCR recognition patterns
- **[Hints DRY Architecture](HintsDRYArchitecture.md)** - Hints system architecture

## Summary

**v5.3.0** brings OCR hints and calculation groups to hints files:

✅ **OCR Hints**: Define keywords for better OCR field identification  
✅ **Calculation Groups**: Define mathematical relationships between fields  
✅ **Internationalization**: Language-specific OCR hints with automatic fallback  
✅ **Backward Compatible**: Existing hints files continue to work  
✅ **DRY**: Define once in hints files, use everywhere  

All configuration is declarative in JSON - no code changes needed!

