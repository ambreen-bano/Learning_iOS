//
//  Model.swift
//  CoreData_Learning
//
//  Created by Ambreen Bano on 20/08/25.
//

import Foundation
import CoreData


/*
 Entities (xcdatamodeld)
 ↓
 NSManagedObject subclasses (Note etc.)
 ↓
 NSManagedObjectContext (work area in memory)
 ↓
 NSPersistentStoreCoordinator
 ↓
 Persistent Store (SQLite file on disk (default), in-memory (RAM), custom binary format)
 

 CRUD - Create Read Update Delete
 
 
 How to write or add Entity Class-
 Select Entity from CoreDataNotesModel.xcdatamodeld class -> Editor -> create NSManagedObject class
 It will automatically create Entity Note class as shown below. We don't need to write manually
 We can write extension EntityName { } if want to customize Entity.
 
 @objc(Note)
 class Note: NSManagedObject {
     @NSManaged var noteText: String
     @NSManaged var createdDate: Date
 }
 */




/*CoreData Stack Class*/
class CoreDataModelStack {
    
    static let shared = CoreDataModelStack()
    let context: NSManagedObjectContext
    let BackgroundContext : NSManagedObjectContext
    
    private init() {
        //1. Create Container for Persistent Store
        //NSPersistentContainer creates a SQLite persistent store.(permanent storage)
        let container: NSPersistentContainer = NSPersistentContainer(name: "CoreDataNotesModel")
        
        /*2. Set Persistent Store Type
        Types of Persistent Stores
        
        Core Data supports multiple storage types (via NSPersistentStore subclasses):
        
        SQLite Store (Default)-
        Data is saved into a SQLite database file (.sqlite).
        Efficient for large datasets.
        Data exists when the app closes/Quit/Terminated. (chat App, notes app, todo list, banking app, fitness tracker)
        Default when you use NSPersistentContainer.
        
        Binary Store-
        Data saved in a custom binary format.
        Rarely used now.
        
        In-Memory Store-
        Data exists only in RAM.
        Disappears when the app closes. Data vanishes when app terminates.
        Good for testing or temporary caches (Search results that don’t need to persis).*/
        
        
        
        // A. Tell Core Data: use In-Memory store instead of SQLite(Default).
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        //B. If we are not setting persistentStoreDescriptions then, it will be default SQLite
        
        
        /*3. Load persistent Store
        This actually loads the SQLite database (or in-memory store, depending on your description) into the container.*/
        container.loadPersistentStores { storeDescription, error in
            if let _ = error {
                print("Data Loading Error")
            }
        }
        
        
        /* 4. Set context (it is a workplace or managed object context, where we are doing CRUD operations)
        Types of Contexts
        
        Main thread context -
        Perfect for UI updates (e.g., showing data in UITableView or SwiftUI).
        Not thread-safe, only use on the main queue.
        
        Background contexts -
        Created with container.newBackgroundContext()
        Used for heavy work (batch inserts, imports, cleanup).
        Runs off the background thread so UI doesn’t freeze.
        eg. inserting or updating 10,000 records. use backgroundContext so UI will not freeze
         let _ = container.newBackgroundContext()
         */
        
        //A. Main thread context
        context = container.viewContext
        //Main thread ViewContext start listening saves of Background thread context 
        context.automaticallyMergesChangesFromParent = true
        
        //B. Background thread context
        BackgroundContext = container.newBackgroundContext()
        
        /* CRASH can happen when we create Note objects in a background context (BG thread). And Later, when trying to delete/Edit them from the main context (viewContext).
        Because the objects created in the background context aren’t the same instances in the main context. Hence the crash. */
    }
}

