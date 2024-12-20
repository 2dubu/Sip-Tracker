//
//  SipTrackerApp.swift
//  SipTracker
//
//  Created by 이건우 on 11/7/24.
//

import SwiftUI
import SwiftData

@main
struct SipTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([DrinkRecord.self, User.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }
}
