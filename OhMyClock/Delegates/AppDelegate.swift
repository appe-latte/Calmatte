//
//  AppDelegate.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-05-10.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import UserNotifications
import LocalAuthentication

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.registerForRemoteNotifications()
        
        // Request user authorization for notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                // User granted permission
                self.scheduleReminders()
            } else {
                // User denied permission or something went wrong
                // Handle accordingly
            }
        }
        
        // Set the delegate for user notification center
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
        // Further handling of the device token if needed by the app
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
        // This notification is not auth related, developer should handle it.
    }
    
    func scheduleReminders() {
        // Create a notification content
        let content = UNMutableNotificationContent()
        content.title = "Log Your Mood"
        content.body = "Don't forget to log your mood for today!"
        content.sound = UNNotificationSound.default
        
        // Set the notification trigger (e.g., 8:00 PM daily)
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create a notification request
        let request = UNNotificationRequest(identifier: "moodReminder", content: content, trigger: trigger)
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                // Handle any error in scheduling the notification
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                // Notification scheduled successfully
                print("Notification scheduled successfully")
            }
        }
    }
    
    // Handle user tapping on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the action based on the notification's identifier or other information
        if response.notification.request.identifier == "moodReminder" {
            // Perform actions specific to the mood reminder notification
            // For example, open the mood logging screen or display a relevant view
            // You can navigate to a specific view controller using your app's navigation stack or present a modal view controller
            // Example:
            // let storyboard = UIStoryboard(name: "Main", bundle: nil)
            // let moodLoggingViewController = storyboard.instantiateViewController(withIdentifier: "MoodLoggingViewController") as! MoodLoggingViewController
            // window?.rootViewController?.present(moodLoggingViewController, animated: true, completion: nil)
        }
        
        // Call the completion handler when done
        completionHandler()
    }
}
