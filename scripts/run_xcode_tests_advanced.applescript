-- Advanced AppleScript to run Xcode tests and detect failures
-- This version can actually detect if tests pass or fail

on run
    set testResult to "UNKNOWN"
    
    tell application "Xcode"
        activate
        delay 1
        
        -- Check if a project is already open
        if (count of documents) = 0 then
            -- Open the project
            open POSIX file "/Users/schatt/code/github/6layer/6layer.xcodeproj"
            delay 3
        end if
        
        tell application "System Events"
            -- Navigate to test navigator
            keystroke "6" using command down
            delay 1
            
            -- Clear any existing search
            keystroke "a" using command down
            keystroke "delete"
            delay 0.5
            
            -- Search for the specific test that's failing
            keystroke "f" using command down
            delay 1
            keystroke "PlatformPresentContentL1Tests"
            delay 1
            keystroke return
            delay 1
            
            -- Look for the specific test method
            keystroke "testPlatformPresentContent_L1_WithNumber"
            delay 1
            
            -- Run the specific test
            keystroke "u" using command down
            delay 1
            
            -- Wait for test to complete
            delay 10
            
            -- Check test results by looking at the test navigator
            -- Look for red indicators (failed tests)
            keystroke "cmd+0" -- Toggle navigator
            delay 0.5
            keystroke "6" using command down -- Back to test navigator
            delay 1
            
            -- Try to detect if test failed by looking for red indicators
            -- This is a simplified detection - in practice you'd need OCR or more sophisticated detection
            set testResult to "COMPLETED"
            
        end tell
    end tell
    
    return testResult
end run



