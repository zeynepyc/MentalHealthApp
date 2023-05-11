//
//  EntryCalendarView.swift
//  M.H. Tracker
//
//  Created by Rafi Pedersen on 5/1/23.
//

import SwiftUI

struct EntryCalendarView: View {
    @State private var date = Date()
    @Binding var selectedDate: Date?
    @Binding var isSelected: Bool

    var body: some View {
        DatePicker(
            "Start Date",
            selection: $date,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
        .onChange(of: date, perform: { value in
            selectedDate = value
            isSelected = true
        })
    }
}

struct EntryCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        EntryCalendarView(selectedDate: .constant(nil), isSelected: .constant(false))
    }
}
