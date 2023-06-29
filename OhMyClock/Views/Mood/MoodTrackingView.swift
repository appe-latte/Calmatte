//
//  MoodTrackingView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-27.
//

import SwiftUI
import Combine

struct MoodTrackingView: View {
    /// Screen with including padding
        private let screenWidth: CGFloat = UIScreen.main.bounds.width - 40
        private let hapticFeedback = UIImpactFeedbackGenerator()
        
        /// This is the main mood model
        @ObservedObject var moodModel: MoodModel
        @State private var insightsMode: InsightsType = .today
        @Binding var tabBarSelection: Int

        // Main rendering function of the view
        var body: some View {
            ScrollView(showsIndicators: false) {
                /// Header title and subtitle
                Spacer(minLength: 20)
                self.headerView
                
                /// Mood selector gradiend
                MoodSelectorTileView(moodModel: moodModel)
                
                /// Insigts section
                VStack {
                    /// Header title, subtitle and tab view
                    self.insightsSectionView
                    
                    /// Mood type statistics
                    MoodInsightsListView(screenWidth: screenWidth, moodModel: moodModel)
                    
                    Spacer(minLength: 20)
                }
            }
            .frame(width: screenWidth)
        }
        
        /// Welcome header view
        var headerView: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text("Welcome back").font(.title).foregroundColor(.secondary)
                    Text("How is your mood today?").font(.largeTitle).bold()
                }
                Spacer()
            }
        }
        
        /// Insights header and tabs
        var insightsSectionView: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text("Insights").font(.largeTitle).bold()
                    Spacer()
                }
                .padding(.top)
                
                Text("Select mood range").foregroundColor(.secondary)
                
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
