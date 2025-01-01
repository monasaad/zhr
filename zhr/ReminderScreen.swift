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
                    if let todaysReminders = viewModel.reminders[viewModel.clearTime(for: viewModel.selectedDate)] {
                        ForEach(todaysReminders) { reminder in
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


struct ReminderScreen_Previews: PreviewProvider {
    static var previews: some View {
        ReminderScreen()
    }
}
