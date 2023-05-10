//
//  TimerView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-05-09.
//

import SwiftUI

struct TimerView: View {
    @State private var timerDescription = "Use this feature to set some time to focus on a task or when you need to clear your mind."
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack(alignment: .bottom) {
            np_white
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // MARK: Timer
                
                VStack(spacing: 20) {
                    
                }
                
                
                // MARK: Timer Functions / Options
                
                VStack(spacing: 20) {
                    
                    Spacer()
                    
                    // MARK: Title
                    HStack {
                        Text("Focus Timer")
                            .font(.system(size: 22, weight: .heavy))
                            .fontWeight(.bold)
                            .kerning(10)
                            .textCase(.uppercase)
                            .minimumScaleFactor(0.6)
                            .lineLimit(1)
                        
                        Spacer()
                    }
                    
                    // MARK: Description
                    Text("\(timerDescription)")
                        .font(.footnote)
                        .kerning(3)
                        .textCase(.uppercase)
                        .minimumScaleFactor(0.5)
                    
                    VStack {
                        // MARK: Timer Buttons
                        Button(action: {
                            //
                            //
                            
                        }, label: {
                            HStack {
                                Image("play")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: 30, maxHeight: 30)
                                Text("start")
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
                    
                }
                .foregroundColor(np_white)
                .padding(20)
            }
            .frame(height: screenHeight * 0.35)
            .background(np_black)
            .cornerRadius(15, corners: [.topLeft, .topRight])
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
