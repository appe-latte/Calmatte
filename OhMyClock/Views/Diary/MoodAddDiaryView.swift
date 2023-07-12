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
    @State private var angrySelected = false
    @State private var counterLabel = "200"
    
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
                    
                    HStack(spacing: 15){
                        
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
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(self.greatSelected ? np_white : Color.clear)
                                        .frame(width: 65, height: 65)
                                    
                                    Image("great")
                                        .resizable()
                                        .frame(width: 55, height: 55)
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
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(self.goodSelected ? np_white : Color.clear)
                                        .frame(width: 65, height: 65)
                                    
                                    Image("good")
                                        .resizable()
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
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(self.okaySelected ? np_white : Color.clear)
                                        .frame(width: 65, height: 65)
                                    
                                    Image("okay")
                                        .resizable()
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
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(self.upsetSelected ? np_white : Color.clear)
                                        .frame(width: 65, height: 65)
                                    
                                    Image("upset")
                                        .resizable()
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
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(self.angrySelected ? np_white : Color.clear)
                                        .frame(width: 65, height: 65)
                                    
                                    Image("angry")
                                        .resizable()
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
                }
                
                // MARK: Journal Entry
                VStack {
                    HStack {
                        Label("Short Event Summary", systemImage: "")
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
                    self.moodModelController.createMood(emotion: Emotion(state: self.emotionState, color: self.moodColor), comment: self.text, date: Date())
                    
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
