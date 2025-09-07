#!/usr/bin/env python3
import re

# Read the file
with open('Development/Tests/SixLayerFrameworkTests/OCRComprehensiveTests.swift', 'r') as f:
    content = f.read()

# Pattern 1: Fix textTypes parameter calls
pattern1 = r'let (\w+) = platformOCRWithVisualCorrection_L1\(\s*image: (\w+),\s*textTypes: (\[.*?\])\s*\) \{ (.*?) \}\s*XCTAssertNotNil\(\1\)'

def replace_texttypes_call(match):
    var_name = match.group(1)
    image_var = match.group(2)
    text_types = match.group(3)
    callback_body = match.group(4)
    
    # Create OCRContext
    context_code = f"""let context = OCRContext(
            textTypes: {text_types},
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let {var_name} = platformOCRWithVisualCorrection_L1(
            image: {image_var},
            context: context
        ) {{ {callback_body} }}
        
        XCTAssertNotNil({var_name})"""
    
    return context_code

# Pattern 2: Fix documentType parameter calls
pattern2 = r'let (\w+) = platformOCRWithVisualCorrection_L1\(\s*image: (\w+),\s*documentType: \.(\w+)\s*\) \{ (.*?) \}\s*XCTAssertNotNil\(\1\)'

def replace_documenttype_call(match):
    var_name = match.group(1)
    image_var = match.group(2)
    doc_type = match.group(3)
    callback_body = match.group(4)
    
    # Create OCRContext with appropriate text types based on document type
    text_types_map = {
        'receipt': '[.price, .number, .date]',
        'invoice': '[.price, .number, .date, .email]',
        'businessCard': '[.email, .phone, .address]',
        'form': '[.general, .email, .phone]'
    }
    
    text_types = text_types_map.get(doc_type, '[.general]')
    
    context_code = f"""let context = OCRContext(
            textTypes: {text_types},
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let {var_name} = platformOCRWithVisualCorrection_L1(
            image: {image_var},
            context: context
        ) {{ {callback_body} }}
        
        XCTAssertNotNil({var_name})"""
    
    return context_code

# Pattern 3: Fix simple textTypes calls without XCTAssertNotNil
pattern3 = r'let (\w+) = platformOCRWithVisualCorrection_L1\(\s*image: (\w+),\s*textTypes: (\[.*?\])\s*\) \{ (.*?) \}'

def replace_simple_texttypes_call(match):
    var_name = match.group(1)
    image_var = match.group(2)
    text_types = match.group(3)
    callback_body = match.group(4)
    
    # Create OCRContext
    context_code = f"""let context = OCRContext(
            textTypes: {text_types},
            language: .english,
            confidenceThreshold: 0.8,
            allowsEditing: true
        )
        
        let {var_name} = platformOCRWithVisualCorrection_L1(
            image: {image_var},
            context: context
        ) {{ {callback_body} }}"""
    
    return context_code

# Apply the replacements
content = re.sub(pattern1, replace_texttypes_call, content, flags=re.DOTALL)
content = re.sub(pattern2, replace_documenttype_call, content, flags=re.DOTALL)
content = re.sub(pattern3, replace_simple_texttypes_call, content, flags=re.DOTALL)

# Fix variable name references
content = content.replace('XCTAssertNotNil(ocrIntent)', 'XCTAssertNotNil(ocrView)')
content = content.replace('XCTAssertNotNil(analysisIntent)', 'XCTAssertNotNil(analysisView)')
content = content.replace('XCTAssertNotNil(receiptIntent)', 'XCTAssertNotNil(receiptView)')
content = content.replace('XCTAssertNotNil(invoiceIntent)', 'XCTAssertNotNil(invoiceView)')
content = content.replace('XCTAssertNotNil(businessCardIntent)', 'XCTAssertNotNil(businessCardView)')
content = content.replace('XCTAssertNotNil(formIntent)', 'XCTAssertNotNil(formView)')

# Write the updated content back
with open('Development/Tests/SixLayerFrameworkTests/OCRComprehensiveTests.swift', 'w') as f:
    f.write(content)

print("Updated OCR test function calls comprehensively")
