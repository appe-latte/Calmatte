//
//  RoutineManager.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2025-03-05.
//

import SwiftUI
import CoreData
import UserNotifications

class RoutineManager: ObservableObject {
    @Published private(set) var routines: [Routine] = []
    @Published var isEditingRoutine: Bool = false // To track if editing is in progress
    @Published var routineToEdit: Routine? = nil // To hold the routine being edited

    init() {
        requestNotificationPermission()
        loadRoutines()
    }

    func addRoutine(_ routine: Routine) {
        routines.append(routine)
        saveRoutines()
        scheduleNotification(for: routine)
    }

    func updateRoutine(routine: Routine) {
        if let index = routines.firstIndex(where: { $0.id == routine.id }) {
            removeNotification(for: routines[index]) // Remove old notification before updating
            routines[index] = routine
            saveRoutines()
            scheduleNotification(for: routine) // Schedule new notification with updated routine
        }
    }

    func deleteRoutine(routine: Routine) {
        routines.removeAll { $0.id == routine.id }
        saveRoutines()
        removeNotification(for: routine)
    }

    func deleteRoutines(at indices: IndexSet) {
        let routinesToDelete = indices.compactMap { routines[$0] }
        routines.remove(atOffsets: indices)
        saveRoutines()
        routinesToDelete.forEach(removeNotification)
    }

    func startEditing(routine: Routine) {
        self.routineToEdit = routine
        self.isEditingRoutine = true
    }

    func stopEditing() {
        self.isEditingRoutine = false
        self.routineToEdit = nil
    }


    private func saveRoutines() {
        do {
            let data = try JSONEncoder().encode(routines)
            UserDefaults.standard.set(data, forKey: "savedRoutines")
        } catch {
            print("Error encoding routines: \(error)")
        }
    }

    func loadRoutines() {
        if let data = UserDefaults.standard.data(forKey: "savedRoutines") {
            do {
                routines = try JSONDecoder().decode([Routine].self, from: data)
            } catch {
                print("Error decoding routines: \(error)")
            }
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted for routines.")
            } else if let error = error {
                print("Notification permission error for routines: \(error.localizedDescription)")
            }
        }
    }

    private func scheduleNotification(for routine: Routine) {
        guard routine.reminderEnabled else { return } // Don't schedule if reminder is not enabled

        let content = UNMutableNotificationContent()
        content.title = "Routine Reminder: \(routine.name)" // More informative title
        content.body = "It's time to start your \(routine.name) routine."
        content.sound = UNNotificationSound.default

        // Create a date components for the start time
        let calendar = Calendar.current
        let startTimeComponents = calendar.dateComponents([.hour, .minute], from: routine.startTime)

        // Create triggers for each day of the week the routine is set for
        for dayOfWeek in routine.daysOfWeek {
            var dateComponents = DateComponents()
            dateComponents.weekday = dayOfWeek + 1 // Sunday is 1, Monday is 2, etc. in Calendar weekday
            dateComponents.hour = startTimeComponents.hour
            dateComponents.minute = startTimeComponents.minute

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true) // Weekly repeat

            let request = UNNotificationRequest(identifier: routine.id.uuidString + "-\(dayOfWeek)", // Unique ID for each day's notification
                                                    content: content,
                                                    trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling routine notification for \(routine.name) on day \(dayOfWeek): \(error.localizedDescription)")
                } else {
                    print("Notification scheduled for routine \(routine.name) on day \(dayOfWeek)")
                }
            }
        }
    }


    private func removeNotification(for routine: Routine) {
        // Remove all scheduled notifications for this routine (for all days)
        for dayOfWeek in routine.daysOfWeek {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [routine.id.uuidString + "-\(dayOfWeek)"])
        }
    }

    private func updateNotification(for oldRoutine: Routine, with newRoutine: Routine) {
        removeNotification(for: oldRoutine)
        scheduleNotification(for: newRoutine)
    }
}
