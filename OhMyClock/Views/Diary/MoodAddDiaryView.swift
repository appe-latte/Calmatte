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
    @State private var emotionState: EmotionState = .okay
    @State private var moodColor: MoodColor = .okayColor
    @State private var greatSelected = false
    @State private var goodSelected = false
    @State private var okaySelected = false
    @State private var upsetSelected = false
    @State private var mehSelected = false
    @State private var sleepySelected = false
    @State private var shockedSelected = false
    @State private var lovedSelected = false
    @State private var sadSelected = false
    @State private var lowSelected = false
    @State private var angrySelected = false
    @State private var counterLabel = "200"
    
    @State private var dayStates: [DayState] = []
    
    var body: some View {
        ZStack {
            np_arsenic
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                HStack {
                    Text("Add Journal Entry")
                        .font(.title2)
                        .fontWeight(.bold)
                        .kerning(5)
                        .minimumScaleFactor(0.5)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    Spacer()
                }
                
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
                        
                        // MARK: Great - emotion
                        VStack(spacing: 5) {
                            Button(action: {
                                self.emotionState = .great
                                self.moodColor = .greatColor
                                self.greatSelected = true
                                self.goodSelected = false
                                self.okaySelected = false
                                self.upsetSelected = false
                                self.angrySelected = false
                                self.sadSelected = false
                                self.lowSelected = false
                                self.mehSelected = false
                                self.lovedSelected = false
                                self.shockedSelected = false
                                self.sleepySelected = false
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(self.greatSelected ? np_white : Color.clear)
                                        .frame(width: 70, height: 70)
                                    
                                    Image("great")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 55)
                                }
                            }
                            
                            Text("Great")
                                .font(.system(size: 10))
                                .fontWeight(.medium)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                        }
                        
                        // MARK: Good - emotion
                        VStack(spacing: 5){
                            Button(action: {
                                self.emotionState = .good
                                self.moodColor = .goodColor
                                self.greatSelected = false
                                self.goodSelected = true
                                self.okaySelected = false
                                self.upsetSelected = false
                                self.angrySelected = false
                                self.sadSelected = false
                                self.lowSelected = false
                                self.mehSelected = false
                                self.lovedSelected = false
                                self.shockedSelected = false
                                self.sleepySelected = false
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(self.goodSelected ? np_white : Color.clear)
                                        .frame(width: 65, height: 65)
                                    
                                    Image("good")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 55, height: 55)
                                }
                            }
                            
                            Text("Good")
                                .font(.system(size: 10))
                                .fontWeight(.medium)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                        }
                        
                        // MARK: Okay - emotion
                        VStack(spacing: 5){
                            Button(action: {
                                self.emotionState = .okay
                                self.moodColor = .okayColor
                                self.greatSelected = false
                                self.goodSelected = false
                                self.okaySelected = true
                                self.upsetSelected = false
                                self.angrySelected = false
                                self.sadSelected = false
                                self.lowSelected = false
                                self.mehSelected = false
                                self.lovedSelected = false
                                self.shockedSelected = false
                                self.sleepySelected = false
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(self.okaySelected ? np_white : Color.clear)
                                        .frame(width: 65, height: 65)
                                    
                                    Image("okay")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 55, height: 55)
                                }
                            }
                            
                            Text("Okay")
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
                                self.greatSelected = false
                                self.goodSelected = false
                                self.okaySelected = false
                                self.upsetSelected = true
                                self.angrySelected = false
                                self.sadSelected = false
                                self.lowSelected = false
                                self.mehSelected = false
                                self.lovedSelected = false
                                self.shockedSelected = false
                                self.sleepySelected = false
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(self.upsetSelected ? np_white : Color.clear)
                                        .frame(width: 65, height: 65)
                                    
                                    Image("upset")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 55, height: 55)
                                }
                            }
                            
                            Text("Upset")
                                .font(.system(size: 10))
                                .fontWeight(.medium)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                        }
                        
                        // MARK: Angry - emotion
                        VStack(spacing: 5){
                            Button(action: {
                                self.emotionState = .angry
                                self.moodColor = .angryColor
                                self.greatSelected = false
                                self.goodSelected = false
                                self.okaySelected = false
                                self.upsetSelected = false
                                self.angrySelected = true
                                self.sadSelected = false
                                self.lowSelected = false
                                self.mehSelected = false
                                self.lovedSelected = false
                                self.shockedSelected = false
                                self.sleepySelected = false
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(self.angrySelected ? np_white : Color.clear)
                                        .frame(width: 65, height: 65)
                                    
                                    Image("angry")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 55, height: 55)
                                }
                            }
                            
                            Text("Angry")
                                .font(.system(size: 10))
                                .fontWeight(.medium)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                        }
                    }
                    
                    // MARK: Stack Two
                    HStack(spacing: 10){
                        
                        // MARK: Loved - emotion
                        VStack(spacing: 5) {
                            Button(action: {
                                self.emotionState = .loved
                                self.moodColor = .lovedColor
                                self.greatSelected = false
                                self.goodSelected = false
                                self.okaySelected = false
                                self.upsetSelected = false
                                self.angrySelected = false
                                self.sadSelected = false
                                self.lowSelected = false
                                self.mehSelected = false
                                self.lovedSelected = true
                                self.shockedSelected = false
                                self.sleepySelected = false
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(self.lovedSelected ? np_white : Color.clear)
                                        .frame(width: 70, height: 70)
                                    
                                    Image("loved")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 55)
                                }
                            }
                            
                            Text("Loved")
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
                                self.greatSelected = false
                                self.goodSelected = false
                                self.okaySelected = false
                                self.upsetSelected = false
                                self.angrySelected = false
                                self.sadSelected = true
                                self.lowSelected = false
                                self.mehSelected = false
                                self.lovedSelected = false
                                self.shockedSelected = false
                                self.sleepySelected = false
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(self.sadSelected ? np_white : Color.clear)
                                        .frame(width: 65, height: 65)
                                    
                                    Image("sad")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 55, height: 55)
                                }
                            }
                            
                            Text("Sad")
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
                                self.greatSelected = false
                                self.goodSelected = false
                                self.okaySelected = false
                                self.upsetSelected = false
                                self.angrySelected = false
                                self.sadSelected = false
                                self.lowSelected = false
                                self.mehSelected = true
                                self.lovedSelected = false
                                self.shockedSelected = false
                                self.sleepySelected = false
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(self.mehSelected ? np_white : Color.clear)
                                        .frame(width: 65, height: 65)
                                    
                                    Image("meh")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 55, height: 55)
                                }
                            }
                            
                            Text("Meh")
                                .font(.system(size: 10))
                                .fontWeight(.medium)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                        }
                        
                        // MARK: Low - emotion
                        VStack(spacing: 5){
                            Button(action: {
                                self.emotionState = .low
                                self.moodColor = .lowColor
                                self.greatSelected = false
                                self.goodSelected = false
                                self.okaySelected = false
                                self.upsetSelected = false
                                self.angrySelected = false
                                self.sadSelected = false
                                self.lowSelected = true
                                self.mehSelected = false
                                self.lovedSelected = false
                                self.shockedSelected = false
                                self.sleepySelected = false
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(self.lowSelected ? np_white : Color.clear)
                                        .frame(width: 65, height: 65)
                                    
                                    Image("low")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 55, height: 55)
                                }
                            }
                            
                            Text("Low")
                                .font(.system(size: 10))
                                .fontWeight(.medium)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                        }
                        
                        // MARK: Shock - emotion
                        VStack(spacing: 5){
                            Button(action: {
                                self.emotionState = .shock
                                self.moodColor = .shockColor
                                self.greatSelected = false
                                self.goodSelected = false
                                self.okaySelected = false
                                self.upsetSelected = false
                                self.angrySelected = false
                                self.sadSelected = false
                                self.lowSelected = false
                                self.mehSelected = false
                                self.lovedSelected = false
                                self.shockedSelected = true
                                self.sleepySelected = false
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(self.shockedSelected ? np_white : Color.clear)
                                        .frame(width: 65, height: 65)
                                    
                                    Image("shock")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 55, height: 55)
                                }
                            }
                            
                            Text("Shocked")
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
                                        RoundedRectangle(cornerRadius: 10)
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
                                        RoundedRectangle(cornerRadius: 10)
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
                            
                            // MARK: Active - state
                            VStack(spacing: 5) {
                                Button(action: {
                                    self.toggleDayState(.active)
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(self.dayStates.contains(.active) ? np_white : np_white.opacity(0.45))
                                            .frame(width: 75, height: 45)
                                            .overlay {
                                                Text("active")
                                                    .font(.system(size: 10))
                                                    .fontWeight(.medium)
                                                    .textCase(.uppercase)
                                                    .foregroundColor(self.dayStates.contains(.active) ? np_jap_indigo : np_white)
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
                                        RoundedRectangle(cornerRadius: 10)
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
                                        RoundedRectangle(cornerRadius: 10)
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
                                    self.toggleDayState(.tiring)
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(self.dayStates.contains(.tiring) ? np_white : np_white.opacity(0.45))
                                            .frame(width: 75, height: 45)
                                            .overlay {
                                                Text("Tiring")
                                                    .font(.system(size: 10))
                                                    .fontWeight(.medium)
                                                    .textCase(.uppercase)
                                                    .foregroundColor(self.dayStates.contains(.tiring) ? np_jap_indigo : np_white)
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
                                        RoundedRectangle(cornerRadius: 10)
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
                                        RoundedRectangle(cornerRadius: 10)
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
                                        RoundedRectangle(cornerRadius: 10)
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
                                        RoundedRectangle(cornerRadius: 10)
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
                            .frame(height: 100)
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
}

struct MoodAddDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        MoodAddDiaryView(moodModelController: MoodModelController(), text: "")
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
        
        // text.textColor = .gray
        text.backgroundColor = UIColor(red: 239/255, green: 243/255, blue: 244/255, alpha: 1)
        text.font = .systemFont(ofSize: 18)
        text.returnKeyType = .done
        text.delegate = context.coordinator
        text.inputAccessoryView = UIView() //Removes the "done" button from the top of the keyboard.
        text.leftSpace()
        return text
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        
        
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
            let allowed = 150
            let typed = textView.text.count
            let remaining = allowed - typed
            
            self.parent.counterLabel = "\(remaining)"
        }
        
        //Runs FIRST when ever text view is about to be changed. Returns true, means allow change, false means do not allow.
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            
            //Do not allow white lines (breaks)
            guard text.rangeOfCharacter(from: .newlines) == nil else {
                return false
            }
            
            //Stop entry while reached 200 chars
            let existingTextLength = textView.text.utf16.count
            let replacementTextLength = text.utf16.count
            let rangeLength = range.length
            
            return existingTextLength + replacementTextLength - rangeLength <= 200
        }
    }
}

extension UITextView {
    func leftSpace() {
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
