//
//  MoodSliderView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-29.
//
import SwiftUI

struct MoodButtonView: View {
    let buttonText: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(isSelected ? np_white : np_white.opacity(0.3))
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay {
                    Text(buttonText)
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                        .kerning(3)
                        .textCase(.uppercase)
                        .foregroundColor(isSelected ? np_jap_indigo : np_gray)
                }
        }
    }
}

struct MoodSliderView: View {
    private let hapticFeedback = UIImpactFeedbackGenerator()
    @State var selectedMood: MoodType = .happy
    
    var model: MoodModel
    
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        HStack(spacing: 10) {
            MoodButtonView(buttonText: "Angry", isSelected: selectedMood == .angry) {
                self.selectedMood = .angry
                self.model.moodType = .angry
                self.hapticFeedback.impactOccurred()
            }
            
            MoodButtonView(buttonText: "Sad", isSelected: selectedMood == .sad) {
                self.selectedMood = .sad
                self.model.moodType = .sad
                self.hapticFeedback.impactOccurred()
            }
            
            MoodButtonView(buttonText: "Okay", isSelected: selectedMood == .okay) {
                self.selectedMood = .okay
                self.model.moodType = .okay
                self.hapticFeedback.impactOccurred()
            }
            
            MoodButtonView(buttonText: "Happy", isSelected: selectedMood == .happy) {
                self.selectedMood = .happy
                self.model.moodType = .happy
                self.hapticFeedback.impactOccurred()
            }
            
            MoodButtonView(buttonText: "Great", isSelected: selectedMood == .great) {
                self.selectedMood = .great
                self.model.moodType = .great
                self.hapticFeedback.impactOccurred()
            }
        }
        .padding()
    }
}

struct MoodSliderView_Previews: PreviewProvider {
    static var previews: some View {
        MoodSliderView(model: MoodModel())
    }
}
