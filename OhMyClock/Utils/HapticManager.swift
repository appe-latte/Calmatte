//
//  HapticManager.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-11-30.
//

import SwiftUI

class HapticManager {
    static let instance = HapticManager()
    
    func hapticSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func hapticError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    func hapticWarning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
}
