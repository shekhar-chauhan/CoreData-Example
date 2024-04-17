//
//  CoreData_ExampleApp.swift
//  CoreData Example
//
//  Created by Shekhar Chauhan on 4/17/24.
//

import SwiftUI

@main
struct CoreData_ExampleApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
