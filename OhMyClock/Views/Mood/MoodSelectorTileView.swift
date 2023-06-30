//
//  MoodSelectorTileView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-29.
//

import SwiftUI

struct MoodSelectorTileView: View {
    private let hapticFeedback = UIImpactFeedbackGenerator()
    @ObservedObject var moodModel: MoodModel
    
    var body: some View {
        ZStack {
            self.largeGradientView
            self.fadedMoodTextView
            
            VStack {
                Spacer()
                
                self.moodEmojiSliderView
                
                self.saveMoodFooterView
            }
        }
        .cornerRadius(20)
    }
    
    /// Large gradient view
    var largeGradientView: some View {
        LinearGradient(gradient: Gradient(colors: moodModel.moodDetails().colors),
                       startPoint: .bottom, endPoint: .top).frame(height: UIScreen.main.bounds.width / 1.2)
    }
    
    /// Faded emoji text
    var fadedMoodTextView: some View {
        ZStack {
            ZStack {
                Text(moodModel.moodType.rawValue.uppercased())
                    .font(.system(size: 95))
                    .fontWeight(.bold)
                    .kerning(3)
                    .textCase(.uppercase)
                    .foregroundColor(np_white)
                    .opacity(0.65)
            }
            .offset(y: -80)
            LinearGradient(gradient: Gradient(colors:
                                                [moodModel.moodDetails().colors.first!, moodModel.moodDetails().colors.last!, moodModel.moodDetails().colors.last!.opacity(0)]),
                           startPoint: .bottom, endPoint: .top)
            .offset(y: -50)
            .opacity(0.9)
        }
    }
    
    // MARK: Emoji + Slider View
    var moodEmojiSliderView: some View {
        VStack {
            Text(moodModel.moodDetails().emoji)
                .font(Font.custom("Helvetica", size: 115))
                .offset(y: 20)
                .shadow(radius: 8)
            
            MoodSliderView(model: moodModel)
        }
    }
    
    var saveMoodFooterView: some View {
        ZStack {
            Color(.black).opacity(0.2).frame(height: 50)
            
            HStack {
                Text("I feel:")
                    .font(.caption)
                    .kerning(3)
                    .textCase(.uppercase)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(np_white)
                    .padding(.leading)
                
                Text(moodModel.moodType.rawValue)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(np_white)
                    .kerning(3)
                    .textCase(.uppercase)
                    .minimumScaleFactor(0.5)
                
                Spacer()
                
                // MARK: Save Mood
                Button(action: {
                    self.hapticFeedback.impactOccurred()
                    self.moodModel.objectWillChange.send()
                    self.moodModel.saveMood()
                }, label: {
                    Text("SAVE")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .kerning(3)
                        .textCase(.uppercase)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(np_white)
                })
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .padding(EdgeInsets(top: -5, leading: -10, bottom: -5, trailing: -10))
                        .foregroundColor(.white)
                        .opacity(0.2)
                )
                .padding().padding(.trailing, 10)
                .disabled(shouldDisableSaveButton)
                .opacity(shouldDisableSaveButton ? 0.4 : 1.0)
            }
        }
    }
    
    /// Disable save button when user selects `This Week` insights, also when the user reached maximum number of check-ins for a certain mood type
    var shouldDisableSaveButton: Bool {
        if moodModel.insightsType == .today {
            return moodModel.moodCount(type: moodModel.moodType) >= moodModel.insightsType.maximumMoodCheckins
        }
        return moodModel.insightsType == .thisWeek
    }
}

// MARK: - Canvas Preview
struct MoodSelectorTileView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            MoodSelectorTileView(moodModel: MoodModel())
        }
    }
}

