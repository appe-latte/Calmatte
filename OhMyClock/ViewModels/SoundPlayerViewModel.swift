//
//  SoundPlayerViewModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-12-06.
//

import AVKit
import SwiftUI
import Combine

class SoundPlayerViewModel: ObservableObject {
    @Published var selectedSoundCard: SoundCard?
    @Published var isPlaying = false
    @Published var progress = 0.0
    var player: AVPlayer?
    
    // Initialize the AVPlayer with the selected sound
    func playSound() {
        guard let selectedSoundCard = selectedSoundCard else { return }
        let url = Bundle.main.url(forResource: selectedSoundCard.audioFileName, withExtension: nil)
        player = AVPlayer(url: url!)
        player?.play()
        isPlaying = true
        
        // Add code to update progress as the sound plays
    }
    
    func pauseSound() {
        player?.pause()
        isPlaying = false
    }
}
