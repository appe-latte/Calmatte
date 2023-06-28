//
//  PlayerView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import SwiftUI

struct PlayerView: View {
    @EnvironmentObject var audioManager: AudioManager
    var meditationViewModel: MeditationViewModel
    var isPreview: Bool = false
    @State private var currentTimeString: String = "0:00"
    @State private var timer: Timer?
    @State private var isPlaying: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                
                // MARK: Playback Controls
                HStack(spacing: 10) {
                    // MARK: "Play" button
                    PlaybackControlButton(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill", fontSize: 40) {
                        isPlaying.toggle()
                        if isPlaying {
                            audioManager.startPlayer(track: meditationViewModel.meditation.track, isPreview: isPreview)
                            startTimer()
                        } else {
                            audioManager.playPause()
                            stopTimer()
                        }
                    }
                    
                    // MARK: "Stop" button
                    PlaybackControlButton(systemName: "stop.circle.fill", fontSize: 40) {
                        audioManager.stop()
                        dismiss()
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            currentTimeString = getTrackCurrentTime()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func getTrackCurrentTime() -> String {
        guard let currentTime = audioManager.player?.currentTime else {
            return "00:00"
        }
        let minutes = Int(currentTime / 60)
        let seconds = Int(currentTime.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

