//
//  SoundPlayerView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-12-07.
//

import SwiftUI
import AVKit

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
