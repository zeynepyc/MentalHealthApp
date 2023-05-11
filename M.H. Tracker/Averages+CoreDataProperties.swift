//
//  Averages+CoreDataProperties.swift
//  M.H. Tracker
//
//  Created by Zeynep Yilmazcoban on 4/19/23.
//
//

import Foundation
import CoreData


extension Averages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Averages> {
        return NSFetchRequest<Averages>(entityName: "Averages")
    }

    @NSManaged public var mood: Int32
    @NSManaged public var activity: Int32
    @NSManaged public var sleep: Int32

}

extension Averages : Identifiable {

}
