//
//  MeditationView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import SwiftUI

struct MeditationView: View {
    @StateObject var meditationViewModel : MeditationViewModel
    @State private var showPlayer = false
    @State var showPlayerSheet = false
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
//        ScrollView {
            VStack(spacing: 0) {
                // MARK: Image
                Image(meditationViewModel.meditation.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth, height: screenHeight * 0.5, alignment: .top)
                
                ZStack {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        HStack {
                            Text("Meditation Sounds")
                                .font(.headline)
                                .kerning(5)
                                .fontWeight(.semibold)
                                .textCase(.uppercase)
                            
                            Spacer()
                            
                            Text(DateComponentsFormatter.abbreviated.string(from: meditationViewModel.meditation.duration) ?? meditationViewModel.meditation.duration.formatted() + "s")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .kerning(5)
                                .textCase(.uppercase)
                        }
                        
                        // MARK: Title
                        
                        Text(meditationViewModel.meditation.title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .kerning(10)
                            .textCase(.uppercase)
                            .minimumScaleFactor(0.6)
                            .lineLimit(1)
                        
                        // MARK: Description
                        
                        Text(meditationViewModel.meditation.description)
                            .font(.footnote)
                            .kerning(7)
                            .textCase(.uppercase)
                            .minimumScaleFactor(0.5)
                        
                        // MARK: Button
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                //                            showPlayer = true
                                showPlayerSheet.toggle()
                                
                            }, label: {
                                HStack {
                                    Image("play")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: 30, maxHeight: 30)
                                    Text("begin")
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .kerning(10)
                                        .textCase(.uppercase)
                                }
                                .padding(.vertical, 5)
                                .foregroundColor(np_white)
                                .frame(width: 200, height: 50)
                                .background(np_black)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule(style: .continuous)
                                        .stroke(np_white, style: StrokeStyle(lineWidth: 1))
                                        .padding(3)
                                )
                            })
                            
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        
                        Spacer()
                        
                    }
                    .foregroundColor(np_black)
                    .padding(20)
                }
                .frame(height: screenHeight * 1 / 2)
                .background(np_white)
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
            .ignoresSafeArea(edges: .top)
//        }
//        .ignoresSafeArea()
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
