//
//  Persistence.swift
//  M.H. Tracker
//
//  Created by Zeynep Yilmazcoban on 4/19/23.
//

import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let calendar = Calendar.current
        for i in 0..<30 {
            let date = calendar.date(byAdding: DateComponents(day: -i), to: Date())
            let newItem = Journal(context: viewContext)
            newItem.journalText = "text"
            newItem.date = date
            
            let newTrackerItem = TrackerEntry(context: viewContext)
            newTrackerItem.mood = Int32(i % 11)
            newTrackerItem.sleep = Int32(i % 13)
            newTrackerItem.activity = Int32(6 - i % 7)
            newTrackerItem.id = UUID()
            newTrackerItem.date = date
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "M_H__Tracker")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }    
}

extension PersistenceController {
    func saveJournalEntry(text: String, date: Date = Date()) -> Journal? {
        let newJournalEntry = Journal(context: container.viewContext)
        newJournalEntry.date = date
        newJournalEntry.journalText = text
        
        do {
            try container.viewContext.save()
            return newJournalEntry
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
            return nil
        }
    }
    
    func addTrackerEntry(mood: Int, activity: Int, sleep: Int, date: Date) {
        do {
            // get the current calendar
            let calendar = Calendar.current
            // get the start of the day of the selected date
            let startDate = calendar.startOfDay(for: date)
            // get the start of the day after the selected date
            let endDate = calendar.date(byAdding: .day, value: 1, to: startDate, wrappingComponents: true)!
            // create a predicate to filter between start date and end date
            let predicate = NSPredicate(format: "date >= %@ AND date < %@", startDate as NSDate, endDate as NSDate)
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerEntry")
            fetchRequest.predicate = predicate
            
            if let match = try container.viewContext.fetch(fetchRequest) as? [TrackerEntry] {
                for entry in match {
                    container.viewContext.delete(entry)
                }
            }
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        let newTrackerEntry = TrackerEntry(context: container.viewContext)
        newTrackerEntry.mood = Int32(mood)
        newTrackerEntry.activity = Int32(activity)
        newTrackerEntry.sleep = Int32(sleep)
        newTrackerEntry.id = UUID()
        newTrackerEntry.date = date
        
        do {
            try container.viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteTrackerEntry(date: Date) {
        do {
            // get the current calendar
            let calendar = Calendar.current
            // get the start of the day of the selected date
            let startDate = calendar.startOfDay(for: date)
            // get the start of the day after the selected date
            let endDate = calendar.date(byAdding: .day, value: 1, to: startDate, wrappingComponents: true)!
            // create a predicate to filter between start date and end date
            let predicate = NSPredicate(format: "date >= %@ AND date < %@", startDate as NSDate, endDate as NSDate)
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerEntry")
            fetchRequest.predicate = predicate
            
            if let match = try container.viewContext.fetch(fetchRequest) as? [TrackerEntry] {
                for entry in match {
                    container.viewContext.delete(entry)
                }
            }
            
            try container.viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func getTrackerEntry(date: Date) -> TrackerEntry? {
        do {
            // get the current calendar
            let calendar = Calendar.current
            // get the start of the day of the selected date
            let startDate = calendar.startOfDay(for: date)
            // get the start of the day after the selected date
            let endDate = calendar.date(byAdding: .day, value: 1, to: startDate, wrappingComponents: true)!
            // create a predicate to filter between start date and end date
            let predicate = NSPredicate(format: "date >= %@ AND date < %@", startDate as NSDate, endDate as NSDate)
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerEntry")
            fetchRequest.predicate = predicate
            
            if let match = try container.viewContext.fetch(fetchRequest) as? [TrackerEntry] {
                print(match)
                return match.count > 0 ? match[0] : nil
            }
        } catch {
            
        }
        
        return nil
    }
    
    func clearAllData() {
        do {
            let allEntities = container.managedObjectModel.entitiesByName
            for (entity, _) in allEntities {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                if let match = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject] {
                    for entry in match {
                        container.viewContext.delete(entry)
                    }
                }
            }
            
            try container.viewContext.save()
        } catch {
            
        }
    }
}




            
