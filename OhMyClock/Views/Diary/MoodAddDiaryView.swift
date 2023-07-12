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
    @State private var counterLabel = "150"
    
    var body: some View {
        ZStack {
            np_arsenic
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                HStack {
                    Text("Add Daily Summary")
                        .font(.title2)
                        .fontWeight(.bold)
                        .kerning(5)
                        .minimumScaleFactor(0.5)
                        .textCase(.uppercase)
                    
                    Spacer()
                }
                
                HStack(spacing: 20){
                    
                    // MARK: Great - emotion
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
                                .frame(width: 60, height: 60)

                            Image("great")
                                .resizable()
                                .frame(width: 55, height: 55)
                        }
                    }
                    
                    // MARK: Good - emotion
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
                                .frame(width: 60, height: 60)

                            Image("good")
                                .resizable()
                                .frame(width: 55, height: 55)
                        }

                    }
                    
                    // MARK: Okay - emotion
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
                                .frame(width: 60, height: 60)

                            Image("okay")
                                .resizable()
                                .frame(width: 55, height: 55)
                        }

                    }
                    
                    // MARK: Upset - emotion
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
                                .frame(width: 60, height: 60)

                            Image("upset")
                                .resizable()
                                .frame(width: 55, height: 55)
                        }
                    }
                    
                    // MARK: Angry - emotion
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
                                .frame(width: 60, height: 60)

                            Image("angry")
                                .resizable()
                                .frame(width: 55, height: 55)
                        }
                    }
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
                
                // MARK: Save Diary Entry button
                Button(action: {
                    self.moodModelController.createMood(emotion: Emotion(state: self.emotionState, color: self.moodColor), comment: self.text, date: Date())
                    
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save Summary")
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
            }.padding()
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
        
        /* Updated for Swift 4 */
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
            //Stop entry while reached 150 chars
            return textView.text.count + (text.count - range.length) <= 150
            
            
            //  return true
        }
    }
}

extension UITextView {
    func leftSpace() {
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
