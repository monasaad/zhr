//
//  ReminderScreen.swift
//  zhr
//
//  Created by Mona on 12/12/2024.
//
import SwiftUI

struct ReminderScreen: View {
    @StateObject private var viewModel = ReminderScreenViewModel()  // استخدام الـ ViewModel
    @State private var showAddReminderSheet = false

    let months = Calendar.current.monthSymbols

    var body: some View {
        NavigationView {
            VStack {
                // الهيدر
                HStack {
                    Text(viewModel.monthName(from: viewModel.selectedMonth))
                        .font(.largeTitle)
                        .bold()
                    // عرض قائمة الأشهر بشكل منبثق باستخدام Menu
                    Menu {
                        ForEach(0..<months.count, id: \.self) { index in
                            Button(action: {
                                viewModel.selectedMonth = index + 1
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
                            ForEach(viewModel.daysInMonth(), id: \.self) { day in
                                VStack {
                                    Text(viewModel.weekdayName(from: day))
                                        .font(.caption)
                                        .foregroundColor(Color("PurpleDark"))
                                    Text(viewModel.dayNumber(from: day))
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(viewModel.isSelected(day) ? Color("PurpleDark") : Color.primary)
                                        .frame(width: 60, height: 60)
                                        .background(viewModel.isSelected(day) ? Color("PurpleDark").opacity(0.2) : Color.clear)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                                .id(day) // تعيين معرف لكل يوم
                                .onTapGesture {
                                    viewModel.selectedDate = day
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .onAppear {
                        // التمرير تلقائياً إلى اليوم الحالي
                        scrollView.scrollTo(viewModel.clearTime(for: viewModel.selectedDate), anchor: .center)
                    }
                }

                // عرض التذكيرات الخاصة باليوم المحدد
                List {
                    let selectedDate = viewModel.clearTime(for: viewModel.selectedDate)
                    if let todaysReminders = viewModel.reminders[selectedDate] {
                        ForEach(todaysReminders) { reminder in
                            reminderView(for: reminder)
                        }
                        .onDelete(perform: viewModel.deleteReminder)
                    } else {
                        Text("No reminders for this day")
                            .foregroundColor(.gray)
                    }
                }
                .background(Color.clear)
            }
            .sheet(isPresented: $showAddReminderSheet) {
                AddReminderView(selectedDate: viewModel.selectedDate) { title, location, date in
                    viewModel.addReminder(title: title, location: location, date: date)
                }
            }
        }
    }

    private func reminderView(for reminder: Reminder) -> some View {
        VStack(alignment: .leading) {
            Text(reminder.title)
                .font(.headline)
                .foregroundColor(.primary)

            Text("\(reminder.location)")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("\(viewModel.formattedTime(reminder.date))")
                .font(.footnote)
                .padding(.leading, 230)
                .foregroundColor(Color("PurpleDark"))
        }
        .padding()
        .background(Color("PurpleLight"))
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
        .listRowBackground(Color.clear)
    }
}

struct ReminderScreen_Previews: PreviewProvider {
    static var previews: some View {
        ReminderScreen()
    }
}

#Preview {
    ReminderScreen()
}
