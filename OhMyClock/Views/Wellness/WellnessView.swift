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
                    
                    ScrollView(.horizontal) {
                        VStack(spacing: 5) {
                            // MARK: Sound Cards
                            HStack {
                                // MARK: Morning Card
                                NavigationLink(destination: MorningCardView()){
                                    Image("img-sunrise")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 190, height: 130)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
                                                HStack {
                                                    Label("Rise n' Shine", systemImage: "")
                                                        .font(.system(size: 6))
                                                        .fontWeight(.semibold)
                                                        .kerning(2)
                                                        .textCase(.uppercase)
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
                                        .frame(width: 190, height: 130)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
                                                HStack {
                                                    Label("Mid-day Pick Me Up", systemImage: "")
                                                        .font(.system(size: 6))
                                                        .fontWeight(.semibold)
                                                        .kerning(2)
                                                        .textCase(.uppercase)
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
                                
                                // MARK: Evening Card
                                NavigationLink(destination: NightCardView()){
                                    Image("img-night")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 190, height: 130)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
                                                HStack {
                                                    Label("Couch n' Chill", systemImage: "")
                                                        .font(.system(size: 6))
                                                        .fontWeight(.semibold)
                                                        .kerning(2)
                                                        .textCase(.uppercase)
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
                                        .frame(width: 190, height: 130)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
                                                HStack {
                                                    Label("Take Your Sunscreen", systemImage: "")
                                                        .font(.system(size: 6))
                                                        .fontWeight(.semibold)
                                                        .kerning(2)
                                                        .textCase(.uppercase)
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
                                
                                // MARK: Nature Card
                                NavigationLink(destination: NatureCardView()){
                                    Image("img-nature")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 190, height: 130)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
                                                HStack {
                                                    Label("Be One With Nature", systemImage: "")
                                                        .font(.system(size: 6))
                                                        .fontWeight(.semibold)
                                                        .kerning(2)
                                                        .textCase(.uppercase)
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
                                        .frame(width: 190, height: 130)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
                                                HStack {
                                                    Label("Water's Healing Powers", systemImage: "")
                                                        .font(.system(size: 6))
                                                        .fontWeight(.semibold)
                                                        .kerning(2)
                                                        .textCase(.uppercase)
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
//                            .frame(width: width - 20)
//                            
//                            // MARK: Row Two
//                            HStack {
//                                // MARK: Evening Card
//                                NavigationLink(destination: NightCardView()){
//                                    Image("img-night")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: 190, height: 130)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                                        .padding(.vertical, 10)
//                                        .overlay {
//                                            VStack {
//                                                HStack {
//                                                    Label("Couch n' Chill", systemImage: "")
//                                                        .font(.system(size: 6))
//                                                        .fontWeight(.semibold)
//                                                        .kerning(2)
//                                                        .textCase(.uppercase)
//                                                        .foregroundColor(np_jap_indigo)
//                                                        .padding(5)
//                                                        .background(np_white)
//                                                        .clipShape(RoundedRectangle(cornerRadius: 5))
//                                                    
//                                                    Spacer()
//                                                }
//                                                
//                                                Spacer()
//                                            }
//                                            .padding(.horizontal)
//                                        }
//                                }
//                                
//                                // MARK: Beach Card
//                                NavigationLink(destination: BeachCardView()){
//                                    Image("img-beach")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: 190, height: 130)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                                        .padding(.vertical, 10)
//                                        .overlay {
//                                            VStack {
//                                                HStack {
//                                                    Label("Take Your Sunscreen", systemImage: "")
//                                                        .font(.system(size: 6))
//                                                        .fontWeight(.semibold)
//                                                        .kerning(2)
//                                                        .textCase(.uppercase)
//                                                        .foregroundColor(np_white)
//                                                        .padding(5)
//                                                        .background(np_jap_indigo)
//                                                        .clipShape(RoundedRectangle(cornerRadius: 5))
//                                                    
//                                                    Spacer()
//                                                }
//                                                
//                                                Spacer()
//                                            }
//                                            .padding(.horizontal)
//                                        }
//                                }
//                            }
//                            .frame(width: width - 20)
//                            
//                            // MARK: Row Three
//                            HStack {
//                                // MARK: Nature Card
//                                NavigationLink(destination: NatureCardView()){
//                                    Image("img-nature")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: 190, height: 130)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                                        .padding(.vertical, 10)
//                                        .overlay {
//                                            VStack {
//                                                HStack {
//                                                    Label("Be One With Nature", systemImage: "")
//                                                        .font(.system(size: 6))
//                                                        .fontWeight(.semibold)
//                                                        .kerning(2)
//                                                        .textCase(.uppercase)
//                                                        .foregroundColor(np_jap_indigo)
//                                                        .padding(5)
//                                                        .background(np_white)
//                                                        .clipShape(RoundedRectangle(cornerRadius: 5))
//                                                    
//                                                    Spacer()
//                                                }
//                                                
//                                                Spacer()
//                                            }
//                                            .padding(.horizontal)
//                                        }
//                                }
//                                
//                                // MARK: Water's Healing Powers
//                                NavigationLink(destination: WaterCardView()){
//                                    Image("img-water")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: 190, height: 130)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                                        .padding(.vertical, 10)
//                                        .overlay {
//                                            VStack {
//                                                HStack {
//                                                    Label("Water's Healing Powers", systemImage: "")
//                                                        .font(.system(size: 6))
//                                                        .fontWeight(.semibold)
//                                                        .kerning(2)
//                                                        .textCase(.uppercase)
//                                                        .foregroundColor(np_white)
//                                                        .padding(5)
//                                                        .background(np_jap_indigo)
//                                                        .clipShape(RoundedRectangle(cornerRadius: 5))
//                                                    
//                                                    Spacer()
//                                                }
//                                                
//                                                Spacer()
//                                            }
//                                            .padding(.horizontal)
//                                        }
//                                }
//                            }
//                            .frame(width: width - 20)
                            
                            Spacer()
                        }
                    }
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
