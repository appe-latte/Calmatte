//
//  AudioManager.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import AVFoundation
import SwiftUI

final class AudioManager: ObservableObject {
    public var player: AVAudioPlayer?
    private var track: String?
    private var isPreview: Bool = false
    
    @Published var isPlaying: Bool = false {
        didSet {
            print("isPlaying", isPlaying)
        }
    }
    
    func startPlayer(track: String, isPreview: Bool = false) {
        self.track = track
        self.isPreview = isPreview
        
        guard let url = Bundle.main.url(forResource: track, withExtension: ".mp3") else {
            print("Music file not found: \(track)")
            return
        }
        
        do {
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
            print("Failed to initialize player:", error)
        }
    }
    
    func playPause() {
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
            player.currentTime = 0
        }
    }
    
    func replay() {
        guard let track = track, !isPreview else { return }
        stop()
        startPlayer(track: track)
    }
}
