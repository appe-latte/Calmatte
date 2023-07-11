//
//  MoodInsightsListView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-29.
//

import SwiftUI

struct MoodInsightsListView: View {
    var screenWidth: CGFloat
    @ObservedObject var moodModel: MoodModel
    
    var body: some View {
        ForEach(0..<MoodType.allCases.count, content: { index in
            HStack(spacing: 10) {
                Text(self.moodModel.moodDetails(type: MoodType.allCases[index]).emoji)
                    .font(.system(size: 35))
                    .frame(width: 40)
                
                ZStack {
                    Color(.secondaryLabel)
                        .opacity(0.2)
                    
                    
                    // MARK: Bars for mood count
                    HStack {
                        self.moodModel.moodDetails(type: MoodType.allCases[index]).colors.first!
                            .frame(maxWidth: self.calculateProgress(forMoodType: MoodType.allCases[index]))
                            .clipShape(Capsule())
                        
                        Spacer(minLength: 0)
                    }
                    
                    Text("\(self.moodModel.moodCount(type: MoodType.allCases[index]))")
                        .fontWeight(.bold)
                        .foregroundColor(self.moodCounterColor(type: MoodType.allCases[index]))
                }
                .frame(height: 40)
                .clipShape(Capsule())
            }
        })
    }
    
    /// This will change the mood counter color from dark to white to look nicer on color background
    private func moodCounterColor(type: MoodType) -> Color {
        let count = self.moodModel.moodCount(type: type)
        return count > (moodModel.insightsType == .today ? 1 : 10) ? np_white : np_gray
    }
    
    /// This will determine the necessary width for the colored progress view
    private func calculateProgress(forMoodType type: MoodType) -> CGFloat {
        let progressWidth: CGFloat = screenWidth - 40
        let progress = (progressWidth * CGFloat(self.moodModel.moodCount(type: type))) / CGFloat(moodModel.insightsType.maximumMoodCheckins)
        return progress > progressWidth ? progressWidth : progress
    }
}

// MARK: - Canvas Preview
struct MoodInsightsListView_Previews: PreviewProvider {
    static var previews: some View {
        MoodInsightsListView(screenWidth: (UIScreen.main.bounds.width - 40), moodModel: MoodModel())
    }
}
