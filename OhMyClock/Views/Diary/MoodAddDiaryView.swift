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
    
    @State private var selectedDayState: DayMoodState? = nil
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
                                .font(.system(size: 50, weight: .heavy))
                                .fontWeight(.bold)
                                .kerning(5)
                                .minimumScaleFactor(0.5)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                            
                            Image("\(emotionState.rawValue)")
                                .resizable()
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .frame(width: 65, height: 60)
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
                                        Label("How are you feeling?", systemImage: "")
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
                                        }
                                        .padding(2)
                                        
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
                                        }
                                        .padding(2)
                                        
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
                                        }
                                        .padding(2)
                                        
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
                                        }
                                        .padding(2)
                                        
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
                                        }
                                        .padding(2)
                                    }
                                    
                                    // MARK: Stack Two
                                    HStack(spacing: 10){
                                        
                                        // MARK: Angry - emotion
                                        VStack(spacing: 5) {
                                            Button(action: {
                                                self.emotionState = .angry
                                                self.moodColor = .angryColor
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
                                        }
                                        .padding(2)
                                        
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
                                        }
                                        .padding(2)
                                        
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
                                        }
                                        .padding(2)
                                        
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
                                        }
                                        .padding(2)
                                        
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
                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                        .frame(width: 65, height: 60)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 15)
                                                                .stroke(self.sickSelected ? Color.white : Color.clear, lineWidth: 2)
                                                        )
                                                }
                                            }
                                        }
                                        .padding(2)
                                    }
                                }
                                
                                // MARK: Day Type selection
                                VStack(spacing: 30) {
                                    HStack {
                                        Label("How was your day?", systemImage: "")
                                            .font(.footnote)
                                            .fontWeight(.semibold)
                                            .kerning(3)
                                            .textCase(.uppercase)
                                            .foregroundColor(np_white)
                                        
                                        Spacer()
                                    }
                                    
                                    // MARK: Day State
                                    HStack(spacing: 5){
                                        
                                        // MARK: Amazing - state
                                        DayStateButton(state: .amazing, selectedState: $selectedDayState)
                                        
                                        // MARK: Good - state
                                        DayStateButton(state: .good, selectedState: $selectedDayState)
                                        
                                        // MARK: Okay - state
                                        DayStateButton(state: .okay, selectedState: $selectedDayState)
                                        
                                        // MARK: Meh - state
                                        DayStateButton(state: .meh, selectedState: $selectedDayState)
                                        
                                        // MARK: Bad - state
                                        DayStateButton(state: .bad, selectedState: $selectedDayState)
                                        
                                        // MARK: Terrible - state
                                        DayStateButton(state: .terrible, selectedState: $selectedDayState)
                                    }
                                }
                                
                                // MARK: Journal Entry
                                VStack {
                                    HStack {
                                        Label("Today's Note", systemImage: "")
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
                                    if let dayState = self.selectedDayState {
                                        // Pass dayState directly, not as an array
                                        self.moodModelController.createMood(emotion: Emotion(state: self.emotionState, color: self.moodColor), comment: self.text, date: Date(), dayState: dayState)
                                    }
                                    HapticManager.instance.hapticSuccess()
                                    self.presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Text("Save")
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .kerning(5)
                                        .textCase(.uppercase)
                                })
                                .padding(.vertical, 5)
                                .foregroundColor(np_beige)
                                .frame(width: 250, height: 50)
                                .background(selectedEmotion.moodColor)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                
                                Spacer()
                            }
                            .padding()
                        }
                    }
            }
        }
        .accentColor(np_white)
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Rectangle()
                .fill(np_jap_indigo)
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
            text.textColor = UIColor(Color(red: 249 / 255, green: 249 / 255, blue: 243 / 255))
        } else {
            text.text = "Enter short mood summary"
            text.textColor = UIColor(Color(red: 169 / 255, green: 169 / 255, blue: 169 / 255))
            text.font = .systemFont(ofSize: 12)
        }
        
        text.backgroundColor = UIColor(red: 59 / 255, green: 68 / 255, blue: 79 / 255, alpha: 1)
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

// MARK: - DayState Button View
struct DayStateButton: View {
    let state: DayMoodState
    @Binding var selectedState: DayMoodState?
    
    var fillColor: Color {
        switch state {
        case .amazing:
            return np_green
        case .good:
            return np_turq
        case .okay:
            return np_yellow
        case .bad:
            return np_orange
        case .terrible:
            return np_red
        case .meh:
            return np_purple
        }
    }
    
    var stateIcon: String {
        switch state {
        case .amazing:
            return "amazing-emoji"
        case .good:
            return "good-emoji"
        case .okay:
            return "okay-emoji"
        case .bad:
            return "bad-emoji"
        case .terrible:
            return "terrible-emoji"
        case .meh:
            return "meh-emoji"
        }
    }
    
    var body: some View {
        Button(action: {
            self.selectedState = self.selectedState == state ? nil : state
        }) {
            ZStack {
                VStack(spacing: 30) {
                    LottieIconAnimView(animationFileName: self.selectedState == state ? stateIcon : stateIcon, loopMode: .loop, height: 75, width: 75)
                    
                    Text(state.displayString)
                        .font(self.selectedState == state ? .system(size: 11) : .system(size: 8))
                        .fontWeight(.heavy)
                        .textCase(.uppercase)
                        .foregroundColor(self.selectedState == state ? np_white : np_gray.opacity(0.75))
                }
            }
        }
    }
}

