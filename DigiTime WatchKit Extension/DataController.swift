//
//  DataController.swift
//  DigiTime WatchKit Extension
//
//  Created by Richard Kay on 18/06/2021.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    let defaults: UserDefaults
    
    var fullVersionUnlocked: Bool {
        get {
            defaults.bool(forKey: "fullVersionUnlocked")
        }
        
        set {
            defaults.set(newValue, forKey:  "fullVersionUnlocked")
        }
    }
    
    init(inMemory: Bool  = false, defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
}
