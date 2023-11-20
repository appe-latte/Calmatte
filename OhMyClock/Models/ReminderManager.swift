//
//  ReminderManager.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-08-07.
//

import Foundation
import SwiftUI
import UserNotifications

class ReminderManager {
    static func requestNotificationAuthorization(reminderTime: Date) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                scheduleReminders(for: reminderTime)
            } else {
                // Handle authorization denial or error
            }
        }
    }
    
    static func scheduleReminders(for reminderTime: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Calmatte App: Journal Reminder"
        content.body = "It's time for you to log your mood."
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.hour, .minute], from: reminderTime)
        dateComponents.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let identifier = "moodReminder"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully: \(identifier)")
            }
        }
    }
    
    static func sendReminderEnabledNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminders Enabled"
        content.body = "Reminder notifications are enabled."
        
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
        content.body = "Notification reminders disabled."
        
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
