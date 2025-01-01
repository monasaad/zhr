//
//  Reminder.swift
//  zhr
//
//  Created by Huda Almadi on 01/01/2025.
//
import Foundation

struct Reminder: Identifiable, Codable {
    var id = UUID()
    let title: String
    let location: String
    let date: Date
}
