//
//  WellnessView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-11-25.
//

import AVKit
import Lottie
import Combine
import SwiftUI

struct WellnessView: View {
    @StateObject private var soundPlayerViewModel = SoundPlayerViewModel()
    
    @State private var showPlayer = false
    @State private var wellnessDescription = "Take a moment to pause, take some deep breathes, reflect and centre your mind."
    
    let cards: [SoundCard] = [
        SoundCard(
            title: "Morning Meditation",
            description: "Relaxing meditative sounds to start your morning.",
            imageName: "img-sunrise",
            audioFileName: "equilibrium.mp3"
        ),
        SoundCard(
            title: "Afternoon Meditation",
            description: "Relaxing meditative sounds to keep you going through the day.",
            imageName: "img-day",
            audioFileName: "equilibrium.mp3"
        ),
        SoundCard(
            title: "Morning Meditation",
            description: "Relaxing meditative sounds to help you prepare your mind for rest.",
            imageName: "img-night",
            audioFileName: "equilibrium.mp3"
        ),
        SoundCard(
            title: "Get Your Mind Right",
            description: "Sound to help you calm your mind when things get too much.",
            imageName: "img-snow",
            audioFileName: "equilibrium.mp3"
        )
    ]
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: Background
            background()
            
            VStack {
                HeaderView()
                
                Spacer()
                
                NavigationView {
                    ScrollView {
                        LazyVStack {
                            ForEach(cards) { card in
                                NavigationLink(destination: SoundPlayerView(soundPlayerViewModel: soundPlayerViewModel)) {
                                    SoundCardView(card: card)
                                        .onTapGesture {
                                            soundPlayerViewModel.selectedSoundCard = card
                                        }
                                }
                            }
                        }
                    }
                    .background(np_arsenic)
                }
            }
        }
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Rectangle()
                .fill(np_arsenic)
                .frame(height: size.height)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
    
    // MARK: "Header View"
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Calmatte Wellness")
                    .font(.custom("Butler", size: 27))
                    .minimumScaleFactor(0.5)
                    .foregroundColor(np_white)
                
                Spacer()
            }
            .hAlign(.leading)
            
            // MARK: Description
            Text("\(wellnessDescription)")
                .font(.custom("Butler", size: 16))
                .kerning(3)
                .minimumScaleFactor(0.5)
                .foregroundColor(np_gray)
        }
        .padding(15)
        .background {
            VStack(spacing: 0) {
                np_jap_indigo
            }
            .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
            .ignoresSafeArea()
        }
    }
}

// MARK: Preview
struct WellnessView_Previews: PreviewProvider {
    static var previews: some View {
        WellnessView()
    }
}

// MARK: Sound Card View
struct SoundCardView: View {
    let card: SoundCard
    
    var body: some View {
        ZStack {
            Image(card.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            VStack {
                Spacer()
                
                Text(card.title)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .textCase(.uppercase)
                    .kerning(3)
                
                Text(card.description)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .textCase(.uppercase)
                    .kerning(3)
            }
            .frame(alignment: .leading)
            .padding(10)
        }
    }
}

// MARK: Sound Player View
struct SoundPlayerView: View {
    @ObservedObject var soundPlayerViewModel = SoundPlayerViewModel()
    
    let cards: [SoundCard] = [
        SoundCard(
            title: "Morning Meditation",
            description: "Relaxing meditative sounds to start your morning.",
            imageName: "img-sunrise",
            audioFileName: "equilibrium.mp3"
        ),
        SoundCard(
            title: "Afternoon Meditation",
            description: "Relaxing meditative sounds to keep you going through the day.",
            imageName: "img-day",
            audioFileName: "equilibrium.mp3"
        ),
        SoundCard(
            title: "Morning Meditation",
            description: "Relaxing meditative sounds to help you prepare your mind for rest.",
            imageName: "img-night",
            audioFileName: "equilibrium.mp3"
        ),
        SoundCard(
            title: "Get Your Mind Right",
            description: "Sound to help you calm your mind when things get too much.",
            imageName: "img-snow",
            audioFileName: "equilibrium.mp3"
        )
    ]
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Image(soundPlayerViewModel.selectedSoundCard?.imageName ?? "")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            // Rest of your player UI...
            
            
            //            LottieIconAnimView(animationFileName: "breathing-circle", loopMode: .loop, height: height / 2, width: width / 1.25)
        }
        .onAppear {
            soundPlayerViewModel.playSound()
        }
        .onDisappear {
            soundPlayerViewModel.pauseSound()
        }
    }
}
