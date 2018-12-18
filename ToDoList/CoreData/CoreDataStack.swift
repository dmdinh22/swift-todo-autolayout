//
//  CoreDataStack.swift
//  ToDoList
//
//  Created by David D on 12/18/18.
//  Copyright © 2018 David D. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var container: NSPersistentContainer {
        let container = NSPersistentContainer(name: "Todos")
        // responsible for loading data model and setting up store to save data to disk
        container.loadPersistentStores { (description, error) in
            guard error == nil else {
                print("error: \(error!)")
                return
            }
        }
        return container
    }
    // manage (save/delete) collection of managed objects (todos)
    var manageContext: NSManagedObjectContext {
        return container.viewContext
    }
}
