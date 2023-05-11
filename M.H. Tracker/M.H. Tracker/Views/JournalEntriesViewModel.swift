//
//  JournalEntriesViewModel.swift
//  M.H. Tracker
//
//  Created by Zeynep Yilmazcoban on 4/24/23.
//

import Foundation
import CoreData
import SwiftUI

class JournalEntriesViewModel: ObservableObject {
    @Published var journalEntries: [Journal] = []
    private var viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchJournalEntries()
    }
    
    func fetchJournalEntries() {
        let fetchRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Journal.date, ascending: false)]
        
        do {
            journalEntries = try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch journal entries: \(error)")
        }
    }
    
    func addNewJournalEntry() {
        let _ = PersistenceController.shared.saveJournalEntry(text: "")
        fetchJournalEntries()
    }
    
    func deleteJournalEntry(at offsets: IndexSet) {
        for index in offsets {
            let entry = journalEntries[index]
            viewContext.delete(entry)
        }
        do {
            try viewContext.save()
            fetchJournalEntries()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
