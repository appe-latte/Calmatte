//
//  MoodAddDiaryView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-11.
//

import SwiftUI

struct MoodAddDiaryView: View {
    @ObservedObject var moodModelController: MoodModelController
    @Environment(\.presentationMode) var presentationMode
    
    @State var text: String? = nil
    @State private var emotionState: EmotionState = .happy
    @State private var moodColor: MoodColor = .happyColor
    @State private var angrySelected = false
    @State private var cheekySelected = false
    @State private var happySelected = false
    @State private var lovedSelected = false
    @State private var mehSelected = false
    @State private var sadSelected = false
    @State private var sickSelected = false
    @State private var sleepySelected = false
    @State private var smilingSelected = false
    @State private var upsetSelected = false
    @State private var counterLabel = "200"
    
    @State private var dayStates: [DayState] = []
    @State private var selectedEmotion = Emotion(state: .happy, color: .happyColor)
    
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .fill(selectedEmotion.moodColor)
                    .frame(width: width, height: height * 0.2)
                    .overlay {
                        HStack(alignment: .center) {
                            Text("\(emotionState.rawValue)")
                                .font(.system(size: 75, weight: .heavy))
                                .fontWeight(.bold)
                                .kerning(5)
                                .minimumScaleFactor(0.5)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                        }
                        .frame(width: width, height: height * 0.2)
                        .padding(.top, 35)
                    }
                
                background()
                    .overlay {
                        ScrollView(.vertical){
                            VStack(spacing: 30) {
                                // MARK: Emotion Selection
                                VStack {
                                    HStack {
                                        Label("How do you feel?", systemImage: "")
                                            .font(.footnote)
                                            .fontWeight(.semibold)
                                            .kerning(3)
                                            .textCase(.uppercase)
                                            .foregroundColor(np_white)
                                        
                                        Spacer()
                                    }
                                    // MARK: Stack One
                                    HStack(spacing: 10){
                                        
                                        // MARK: Happy - emotion
                                        VStack(spacing: 5) {
                                            Button(action: {
                                                self.emotionState = .happy
                                                self.moodColor = .happyColor
                                                self.happySelected = true
                                                self.angrySelected = false
                                                self.sadSelected = false
                                                self.upsetSelected = false
                                                self.lovedSelected = false
                                                self.mehSelected = false
                                                self.sickSelected = false
                                                self.smilingSelected = false
                                                self.sleepySelected = false
                                                self.cheekySelected = false
                                                selectedEmotion.color = moodColor
                                            }) {
                                                ZStack {
                                                    Image("happy")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                                        .frame(width: 65, height: 60)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 15)
                                                                .stroke(self.happySelected ? Color.white : Color.clear, lineWidth: 2)
                                                        )
                                                }
                                            }
                                            .padding(2)
                                            
                                            Text("Happy")
                                                .font(.system(size: 10))
                                                .fontWeight(.medium)
                                                .textCase(.uppercase)
                                                .foregroundColor(np_white)
                                        }
                                        
                                        // MARK: Smiling - emotion
                                        VStack(spacing: 5){
                                            Button(action: {
                                                self.emotionState = .smiling
                                                self.moodColor = .smilingColor
                                                self.smilingSelected = true
                                                self.happySelected = false
                                                self.angrySelected = false
                                                self.sadSelected = false
                                                self.upsetSelected = false
                                                self.lovedSelected = false
                                                self.mehSelected = false
                                                self.sickSelected = false
                                                self.sleepySelected = false
                                                self.cheekySelected = false
                                                selectedEmotion.color = moodColor
                                            }) {
                                                ZStack {
                                                    Image("smiling")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                                        .frame(width: 65, height: 60)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 15)
                                                                .stroke(self.smilingSelected ? Color.white : Color.clear, lineWidth: 2)
                                                        )
                                                }
                                            }
                                            .padding(2)
                                            
                                            Text("Smiling")
                                                .font(.system(size: 10))
                                                .fontWeight(.medium)
                                                .textCase(.uppercase)
                                                .foregroundColor(np_white)
                                        }
                                        
                                        // MARK: Cheeky - emotion
                                        VStack(spacing: 5){
                                            Button(action: {
                                                self.emotionState = .cheeky
                                                self.moodColor = .cheekyColor
                                                self.cheekySelected = true
                                                self.smilingSelected = false
                                                self.happySelected = false
                                                self.angrySelected = false
                                                self.sadSelected = false
                                                self.upsetSelected = false
                                                self.lovedSelected = false
                                                self.mehSelected = false
                                                self.sickSelected = false
                                                self.sleepySelected = false
                                                selectedEmotion.color = moodColor
                                            }) {
                                                ZStack {
                                                    Image("cheeky")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                                        .frame(width: 65, height: 60)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 15)
                                                                .stroke(self.cheekySelected ? Color.white : Color.clear, lineWidth: 2)
                                                        )
                                                }
                                            }
                                            .padding(2)
                                            
                                            Text("Cheeky")
                                                .font(.system(size: 10))
                                                .fontWeight(.medium)
                                                .textCase(.uppercase)
                                                .foregroundColor(np_white)
                                        }
                                        
                                        // MARK: Loved - emotion
                                        VStack(spacing: 5){
                                            Button(action: {
                                                self.emotionState = .loved
                                                self.moodColor = .lovedColor
                                                self.lovedSelected = true
                                                self.cheekySelected = false
                                                self.smilingSelected = false
                                                self.happySelected = false
                                                self.angrySelected = false
                                                self.sadSelected = false
                                                self.upsetSelected = false
                                                self.mehSelected = false
                                                self.sickSelected = false
                                                self.sleepySelected = false
                                                selectedEmotion.color = moodColor
                                            }) {
                                                ZStack {
                                                    Image("loved")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                                        .frame(width: 65, height: 60)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 15)
                                                                .stroke(self.lovedSelected ? Color.white : Color.clear, lineWidth: 2)
                                                        )
                                                }
                                            }
                                            .padding(2)
                                            
                                            Text("Loved")
                                                .font(.system(size: 10))
                                                .fontWeight(.medium)
                                                .textCase(.uppercase)
                                                .foregroundColor(np_white)
                                        }
                                        
                                        // MARK: Meh - emotion
                                        VStack(spacing: 5){
                                            Button(action: {
                                                self.emotionState = .meh
                                                self.moodColor = .mehColor
                                                self.mehSelected = true
                                                self.cheekySelected = false
                                                self.smilingSelected = false
                                                self.happySelected = false
                                                self.angrySelected = false
                                                self.sadSelected = false
                                                self.upsetSelected = false
                                                self.lovedSelected = false
                                                self.sickSelected = false
                                                self.sleepySelected = false
                                                selectedEmotion.color = moodColor
                                            }) {
                                                ZStack {
                                                    Image("meh")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                                        .frame(width: 65, height: 60)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 15)
                                                                .stroke(self.mehSelected ? Color.white : Color.clear, lineWidth: 2)
                                                        )
                                                }
                                            }
                                            .padding(2)
                                            
                                            Text("Meh")
                                                .font(.system(size: 10))
                                                .fontWeight(.medium)
                                                .textCase(.uppercase)
                                                .foregroundColor(np_white)
                                        }
                                    }
                                    
                                    // MARK: Stack Two
                                    HStack(spacing: 10){
                                        
                                        // MARK: Angry - emotion
                                        VStack(spacing: 5) {
                                            Button(action: {
                                                self.emotionState = .sick
                                                self.moodColor = .sickColor
                                                self.angrySelected = true
                                                self.cheekySelected = false
                                                self.smilingSelected = false
                                                self.happySelected = false
                                                self.lovedSelected = false
                                                self.sadSelected = false
                                                self.upsetSelected = false
                                                self.mehSelected = false
                                                self.sickSelected = false
                                                self.sleepySelected = false
                                                selectedEmotion.color = moodColor
                                            }) {
                                                ZStack {
                                                    Image("angry")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                                        .frame(width: 65, height: 60)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 15)
                                                                .stroke(self.angrySelected ? Color.white : Color.clear, lineWidth: 2)
                                                        )
                                                }
                                            }
                                            .padding(2)
                                            
                                            Text("Angry")
                                                .font(.system(size: 10))
                                                .fontWeight(.medium)
                                                .textCase(.uppercase)
                                                .foregroundColor(np_white)
                                        }
                                        
                                        // MARK: Upset - emotion
                                        VStack(spacing: 5){
                                            Button(action: {
                                                self.emotionState = .upset
                                                self.moodColor = .upsetColor
                                                self.upsetSelected = true
                                                self.cheekySelected = false
                                                self.smilingSelected = false
                                                self.happySelected = false
                                                self.angrySelected = false
                                                self.sadSelected = false
                                                self.lovedSelected = false
                                                self.mehSelected = false
                                                self.sickSelected = false
                                                self.sleepySelected = false
                                                selectedEmotion.color = moodColor
                                            }) {
                                                ZStack {
                                                    Image("upset")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                                        .frame(width: 65, height: 60)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 15)
                                                                .stroke(self.upsetSelected ? Color.white : Color.clear, lineWidth: 2)
                                                        )
                                                }
                                            }
                                            .padding(2)
                                            
                                            Text("Upset")
                                                .font(.system(size: 10))
                                                .fontWeight(.medium)
                                                .textCase(.uppercase)
                                                .foregroundColor(np_white)
                                        }
                                        
                                        // MARK: Sad - emotion
                                        VStack(spacing: 5){
                                            Button(action: {
                                                self.emotionState = .sad
                                                self.moodColor = .sadColor
                                                self.sadSelected = true
                                                self.cheekySelected = false
                                                self.smilingSelected = false
                                                self.happySelected = false
                                                self.angrySelected = false
                                                self.lovedSelected = false
                                                self.upsetSelected = false
                                                self.mehSelected = false
                                                self.sickSelected = false
                                                self.sleepySelected = false
                                                selectedEmotion.color = moodColor
                                            }) {
                                                ZStack {
                                                    Image("sad")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                                        .frame(width: 65, height: 60)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 15)
                                                                .stroke(self.sadSelected ? Color.white : Color.clear, lineWidth: 2)
                                                        )
                                                }
                                            }
                                            .padding(2)
                                            
                                            Text("Sad")
                                                .font(.system(size: 10))
                                                .fontWeight(.medium)
                                                .textCase(.uppercase)
                                                .foregroundColor(np_white)
                                        }
                                        
                                        // MARK: Sleepy - emotion
                                        VStack(spacing: 5){
                                            Button(action: {
                                                self.emotionState = .sleepy
                                                self.moodColor = .sleepyColor
                                                self.sleepySelected = true
                                                self.cheekySelected = false
                                                self.smilingSelected = false
                                                self.happySelected = false
                                                self.angrySelected = false
                                                self.sadSelected = false
                                                self.upsetSelected = false
                                                self.mehSelected = false
                                                self.sickSelected = false
                                                self.lovedSelected = false
                                                selectedEmotion.color = moodColor
                                            }) {
                                                ZStack {
                                                    Image("sleepy")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                                        .frame(width: 65, height: 60)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 15)
                                                                .stroke(self.sleepySelected ? Color.white : Color.clear, lineWidth: 2)
                                                        )
                                                }
                                            }
                                            .padding(2)
                                            
                                            Text("Tired")
                                                .font(.system(size: 10))
                                                .fontWeight(.medium)
                                                .textCase(.uppercase)
                                                .foregroundColor(np_white)
                                        }
                                        
                                        // MARK: Sick - emotion
                                        VStack(spacing: 5){
                                            Button(action: {
                                                self.emotionState = .sick
                                                self.moodColor = .sickColor
                                                self.sickSelected = true
                                                self.cheekySelected = false
                                                self.smilingSelected = false
                                                self.happySelected = false
                                                self.angrySelected = false
                                                self.sadSelected = false
                                                self.upsetSelected = false
                                                self.mehSelected = false
                                                self.lovedSelected = false
                                                self.sleepySelected = false
                                                selectedEmotion.color = moodColor
                                            }) {
                                                ZStack {
                                                    Image("sick")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                                        .frame(width: 65, height: 60)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 15)
                                                                .stroke(self.sickSelected ? Color.white : Color.clear, lineWidth: 2)
                                                        )
                                                }
                                            }
                                            .padding(2)
                                            
                                            Text("Sick")
                                                .font(.system(size: 10))
                                                .fontWeight(.medium)
                                                .textCase(.uppercase)
                                                .foregroundColor(np_white)
                                        }
                                    }
                                }
                                
                                
                                // MARK: Day Type selection
                                VStack {
                                    HStack {
                                        Label("How was your day?", systemImage: "")
                                            .font(.footnote)
                                            .fontWeight(.semibold)
                                            .kerning(3)
                                            .textCase(.uppercase)
                                            .foregroundColor(np_white)
                                        
                                        Spacer()
                                    }
                                    
                                    // MARK: Day State - Row 1
                                    VStack {
                                        HStack(spacing: 5){
                                            
                                            // MARK: Fun - state
                                            VStack(spacing: 5) {
                                                Button(action: {
                                                    self.toggleDayState(.fun)
                                                }) {
                                                    ZStack {
                                                        Capsule()
                                                            .fill(self.dayStates.contains(.fun) ? np_white : np_white.opacity(0.45))
                                                            .frame(width: 75, height: 45)
                                                            .overlay {
                                                                Text("Fun")
                                                                    .font(.system(size: 10))
                                                                    .fontWeight(.medium)
                                                                    .textCase(.uppercase)
                                                                    .foregroundColor(self.dayStates.contains(.fun) ? np_jap_indigo : np_white)
                                                            }
                                                    }
                                                }
                                            }
                                            
                                            // MARK: Busy - state
                                            VStack(spacing: 5) {
                                                Button(action: {
                                                    self.toggleDayState(.busy)
                                                }) {
                                                    ZStack {
                                                        Capsule()
                                                            .fill(self.dayStates.contains(.busy) ? np_white : np_white.opacity(0.45))
                                                            .frame(width: 75, height: 45)
                                                            .overlay {
                                                                Text("Busy")
                                                                    .font(.system(size: 10))
                                                                    .fontWeight(.medium)
                                                                    .textCase(.uppercase)
                                                                    .foregroundColor(self.dayStates.contains(.busy) ? np_jap_indigo : np_white)
                                                            }
                                                    }
                                                }
                                            }
                                            
                                            // MARK: Angry - state
                                            VStack(spacing: 5) {
                                                Button(action: {
                                                    self.toggleDayState(.angry)
                                                }) {
                                                    ZStack {
                                                        Capsule()
                                                            .fill(self.dayStates.contains(.angry) ? np_white : np_white.opacity(0.45))
                                                            .frame(width: 75, height: 45)
                                                            .overlay {
                                                                Text("angry")
                                                                    .font(.system(size: 10))
                                                                    .fontWeight(.medium)
                                                                    .textCase(.uppercase)
                                                                    .foregroundColor(self.dayStates.contains(.angry) ? np_jap_indigo : np_white)
                                                            }
                                                    }
                                                }
                                            }
                                            
                                            // MARK: Productive - state
                                            VStack(spacing: 5) {
                                                Button(action: {
                                                    self.toggleDayState(.productive)
                                                }) {
                                                    ZStack {
                                                        Capsule()
                                                            .fill(self.dayStates.contains(.productive) ? np_white : np_white.opacity(0.45))
                                                            .frame(width: 75, height: 45)
                                                            .overlay {
                                                                Text("Productive")
                                                                    .font(.system(size: 10))
                                                                    .fontWeight(.medium)
                                                                    .textCase(.uppercase)
                                                                    .foregroundColor(self.dayStates.contains(.productive) ? np_jap_indigo : np_white)
                                                            }
                                                    }
                                                }
                                            }
                                            
                                            // MARK: Bored - state
                                            VStack(spacing: 5) {
                                                Button(action: {
                                                    self.toggleDayState(.bored)
                                                }) {
                                                    ZStack {
                                                        Capsule()
                                                            .fill(self.dayStates.contains(.bored) ? np_white : np_white.opacity(0.45))
                                                            .frame(width: 75, height: 45)
                                                            .overlay {
                                                                Text("Boring")
                                                                    .font(.system(size: 10))
                                                                    .fontWeight(.medium)
                                                                    .textCase(.uppercase)
                                                                    .foregroundColor(self.dayStates.contains(.bored) ? np_jap_indigo : np_white)
                                                            }
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                    
                                    // MARK: Day State - Row 2
                                    VStack {
                                        HStack(spacing: 5){
                                            // MARK: Tiring - state
                                            VStack(spacing: 5) {
                                                Button(action: {
                                                    self.toggleDayState(.tired)
                                                }) {
                                                    ZStack {
                                                        Capsule()
                                                            .fill(self.dayStates.contains(.tired) ? np_white : np_white.opacity(0.45))
                                                            .frame(width: 75, height: 45)
                                                            .overlay {
                                                                Text("Tiring")
                                                                    .font(.system(size: 10))
                                                                    .fontWeight(.medium)
                                                                    .textCase(.uppercase)
                                                                    .foregroundColor(self.dayStates.contains(.tired) ? np_jap_indigo : np_white)
                                                            }
                                                    }
                                                }
                                            }
                                            
                                            // MARK: Meh - state
                                            VStack(spacing: 5) {
                                                Button(action: {
                                                    self.toggleDayState(.meh)
                                                }) {
                                                    ZStack {
                                                        Capsule()
                                                            .fill(self.dayStates.contains(.meh) ? np_white : np_white.opacity(0.45))
                                                            .frame(width: 75, height: 45)
                                                            .overlay {
                                                                Text("Meh")
                                                                    .font(.system(size: 10))
                                                                    .fontWeight(.medium)
                                                                    .textCase(.uppercase)
                                                                    .foregroundColor(self.dayStates.contains(.meh) ? np_jap_indigo : np_white)
                                                            }
                                                    }
                                                }
                                            }
                                            
                                            // MARK: Exciting - state
                                            VStack(spacing: 5) {
                                                Button(action: {
                                                    self.toggleDayState(.exciting)
                                                }) {
                                                    ZStack {
                                                        Capsule()
                                                            .fill(self.dayStates.contains(.exciting) ? np_white : np_white.opacity(0.45))
                                                            .frame(width: 75, height: 45)
                                                            .overlay {
                                                                Text("Exciting")
                                                                    .font(.system(size: 10))
                                                                    .fontWeight(.medium)
                                                                    .textCase(.uppercase)
                                                                    .foregroundColor(self.dayStates.contains(.exciting) ? np_jap_indigo : np_white)
                                                            }
                                                    }
                                                }
                                            }
                                            
                                            // MARK: Okay - state
                                            VStack(spacing: 5) {
                                                Button(action: {
                                                    self.toggleDayState(.okay)
                                                }) {
                                                    ZStack {
                                                        Capsule()
                                                            .fill(self.dayStates.contains(.okay) ? np_white : np_white.opacity(0.45))
                                                            .frame(width: 75, height: 45)
                                                            .overlay {
                                                                Text("Okay")
                                                                    .font(.system(size: 10))
                                                                    .fontWeight(.medium)
                                                                    .textCase(.uppercase)
                                                                    .foregroundColor(self.dayStates.contains(.okay) ? np_jap_indigo : np_white)
                                                            }
                                                    }
                                                }
                                            }
                                            
                                            // MARK: Sad - state
                                            VStack(spacing: 5) {
                                                Button(action: {
                                                    self.toggleDayState(.sad)
                                                }) {
                                                    ZStack {
                                                        Capsule()
                                                            .fill(self.dayStates.contains(.sad) ? np_white : np_white.opacity(0.45))
                                                            .frame(width: 75, height: 45)
                                                            .overlay {
                                                                Text("Sad")
                                                                    .font(.system(size: 10))
                                                                    .fontWeight(.medium)
                                                                    .textCase(.uppercase)
                                                                    .foregroundColor(self.dayStates.contains(.sad) ? np_jap_indigo : np_white)
                                                            }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                // MARK: Journal Entry
                                VStack {
                                    HStack {
                                        Label("Summary", systemImage: "")
                                            .font(.footnote)
                                            .fontWeight(.semibold)
                                            .kerning(2)
                                            .textCase(.uppercase)
                                            .foregroundColor(np_white)
                                        
                                        Spacer()
                                    }
                                    
                                    ZStack(alignment: .bottomTrailing) {
                                        MultiLineTextField(txt: $text, counterLabel: $counterLabel)
                                            .frame(height: 200)
                                            .cornerRadius(20)
                                        
                                        Text("Remaining Text: \(counterLabel)")
                                            .font(.system(size: 8))
                                            .fontWeight(.medium)
                                            .textCase(.uppercase)
                                            .kerning(2)
                                            .foregroundColor(np_gray)
                                            .padding([.bottom, .trailing], 8)
                                    }
                                }
                                
                                // MARK: Save Diary Entry button
                                Button(action: {
                                    self.moodModelController.createMood(emotion: Emotion(state: self.emotionState, color: self.moodColor), comment: self.text, date: Date(), dayStates: self.dayStates)
                                    
                                    self.presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Text("Save")
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .kerning(5)
                                        .textCase(.uppercase)
                                })
                                .padding(.vertical, 5)
                                .foregroundColor(np_jap_indigo)
                                .frame(width: 250, height: 50)
                                .background(np_white)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule(style: .continuous)
                                        .stroke(np_jap_indigo, style: StrokeStyle(lineWidth: 1))
                                        .padding(2)
                                )
                                
                                Spacer()
                            }
                            .padding()
                        }
                    }
            }
        }
        .accentColor(np_black)
    }
    
    // MARK: - Method to toggle day state
    func toggleDayState(_ state: DayState) {
        if let index = dayStates.firstIndex(of: state) {
            dayStates.remove(at: index)
        } else {
            dayStates.append(state)
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
}

// MARK: Multiline Text View
struct MultiLineTextField: UIViewRepresentable {
    @Binding var txt: String?
    @Binding var counterLabel: String
    
    func makeCoordinator() -> MultiLineTextField.Coordinator {
        return MultiLineTextField.Coordinator(parent1: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let text = UITextView()
        text.isEditable = true
        text.isUserInteractionEnabled = true
        
        if self.txt != "" {
            text.text = self.txt
            text.textColor = UIColor(Color(red: 27 / 255, green: 27 / 255, blue: 27 / 255))
        } else {
            text.text = "Enter short mood summary"
            text.textColor = UIColor(Color(red: 169 / 255, green: 169 / 255, blue: 169 / 255))
            text.font = .systemFont(ofSize: 12)
        }
        
        text.backgroundColor = UIColor(red: 239/255, green: 243/255, blue: 244/255, alpha: 1)
        text.font = .systemFont(ofSize: 18)
        text.returnKeyType = .done
        text.delegate = context.coordinator
        text.inputAccessoryView = UIView() //Removes the "done" button from the top of the keyboard.
        text.leftSpace()
        return text
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        //
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MultiLineTextField
        
        init(parent1: MultiLineTextField) {
            
            parent = parent1
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if self.parent.txt == "" {
                
                textView.text = ""
                textView.textColor = .black
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            
            self.parent.txt = textView.text
            
            // MARK: Character length calculation
            let allowed = 250
            let typed = textView.text.count
            let remaining = allowed - typed
            
            self.parent.counterLabel = "\(remaining)"
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            
            // MARK: removes white spaces
            guard text.rangeOfCharacter(from: .newlines) == nil else {
                return false
            }
            
            // MARK: Set text limit to 200
            let existingTextLength = textView.text.utf16.count
            let replacementTextLength = text.utf16.count
            let rangeLength = range.length
            
            return existingTextLength + replacementTextLength - rangeLength <= 250
        }
    }
}

extension UITextView {
    func leftSpace() {
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
