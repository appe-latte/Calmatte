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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            np_black
                .edgesIgnoringSafeArea(.all)
            
            // MARK: Breathing action
            VStack {
                Circle()
                    .fill(np_black)
                    .frame(width: 300, height: 300)
                    .overlay {
                        Circle()
                            .stroke(np_white, lineWidth: 2)
                        
                        Circle()
                            .fill(np_white)
                            .frame(width: 150, height: 150)
                            .modifier(BreathingAnimation(isBreathing: breathingAnimation))
                            .onAppear() {
                                breathingAnimation = true
                                
                            }
                            .overlay {
                                Text(textBreathingAnimation ? "Breathe Out" : "Breathe In")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .kerning(5)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_black)
                                    .modifier(TextBreathingAnimation(isBreathing: textBreathingAnimation))
                                    .onAppear() {
                                        textBreathingAnimation = true
                                        
                                    }
                            }
                    }
                
                Spacer()
            }
            .padding(.top, 100)
            
            // MARK: Description
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(meditationViewModel.meditation.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .kerning(10)
                        .textCase(.uppercase)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                    
                    Spacer()
                }
                
                // MARK: Description
                Text(meditationViewModel.meditation.description)
                    .font(.footnote)
                    .kerning(3)
                    .textCase(.uppercase)
                    .minimumScaleFactor(0.5)
                
                // MARK: Meditation Music Player
                PlayerView(meditationViewModel: meditationViewModel)
            }
            .foregroundColor(np_white)
            .padding(20)
            .frame(height: screenHeight * 0.30)
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

struct BreathingAnimation: ViewModifier {
    let isBreathing: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isBreathing ? 2.0 : 1.0)
            .animation(Animation.easeInOut(duration: 5.0).repeatForever(autoreverses: true))
    }
}

struct TextBreathingAnimation: ViewModifier {
    let isBreathing: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isBreathing ? 1.5 : 1.0)
            .animation(Animation.easeInOut(duration: 5.0).repeatForever(autoreverses: true))
    }
}
