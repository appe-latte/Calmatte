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
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize Firebase
        FirebaseApp.configure()
        
        // Load data for a specific key
        if let appData = DataManager.loadData(forKey: .appData) as? [String: Any] {
            // Do something with appData, e.g., update your application's state
        }
        
        application.registerForRemoteNotifications()
        
        // Fetch the reminder time from UserDefaults
        let reminderTimeDouble = UserDefaults.standard.double(forKey: "reminderTime")
        let selectedReminderTime = reminderTimeDouble > 0 ? Date(timeIntervalSince1970: reminderTimeDouble) : Date()
        
        // Request user authorization for notifications
        requestNotificationAuthorization(application: application, selectedReminderTime: selectedReminderTime)
        
        // Set the delegate for user notification center
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    // MARK: - Notification Authorization
    private func requestNotificationAuthorization(application: UIApplication, selectedReminderTime: Date) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                // User granted permission
                ReminderManager.scheduleReminders(for: selectedReminderTime)
            } else {
                // User denied permission or something went wrong
                // Handle accordingly
            }
        }
    }
    
    // MARK: - Remote Notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        DataManager.updateData(with: notification)
        completionHandler(.newData)
    }
    
    // MARK: - App State Transitions
    func applicationWillResignActive(_ application: UIApplication) {
        // Pause ongoing tasks, disable timers, etc.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        DataManager.saveCurrentAppState()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if let appState = DataManager.loadCurrentAppState() {
            // Update the app with the loaded state if necessary
            print("Loaded app state:", appState)
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused when the app was inactive
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // You need to define what data you want to save and under what key.
        let dataToSave: [String: Any] = ["lastSession": Date()]
        DataManager.saveData(dataToSave, forKey: .appData)
    }
    
    // MARK: - User Notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the action based on the notification's identifier or other information
        handleNotificationAction(response: response)
        
        completionHandler()
    }
    
    // MARK: - Notification Actions
    private func handleNotificationAction(response: UNNotificationResponse) {
        if response.notification.request.identifier == "moodReminder" {
            // Perform actions specific to the mood reminder notification
            navigateToMoodLogging()
        }
    }
    
    private func navigateToMoodLogging() {
        // Example of navigating to a specific view controller
    }
}

// MARK: - Data Management
class DataManager {
    
    static let shared = DataManager()
    
    // This enum holds the keys for data storage to avoid hardcoding strings throughout the app
    enum UserDefaultsKey: String {
        case appData
    }
    
    // Save data to UserDefaults
    static func saveData(_ data: Any, forKey key: UserDefaultsKey) {
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: key.rawValue)
        defaults.synchronize()
    }
    
    // Load data from UserDefaults
    static func loadData(forKey key: UserDefaultsKey) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: key.rawValue)
    }
    
    // Update data when notification is received
    static func updateData(with notification: [AnyHashable: Any]) {
        // Example: Update data based on notification content
        if let data = notification["data"] as? [String: Any] {
            // Process and save the updated data
            saveData(data, forKey: .appData)
        }
    }
    
    // Call this method to save any current app data
    static func saveCurrentAppState() {
        // Example: Save the current app state
        // This could be a dictionary of your app's data
        let currentAppState: [String: Any] = ["lastOpened": Date()]
        saveData(currentAppState, forKey: .appData)
    }
    
    // Call this method to load the app state when the app becomes active
    static func loadCurrentAppState() -> [String: Any]? {
        // Load the app state that was previously saved
        return loadData(forKey: .appData) as? [String: Any]
    }
}
