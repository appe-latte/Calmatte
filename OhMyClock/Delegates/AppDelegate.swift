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
        // Initialize Firebase
        FirebaseApp.configure()
        
        application.registerForRemoteNotifications()
        
        // Request user authorization for notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                // User granted permission
                ReminderManager.scheduleReminders()
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
