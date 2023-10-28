//
//  LastMonthsView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-10-27.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct LastMonthsView: View {
    @ObservedObject var moodModelController: MoodModelController
    let startDate: Date
    let monthsToDisplay: Int
    var selectableDays: Bool
    
    init(start: Date, monthsToShow: Int, daysSelectable: Bool = true, moodController: MoodModelController) {
        self.startDate = start
        self.monthsToDisplay = monthsToShow
        self.selectableDays = daysSelectable
        self.moodModelController = moodController
    }
    
    public var body: some View {
        VStack {
            StreakView(moodModelController: moodModelController)
                .background(np_jap_indigo)
                .padding(.top, 20)
            
            Divider()
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach((0..<3).reversed(), id: \.self) { monthOffset in
                    MonthView(
                        moodModelController: moodModelController,
                        month: Month(
                            startDate: previousMonth(from: startDate, subtract: monthOffset),
                            selectableDays: selectableDays
                        )
                    )
                    .font(.headline)
                    .fontWeight(.bold)
                    .kerning(3)
                    .textCase(.uppercase)
                    .foregroundColor(np_white)
                }
            }

            
            Spacer()
        }
        .background(np_jap_indigo)
        .edgesIgnoringSafeArea(.all)
    }
    
    func previousMonth(from date: Date, subtract months: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: -months, to: date) ?? date
    }
    
    func nextMonth(currentMonth: Date, add: Int) -> Date {
        var components = DateComponents()
        components.month = add
        return Calendar.current.date(byAdding: components, to: currentMonth)!
    }
}

struct LastMonthsView_Previews: PreviewProvider {
    static var previews: some View {
        LastMonthsView(start: Date(), monthsToShow: 2, moodController: MoodModelController())
    }
}

// MARK: - Streak View
struct StreakView: View {
    @ObservedObject var moodModelController: MoodModelController
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Show Streak
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Journal History")
                        .font(.title3)
                        .fontWeight(.bold)
                        .kerning(3)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    Spacer()
                }
                
                HStack {
                    Text("Streak Count:")
                        .font(.system(size: 13))
                        .fontWeight(.bold)
                        .kerning(3)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                }
                
                // MARK: Current Streak
                HStack {
                    Text("\(moodModelController.currentStreak)")
                        .font(.title)
                        .fontWeight(.semibold)
                        .kerning(3)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("👑 Current Streak")
                                .font(.system(size: 10))
                                .fontWeight(.semibold)
                                .kerning(3)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                        }
                        
                        Capsule()
                            .frame(width: 250, height: 1)
                            .foregroundColor(np_gray)
                    }
                }
                
                // MARK: Best Streak
                HStack {
                    Text("\(moodModelController.bestStreak)")
                        .font(.title)
                        .fontWeight(.semibold)
                        .kerning(3)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("🏆 Best Streak")
                            
                                .font(.system(size: 10))
                                .fontWeight(.semibold)
                                .kerning(3)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                        }
                        
                        Capsule()
                            .frame(width: 250, height: 1)
                            .foregroundColor(np_gray)
                    }
                }
                
                // MARK: Total Logging Days
                HStack {
                    Text("\(moodModelController.totalDaysLogged)")
                        .font(.title)
                        .fontWeight(.semibold)
                        .kerning(3)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("📆 Total Days")
                                .font(.system(size: 10))
                                .fontWeight(.semibold)
                                .kerning(3)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                        }
                        
                        Capsule()
                            .frame(width: 250, height: 1)
                            .foregroundColor(np_gray)
                    }
                }
            }
            .padding(.horizontal, 15)
        }
    }
}
