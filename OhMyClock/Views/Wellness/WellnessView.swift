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
            title: "Rise n' Shine",
            description: "Breakfast is the most important meal but so is starting your day off right mentally, listen to some meditative sounds to get you ready for the day.",
            imageName: "img-sunrise",
            audioFileName: "equilibrium.mp3"
        ),
        SoundCard(
            title: "Mid-day Pick Me Up",
            description: "The day maybe hectic, but take some time out to quieten your mind to keep your calm and productive throughout the remainder of the day.",
            imageName: "img-day",
            audioFileName: "equilibrium.mp3"
        ),
        SoundCard(
            title: "Couch n' Chill",
            description: "It's been a long day, now it's time to relax, reset and prepare your mind for some much needed rest.",
            imageName: "img-night",
            audioFileName: "equilibrium.mp3"
        ),
        SoundCard(
            title: "Take Your Sunscreen",
            description: "Put your shades on and bring the beach to you with calming sounds of the beach.",
            imageName: "img-beach",
            audioFileName: "equilibrium.mp3"
        ),
        SoundCard(
            title: "Be One With Nature",
            description: "Tune out all the noise from world and enjoy the calming sounds of mother nature.",
            imageName: "img-nature",
            audioFileName: "equilibrium.mp3"
        ),
        SoundCard(
            title: "Water's Healing Powers",
            description: "Nothing is more relaxing than listening to sound of rain or the gentle ripples of a stream.",
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
            
            Image("img-bg")
                .resizable()
                .scaledToFill()
                .frame(height: size.height, alignment: .bottom)
            
            Rectangle()
                .fill(np_arsenic)
                .opacity(0.98)
                .frame(height: size.height, alignment: .bottom)
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
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            VStack {
                Image(card.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                VStack(spacing: 10) {
                    Text(card.title)
                        .font(.headline)
                        .fontWeight(.heavy)
                        .textCase(.uppercase)
                        .kerning(3)
                    
                    Text(card.description)
                        .font(.system(size: 9))
                        .fontWeight(.medium)
                        .textCase(.uppercase)
                        .kerning(3)
                }
                .frame(width:width, height: 80, alignment: .leading)
                .padding(5)
            }
        }
    }
}

// MARK: Sound Player View
struct SoundPlayerView: View {
    @ObservedObject var soundPlayerViewModel = SoundPlayerViewModel()
    
    let cards: [SoundCard] = [
        SoundCard(
            title: "Rise n' Shine",
            description: "Breakfast is the most important meal but so is starting your day off right mentally, listen to some meditative sounds to get you ready for the day.",
            imageName: "img-sunrise",
            audioFileName: "equilibrium.mp3"
        ),
        SoundCard(
            title: "Mid-day Pick Me Up",
            description: "The day maybe hectic, but take some time out to quieten your mind to keep your calm and productive throughout the remainder of the day.",
            imageName: "img-day",
            audioFileName: "equilibrium.mp3"
        ),
        SoundCard(
            title: "Couch n' Chill",
            description: "It's been a long day, now it's time to relax, reset and prepare your mind for some much needed rest.",
            imageName: "img-night",
            audioFileName: "equilibrium.mp3"
        ),
        SoundCard(
            title: "Take Your Sunscreen",
            description: "Put your shades on and bring the beach to you with calming sounds of the beach.",
            imageName: "img-beach",
            audioFileName: "equilibrium.mp3"
        ),
        SoundCard(
            title: "Be One With Nature",
            description: "Tune out all the noise from world and enjoy the calming sounds of mother nature.",
            imageName: "img-nature",
            audioFileName: "equilibrium.mp3"
        ),
        SoundCard(
            title: "Water's Healing Powers",
            description: "Nothing is more relaxing than listening to sound of rain or the gentle ripples of a stream.",
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
