//
//  MoodChartView.swift
//  M.H. Tracker
//
//  Created by Rafi Pedersen on 5/1/23.
//

import SwiftUI
import CoreData
//import SwiftUIGraphs
//import SwiftUICharts

enum DataType {
    case mood
    case activity
    case sleep
}

extension Date {
    func startOfWeek() -> Date {
        Calendar(identifier: .gregorian)
            .dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
    
    func dayOfWeek() -> Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday!
    }
}

struct ChartView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: TrackerEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TrackerEntry.date, ascending: false)],
        animation: .default)
    private var trackerEntries: FetchedResults<TrackerEntry>
    @State private var dataWeeks: Array<[(Double, Double)]> = []
    private var title: String = ""
    private var dataType: DataType = .mood
    
    init(title: String = "", dataType: DataType = .mood) {
        self.title = title
        self.dataType = dataType
    }
    
    let colors: [Color] = [.blue, Color(white: 0.3), Color(white: 0.5), Color(white: 0.7)]
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous).fill(Color(white: 0.95))
            VStack {
                Text(title)
                ZStack {
                    ForEach(0..<11, id:\.self) {i in
                        PlotLine(data: [(0.9, Double(i)), (7.1, Double(i))], xlim: (1,7), ylim: (0, 10))
                            .stroke(Color(white: 0.85), style: StrokeStyle(lineWidth: 1, dash: i % 2 == 0 ? [] : [20]))
                    }
                    ForEach(dataWeeks.indices.reversed(), id: \.self) { i in
                        PlotLine(data: dataWeeks[i], xlim: (1,7), ylim: (0,10))
                            .stroke(colors[i], style: StrokeStyle(lineWidth: i == 0 ? 5 : 2, lineCap: .round, lineJoin: .round))
                    }
                }.padding()
            }
        }.onAppear {
            buildWeekData()
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    private func dateRangePredicate(from: Date, to: Date) -> NSPredicate {
        return NSPredicate(format: "date >= %@ AND date < %@", from as NSDate, to as NSDate)
    }
    
    private func entryToXY(entry: TrackerEntry) -> (Double, Double) {
        let x = Double((entry.date?.dayOfWeek())!)
        
        let y: Int32 = {
            switch self.dataType {
            case .mood:
                return entry.mood
            case .activity:
                return entry.activity
            case .sleep:
                return entry.sleep
            }
        }()
        
        
        return (x,Double(y))
    }
    
    private func buildWeekData() {
        dataWeeks = []
        
        let calendar = Calendar.current
        let date = Date()
        let startThisWeek = date.startOfWeek()
        let endThisWeek = calendar.date(byAdding: DateComponents(weekOfYear: 1), to: startThisWeek)!
        let startLastWeek = calendar.date(byAdding: DateComponents(weekOfYear: -1), to: startThisWeek)!
        let startLLastWeek = calendar.date(byAdding: DateComponents(weekOfYear: -1), to: startLastWeek)!
        let startLLLastWeek = calendar.date(byAdding: DateComponents(weekOfYear: -1), to: startLLastWeek)!
        
        let thisWeekEntries = trackerEntries.filter {
            if let d = $0.date {
                return d >= startThisWeek && d < endThisWeek
            }
            return false
        }
        
        dataWeeks.append(thisWeekEntries.map {entryToXY(entry: $0)})
        
        let lastWeekEntries = trackerEntries.filter {
            if let d = $0.date {
                return d >= startLastWeek && d < startThisWeek
            }
            return false
        }
        dataWeeks.append(lastWeekEntries.map {entryToXY(entry: $0)})
        
        let lLastWeekEntries = trackerEntries.filter {
            if let d = $0.date {
                return d >= startLLastWeek && d < startLastWeek
            }
            return false
        }
        dataWeeks.append(lLastWeekEntries.map {entryToXY(entry: $0)})
        
        let lLLastWeekEntries = trackerEntries.filter {
            if let d = $0.date {
                return d >= startLLLastWeek && d < startLLastWeek
            }
            return false
        }
        dataWeeks.append(lLLastWeekEntries.map {entryToXY(entry: $0)})
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(title: "Mood").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
