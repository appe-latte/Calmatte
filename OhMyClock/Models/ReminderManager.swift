//
//  ReminderManager.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-08-07.
//

import Foundation
import SwiftUI

class ReminderManager {
    // MARK: Reminders
    static func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                scheduleReminders()
            } else {
                // Handle authorization denial or error
            }
        }
    }
    
    static func scheduleReminders() {
        let content = UNMutableNotificationContent()
        content.title = "Log Your Mood"
        content.body = "Don't forget to log your mood!"
        content.sound = UNNotificationSound.default

        let calendar = Calendar.current
        let reminderHours = [12, 20] // Reminders sent at mid-day and 8pm

        for (index, hour) in reminderHours.enumerated() {
            var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
            dateComponents.hour = hour
            dateComponents.minute = 0

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let identifier = "moodReminder_\(index)"

            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled successfully: \(identifier)")
                }
            }
        }
    }

    
    static func sendReminderEnabledNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminders Enabled"
        content.body = "You will now receive reminders to log your mood."
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // Trigger notification immediately
        
        let request = UNNotificationRequest(identifier: "reminderEnabledNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully: reminderEnabledNotification")
            }
        }
    }
    
    static func sendReminderDisabledNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminders Disabled"
        content.body = "You have disabled reminders to log your mood."
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // Trigger notification immediately
        
        let request = UNNotificationRequest(identifier: "reminderDisabledNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully: reminderDisabledNotification")
            }
        }
    }
    
    static func cancelScheduledReminders() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["moodReminder"])
    }
}
