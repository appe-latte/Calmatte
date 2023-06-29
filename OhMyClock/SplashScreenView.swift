//
//  SplashScreenView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-14.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                background()
                
                VStack {
                    Image("logo")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: screenWidth / 3, height: screenHeight / 8)
                        .foregroundColor(np_white)
                    
                    Text("Oh My Clock")
                        .font(.title)
                        .fontWeight(.light)
                        .kerning(5)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    Text("by: Appè Latte")
                        .font(.footnote)
                        .fontWeight(.thin)
                        .kerning(9.5)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        self.size = 1.1
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isActive = true
                }
            }
        }
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Image(background_theme)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(y: -50)
                .frame(width: size.width, height: size.height)
                .clipped()
                .overlay {
                    ZStack {
                        Rectangle()
                            .fill(.linearGradient(colors: [.clear, np_black, np_black, np_black], startPoint: .top, endPoint: .bottom))
                            .frame(height: size.height * 0.35)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
            
            // Mask Tint
            Rectangle()
                .fill(np_black).opacity(0.5)
                .frame(height: size.height)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
    
    // MARK: Day / Night Theme
    func getTime()->String {
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        
        return format.string(from: Date())
    }
    
    private var background_theme : String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<19:
            return "snow-mountain"
        default:
            return "mountain-pond"
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
