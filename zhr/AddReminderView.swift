//
//  AddReminderView.swift
//  zhr
//
//  Created by Rahaf ALDossari on 01/07/1446 AH.
//


import SwiftUI

struct AddReminderView: View {
    @State private var title: String = ""
    @State private var location: String = ""
    @State private var time = Date()
    @State private var date: Date
    var onSave: (String, String, Date) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    init(selectedDate: Date, onSave: @escaping (String, String, Date) -> Void) {
        _date = State(initialValue: selectedDate)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                    TextField("Location", text: $location)
                }
                Section(header: Text("Date and Time")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                }
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Create") {
                    let combinedDateTime = combine(date: date, time: time)
                    onSave(title, location, combinedDateTime)
                    presentationMode.wrappedValue.dismiss()
                }
                    .disabled(title.isEmpty || location.isEmpty)
            )
            .navigationBarTitle("New Reminder", displayMode: .inline)
        }
    }
    
    func combine(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        return calendar.date(from: DateComponents(
            year: dateComponents.year,
            month: dateComponents.month,
            day: dateComponents.day,
            hour: timeComponents.hour,
            minute: timeComponents.minute
        )) ?? date
    }
}

