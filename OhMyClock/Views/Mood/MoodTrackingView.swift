//
//  MoodTrackingView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-27.
//

import SwiftUI
import Combine

struct MoodTrackingView: View {
    private let screenWidth: CGFloat = UIScreen.main.bounds.width - 40
    private let hapticFeedback = UIImpactFeedbackGenerator()
    
    @ObservedObject var moodModel: MoodModel
    @State private var insightsMode: InsightsType = .today
    @Binding var tabBarSelection: Int
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            MoodSelectorTileView(moodModel: moodModel)
            
            VStack {
                
                self.insightsSectionView
                
                // MARK: Mood Statistics
                MoodInsightsListView(screenWidth: screenWidth, moodModel: moodModel)
                
                Spacer(minLength: 20)
            }
        }
        .frame(width: screenWidth)
    }
    
    // MARK: Insights Header
    var insightsSectionView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Insights").font(.largeTitle).bold()
                Spacer()
            }
            .padding(.top)
            
            Text("Mood Selection").foregroundColor(.secondary)
            
            Picker(selection: $insightsMode, label: Text("")) {
                ForEach(InsightsType.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top, -5)
            .padding(.bottom, 10)
            .onReceive(Just(insightsMode)) { newValue in
                self.hapticFeedback.impactOccurred()
                self.moodModel.didChangeInsights(type: newValue)
            }
            
        }
    }
}
