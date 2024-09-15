//
//  WellnessAudioView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2024-01-08.
//

import AVKit
import Lottie
import Combine
import SwiftUI

struct WellnessAudioView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var dragOffset: CGFloat = 0
    
    @State private var wellnessDescription = "Embrace this sanctuary of sound and support, designed for your journey towards inner peace and balance."
    @State private var showPlayer = false
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    @State var showDiySheet = false
    @State var show101Sheet = false
    @State var showSquadHelpSheet = false
    @State var showGetRealSheet = false
    @State var showProTalkSheet = false
    @State var showSelfCareSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // MARK: Background
                background()
                
                VStack {
//                    HeaderView()
                    
                    // MARK: Card Carousel
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            // MARK: Row One
                            HStack(spacing: 10) {
                                // MARK: Morning Card
                                NavigationLink(destination: MorningCardView()){
                                    Image("img-sunrise")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
                                                HStack {
                                                    Label("Rise n' Shine", systemImage: "")
                                                        .font(.system(size:  10, weight: .semibold, design: .rounded))
                                                        .textCase(.uppercase)
                                                        .kerning(1)
                                                        .foregroundColor(np_jap_indigo)
                                                        .padding(5)
                                                        .background(np_white)
                                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                                    
                                                    Spacer()
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(.horizontal)
                                        }
                                }
                                
                                // MARK: Afternoon Card
                                NavigationLink(destination: AfternoonCardView()){
                                    Image("img-day")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
                                                HStack {
                                                    Label("Mid-day Pick Me Up", systemImage: "")
                                                        .font(.system(size:  10, weight: .semibold, design: .rounded))
                                                        .textCase(.uppercase)
                                                        .kerning(1)
                                                        .foregroundColor(np_white)
                                                        .padding(5)
                                                        .background(np_jap_indigo)
                                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                                    
                                                    Spacer()
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(.horizontal)
                                        }
                                }
                            }
                            .padding(5)
                            
                            // MARK: Row Two
                            HStack(spacing: 10) {
                                // MARK: Evening Card
                                NavigationLink(destination: NightCardView()){
                                    Image("img-night")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
                                                HStack {
                                                    Label("Couch n' Chill", systemImage: "")
                                                        .font(.system(size:  10, weight: .semibold, design: .rounded))
                                                        .textCase(.uppercase)
                                                        .kerning(1)
                                                        .foregroundColor(np_jap_indigo)
                                                        .padding(5)
                                                        .background(np_white)
                                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                                    
                                                    Spacer()
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(.horizontal)
                                        }
                                }
                                
                                // MARK: Beach Card
                                NavigationLink(destination: BeachCardView()){
                                    Image("img-beach")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
                                                HStack {
                                                    Label("Take Your Sunscreen", systemImage: "")
                                                        .font(.system(size:  10, weight: .semibold, design: .rounded))
                                                        .textCase(.uppercase)
                                                        .kerning(1)
                                                        .foregroundColor(np_white)
                                                        .padding(5)
                                                        .background(np_jap_indigo)
                                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                                    
                                                    Spacer()
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(.horizontal)
                                        }
                                }
                            }
                            .padding(5)
                            
                            // MARK: Row Three
                            HStack(spacing: 10){
                                // MARK: Nature Card
                                NavigationLink(destination: NatureCardView()){
                                    Image("img-nature")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
                                                HStack {
                                                    Label("Be One With Nature", systemImage: "")
                                                        .font(.system(size:  10, weight: .semibold, design: .rounded))
                                                        .textCase(.uppercase)
                                                        .kerning(1)
                                                        .foregroundColor(np_jap_indigo)
                                                        .padding(5)
                                                        .background(np_white)
                                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                                    
                                                    Spacer()
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(.horizontal)
                                        }
                                }
                                
                                // MARK: Water's Healing Powers
                                NavigationLink(destination: WaterCardView()){
                                    Image("img-water")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
                                                HStack {
                                                    Label("Water's Healing Powers", systemImage: "")
                                                        .font(.system(size:  10, weight: .semibold, design: .rounded))
                                                        .textCase(.uppercase)
                                                        .kerning(1)
                                                        .foregroundColor(np_white)
                                                        .padding(5)
                                                        .background(np_jap_indigo)
                                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                                    
                                                    Spacer()
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(.horizontal)
                                        }
                                }
                            }
                            .padding(5)
                        }
                    }
                    
                    Spacer()
                }
            }
                        .frame(width: width)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack(spacing: 10) {
                Image(systemName: "chevron.left")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(np_jap_indigo)
                    .padding(10)
                    .background(Circle().fill(np_white))
                
                Spacer()
                
                Text("Wellness Audio")
                    .font(.system(size: 27, weight: .semibold, design: .rounded))
                    .kerning(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(np_white)
            }
            .hAlign(.leading)
            
        })
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
//            
//            Image("img-bg")
//                .resizable()
//                .scaledToFill()
//                .frame(height: size.height, alignment: .bottom)
            
            Rectangle()
                .fill(np_arsenic)
//                .opacity(0.98)
                .frame(height: size.height, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
    
    // MARK: "Header View"
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 2) {
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

#Preview {
    WellnessAudioView()
}
