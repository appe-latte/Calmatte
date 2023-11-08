//
//  AnalyticsView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-11-07.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct AnalyticsView: View {
    @ObservedObject var moodModelController: MoodModelController
    let startDate: Date
    let monthsToDisplay: Int
    var selectableDays: Bool
    
    @State private var reportDescription = "Here's a summary of your mood statistics over time."
    
    init(start: Date, monthsToShow: Int, daysSelectable: Bool = true, moodController: MoodModelController) {
        self.startDate = start
        self.monthsToDisplay = monthsToShow
        self.selectableDays = daysSelectable
        self.moodModelController = moodController
    }
    
    public var body: some View {
        ZStack {
            background()
            
            VStack(spacing: 10) {
                HeaderView()
                
                StreakView(moodModelController: moodModelController)
                    .padding(.vertical, 20)
                
                VStack {
                    HStack {
                        Label("Last 3 Months", systemImage: "")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .kerning(2)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .foregroundColor(np_white)
                        .padding(.vertical, 10)
                    
                    // MARK: Last Months Statistics
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach((0..<3).reversed(), id: \.self) { monthOffset in
                            ThreeMonthView(
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
                }
            }
        }
        .background(np_jap_indigo)
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Rectangle()
                .fill(np_arsenic)
                .frame(height: size.height)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
    
    // MARK: "Header View"
    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Mood Summary Report")
                            .font(.title)
                            .fontWeight(.bold)
                            .kerning(2)
                            .minimumScaleFactor(0.5)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                        
                        Spacer()
                    }
                    
                    // MARK: Description
                    Text("\(reportDescription)")
                        .font(.system(size: 10))
                        .kerning(3)
                        .textCase(.uppercase)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(np_white)
                }
                .hAlign(.leading)
            }
        }
        .padding(15)
        .background {
            VStack(spacing: 0) {
                np_jap_indigo
            }
            .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
            .ignoresSafeArea()
        }
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

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView(start: Date(), monthsToShow: 2, moodController: MoodModelController())
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
                    Text("Streak Count:")
                        .font(.system(size: 13))
                        .fontWeight(.bold)
                        .kerning(3)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    Spacer()
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

// MARK: - 3 Month View
struct ThreeMonthView: View {
    @ObservedObject var moodModelController: MoodModelController
    var month: Month
    let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
    let colors = DiaryColors()
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                
                // MARK: Month Title
                HStack {
                    Spacer()
                    
                    Text("\(month.monthNameYear)")
                        .font(.title)
                        .scaledToFill()
                        .minimumScaleFactor(0.5)
                }
                .padding(.horizontal)
                
                // MARK: Weekdays
                HStack {
                    GridStack(rows: 1, columns: 7) { row, col in
                        Text(weekdays[col])
                            .font(.headline)
                            .fontWeight(.bold)
                            .kerning(3)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                    }
                }
                
                // MARK: Calendar days grid
                GridStack(rows: month.monthRows, columns: month.monthDays.count) { row, col in
                    if month.monthDays[col+1]![row].dayDate == Date(timeIntervalSince1970: 0) {
                        Text("")
                            .frame(width: 20, height: 20)
                    } else {
                        DayCellView(moodModelController: moodModelController,
                                    day: month.monthDays[col+1]![row])
                    }
                }
                .font(.headline)
                .fontWeight(.bold)
                .kerning(3)
                .textCase(.uppercase)
            }
            .padding(.bottom, 10)
        }
        .background(np_arsenic)
    }
}
