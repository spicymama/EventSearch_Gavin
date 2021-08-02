//
//  CoreDataStack.swift
//  EventSearch_Gavin
//
//  Created by Gavin Woffinden on 7/31/21.
//

import Foundation
import CoreData

class CoreDataStack {
    static let container: NSPersistentContainer = {
        
        let EventCoreData = Bundle.main.object(forInfoDictionaryKey: (kCFBundleNameKey as String)) as! String
        let container = NSPersistentContainer(name: "EventSearch_Gavin")
        container.loadPersistentStores() { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext { return container.viewContext }
    static func saveContext() {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context \(error)")
            }
        }
    }
    
}//End of enum


