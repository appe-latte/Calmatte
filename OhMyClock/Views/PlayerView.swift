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
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                
                // MARK: Playback Controls
                HStack(spacing: 15) {
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
                    PlaybackControlButton(systemName: "stop.circle.fill", fontSize: 35) {
                        audioManager.stop()
                        dismiss()
                    }
                    
                    Spacer()
                    
                    // MARK: "Duration"
                    Text(currentTimeString)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .kerning(5)
                        .foregroundColor(np_black)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(np_white)
                .clipShape(Capsule())
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(np_black, lineWidth: 1)
                        .padding(7)
                )
                
                Spacer()
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

