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
            np_black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(spacing: 20) {
                    GeometryReader { proxy in
                        VStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .fill(np_white.opacity(0.03))
                                    .padding(-40)
                                    .ignoresSafeArea()
                                
                                // MARK: Shadow
                                Circle()
                                    .stroke(np_white, lineWidth: 5)
                                    .blur(radius: 15)
                                    .padding(-2)
                                
                                
                                Circle()
                                    .fill(np_white.opacity(0.03))
                                    .padding(-40)
                                
                                Circle()
                                    .stroke(np_red, lineWidth: 30)
                                
                                Circle()
                                    .trim(from: 0, to: timerModel.progress)
                                    .stroke(np_white, style: StrokeStyle(lineWidth: 30, lineCap: .round))
       
                                // MARK: Timer Knob
                                GeometryReader { proxy in
                                    let size = proxy.size
                                    
                                    Circle()
                                        .fill(np_white)
                                        .frame(width: 35, height: 35).overlay(
                                            Circle()
                                                .fill(np_red)
                                                .padding(5)
                                        )
                                        .frame(width: size.width, height: size.height, alignment: .center)
                                        .offset(x: size.height / 2)
                                        .rotationEffect(.init(degrees: timerModel.progress * 360))
                                }
                                
                                Text(timerModel.timerValue)
                                    .font(.system(size: 60, weight: .light))
                                    .foregroundColor(np_white)
                                    .kerning(5)
                                    .rotationEffect(.init(degrees: 90))
                                    .animation(.none, value: timerModel.progress)
                            }
                            .padding(60)
                            .frame(height: proxy.size.width)
                            .rotationEffect(.init(degrees: -90))
                            .animation(.easeInOut, value: timerModel.progress)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            
                            
                            HStack(spacing: 15) {
                                
                                // MARK: "Start" timer
                                Button(action: {
                                    if timerModel.isStarted {
                                        timerModel.stopFocusTimer()
                                        
                                        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                                    } else {
                                        timerModel.addNewTimer = true
                                    }
                                }, label: {
                                    VStack {
                                        Image(!timerModel.isStarted ? "play" : "stop")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(np_white)
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(np_white, lineWidth: 1))
                                        
                                        Text(!timerModel.isStarted ? "Start" : "Cancel")
                                            .font(.footnote)
                                            .kerning(3)
                                            .textCase(.uppercase)
                                            .minimumScaleFactor(0.5)
                                    }
                                })
                            }
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
            }
            .overlay(content: {
                ZStack {
                    np_gray
                        .opacity(timerModel.addNewTimer ? 0.25 : 0)
                        .onTapGesture {
                            timerModel.hour = 0
                            timerModel.minutes = 0
                            timerModel.seconds = 0
                            timerModel.addNewTimer = false
                        }
                    
                    NewTimerView()
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y: timerModel.addNewTimer ? 0 : 400)
                }
                .animation(.easeInOut, value: timerModel.addNewTimer)
            })
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) {
                _ in
                if timerModel.isStarted {
                    timerModel.updateFocusTimer()
                }
            }
            .alert("Focus time complete", isPresented: $timerModel.isFinished) {
                Button("New Timer", role: .cancel) {
                    timerModel.stopFocusTimer()
                    timerModel.addNewTimer = true
                }
                
                Button("Close", role: .destructive) {
                    timerModel.stopFocusTimer()
                }
            }
        }
    }
    
    @ViewBuilder
    func NewTimerView() -> some View {
        VStack(spacing: 15) {
            Text("Set Focus Time")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(np_white)
                .kerning(3)
                .textCase(.uppercase)
                .padding(.top, 5)
            
            // MARK: Time Selection
            HStack(spacing: 15) {
                // Hours
                Text("\(timerModel.hour) hr(s)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(np_white)
                    .kerning(3)
                    .textCase(.uppercase)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(np_white, lineWidth: 1)
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 12, hint: "hours") { value in
                            timerModel.hour = value
                        }
                    }
                
                // Minutes
                Text("\(timerModel.minutes) mins")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(np_white)
                    .kerning(3)
                    .textCase(.uppercase)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(np_white, lineWidth: 1)
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 60, hint: "mins") { value in
                            timerModel.minutes = value
                        }
                    }
                
                // Seconds
                Text("\(timerModel.seconds) s")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(np_white)
                    .kerning(3)
                    .textCase(.uppercase)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(np_white, lineWidth: 1)
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 60, hint: "seconds") { value in
                            timerModel.seconds = value
                        }
                    }
            }
            .padding(.top, 20)
            
            // MARK: Save Time
            Button(action: {
                timerModel.startFocusTimer()
            }, label: {
                Text("Save")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(np_black)
                    .kerning(5)
                    .textCase(.uppercase)
                    .padding(.vertical)
                    .padding(.horizontal, 100)
                    .background {
                        Capsule()
                            .fill(np_white)
                            .frame(width: 125, height: 35)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(np_black, style: StrokeStyle(lineWidth: 1))
                                    .padding(2)
                            )
                    }
            })
            .disabled(timerModel.seconds == 0)
            .opacity(timerModel.seconds == 0 ? 0.5 : 1)
            .padding(.top)
        }
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(np_black)
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
        }
    }
    
    // MARK: Reusable Context Menu Options
    @ViewBuilder
    func ContextMenuOptions(maxValue: Int, hint: String, onClick: @escaping (Int) -> ())->some View {
        ForEach(0...maxValue, id: \.self) { value in
            Button("\(value) \(hint)") {
                onClick(value)
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
