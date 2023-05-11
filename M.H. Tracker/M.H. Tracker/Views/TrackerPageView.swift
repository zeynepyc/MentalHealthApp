//
//  TrackerPageView.swift
//  M.H. Tracker
//
//  Created by Zeynep Yilmazcoban on 4/19/23.
//

import SwiftUI
import CoreData

struct TrackerPageView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @State private var date: Date = Date()
    @State private var mood: Double = 5.0
    @State private var activity: Int = 0
    @State private var sleepHours: Int = 8
    @Binding var selectedDate: Date?
    @Binding var isSelected: Bool
    
    init(date: Date? = Date(), selectedDate: Binding<Date?>, isSelected: Binding<Bool>) {
        self._selectedDate = selectedDate
        self._isSelected = isSelected
        if let d = date {
            self.date = d
        } else {
            self.date = Date()
        }
    }
    
    var body: some View {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: [.date])
                Section(header: Text("Mood")) {
                    Text("How was your mood today?")
                    HStack {
                        Slider(value: $mood, in: 1...10, step: 1)
                        Text(String(format: "%.0f", mood))
                    }
                }
                
                Section(header: Text("Activity")) {
                    Text("How many hours did you spend on physical activities today?")
                    Stepper(value: $activity, in: 0...24, step: 1) {
                        Text("\(activity)")
                    }
                }
                
                Section(header: Text("Sleep")) {
                    Text("How many hours did you sleep last night?")
                    Stepper(value: $sleepHours, in: 0...24, step: 1) {
                        Text("\(sleepHours)")
                    }
                }
                
                
                Button(action: {
                    saveData()
                    presentationMode.wrappedValue.dismiss()
                    selectedDate = nil
                    isSelected = false
                }) {
                    Text("Save")
                }.frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    deleteData()
                    presentationMode.wrappedValue.dismiss()
                    selectedDate = nil
                    isSelected = false
                }) {
                    Text("Delete")
                }.frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Tracker")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                if let d = selectedDate {
                    self.date = d
                }
                if let existingEntry = PersistenceController.shared.getTrackerEntry(date: date) {
                    mood = Double(existingEntry.mood)
                    activity = Int(existingEntry.activity)
                    sleepHours = Int(existingEntry.sleep)
                }
            })
    }
    
    func saveData() {
        PersistenceController.shared.addTrackerEntry(mood: Int(mood), activity: activity, sleep: sleepHours, date: date)
    }
    
    func deleteData() {
        PersistenceController.shared.deleteTrackerEntry(date: date)
    }
}


struct TrackerPageView_Previews: PreviewProvider {
    static var previews: some View {
        TrackerPageView(selectedDate: .constant(nil), isSelected: .constant(false))
    }
}


