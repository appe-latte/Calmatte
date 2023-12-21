//
//  RiseShineCardView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-12-07.
//

import SwiftUI
import AVFoundation
import Lottie

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
    // Load an audio file by name
    private func loadAudio(audioName: String) {
        // Check if the track is already loaded
        if currentTrack == audioName && audioPlayer != nil {
            return
        }
        
        // Load the new track
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
    
    
    // Format time from seconds to "Minutes:Seconds"
    private func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 5) {
                    Image("img-sunrise")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: 400, alignment: .topLeading)
                        .overlay {
                            VStack(spacing: 5) {
                                Spacer()
                                
                                // MARK: Title
                                HStack {
                                    Text("Rise n' Shine")
                                        .font(.system(size: 23, design: .rounded))
                                        .fontWeight(.bold)
                                        .textCase(.uppercase)
                                        .kerning(3)
                                        .foregroundColor(np_white)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                
                                // MARK: Track Time
                                HStack(spacing: 5) {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.system(size: 9))
                                        .fontWeight(.heavy)
                                        .foregroundStyle(np_white)
                                    
                                    Text("Wellness Activity •")
                                        .font(.system(size: 8, design: .rounded))
                                        .fontWeight(.bold)
                                        .textCase(.uppercase)
                                        .kerning(2)
                                        .foregroundColor(np_white)
                                    
                                    Text("\(trackTime)min")
                                        .font(.system(size: 8, design: .rounded))
                                        .fontWeight(.bold)
                                        .textCase(.uppercase)
                                        .kerning(2)
                                        .foregroundColor(np_white)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.vertical, 10)
                        }
                        .edgesIgnoringSafeArea(.top)
                    
                    Spacer()
                    
                    // MARK: Equilibrium
//                    VStack {
//                        HStack(spacing: 5) {
//                            Label("Equilibrium", systemImage: "lock.open.fill")
//                                .font(.system(size: 14))
//                                .fontWeight(.semibold)
//                                .kerning(2)
//                                .textCase(.uppercase)
//                                .foregroundColor(np_white)
//                                .padding(5)
//                            
//                            Spacer()
//                        }
//                        .padding(.horizontal)
//                        
//                        HStack(spacing: 5) {
//                            Button(action: {
//                                self.playOrStop(trackName: "equilibrium")
//                            }) {
//                                Image(isPlaying ? "stop" : "play")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 40, height: 50)
//                                    .foregroundStyle(np_white)
//                            }
//                            
//                            Spacer()
//                            
//                            Label("\(currentTime) / \(duration)", systemImage: "")
//                                .font(.system(size: 10))
//                                .fontWeight(.semibold)
//                                .kerning(2)
//                                .textCase(.uppercase)
//                                .foregroundColor(np_white)
//                                .padding(5)
//                        }
//                        .frame(width: width)
//                        .padding(.horizontal, 10)
//                        
//                        ProgressView(value: progress)
//                            .progressViewStyle(BarProgressStyle(height: 50.0))
//                            .padding(.horizontal, 10)
//                    }
//                    .onAppear {
//                        self.loadAudio(audioName: "equilibrium")
//                    }
                    
                    // MARK: Piano_meditation
                    VStack {
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
                        
                        HStack(spacing: 5) {
                            Button(action: {
                                self.playOrStop(trackName: "piano-meditation")
                            }) {
                                Image(isPlaying ? "stop" : "play")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 50)
                                    .foregroundStyle(np_white)
                            }
                            
                            Spacer()
                            
                            Label("\(currentTime) / \(duration)", systemImage: "")
                                .font(.system(size: 10))
                                .fontWeight(.semibold)
                                .kerning(2)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                                .padding(5)
                        }
                        .frame(width: width)
                        .padding(.horizontal, 40)
                        
                        ProgressView(value: progress)
                            .progressViewStyle(BarProgressStyle(height: 50.0))
                            .padding(.horizontal, 10)
                    }
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
                .fill(np_arsenic)
                .frame(height: size.height, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MorningCardView()
}

// MARK: Progress Bar - custom
struct BarProgressStyle: ProgressViewStyle {
    var color: Color = np_white
    var height: Double = 20.0
    var labelFontStyle: Font = .body
    
    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0.0
        
        return GeometryReader { geometry in
            HStack {
                configuration.label
                    .font(labelFontStyle)
                
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(np_gray)
                        .opacity(0.15)
                        .frame(height: height)
                    
                    if progress > 0 {
                        Capsule()
                            .fill(color)
                            .frame(width: max(geometry.size.width * CGFloat(progress), height))
                    }
                }
                .frame(width: geometry.size.width, height: height)
            }
        }
    }
}

