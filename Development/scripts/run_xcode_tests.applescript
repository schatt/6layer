-- AppleScript to run Xcode tests and catch SwiftUI rendering issues
-- This script will open Xcode, navigate to tests, and run them

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
        
        -- Search for the specific test that's failing
        keystroke "f" using command down
        delay 1
        keystroke "PlatformPresentContentL1Tests"
        delay 1
        keystroke return
        delay 1
        
        -- Select the specific test method
        keystroke "testPlatformPresentContent_L1_WithNumber"
        delay 1
        
        -- Run the specific test
        keystroke "u" using command down
        delay 1
        
        -- Wait for test to complete and show results
        delay 5
        
        -- Check if test failed (look for red indicators in navigator)
        -- This is a basic check - in practice you'd need more sophisticated detection
        keystroke "cmd+0" -- Show/hide navigator to refresh
        delay 1
        keystroke "6" using command down -- Back to test navigator
        delay 1
        
    end tell
end tell

-- Return status (this is a simplified version)
return "Test execution completed"




