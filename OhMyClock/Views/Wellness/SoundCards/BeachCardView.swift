//
//  TakeSunscreenView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-12-21.
//

import SwiftUI
import Lottie
import AVFoundation

struct BeachCardView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var progress: Float = 0.0
    @State private var trackTime : Int = 1
    @State private var currentTime: String = "0:00"
    @State private var duration: String = "0:00"
    @State private var currentTrack: String?
    @State private var animationTimer: Timer?
    
    @State private var amplitude : CGFloat = 0.8
    @State private var phase : CGFloat = 0.0
    @State private var change : CGFloat = 0.1
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let id = UUID()
    
    // MARK: Load Audio File
    private func loadAudio(audioName: String) {
        if currentTrack == audioName && audioPlayer != nil {
            return
        }
        
        guard let url = Bundle.main.url(forResource: audioName, withExtension: "mp3") else {
            print("Audio file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            duration = formatTime(time: audioPlayer?.duration ?? 0)
            currentTime = "0:00"
            progress = 0.0
            currentTrack = audioName
        } catch {
            print("Audio file could not be loaded")
        }
    }
    
    // MARK: Play/Stop Controls
    private func playOrStop(trackName: String) {
        if currentTrack != trackName || audioPlayer == nil {
            loadAudio(audioName: trackName)
        }
        
        if isPlaying {
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0 // Reset the track to the beginning
            isPlaying = false
            animationTimer?.invalidate() // Stops the waveform animation
        } else {
            audioPlayer?.play()
            isPlaying = true
            startAnimation()
            
            // Update progress and track time
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if let player = audioPlayer {
                    if player.isPlaying {
                        self.progress = Float(player.currentTime / player.duration)
                        self.currentTime = formatTime(time: player.currentTime)
                    } else {
                        timer.invalidate()
                        self.progress = 0.0
                        self.currentTime = "0:00"
                        self.isPlaying = false
                    }
                }
            }
        }
    }
    
    // MARK: Animation Control
    private func startAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            withAnimation(.linear(duration: 0.1)) {
                self.amplitude = self._nextAmplitude()
                self.phase -= 1.5
            }
        }
    }
    
    // MARK: Skip Forward/Backward
    private func skip(seconds: TimeInterval) {
        guard let player = audioPlayer else { return }
        
        let newTime = player.currentTime + seconds
        if newTime < 0 {
            audioPlayer?.currentTime = 0
        } else if newTime > player.duration {
            audioPlayer?.currentTime = player.duration
        } else {
            audioPlayer?.currentTime = newTime
        }
        
        self.updateProgress()
    }
    
    // MARK: Amplitude for waveform
    private func _nextAmplitude() -> CGFloat {
        if self.amplitude <= 0.01 {
            self.change = 0.1
            return 0.02
        } else if self.amplitude > 0.9 {
            self.change = -0.1
            return 0.9
        }
        
        let newAmplitude = self.amplitude + (self.change * CGFloat.random(in: 0.3...0.8))
        return max(0.01, newAmplitude)
    }
    
    // MARK: Update Progress
    private func updateProgress() {
        if let player = audioPlayer {
            self.progress = Float(player.currentTime / player.duration)
            self.currentTime = formatTime(time: player.currentTime)
        }
    }
    
    private func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 5) {
                    CustomHeaderShape()
                        .frame(width: width, height: 500)
                        .overlay {
                            Image("img-beach")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width, height: 600)
                                .overlay {
                                    VStack(spacing: 5) {
                                        // MARK: Title
                                        HStack {
                                            Spacer()
                                            
                                            Text("Take Your Sunscreen")
                                                .font(.system(size: 23, design: .rounded))
                                                .fontWeight(.bold)
                                                .textCase(.uppercase)
                                                .kerning(3)
                                                .foregroundColor(np_black)
                                        }
                                        .padding(.horizontal, 20)
                                        
                                        // MARK: Track Time
                                        HStack(spacing: 5) {
                                            Spacer()
                                            
                                            Image(systemName: "speaker.wave.2.fill")
                                                .font(.system(size: 9))
                                                .fontWeight(.heavy)
                                                .foregroundStyle(np_black)
                                            
                                            Text("Wellness Sounds •")
                                                .font(.system(size: 8, design: .rounded))
                                                .fontWeight(.bold)
                                                .textCase(.uppercase)
                                                .kerning(2)
                                                .foregroundColor(np_black)
                                            
                                            Text("\(trackTime)min")
                                                .font(.system(size: 8, design: .rounded))
                                                .fontWeight(.bold)
                                                .textCase(.uppercase)
                                                .kerning(2)
                                                .foregroundColor(np_black)
                                        }
                                        .padding(.horizontal, 20)
                                        
                                        Spacer()
                                            .frame(height: 20)
                                        
                                        Muiltiwave(amplitude: amplitude, color: np_arsenic, phase: phase)
                                            .frame(height: 300)
                                    }
                                    .padding(.vertical, 10)
                                }
                        }
                        .clipShape(CustomHeaderShape())
                        .edgesIgnoringSafeArea(.top)
                    
                    
                    Spacer()
                        .frame(height: 100)
                    
                    // MARK: Ocean Ambience Sound
                    VStack(spacing: 25) {
                        HStack(spacing: 5) {
                            Label("Ocean Ambience", systemImage: "lock.open.fill")
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                                .kerning(2)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                                .padding(5)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 35) {
                            // "Skip Backwards" button
                            Button(action: {
                                self.skip(seconds: -10)
                            }) {
                                Image(systemName: "gobackward.10")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(np_white)
                            }
                            
                            // "Play / Stop" button
                            Button(action: {
                                self.playOrStop(trackName: "ocean-ambience")
                            }) {
                                Image(systemName: isPlaying ? "stop.circle.fill" : "play.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(np_white)
                            }
                            
                            // "Skip forward" button
                            Button(action: {
                                self.skip(seconds: 10)
                            }) {
                                Image(systemName: "goforward.10")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(np_white)
                            }
                        }
                        .frame(width: width - 40)
                        
                        ProgressView(value: progress)
                            .accentColor(np_white)
                            .padding(.horizontal)
                        
                        HStack {
                            Text("\(currentTime)")
                                .font(.system(size: 10))
                                .fontWeight(.semibold)
                                .kerning(2)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                                .padding(5)
                            
                            Spacer()
                            
                            Text("\(duration)")
                                .font(.system(size: 10))
                                .fontWeight(.semibold)
                                .kerning(2)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                                .padding(5)
                        }
                        .frame(width: width - 40)
                    }
                    .padding(.bottom, 150)
                    .onAppear {
                        self.loadAudio(audioName: "ocean-ambience")
                    }
                    .onDisappear {
                        self.audioPlayer?.stop()
                        self.audioPlayer?.currentTime = 0
                        self.isPlaying = false
                    }
                }
            }
            .background(background())
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(np_jap_indigo)
                    .padding(10)
                    .background(Circle().fill(np_white))
            })
        }
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Rectangle()
                .fill(np_jap_indigo)
                .frame(height: size.height, alignment: .bottom)
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    BeachCardView()
}
