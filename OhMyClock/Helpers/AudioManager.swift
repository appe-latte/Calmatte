//
//  AudioManager.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import Foundation
import AVKit

final class AudioManager: ObservableObject {
    var player : AVAudioPlayer?
    @Published private(set) var isPlaying : Bool = false {
        didSet {
            print("isPlaying", isPlaying)
        }
    }
    
    func startPlayer(track: String, isPreview: Bool = false) {
        guard let url = Bundle.main.url(forResource: track, withExtension: ".mp3") else {
            print("Music file not found: \(track)")
            return
            
        }
        
        do {
            // MARK: plays sound whether device is on silent mode or not
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            
            if isPreview {
                player?.prepareToPlay()
            } else {
                player?.play()
                isPlaying = true
            }
        } catch {
            print("Failed to initialise player", error)
        }
    }
    
    func playPauseFunction() {
        guard let player = player else {
            print("No instance of the audio player was found")
            return
        }
        
        if player.isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }
    
    func stop() {
        guard let player = player else { return }
        
        if player.isPlaying {
            player.stop()
            isPlaying = false
        }
    }
}
