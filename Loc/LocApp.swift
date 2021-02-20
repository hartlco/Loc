//
//  LocApp.swift
//  Loc
//
//  Created by Martin Hartl on 20.02.21.
//

import SwiftUI

@main
struct LocApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
