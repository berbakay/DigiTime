//
//  DigiTimeApp.swift
//  DigiTime WatchKit Extension
//
//  Created by Richard Kay on 01/05/2021.
//

import SwiftUI

@main
struct DigiTimeApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
