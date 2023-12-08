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

struct WellnessSoundsView: View {
    @State private var wellnessDescription = "Sounds to help you meditate, calm your mind or get through the day."
    @State private var showPlayer = false
    
    let wellCard: [WellnessCard] = [
        WellnessCard(
            title: "Rise n' Shine",
            description: "Breakfast is the most important meal of the day, but so is starting your day off right...Mentally! Take some time to meditate and get mentally prepared for the day.",
            imageName: "img-sunrise"
        ),
        WellnessCard(
            title: "Mid-day Pick Me Up",
            description: "The day maybe hectic, but take a mindfulness break to quieten your mind, calm yourself and give yourself the best chance of being productive for the remaining hours of the day.",
            imageName: "img-day"
        ),
        WellnessCard(
            title: "Couch n' Chill",
            description: "It's been a long day, now it's time to relax, reset and prepare your mind for some much needed rest.",
            imageName: "img-night"
        ),
        WellnessCard(
            title: "Take Your Sunscreen",
            description: "Put your shades on and bring the beach to you with calming sounds of the beach.",
            imageName: "img-beach"
        ),
        WellnessCard(
            title: "Be One With Nature",
            description: "Tune out all the noise from world and enjoy the calming sounds of mother nature.",
            imageName: "img-nature"
        ),
        WellnessCard(
            title: "Water's Healing Powers",
            description: "Nothing is more relaxing than listening to calming sound of the rain gently pouring down or the soothing ripples of a stream in the woods.",
            imageName: "img-water"
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
                            ForEach(wellCard) { card in
                                WellnessCardView(wellCard: card)
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
        WellnessSoundsView()
    }
}

// MARK: Sound Card View
struct WellnessCardView: View {
    let wellCard: WellnessCard
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            VStack {
                Image(wellCard.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                VStack(spacing: 10) {
                    Text(wellCard.title)
                        .font(.headline)
                        .fontWeight(.heavy)
                        .textCase(.uppercase)
                        .kerning(3)
                    
                    Text(wellCard.description)
                        .font(.system(size: 9))
                        .fontWeight(.medium)
                        .textCase(.uppercase)
                        .kerning(3)
                        .minimumScaleFactor(0.6)
                        .padding(5)
                }
                .frame(width:width, height: 80, alignment: .center)
                .padding(5)
            }
        }
    }
}
