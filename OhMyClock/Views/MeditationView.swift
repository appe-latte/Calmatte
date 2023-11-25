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
    @State private var showPlayer = false
    @State private var breathingAnimation = false
    @State private var textBreathingAnimation = false
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // MARK: Breathing Animation
    @Namespace private var animation
    @State private var currentType : BreathType = sampleTypes[0]
    @State private var showBreatheView = false
    @State private var startAnimation = false
    @State private var timerCount : CGFloat = 0
    @State private var breatheAction = "Breathe In"
    @State private var count = 0
    @State private var breathingScale = false
    
    @EnvironmentObject var userViewModel : UserViewModel
    @State private var meditationDescription = "Take a moment to pause, take some deep breathes, reflect and centre your mind."
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: Background
            background()
            
            VStack {
                HeaderView()
                
                Spacer()
                
                // MARK: "Content" section
                BreathingView()
                    .frame(width: 100, height: 100)
                
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
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Meditation")
                            .font(.custom("Butler", size: 27))
                            .minimumScaleFactor(0.5)
                            .foregroundColor(np_white)
                        
                        Spacer()
                        
                        // MARK: "Play / Stop" sound
                        PlayerView(meditationViewModel: meditationViewModel)
                    }
                    .hAlign(.leading)
                    
                    // MARK: Description
                    Text("\(meditationDescription)")
                        .font(.custom("Butler", size: 16))
                        .kerning(3)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(np_gray)
                }
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
    
    // MARK: Meditation View
    @ViewBuilder
    func BreathingView() -> some View {
        VStack {
                LottieViewModel(animationFileName: "breathing-circle", loopMode: .loop)

            Spacer()
        }
    }
}

struct MeditationView_Previews: PreviewProvider {
    static let meditationViewModel = MeditationViewModel(meditation: Meditation.data)
    
    static var previews: some View {
        MeditationView(meditationViewModel: meditationViewModel)
            .environmentObject(AudioManager())
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
