//
//  MoodSelectorTileView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-29.
//

import SwiftUI

/// Main mood selector tile with gradient background and emoji
struct MoodSelectorTileView: View {
    private let hapticFeedback = UIImpactFeedbackGenerator()
    @ObservedObject var moodModel: MoodModel

    // Main rendering function of the view
    var body: some View {
        ZStack {
            self.largeGradientView
            self.fadedMoodTextView
            
            VStack {
                Spacer()
                /// Mood emoji and slider
                self.moodEmojiSliderView
                
                /// Mood name with set button
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
                    .font(Font.custom("Arial", size: 80)).bold()
                    .foregroundColor(.white)
                    .opacity(0.5)
            }
            .offset(y: -80)
            LinearGradient(gradient: Gradient(colors:
                [moodModel.moodDetails().colors.first!, moodModel.moodDetails().colors.last!, moodModel.moodDetails().colors.last!.opacity(0)]),
                           startPoint: .bottom, endPoint: .top)
                .offset(y: -50)
                .opacity(0.9)
        }
    }
    
    /// Mood large emoji and slider view
    var moodEmojiSliderView: some View {
        VStack {
            Text(moodModel.moodDetails().emoji)
                .font(Font.custom("Helvetica", size: 115))
                .offset(y: 20)
                .shadow(radius: 8)
            
            MoodSliderView(model: moodModel)
        }
    }
    
    /// Save mood gradient footer view
    var saveMoodFooterView: some View {
        ZStack {
            Color(.black).opacity(0.2).frame(height: 50)
            HStack {
                Text("I'm feeling")
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
                
                Button(action: {
                    /// Save the mood for today
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
                }).background(
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

