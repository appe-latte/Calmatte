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
    @State var showPlayerSheet = false
    @State var showTimerSheet = false
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: Background Image
                Image(meditationViewModel.meditation.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth, height: screenHeight * 0.6, alignment: .top)
                
                ZStack(alignment: .bottom) {
                    VStack(spacing: 20) {
                        // MARK: Title
                        HStack {
                            Text(meditationViewModel.meditation.title)
                                .font(.system(size: 22, weight: .heavy))
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
                        
//                        VStack {
//                            // MARK: Meditation Sound Button
//                            Button(action: {
//                                showPlayerSheet.toggle()
//                            }, label: {
//                                HStack {
//                                    Image("play")
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(maxWidth: 30, maxHeight: 30)
//                                    Text("begin")
//                                        .font(.footnote)
//                                        .fontWeight(.semibold)
//                                        .kerning(10)
//                                        .textCase(.uppercase)
//                                }
//                                .padding(.vertical, 5)
//                                .foregroundColor(np_white)
//                                .frame(width: 200, height: 50)
//                                .background(np_black)
//                                .clipShape(Capsule())
//                                .overlay(
//                                    Capsule(style: .continuous)
//                                        .stroke(np_white, style: StrokeStyle(lineWidth: 1))
//                                        .padding(3)
//                                )
//                            })
//
//                            Spacer()
//                        }
//                        .padding(.vertical, 5)
                        
                        PlayerView(meditationViewModel: meditationViewModel)
                    }
                    .foregroundColor(np_white)
                    .padding(20)
                }
                .frame(height: screenHeight * 0.35)
                .background(np_black)
                .cornerRadius(15, corners: [.topLeft, .topRight])
                .blurredSheet(.init(.ultraThinMaterial), show: $showPlayerSheet) {
                    //
                } content: {
                    if #available(iOS 16.0, *) {
                        PlayerView(meditationViewModel: meditationViewModel)
                            .ignoresSafeArea()
                            .presentationDetents([.height(screenHeight / 2.5), .fraction(0.4)])
                    } else {
                        // Fallback on earlier versions
                        PlayerView(meditationViewModel: meditationViewModel)
                    }
                }
            }
        }
        .background(np_white)
        .ignoresSafeArea(edges: .top)
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
