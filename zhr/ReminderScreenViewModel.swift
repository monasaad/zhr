//
//  ReminderScreenViewModel.swift
//  zhr
//
//  Created by Huda Almadi on 23/12/2024.
//
import Foundation
import UserNotifications

class ReminderScreenViewModel: ObservableObject {
    @Published var selectedMonth = Calendar.current.component(.month, from: Date())
    @Published var selectedDate = Date() // اليوم المختار
    @Published var reminders: [Date: [Reminder]] = [:] // تخزين التذكيرات حسب اليوم

    init() {
        loadReminders() // تحميل التذكيرات عند بدء تشغيل ViewModel
    }

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

        saveReminders() // حفظ التذكيرات بعد إضافتها
        scheduleNotification(for: newReminder)  // إضافة الإشعار بعد التذكير
    }

    func deleteReminder(at offsets: IndexSet) {
        let keyDate = clearTime(for: selectedDate)
        reminders[keyDate]?.remove(atOffsets: offsets)
        saveReminders()
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

    // حفظ التذكيرات في UserDefaults
    func saveReminders() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(reminders) {
            UserDefaults.standard.set(encoded, forKey: "reminders")
        }
    }

    // تحميل التذكيرات من UserDefaults
    func loadReminders() {
        if let savedReminders = UserDefaults.standard.object(forKey: "reminders") as? Data {
            let decoder = JSONDecoder()
            if let loadedReminders = try? decoder.decode([Date: [Reminder]].self, from: savedReminders) {
                reminders = loadedReminders
            }
        }
    }

    // جدولة الإشعار
    func scheduleNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = reminder.title
        content.body = "Reminder for \(reminder.location)"
        content.sound = .default

        // تحديد وقت الإشعار
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        // إنشاء الطلب للإشعار
        let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)

        // إضافة الإشعار
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(reminder.title) at \(reminder.date)")
            }
        }
    }
}
