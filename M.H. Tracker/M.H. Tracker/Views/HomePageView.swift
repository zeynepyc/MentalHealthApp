//
//  HomePageView.swift
//  M.H. Tracker
//
//  Created by Zeynep Yilmazcoban on 4/19/23.
//

/*import SwiftUI

struct HomePageView: View {
    @State private var moodAverage: Double = 0
    @State private var activityAverage: Double = 0
    @State private var sleepAverage: Double = 0
    @State private var journalEntries: [JournalEntry] = JournalEntry.example()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack {
                    Text("Mood Average: \(moodAverage, specifier: "%.2f")")
                    Text("Activity Average: \(activityAverage, specifier: "%.2f")")
                    Text("Sleep Average: \(sleepAverage, specifier: "%.2f")")
                }
                .padding()
                .onAppear {
                    loadData()
                }
                
                VStack {
                    NavigationLink(destination: TrackerPageView()) {
                        Text("Tracker")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    NavigationLink(destination: JournalEntriesListView(journalEntries: $journalEntries)) {
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
        }
    }
    
    func loadData() {
        // Load data from CoreData or other local storage and calculate the averages
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}

*/
