//
//  JournalEntriesListView.swift
//  M.H. Tracker
//
//  Created by Zeynep Yilmazcoban on 4/19/23.
//

import SwiftUI
import CoreData

struct JournalEntriesListView: View {
    // View's context for data storage
    @Environment(\.managedObjectContext) private var viewContext
    // Fetch results for the journal entries in storage
    @FetchRequest(
        entity: Journal.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Journal.date, ascending: false)],
        animation: .default)
    private var journalEntries: FetchedResults<Journal>
    
    var body: some View {
        NavigationView {
            // Create a list of every entry in the fetched journal entries
            List {
                ForEach(journalEntries) { entry in
                    // Each entry creates a NavigationLink to a JournalingPageView which has a reference to that entry.
                    NavigationLink(destination: JournalingPageView(entry: entry)) {
                        HStack {
                            Text("\(entry.date ?? Date(), formatter: dateFormatter)")
                            Spacer()
                            Text(entry.journalText ?? "")
                                .lineLimit(1)
                        }
                    }
                }
                // Allow for entry deletion through Edit menu
                .onDelete(perform: deleteJournalEntry)
                
                // New entry button
                Button(action: {
                    createNewJournalEntry()
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add New Journal Entry")
                    }
                }
            }
            .navigationTitle("Journal")
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    func createNewJournalEntry() {
        if let newEntry = PersistenceController.shared.saveJournalEntry(text: "") {
            print("New journal entry created: \(newEntry)")
        }
    }
    
    func deleteJournalEntry(at offsets: IndexSet) {
        for index in offsets {
            let entry = journalEntries[index]
            viewContext.delete(entry)
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

struct JournalEntriesListView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntriesListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
