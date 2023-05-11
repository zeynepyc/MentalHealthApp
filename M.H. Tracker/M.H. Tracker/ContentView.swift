//
//  ContentView.swift
//  M.H. Tracker
//
//  Created by Zeynep Yilmazcoban on 4/19/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var moodAverage: Double = 0
    @State private var activityAverage: Double = 0
    @State private var sleepAverage: Double = 0
    @State private var selectedDate: Date? = nil
    @State private var isSelected: Bool = false
    
    @FetchRequest(
        entity: TrackerEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TrackerEntry.date, ascending: false)]
    ) private var trackerEntries: FetchedResults<TrackerEntry>
    
    // set this to true to clear all data + generate sample data
    private var toRegenerate = false
    @State private var alreadyRegenerated = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TabView {
                    EntryCalendarView(selectedDate: $selectedDate, isSelected: $isSelected)
                        .tabItem {
                            Image(systemName: "calendar")
                        }
                    ChartView(title: "Mood", dataType: .mood)
                        .tabItem {
                            Image(systemName: "face.smiling")
                        }
                    ChartView(title: "Activity", dataType: .activity)
                        .tabItem {
                            Image(systemName: "figure.walk")
                        }
                    ChartView(title: "Sleep", dataType: .sleep)
                        .tabItem {
                            Image(systemName: "zzz")
                        }
                }
                
                VStack {
                    Text("Mood Average: \(moodAverage, specifier: "%.2f")")
                    Text("Activity Average: \(activityAverage, specifier: "%.2f")")
                    Text("Sleep Average: \(sleepAverage, specifier: "%.2f")")
                    NavigationLink(destination: TrackerPageView(date: selectedDate, selectedDate: $selectedDate, isSelected: $isSelected), isActive: $isSelected) { EmptyView() }
                }
                .padding()
                
                /*
                List {
                    ForEach(trackerEntries) { entry in
                        Text("Mood: \(entry.mood), Activity: \(entry.activity), Sleep: \(entry.sleep), \(entry.date ?? Date(), formatter: dateFormatter)")
                    }
                }*/
                
                HStack {
                    NavigationLink(destination: TrackerPageView(selectedDate: $selectedDate, isSelected: $isSelected)) {
                        Text("Tracker")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    NavigationLink(destination: JournalEntriesListView()) {
                        Text("Journal")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    NavigationLink(destination: ResourcesPageView()) {
                        Text("Resources")
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
            }
            .navigationTitle("Home")
            .padding()
            .onAppear {
                if (toRegenerate && !alreadyRegenerated) {
                    generateData()
                    alreadyRegenerated = true
                }
                
                loadData()
                requestNotificationAuthorization()
                scheduleDailyReminderNotification()
            }
        }
    }

    func loadData() {
        // Load data from CoreData or other local storage and calculate the averages
        moodAverage = 0
        activityAverage = 0
        sleepAverage = 0
        for entry in trackerEntries {
            moodAverage += Double(entry.mood)
            activityAverage += Double(entry.activity)
            sleepAverage += Double(entry.sleep)
        }
        
        if trackerEntries.count > 0 {
            moodAverage = moodAverage / Double(trackerEntries.count)
            activityAverage = activityAverage / Double(trackerEntries.count)
            sleepAverage = sleepAverage / Double(trackerEntries.count)
        }
    }
    
    func generateData() {
        PersistenceController.shared.clearAllData()
        let calendar = Calendar.current
        
        for i in 1...30 {
            let date = calendar.date(byAdding: .day, value: -i, to: Date())!
            let mood = 5 + (7*i)%3 + (9*i)%4
            let activity = (4*i)%3 + (2*i)%7
            let sleep = 4 + (3*i)%5 + (4*i)%3
            PersistenceController.shared.addTrackerEntry(mood: mood, activity: activity, sleep: sleep, date: date)
            _ = PersistenceController.shared.saveJournalEntry(text: "Entry \(i)", date: date)
        }
    }
}

private func requestNotificationAuthorization() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
        if granted {
            print("auth granted")
        } else if let error = error {
            print("auth denied: \(error.localizedDescription)")
        }
    }
}

private func scheduleDailyReminderNotification() {
    let content = UNMutableNotificationContent()
    content.title = "Mental Health Tracker"
    content.body = "Reminder to track your mood, activity, and sleep today and add a journal entry!"
    content.sound = .default
    var dateComps = DateComponents()
    dateComps.hour = 15 // hour of notification
    dateComps.minute = 01 // minute
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComps, repeats: true)
    let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request) { (error) in
        if let error = error {
            print("Failed to schedule: \(error.localizedDescription)")
        } else {
            print("Scheduled successfully")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
