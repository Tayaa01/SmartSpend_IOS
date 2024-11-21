//
//  SMARTSPENDApp.swift
//  SMARTSPEND
//
//  Created by yassmine zammali on 20/11/2024.
//

import SwiftUI

@main
struct SMARTSPENDApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
