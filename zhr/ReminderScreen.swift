//
//  ReminderScreen.swift
//  zhr
//
//  Created by Mona on 12/12/2024.
//

import SwiftUI

struct ReminderScreen: View {
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var showMonthPicker = false
    @State private var selectedDate = Date() // اليوم المختار
    @State private var showAddReminderSheet = false
    @State private var reminders: [Date: [Reminder]] = [:] // تخزين التذكيرات حسب اليوم

    let months = Calendar.current.monthSymbols

    var body: some View {
        NavigationView {
            VStack {
                // الهيدر
                HStack {
                    Text(monthName(from: selectedMonth))
                        .font(.largeTitle)
                        .bold()
                    // عرض قائمة الأشهر بشكل منبثق باستخدام Menu
                    Menu {
                        ForEach(0..<months.count, id: \.self) { index in
                            Button(action: {
                                selectedMonth = index + 1
                            }) {
                                Text(months[index])
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.up.chevron.down")
                            .foregroundColor(Color("PurpleDark"))
                    }
                    Spacer()
                    Button(action: {
                        showAddReminderSheet.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("PurpleDark"))
                    }
                }
                .padding()

                // التقويم الأفقي
                ScrollViewReader { scrollView in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(daysInMonth(), id: \.self) { day in
                                VStack {
                                    Text(weekdayName(from: day))
                                        .font(.caption)
                                        .foregroundColor(Color("PurpleDark"))
                                    Text(dayNumber(from: day))
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(isSelected(day) ? (Color("PurpleDark")) : Color.primary)
                                       // .foregroundColor(isSelected(day) ? .white : .primary)
                                        .frame(width: 60, height: 60)
                                        .background(isSelected(day) ? Color("PurpleDark").opacity(0.2) : Color.clear)
                                       // .background(isSelected(day) ? Color("PurpleDark") : Color.clear)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                                .id(day) // تعيين معرف لكل يوم
                                .onTapGesture {
                                    selectedDate = day
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .onAppear {
                        // التمرير تلقائياً إلى اليوم الحالي
                        scrollView.scrollTo(clearTime(for: selectedDate), anchor: .center)
                    }
                }

                // عرض التذكيرات الخاصة باليوم المحدد
                List {
                    if let todaysReminders = reminders[clearTime(for: selectedDate)] {
                        ForEach(todaysReminders) { reminder in
                            VStack(alignment: .leading) {
                                Text(reminder.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("\(reminder.location)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Text("\(formattedTime(reminder.date))")
                                    .font(.footnote)
                                    .padding(.leading, 260)
                                    .foregroundColor(Color("PurpleDark"))

                            }
                            .padding() // إضافة مساحة داخلية لكل عنصر
                                        .background(Color("PurpleLight")) // لون خلفية العنصر
                                        .cornerRadius(15) // لتنعيم الحواف
                                        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2) // إضافة ظل خفيف
                                        .listRowBackground(Color.clear)
                        }
                        
                    } else {
                        Text("No reminders for this day")
                            .foregroundColor(.gray)
                    }
                    
                }
              //  .listStyle(PlainListStyle()) // تغيير نمط القائمة لجعلها بدون تصميم إضافي
                .background(Color.clear) //
            }
            .sheet(isPresented: $showAddReminderSheet) {
                AddReminderView(selectedDate: selectedDate) { title, location, date in
                    addReminder(title: title, location: location, date: date)
                }
            }
        }
    }

    // دالة لتحويل الرقم إلى اسم الشهر
    func monthName(from month: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.monthSymbols[month - 1]
    }

    // إضافة تذكير جديد
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

// هيكل بيانات التذكير
struct Reminder: Identifiable {
    let id = UUID()
    let title: String
    let location: String
    let date: Date
}

// شاشة إضافة التذكير
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
        return calendar.date(from: DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute)) ?? date
    }
}

struct ReminderScreen_Previews: PreviewProvider {
    static var previews: some View {
        ReminderScreen()
    }
}










/*
 import SwiftUI

 struct ReminderScreen: View {
     @State private var selectedMonth = Calendar.current.component(.month, from: Date())
     @State private var showMonthPicker = false
     @State private var selectedDate = Date() // اليوم المختار
     @State private var showAddReminderSheet = false
     @State private var reminders: [Date: [Reminder]] = [:] // تخزين التذكيرات حسب اليوم

     let months = Calendar.current.monthSymbols

     var body: some View {
         NavigationView {
             VStack {
                 // الهيدر
                 HStack {
                     Text(monthName(from: selectedMonth))
                         .font(.largeTitle)
                         .bold()
                     Button(action: {
                         withAnimation {
                             showMonthPicker.toggle()
                         }
                     }) {
                         Image(systemName: "chevron.up.chevron.down")
                             .foregroundColor(Color("PurpleDark"))
                             .rotationEffect(.degrees(showMonthPicker ? 180 : 0))
                     }
                     Spacer()
                     Button(action: {
                         showAddReminderSheet.toggle()
                     }) {
                         Image(systemName: "plus.circle.fill")
                             .resizable()
                             .frame(width: 30, height: 30)
                             .foregroundColor(Color("PurpleDark"))
                     }
                 }
                 .padding()

                 // عرض الأشهر في List بدلاً من Picker
                 if showMonthPicker {
                     List(months, id: \.self) { month in
                         Button(action: {
                             if let monthIndex = months.firstIndex(of: month) {
                                 selectedMonth = monthIndex + 1
                                 withAnimation {
                                     showMonthPicker = false
                                 }
                             }
                         }) {
                             Text(month)
                                 .padding()
                         }
                     }
                     .frame(maxHeight: 300)
                 }

                 // التقويم الأفقي
                 ScrollViewReader { scrollView in
                     ScrollView(.horizontal, showsIndicators: false) {
                         HStack(spacing: 16) {
                             ForEach(daysInMonth(), id: \.self) { day in
                                 VStack {
                                     Text(weekdayName(from: day))
                                         .font(.caption)
                                         .foregroundColor(Color("PurpleDark"))
                                     Text(dayNumber(from: day))
                                         .font(.title2)
                                         .bold()
                                         .foregroundColor(isSelected(day) ? .white : .primary)
                                         .frame(width: 60, height: 60)
                                         .background(isSelected(day) ? Color("PurpleDark") : Color.clear)
                                         .clipShape(RoundedRectangle(cornerRadius: 15))
                                 }
                                 .id(day) // تعيين معرف لكل يوم
                                 .onTapGesture {
                                     selectedDate = day
                                 }
                             }
                         }
                         .padding(.horizontal)
                     }
                     .onAppear {
                         // التمرير تلقائياً إلى اليوم الحالي
                         scrollView.scrollTo(clearTime(for: selectedDate), anchor: .center)
                     }
                 }

                 // عرض التذكيرات الخاصة باليوم المحدد
                 List {
                     if let todaysReminders = reminders[clearTime(for: selectedDate)] {
                         ForEach(todaysReminders) { reminder in
                             VStack(alignment: .leading) {
                                 Text(reminder.title)
                                     .font(.headline)
                                 Text("Location: \(reminder.location)")
                                     .font(.subheadline)
                                 Text("Time: \(formattedTime(reminder.date))")
                                     .font(.footnote)
                             }
                         }
                     } else {
                         Text("No reminders for this day")
                             .foregroundColor(.gray)
                     }
                 }
             }
             .sheet(isPresented: $showAddReminderSheet) {
                 AddReminderView(selectedDate: selectedDate) { title, location, date in
                     addReminder(title: title, location: location, date: date)
                 }
             }
         }
     }

     // دالة لتحويل الرقم إلى اسم الشهر
     func monthName(from month: Int) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "MMMM"
         return dateFormatter.monthSymbols[month - 1]
     }

     // إضافة تذكير جديد
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

 // هيكل بيانات التذكير
 struct Reminder: Identifiable {
     let id = UUID()
     let title: String
     let location: String
     let date: Date
 }

 // شاشة إضافة التذكير
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
         return calendar.date(from: DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute)) ?? date
     }
 }

 struct ReminderScreen_Previews: PreviewProvider {
     static var previews: some View {
         ReminderScreen()
     }
 }

 
 */
