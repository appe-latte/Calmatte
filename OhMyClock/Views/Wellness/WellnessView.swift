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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var wellnessDescription = "Sounds to help you meditate, calm your mind or get through the day."
    @State private var showPlayer = false
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // MARK: Background
                background()
                
                VStack {
                    HeaderView()
                    
                    Spacer()
                    
                    ScrollView {
                        LazyVStack {
                            // MARK: Rise n' Shine
                            NavigationLink(destination: MorningCardView()){
                                VStack(spacing: 5) {
                                    HStack {
                                        Label("Rise n' Shine", systemImage: "")
                                            .font(.system(size: 10))
                                            .fontWeight(.semibold)
                                            .kerning(2)
                                            .textCase(.uppercase)
                                            .foregroundColor(np_jap_indigo)
                                            .padding(5)
                                            .background(np_white)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    
                                    // Image - Rise n' Shine
                                    Image("img-sunrise")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: width - 30, height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                    
                                    // Text - Rise n' Shine
                                    Text("Breakfast is the most important meal of the day, but so is starting your day off right...Mentally! Take some time to meditate and get mentally prepared for the day.")
                                        .font(.system(size: 9, design: .rounded))
                                        .fontWeight(.medium)
                                        .textCase(.uppercase)
                                        .kerning(1)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(4)
                                        .minimumScaleFactor(0.6)
                                        .padding(.horizontal, 5)
                                }
                                .padding(.bottom, 15)
                            }
                            
                            // MARK: Mid-day
                            NavigationLink(destination: AfternoonCardView()){
                                VStack(spacing: 5) {
                                    HStack {
                                        Label("Mid-day Pick Me Up", systemImage: "")
                                            .font(.system(size: 10))
                                            .fontWeight(.semibold)
                                            .kerning(2)
                                            .textCase(.uppercase)
                                            .foregroundColor(np_jap_indigo)
                                            .padding(5)
                                            .background(np_white)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    
                                    // Image - Mid-day
                                    Image("img-day")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: width - 40, height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                    
                                    // Text - Mid-day
                                    Text("The day maybe hectic, but take a mindfulness break to quieten your mind, calm yourself and give yourself the best chance of being productive for the remaining hours of the day.")
                                        .font(.system(size: 9, design: .rounded))
                                        .fontWeight(.medium)
                                        .textCase(.uppercase)
                                        .kerning(1)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(4)
                                        .minimumScaleFactor(0.6)
                                        .padding(.horizontal, 5)
                                }
                                .padding(.bottom, 15)
                            }
                            
                            // MARK: Couch n' Chill
                            NavigationLink(destination: NightCardView()){
                                VStack(spacing: 5) {
                                    HStack {
                                        Label("Couch n' Chill", systemImage: "")
                                            .font(.system(size: 10))
                                            .fontWeight(.semibold)
                                            .kerning(2)
                                            .textCase(.uppercase)
                                            .foregroundColor(np_jap_indigo)
                                            .padding(5)
                                            .background(np_white)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    
                                    // Image - Couch n' Chill
                                    Image("img-night")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: width - 30, height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                    
                                    // Text - Couch n' Chill
                                    Text("It's been a long day, now it's time to relax, reset and prepare your mind for some much needed rest.")
                                        .font(.system(size: 9, design: .rounded))
                                        .fontWeight(.medium)
                                        .textCase(.uppercase)
                                        .kerning(1)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(4)
                                        .minimumScaleFactor(0.6)
                                        .padding(.horizontal, 5)
                                }
                                .padding(.bottom, 15)
                            }
                            
                            // MARK: Take Your Sunscreen
                            NavigationLink(destination: BeachCardView()){
                                VStack(spacing: 5) {
                                    HStack {
                                        Label("Take Your Sunscreen", systemImage: "")
                                            .font(.system(size: 10))
                                            .fontWeight(.semibold)
                                            .kerning(2)
                                            .textCase(.uppercase)
                                            .foregroundColor(np_jap_indigo)
                                            .padding(5)
                                            .background(np_white)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    
                                    // Image - Take Your Sunscreen
                                    Image("img-beach")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: width - 30, height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                    
                                    // Text - Take Your Sunscreen
                                    Text("Put your shades on and bring the beach to you with calming sounds of the beach.")
                                        .font(.system(size: 9, design: .rounded))
                                        .fontWeight(.medium)
                                        .textCase(.uppercase)
                                        .kerning(1)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(4)
                                        .minimumScaleFactor(0.6)
                                        .padding(.horizontal, 5)
                                }
                                .padding(.bottom, 15)
                            }
                            
                            // MARK: Be One With Nature
                            NavigationLink(destination: NatureCardView()){
                                VStack(spacing: 5) {
                                    HStack {
                                        Label("Be One With Nature", systemImage: "")
                                            .font(.system(size: 10))
                                            .fontWeight(.semibold)
                                            .kerning(2)
                                            .textCase(.uppercase)
                                            .foregroundColor(np_jap_indigo)
                                            .padding(5)
                                            .background(np_white)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    
                                    // Image - Be One With Nature
                                    Image("img-nature")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: width - 30, height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                    
                                    // Text - Be One With Nature
                                    Text("Tune out all the noise from world and enjoy the calming sounds of mother nature.")
                                        .font(.system(size: 9, design: .rounded))
                                        .fontWeight(.medium)
                                        .textCase(.uppercase)
                                        .kerning(1)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(4)
                                        .minimumScaleFactor(0.6)
                                        .padding(.horizontal, 5)
                                }
                                .padding(.bottom, 15)
                            }
                            
                            // MARK: Water's Healing Powers
                            NavigationLink(destination: WaterCardView()){
                                VStack(spacing: 5) {
                                    HStack {
                                        Label("Water's Healing Powers", systemImage: "")
                                            .font(.system(size: 10))
                                            .fontWeight(.semibold)
                                            .kerning(2)
                                            .textCase(.uppercase)
                                            .foregroundColor(np_jap_indigo)
                                            .padding(5)
                                            .background(np_white)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    
                                    // Image - Water's Healing Powers
                                    Image("img-water")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: width - 30, height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                    
                                    // Text - Water's Healing Powers
                                    Text("Nothing is more relaxing than listening to calming sound of the rain gently pouring down or the soothing ripples of a stream in the woods.")
                                        .font(.system(size: 9, design: .rounded))
                                        .fontWeight(.medium)
                                        .textCase(.uppercase)
                                        .kerning(1)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(4)
                                        .minimumScaleFactor(0.6)
                                        .padding(.horizontal, 5)
                                }
                            }
                        }
                    }
                    .background(np_arsenic)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text("Calmatte Wellness")
                    .font(.system(size: 27, weight: .semibold, design: .rounded))
                    .kerning(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(np_white)
                
                Spacer()
            }
            .hAlign(.leading)
            
            // MARK: Description
            Text("\(wellnessDescription)")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .kerning(1)
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
