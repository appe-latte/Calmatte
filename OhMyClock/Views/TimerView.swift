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
    
    @EnvironmentObject var timerModel : TimerModel
    @State private var timerDescription = "Use this feature to set some time to focus on a task or when you need to clear your mind."
    
    var body: some View {
        ZStack(alignment: .bottom) {
            np_white
                .edgesIgnoringSafeArea(.all)
            
            VStack {// MARK: Pomodoro Timer
                VStack(spacing: 20) {
                    GeometryReader { proxy in
                        VStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .fill(np_black.opacity(0.03))
                                    .padding(-40)
                                    .ignoresSafeArea()
                                
                                Circle()
                                    .trim(from: 0, to: timerModel.progress)
                                    .stroke(np_black.opacity(0.03), lineWidth: 80)
                                    .padding(-40)
                                
                                // MARK: Shadow
                                Circle()
                                    .stroke(np_black, lineWidth: 5)
                                    .blur(radius: 15)
                                    .padding(-2)
                                
                                
                                Circle()
                                    .fill(np_black.opacity(0.03))
                                    .padding(-40)
                                
                                Circle()
                                    .trim(from: 0, to: timerModel.progress)
                                    .stroke(np_red.opacity(0.7), lineWidth: 10)
                                    
                                
                                // MARK: Timer Knob
                                GeometryReader { proxy in
                                    let size = proxy.size
                                    
                                    Circle()
                                        .fill(np_red)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Circle()
                                                .fill(np_white)
                                                .padding(5)
                                        )
                                        .frame(width: size.width, height: size.height, alignment: .center)
                                        .offset(x: size.height / 2)
                                        .rotationEffect(.init(degrees: timerModel.progress * 360))
                                }
                                
                                Text(timerModel.timerValue)
                                    .font(.largeTitle)
                                    .kerning(5)
                                    .rotationEffect(.init(degrees: -90))
                                    .animation(.none, value: timerModel.progress)
                            }
                            .padding(60)
                            .frame(height: proxy.size.width)
                            .rotationEffect(.init(degrees: -90))
                            .animation(.easeInOut, value: timerModel.progress)
                            
                            Button(action: {
                             //
                            }, label: {
                                Image(systemName: "pause")
                                    .font(.largeTitle.bold())
                                    .foregroundColor(np_white)
                                    .frame(width: 50, height: 50)
                                    .background {
                                        Circle()
                                            .fill(np_black)
                                    }
                            })
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
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
                .frame(height: screenHeight * 0.20)
                .background(np_black)
            }
            
            .cornerRadius(15, corners: [.topLeft, .topRight])
        }
    }
}

//struct TimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimerView()
//    }
//}
