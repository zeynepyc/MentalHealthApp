//
//  JournalingPageView.swift
//  M.H. Tracker
//
//  Created by Zeynep Yilmazcoban on 4/19/23.
//

import SwiftUI

// View to edit a single JournalEntry
struct JournalingPageView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    // Receives an ObservedObject journal entry
    @ObservedObject var entry: Journal
    // The local entry content. This can be edited independently of the original entry, and will only sync when you hit save.
    @State private var entryContent: String = ""
    @State private var date: Date = Date()
    
    var body: some View {
        VStack {
            DatePicker("Date", selection: $date, displayedComponents: [.date])
                .onAppear(perform: {
                    date = entry.date ?? Date()
                })
                .padding()
            
            // Text field for the local entry content
            TextField("Journal entry...", text: $entryContent)
                .onAppear(perform: {
                    // Initialized to the text in the passed-in journal entry
                    entryContent = entry.journalText ?? ""
                })
                .padding()
            
            // Save button
            Button(action: {
                // Set the passed in entry's text to the local text, then try saving it to local storage.
                entry.journalText = entryContent
                entry.date = date
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    print("Unresolved error \(nsError), \(nsError.userInfo)")
                }
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
            }
            
            
            Spacer()
        }
        .navigationTitle("Journal Entry")
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

struct JournalingPageView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let sampleJournalEntry = Journal(context: viewContext)
        sampleJournalEntry.date = Date()
        sampleJournalEntry.journalText = "Sample Journal Entry"
        
        return JournalingPageView(entry: sampleJournalEntry)
            .environment(\.managedObjectContext, viewContext)
    }
}

