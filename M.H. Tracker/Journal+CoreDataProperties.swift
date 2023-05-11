//
//  Journal+CoreDataProperties.swift
//  M.H. Tracker
//
//  Created by Zeynep Yilmazcoban on 4/19/23.
//
//

import Foundation
import CoreData


extension Journal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Journal> {
        return NSFetchRequest<Journal>(entityName: "Journal")
    }

    @NSManaged public var date: Date?
    @NSManaged public var journalText: String?

}

extension Journal : Identifiable {

}
