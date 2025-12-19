//
//  TaskManagerApp.swift
//  TaskManagerSampleApp
//
//  Main app entry point
//

import SwiftUI
import SixLayerFramework

/// Main app demonstrating SixLayer Framework usage
@main
public struct TaskManagerApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            TaskListView()
        }
    }
}





