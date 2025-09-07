#!/usr/bin/env python3
import re

# Read the file
with open('Development/Tests/SixLayerFrameworkTests/OCRComprehensiveTests.swift', 'r') as f:
    content = f.read()

# Pattern to match function calls with textTypes parameter
pattern = r'let (\w+) = platformOCRWithVisualCorrection_L1\(\s*image: (\w+),\s*textTypes: (\[.*?\])\s*\) \{ (.*?) \}\s*XCTAssertNotNil\(\1\)'

def replace_function_call(match):
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

# Apply the replacement
new_content = re.sub(pattern, replace_function_call, content, flags=re.DOTALL)

# Write the updated content back
with open('Development/Tests/SixLayerFrameworkTests/OCRComprehensiveTests.swift', 'w') as f:
    f.write(new_content)

print("Updated OCR test function calls")
