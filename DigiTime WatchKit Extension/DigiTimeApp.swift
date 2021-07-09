//
//  DigiTimeApp.swift
//  DigiTime WatchKit Extension
//
//  Created by Richard Kay on 01/05/2021.
//

import SwiftUI

@main
struct DigiTimeApp: App {
    @StateObject var dataController: DataController
    @StateObject var unlockManager: UnlockManager
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(dataController: dataController)
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(dataController)
                    .environmentObject(unlockManager)
            }
        }
    }
    
    init() {
        let dataController = DataController()
        let unlockManager = UnlockManager(dataController: dataController)
        _dataController = StateObject(wrappedValue: dataController)
        _unlockManager = StateObject(wrappedValue: unlockManager)
    }
}
