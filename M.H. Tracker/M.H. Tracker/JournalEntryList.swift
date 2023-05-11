//
//  JournalEntryList.swift
//  M.H. Tracker
//
//  Created by Zeynep Yilmazcoban on 4/19/23.
//

/*import Foundation

struct JournalEntry: Equatable, Encodable, Decodable, Identifiable, Comparable {
    var id = UUID()
    var entry: String
    var date: Date
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.entry == rhs.entry && lhs.date == rhs.date
    }
    
    static func <(lhs: Self, rhs: Self) -> Bool {
        return rhs.date < lhs.date
    }
    
    static func example() -> [JournalEntry] {
        return [
            JournalEntry(entry: "test 1", date: Calendar.current.date(from: DateComponents(year: 2018, month: 5, day: 22))!),
            JournalEntry(entry: "test 2", date: Calendar.current.date(byAdding: Calendar.Component.day, value: -1, to: Date.now, wrappingComponents: false)!),
            JournalEntry(entry: "test 3", date: Calendar.current.date(byAdding: Calendar.Component.month, value: -1, to: Date.now, wrappingComponents: false)!)
        ]
    }
}

class JournalEntryList: ObservableObject {
    @Published var list: [Journal] = []
    @Published var selected: Int? = nil
    
    init() {
        loadList()
    }
    
    func addEntry(_ entry: JournalEntry) {
        list.append(entry)
        saveList()
    }
    
    func deleteShow(_ entry: JournalEntry) {
        var found: Int? = nil
        for i in 0..<list.count {
            if list[i] == entry {
                found = i
                break
            }
        }
        if let idx = found {
            list.remove(at: idx)
            selected = nil
            saveList()
        }
    }

    
    let fname = "entries.json"
    var url: URL? {
        let baseURL = try? FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask,
               appropriateFor: nil, create: false )
        return baseURL?.appendingPathComponent(fname)
    }
    
    func saveList() {
        let listData: Data? = try? JSONEncoder().encode(list)
        if let file = url {
            try? listData?.write(to: file)
        }
    }
    
    func loadList() {
        if let file = url {
            if let data = try? Data(contentsOf: file) {
                if let listData = try? JSONDecoder().decode(Array<JournalEntry>.self, from: data) {
                    list = listData
                }
            }
        }
    }


}*/

/*import Foundation
import CoreData
import SwiftUI

class JournalEntryList: ObservableObject {
    @Published var list: [Journal] = []
    @Published var selected: Int? = nil
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        loadList()
    }
    
    func addEntry(_ entry: Journal) {
        let newItem = Journal(context: context)
        newItem.date = entry.date
        newItem.journalText = entry.journalText
        
        do {
            try context.save()
            loadList()
        } catch {
            print("Error saving journal entry: \(error.localizedDescription)")
        }
    }
    
    func deleteEntry(_ entry: Journal) {
        let fetchRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "journalText == %@ AND date == %@", entry.journalText as! NSString, entry.date as! NSDate)
        do {
                    let items = try context.fetch(fetchRequest)
                    for item in items {
                        context.delete(item)
                    }
                    try context.save()
                    loadList()
                } catch {
                    print("Error deleting journal entry: \(error.localizedDescription)")
                }
            }

    func loadList() {
            let fetchRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
            let sortDescriptor = NSSortDescriptor(keyPath: \Journal.date, ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            do {
                let items = try context.fetch(fetchRequest)
                list = items.map { Journal(journalText: $0.journalText ?? "", date: $0.date ?? Date()) }
            } catch {
                print("Error fetching journal entries: \(error.localizedDescription)")
            }
        }
    }
*/
