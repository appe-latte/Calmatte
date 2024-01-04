//
//  RiseShineCardView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-12-07.
//

import SwiftUI
import Lottie
import AVFoundation

struct MorningCardView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var progress: Float = 0.0
    @State private var trackTime : Int = 2
    @State private var currentTime: String = "0:00"
    @State private var duration: String = "0:00"
    @State private var currentTrack: String?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
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
        } else {
            audioPlayer?.play()
            isPlaying = true
            
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
                            Image("img-sunrise")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width, height: 600)
                                .overlay {
                                    VStack(spacing: 5) {
                                        // MARK: Title
                                        HStack {
                                            Spacer()
                                            
                                            Text("Rise n' Shine")
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
                                            
                                            Text("Wellness Activity •")
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
                                            .frame(height: 300)
                                    }
                                    .padding(.vertical, 10)
                                }
                            
                        }
                        .clipShape(CustomHeaderShape())
                        .edgesIgnoringSafeArea(.top)
                    
                    Spacer()
                        .frame(height: 100)
                    
                    // MARK: Piano_meditation
                    VStack(spacing: 25) {
                        // MARK: Card Description
//                        Text("Breakfast is the most important meal of the day, but so is starting your day off right...Mentally! Take some time to meditate and get mentally prepared for the day.")
//                            .frame(width: width - 40, height: 100)
//                            .font(.system(size: 12, design: .rounded))
//                            .fontWeight(.medium)
//                            .textCase(.uppercase)
//                            .multilineTextAlignment(.leading)
//                            .lineLimit(4)
//                            .kerning(1)
                        
                        HStack(spacing: 5) {
                            Label("Piano Meditation", systemImage: "lock.open.fill")
                                .font(.system(size: 14))
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
                                self.playOrStop(trackName: "piano-meditation")
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
                        self.loadAudio(audioName: "piano-meditation")
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
    MorningCardView()
}
