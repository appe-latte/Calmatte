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
    @State var dragOffset: CGFloat = 0
    
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
                    
                    // MARK: Audio Section
                    VStack {
                        HStack {
                            Text("Wellness Audio")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .kerning(2)
                                .textCase(.uppercase)
                                .foregroundColor(np_jap_indigo)
                                .padding(5)
                                .background(np_white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // MARK: Card Carousel
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack(spacing: 10) {
                                // MARK: Morning Card
                                NavigationLink(destination: MorningCardView()){
                                    Image("img-sunrise")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 250, height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
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
                                        .frame(width: 250, height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
                                                HStack {
                                                    Label("Mid-day Pick Me Up", systemImage: "")
                                                        .font(.system(size: 10))
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
                                        .frame(width: 250, height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
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
                                        .frame(width: 250, height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
                                                HStack {
                                                    Label("Take Your Sunscreen", systemImage: "")
                                                        .font(.system(size: 10))
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
                                        .frame(width: 250, height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
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
                                        .frame(width: 250, height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.vertical, 10)
                                        .overlay {
                                            VStack {
                                                HStack {
                                                    Label("Water's Healing Powers", systemImage: "")
                                                        .font(.system(size: 10))
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
                            .padding(10)
                        }
                    }
                    
                    // MARK: Mental Health First Kit
                    VStack(spacing: 10) {
                        HStack {
                            Text("Mental Health First Kit")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .kerning(2)
                                .textCase(.uppercase)
                                .foregroundColor(np_jap_indigo)
                                .padding(5)
                                .background(np_white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        NavigationStack {
                            Group {
                                // MARK: Mental Health 101
                                NavigationLink(destination: MentalHealth101View()){
                                    HStack(spacing: 10) {
                                        Text("Mental Health 101")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .kerning(1)
                                            .textCase(.uppercase)
                                            .foregroundColor(np_white)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                    }
                                    .padding(.horizontal, 10)
                                }
                                
                                Divider()
                                    .background(np_gray)
                                
                                // MARK: DIY Calm
                                NavigationLink(destination: MentalHealth101View()){
                                    HStack(spacing: 10) {
                                        Text("DIY Calm")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .kerning(1)
                                            .textCase(.uppercase)
                                            .foregroundColor(np_white)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                    }
                                    .padding(.horizontal, 10)
                                }
                                
                                Divider()
                                    .background(np_gray)
                                
                                // MARK: Helping Your Squad
                                NavigationLink(destination: MentalHealth101View()){
                                    HStack(spacing: 10) {
                                        Text("Helping Your Squad")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .kerning(1)
                                            .textCase(.uppercase)
                                            .foregroundColor(np_white)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                    }
                                    .padding(.horizontal, 10)
                                }
                                
                                Divider()
                                    .background(np_gray)
                                
                                // MARK: When Things Get Real
                                NavigationLink(destination: MentalHealth101View()){
                                    HStack(spacing: 10) {
                                        Text("When Things Get Real")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .kerning(1)
                                            .textCase(.uppercase)
                                            .foregroundColor(np_white)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                    }
                                    .padding(.horizontal, 10)
                                }
                                
                                Divider()
                                    .background(np_gray)
                                
                                // MARK: Pro Talk
                                NavigationLink(destination: MentalHealth101View()){
                                    HStack(spacing: 10) {
                                        Text("Pro Talk")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .kerning(1)
                                            .textCase(.uppercase)
                                            .foregroundColor(np_white)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                    }
                                    .padding(.horizontal, 10)
                                }
                                
                                Divider()
                                    .background(np_gray)
                                
                                // MARK: Keepin' It Steady
                                NavigationLink(destination: MentalHealth101View()){
                                    HStack(spacing: 10) {
                                        Text("Keepin' It Steady")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .kerning(1)
                                            .textCase(.uppercase)
                                            .foregroundColor(np_white)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                    }
                                    .padding(.horizontal, 10)
                                }
                                
                                Divider()
                                    .background(np_gray)
                            }
                        }
                    }
                    
                    Spacer()
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
