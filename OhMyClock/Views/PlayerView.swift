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
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                // MARK: description
                Text("As you begin your meditative journey, remember to steady your mind and focus on your slow, deep breathing.")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .kerning(7)
                    .textCase(.uppercase)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity)
                
                // MARK: Playback Controls
                HStack(spacing: 30) {
                    // MARK: "Play" button
                    PlaybackControlButton(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill", fontSize: 50) {
                        audioManager.playPause()
                    }
                    
                    // MARK: "Stop" button
                    PlaybackControlButton(systemName: "stop.circle.fill", fontSize: 40) {
                        audioManager.stop()
                        dismiss()
                    }
                    
                    // MARK: "Duration"
                    Text(currentTimeString)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .kerning(5)
                        .foregroundColor(np_black)
                }
                .frame(maxWidth: .infinity)
                .padding(5)
                .background(np_white)
                .clipShape(Capsule())
                .padding(.top, 15)
                
                Spacer()
            }
            .padding(20)
        }
        .onAppear {
            audioManager.startPlayer(track: meditationViewModel.meditation.track, isPreview: isPreview)
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            currentTimeString = getTrackCurrentTime()
        }
    }
    
    private func getTrackCurrentTime() -> String {
        guard let currentTime = audioManager.player?.currentTime else {
            return "0:00"
        }
        let minutes = Int(currentTime / 60)
        let seconds = Int(currentTime.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

