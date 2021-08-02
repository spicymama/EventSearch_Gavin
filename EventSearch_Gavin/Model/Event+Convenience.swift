//
//  Event+Convenience.swift
//  EventSearch_Gavin
//
//  Created by Gavin Woffinden on 7/31/21.
//


import UIKit
import CoreData

extension Event {
    convenience init(name: String, date: String, location: String, imageURL: String, isFavorite: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.date = date
        self.location = location
        self.imageURL = imageURL
        self.isFavorite = isFavorite
    }
}
