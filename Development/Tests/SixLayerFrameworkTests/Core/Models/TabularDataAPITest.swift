import Testing


//
//  TabularDataAPITest.swift
//  SixLayerFrameworkTests
//
//  Test to understand TabularData API
//

import TabularData

final class TabularDataAPITest {
    
    @Test func testTabularDataAPI() throws {
        // Create a simple DataFrame to understand the API
        let nameColumn = Column(name: "name", contents: ["Alice", "Bob", "Charlie"])
        let ageColumn = Column(name: "age", contents: [25, 30, 35])
        var dataFrame = DataFrame()
        dataFrame.append(column: nameColumn)
        dataFrame.append(column: ageColumn)
        
        // Test what properties are available on AnyColumn
        for column in dataFrame.columns {
            print("Column name: \(column.name)")
            print("Column count: \(column.count)")
            print("Column type: \(type(of: column))")
            
            // Check if there are other ways to count nils
            let nonNilCount = column.compactMap { $0 }.count
            print("Non-nil count: \(nonNilCount)")
            
            // Check unique values (simplified)
            print("Total count: \(column.count)")
        }
    }
}
