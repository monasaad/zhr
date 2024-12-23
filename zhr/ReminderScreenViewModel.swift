//
//  ReminderScreenViewModel.swift
//  zhr
//
//  Created by Huda Almadi on 23/12/2024.
//
import Foundation

class ReminderScreenViewModel: ObservableObject {
    @Published var selectedMonth = Calendar.current.component(.month, from: Date())
    @Published var selectedDate = Date() // اليوم المختار
    @Published var reminders: [Date: [Reminder]] = [:] // تخزين التذكيرات حسب اليوم

    let months = Calendar.current.monthSymbols

    func monthName(from month: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.monthSymbols[month - 1]
    }

    func addReminder(title: String, location: String, date: Date) {
        let newReminder = Reminder(title: title, location: location, date: date)
        let keyDate = clearTime(for: date)

        if reminders[keyDate] != nil {
            reminders[keyDate]?.append(newReminder)
        } else {
            reminders[keyDate] = [newReminder]
        }
    }

    func clearTime(for date: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return Calendar.current.date(from: components) ?? date
    }

    func daysInMonth() -> [Date] {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: calendar.component(.year, from: Date()), month: selectedMonth))!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.compactMap { day -> Date? in
            calendar.date(from: DateComponents(year: calendar.component(.year, from: Date()), month: selectedMonth, day: day))
        }
    }

    func weekdayName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }

    func dayNumber(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    func isSelected(_ date: Date) -> Bool {
        Calendar.current.isDate(selectedDate, inSameDayAs: date)
    }

    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

