//
//  MeditationViewModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import Foundation
import Combine

final class MeditationViewModel: ObservableObject {
    private(set) var meditation: Meditation
    
    @Published var timeRemaining: TimeInterval
    @Published var isMuted = false
    @Published var isVibrationEnabled = true
    
    private var timer: Timer?
    
    init(meditation: Meditation) {
        self.meditation = meditation
        self.timeRemaining = meditation.duration
    }
    
    // MARK: Start Timer
    func startTimer() {
        stopTimer() // Ensure any previous timer is stopped
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    // MARK: Stop Timer
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: Reset Timer
    func resetTimer() {
        timeRemaining = meditation.duration
        stopTimer()
    }
    
    // MARK: Toggle Mute
    func toggleMute() {
        isMuted.toggle()
    }
    
    // MARK: Toggle Vibration
    func toggleVibration() {
        isVibrationEnabled.toggle()
    }
}

struct Meditation {
    let id = UUID()
    let title: String
    let description: String
    let duration: TimeInterval
    let track: String
    let image: String
    
    static let data = Meditation(
        title: "Meditation Break",
        description: "Take a deep breath and find your center.",
        duration: 48, // Matches the example image countdown
        track: "relaxing-sounds",
        image: "meditation-character" // Replace with actual asset name
    )
}
