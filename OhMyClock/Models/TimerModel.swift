//
//  TimerModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-03-07.
//

import SwiftUI
import Foundation

class TimerModel : NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var progress : CGFloat = 1
    @Published var timerValue : String = "00:00"
    @Published var isStarted : Bool = false
    @Published var addNewTimer : Bool = false
    
//    @Published var hour : Int = 0
    @Published var minutes : Int = 0
    @Published var seconds : Int = 0
    
    // Total Seconds
    @Published var totalSeconds : Int = 0
    @Published var staticTotalSeconds : Int = 0
    
    // Post Timer Properties
    @Published var isFinished : Bool = false
    
    override init() {
        super.init()
        self.authorizeNotification()
    }
    
    // MARK: Request Notification
    func authorizeNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { _, _ in
            //
        }
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge])
    }
    
    // MARK: Timer Settings
    func startFocusTimer() {
        withAnimation(.easeInOut(duration: 0.25)) { isStarted = true }
        //        timerValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        timerValue = "\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        
        // Calculation for timer animation
        totalSeconds = (minutes * 60) + seconds
        //        totalSeconds = (hour * 3600) + (minutes * 60) + seconds
        staticTotalSeconds = totalSeconds
        addNewTimer = false
        addNotification()
    }
    
    func stopFocusTimer() {
        withAnimation {
            isStarted = false
//            hour = 0
            minutes = 0
            seconds = 0
            progress = 1
        }
        totalSeconds = 0
        staticTotalSeconds = 0
        timerValue = "00:00"
    }
    
    func updateFocusTimer() {
        totalSeconds -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = (progress < 0 ? 0 : progress)
        
//        hour = totalSeconds / 3600
        minutes = (totalSeconds / 60) % 60
        seconds = (totalSeconds % 60)
        
        //        timerValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        
        //        if hour == 0 && minutes == 0 && seconds == 0 {
        //            isStarted = false
        //            print("Focus Timer Complete!")
        //            isFinished = true
        //        }
        
        timerValue = "\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        
        if minutes == 0 && seconds == 0 {
            isStarted = false
            print("Focus Timer Complete!")
            isFinished = true
        }
    }
    
    func addNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Focus Timer"
        content.subtitle = "Your focus time is now complete."
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats: false))
        
        UNUserNotificationCenter.current().add(request)
    }
}
