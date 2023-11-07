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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: Background
            background()
            
            // MARK: "Content" section
            Content()
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
    
    // MARK: Content
    @ViewBuilder
    func Content() -> some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(sampleTypes){ type in
                        Text(type.title)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .kerning(3)
                            .textCase(.uppercase)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(currentType.id == type.id ? np_arsenic : np_white)
                            .padding(15)
                            .clipShape(Capsule())
                            .background {
                                ZStack {
                                    if currentType.id == type.id {
                                        Capsule(style: .continuous)
                                            .fill(currentType.color)
                                            .padding(2)
                                            .matchedGeometryEffect(id: "TAP", in: animation)
                                    } else {
                                        Capsule(style: .continuous)
                                            .stroke(np_white, style: StrokeStyle(lineWidth: 2.5))
                                            .padding(2)
                                    }
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    currentType = type
                                }
                            }
                    }
                    
                    // MARK: "Play / Stop" sound
                    PlayerView(meditationViewModel: meditationViewModel)
                }
                .padding(.horizontal)
            }
            .opacity(showBreatheView ? 0 : 1)
            .padding(.top, 45)
            
            HStack {
                Button {
                    startBreathing()
                } label: {
                    Text(showBreatheView ? "End Exercise" : "Start Exercise")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .kerning(3)
                        .textCase(.uppercase)
                        .foregroundColor(showBreatheView ? np_white.opacity(0.75) : np_gray)
                        .frame(width: screenWidth * 0.65, height: 50)
                        .clipShape(Capsule())
                        .background {
                            if showBreatheView {
                                Capsule(style: .continuous)
                                    .stroke(np_white, style: StrokeStyle(lineWidth: 2.5))
                                    .padding(2)
                                
                            } else {
                                Capsule(style: .continuous)
                                    .stroke(currentType.color, style: StrokeStyle(lineWidth: 2.5))
                                    .padding(2)
                            }
                        }
                }
                .padding()
            }
            
            GeometryReader { proxy in
                let size = proxy.size
                
                VStack {
                    BreatheView(size: size)
                        .padding(.bottom, 50)
                    
                    HStack {
                        Text(meditationViewModel.meditation.title)
                            .font(.title3)
                            .fontWeight(.bold)
                            .kerning(10)
                            .textCase(.uppercase)
                            .minimumScaleFactor(0.6)
                            .lineLimit(1)
                            .foregroundColor(np_white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20)
                    .opacity(showBreatheView ? 0 : 1)
                    
                    // MARK: Description
                    HStack {
                        Text(meditationViewModel.meditation.description)
                            .font(.footnote)
                            .kerning(3)
                            .textCase(.uppercase)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(np_white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                    .padding(.bottom, 20)
                    .opacity(showBreatheView ? 0 : 1)
                }
                .frame(width: size.width, height: size.height, alignment: .bottom)
                .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) {_ in
                    if showBreatheView {
                        if timerCount >= 3 {
                            timerCount = 0
                            breatheAction = (breatheAction == "Breathe Out" ? "Breathe In" : "Breathe Out")
                            withAnimation(.easeInOut(duration: 3)) {
                                breathingScale.toggle()
                            }
                            
                            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        } else {
                            timerCount += 1
                        }
                        count = 3 - Int(timerCount)
                    } else {
                        timerCount = 0
                    }
                }
            }
        }
    }
    
    // MARK: Breathe Circle
    @ViewBuilder
    func BreatheView(size: CGSize) -> some View {
        ZStack {
            ForEach(1...8, id: \.self) { index in
                Circle()
                    .fill(currentType.color.opacity(0.5))
                    .frame(width: 150, height: 150)
                    .offset(x: showBreatheView ? 0 : 75)
                    .rotationEffect(.init(degrees: Double(index)) * 45)
                    .rotationEffect(.init(degrees: showBreatheView ? -45 : 0))
            }
        }
        .scaleEffect(showBreatheView ? 1 : 0.8) // Update the scaleEffect
        .animation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) // Add repeating animation
        .frame(height: size.width - 40)
    }
    
    private func startBreathing() {
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
            showBreatheView.toggle()
        }
        
        if showBreatheView {
            withAnimation(.easeInOut(duration: 3).delay(0.05)) {
                startAnimation = true
            }
        } else {
            withAnimation(.easeInOut(duration: 1.5)) {
                startAnimation = false
            }
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
