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
    @State private var selectedSeconds = 0
    @State private var selectedMinutes = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            background()
            
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
                    np_black
                        .opacity(timerModel.addNewTimer ? 0.25 : 0)
                        .onTapGesture {
                            //                            timerModel.hour = 0
                            timerModel.minutes = 0
                            timerModel.seconds = 0
                            timerModel.addNewTimer = false
                        }
                        .edgesIgnoringSafeArea(.top)
                    
                    NewTimerView()
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y: timerModel.addNewTimer ? 0 : 400)
                }
            })
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) {
                _ in
                if timerModel.isStarted {
                    timerModel.updateFocusTimer()
                }
            }
            .alert("Focus Time Ended", isPresented: $timerModel.isFinished) {
                Button("Close", role: .cancel) {
                    timerModel.stopFocusTimer()
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
    
    @ViewBuilder
    func NewTimerView() -> some View {
        VStack(spacing: 2) {
            Text("Set Focus Time")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(np_white)
                .kerning(3)
                .textCase(.uppercase)
            //                .padding(.top, 5)
            
            // MARK: Time Selection
            HStack(spacing: 15) {
                // Minutes
                Picker("Minutes", selection: $selectedMinutes) {
                    ForEach(0..<61, id: \.self) { minute in
                        Text("\(minute) minutes")
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(np_white, lineWidth: 1)
                }
                .onChange(of: selectedMinutes) { newValue in
                    timerModel.minutes = newValue
                }
                
                // Seconds
                Picker("Seconds", selection: $selectedSeconds) {
                    ForEach(0..<61, id: \.self) { second in
                        Text("\(second) seconds")
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(np_white, lineWidth: 1)
                }
                .onChange(of: selectedSeconds) { newValue in
                    timerModel.seconds = newValue
                }
            }
            .padding(.top, 10)
            
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
                    .padding(.vertical, 5)
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
                .frame(width: screenWidth)
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
    
    // MARK: Context Menu Options for minutes -- increments of 5
    @ViewBuilder
    func ContextMenuMinutesOptions(maxValue: Int, hint: String, onClick: @escaping (Int) -> ()) -> some View {
        let values = Array(stride(from: 0, through: 9, by: 1)) + Array(stride(from: 10, through: maxValue, by: 5))
        ForEach(values, id: \.self) { value in
            Button("\(value) \(hint)") {
                onClick(value)
            }
        }
    }
    
    // MARK: Context Menu Options for seconds -- increments of 5
    @ViewBuilder
    func ContextMenuSecondsOptions(maxValue: Int, hint: String, onClick: @escaping (Int) -> ()) -> some View {
        let values = [0, 1, 2, 3, 4, 5] + Array(stride(from: 10, through: maxValue - 1, by: 5)) + [ 59 ]
        ForEach(values, id: \.self) { value in
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
