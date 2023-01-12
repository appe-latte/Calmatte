//
//  PlayerView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import SwiftUI

struct PlayerView: View {
    @EnvironmentObject var audioManager : AudioManager
    var meditationViewModel : MeditationViewModel
    var isPreview : Bool = false
    
    @State private var value : Double = 0.0
    @State private var isEditing : Bool = false
    @Environment(\.dismiss) var dismiss
    
    let timer = Timer
        .publish(every: 0.5, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 10) {
                
                // MARK: Playback
                
                //                if let player = audioManager.player {
                //                    VStack(spacing: 5) {
                //                        Slider(value: $value, in: 0...player.duration) { editing in
                //                            isEditing = editing
                //
                //                            if !editing {
                //                                audioManager.player?.currentTime = value
                //                            }
                //                        }
                //                        .accentColor(np_red)
                //                        .frame(maxWidth: .infinity)
                //                        .padding(.vertical, 10)
                //                    }
                //
                //                    HStack {
                //                        Text(DateComponentsFormatter.positional.string(from: player.currentTime) ?? "0:00")
                //                            .fontWeight(.semibold)
                //                            .kerning(5)
                //                            .frame(width: 75, height:20)
                //                            .padding(.leading, 10)
                //                            .background(np_white)
                //                            .clipShape(Capsule())
                //
                //                        Spacer()
                //
                //                        Text(DateComponentsFormatter.positional.string(from: player.duration - player.currentTime) ?? "0:00")
                //                            .fontWeight(.semibold)
                //                            .kerning(5)
                //                            .frame(width: 75, height:20)
                //                            .padding(.leading, 10)
                //                            .background(np_white)
                //                            .clipShape(Capsule())
                //                    }
                //                    .font(.caption)
                //                    .foregroundColor(np_black)
                //                }
                
                //                Text("As you begin your meditation, take slow deep breaths and let the calming sounds gently drift you away.")
                //                    .font(.footnote)
                //                    .fontWeight(.semibold)
                //                    .kerning(7)
                //                    .textCase(.uppercase)
                //                    .minimumScaleFactor(0.5)
                //                    .frame(maxWidth: .infinity)
                
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
                        audioManager.playPauseFunction()
                    }
                    
                    // MARK: "Stop" button
                    
                    PlaybackControlButton(systemName: "stop.circle.fill", fontSize: 40) {
                        audioManager.stop()
                        dismiss()
                    }
                    
                    // MARK: "Duration"
                    
                    Text(DateComponentsFormatter.positional.string(from: (audioManager.player?.currentTime ?? 0.0)) ?? "0:00")
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
        }
        .onReceive(timer) { _ in
            guard let player = audioManager.player, !isEditing else { return }
            value = player.currentTime
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static let meditationViewModel = MeditationViewModel(meditation: Meditation.data)
    
    static var previews: some View {
        PlayerView(meditationViewModel: meditationViewModel, isPreview: true)
            .environmentObject(AudioManager())
    }
}
