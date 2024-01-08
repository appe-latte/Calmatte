//
//  MeditationView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import SwiftUI
import AVKit

struct MeditationView: View {
    @StateObject var meditationViewModel : MeditationViewModel
    @StateObject var audioManager = AudioManager()
    @State private var showPlayer = false
    
    @State private var meditationDescription = "Take a moment to pause, take some deep breathes, reflect and centre your mind."
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: Background
            background()
            
            VStack {
                HeaderView()
                
                Spacer()
                
                // MARK: "Content" section
                BreathingView()
                
                // MARK: User Subscription Status
                //            VStack {
                //                HStack {
                //                    Image("paid")
                //                        .resizable()
                //                        .frame(width: 25, height: 25)
                //                        .padding(5)
                //                        .foregroundColor(np_turq)
                //
                //                    Text("Subscription:")
                //                        .font(.caption2)
                //                        .fontWeight(.semibold)
                //                        .kerning(2)
                //                        .textCase(.uppercase)
                //                        .foregroundColor(np_white)
                //
                //                    Text(userViewModel.isSubscriptionActive ? "Calmatte Plus" : "Free")
                //                        .font(.caption2)
                //                        .fontWeight(.semibold)
                //                        .kerning(2)
                //                        .textCase(.uppercase)
                //                        .foregroundColor(np_white)
                //                }
                //            }
                //            .padding(.horizontal, 20)
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
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Meditation Break")
                            .font(.custom("Butler", size: 27))
                            .minimumScaleFactor(0.5)
                            .foregroundColor(np_white)
                        
                        Spacer()
                    }
                    
                    // MARK: Description
                    Text("\(meditationDescription)")
                        .font(.custom("Butler", size: 16))
                        .kerning(3)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(np_gray)
                }
                .hAlign(.leading)
            }
        }
        .padding(15)
        .background {
            VStack(spacing: 0) {
                np_jap_indigo
            }
            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
            .ignoresSafeArea()
        }
    }
    
    // MARK: Meditation View
    @ViewBuilder
    func BreathingView() -> some View {
        VStack {
            LottieIconAnimView(animationFileName: "breathing-bear", loopMode: .loop, height: height / 2, width: width / 1.25)
            
            // MARK: "Play / Stop" sound
            HStack {
                Spacer()
                
                MeditationPlayerView(meditationViewModel: meditationViewModel)
                    .frame(width: 60, height: 60)
                    .background(np_jap_indigo)
                    .clipShape(Circle())
            }
            .padding()
        }
        .frame(alignment: .center)
    }
}

// MARK: extension for rounded corners for ZStack
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct MeditationView_Previews: PreviewProvider {
    static let meditationViewModel = MeditationViewModel(meditation: Meditation.data)
    
    static var previews: some View {
        MeditationView(meditationViewModel: meditationViewModel)
            .environmentObject(AudioManager())
    }
}
