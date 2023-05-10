//
//  TimerView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-05-09.
//

import SwiftUI

struct TimerView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State private var timerDescription = "Use this feature to set some time to focus on a task or when you need to clear your mind."
    
    var body: some View {
        ZStack(alignment: .bottom) {
            np_white
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // MARK: Pomodor Timer
                VStack(spacing: 20) {
                    
                }
                
                // MARK: Timer Functions / Options
                VStack(alignment: .leading, spacing: 20) {
                    // MARK: Title
                    HStack {
                        Text("Focus Timer")
                            .font(.title3)
                            .fontWeight(.bold)
                            .kerning(10)
                            .textCase(.uppercase)
                            .minimumScaleFactor(0.6)
                            .lineLimit(1)
                        
                        Spacer()
                        
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
                                    .kerning(7)
                                    .textCase(.uppercase)
                            }
                            .padding(2)
                            .foregroundColor(np_black)
                            .frame(width: 125, height: 35)
                            .background(np_white)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(np_black, style: StrokeStyle(lineWidth: 1))
                                    .padding(2)
                            )
                        })
                    }
                    
                    // MARK: Description
                    Text("\(timerDescription)")
                        .font(.footnote)
                        .kerning(3)
                        .textCase(.uppercase)
                        .minimumScaleFactor(0.5)
                }
                .foregroundColor(np_white)
                .padding(20)
            }
            .frame(height: screenHeight * 0.20)
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
