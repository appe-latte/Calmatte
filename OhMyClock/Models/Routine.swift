//
//  Routine.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2025-03-05.
//


struct Routine: Identifiable, Codable {
    var id: UUID = .init()
    var name: String // Routine Name, e.g., "Morning Routine"
    var daysOfWeek: [Int] // Days to repeat, e.g., [1, 2, 3, 4, 5] for weekdays (Mon-Fri)
    var startTime: Date // Start time for the routine
    var reminderEnabled: Bool // Is reminder enabled?
    var reminderType: ReminderType // Reminder type (Time or Manual)

    // Convert Routine to a dictionary if needed for database operations
    func asDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "name": name,
            "daysOfWeek": daysOfWeek,
            "startTime": startTime,
            "reminderEnabled": reminderEnabled,
            "reminderType": reminderType.rawValue // Assuming ReminderType is an enum with RawRepresentable
        ]
    }
}

// Make ReminderType Codable and RawRepresentable
enum ReminderType: String, Codable, CaseIterable {
    case time = "Time"
    case manual = "Manual"
}