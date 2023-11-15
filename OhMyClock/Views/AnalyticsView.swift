//
//  AnalyticsView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-11-07.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Charts

struct AnalyticsView: View {
    @ObservedObject var moodModelController: MoodModelController
    @ObservedObject var authModel = AuthViewModel()
    @StateObject var progressViewModel = AppViewModel()
    
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
                
                ScrollView(.vertical, showsIndicators: false){
                    StreakView(moodModelController: moodModelController)
                        .padding(.top, 20)
                    
                    ChartView()
                        .frame(height: 500)
                    
                    // MARK: Last 3 months
                    VStack {
                        HStack {
                            Label("Last Month:", systemImage: "")
                                .font(.system(size: 13))
                                .fontWeight(.bold)
                                .kerning(3)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // MARK: Last Months Statistics
                        ForEach((1..<2).reversed(), id: \.self) { monthOffset in
                            LastMonthView(
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
                    .padding(.vertical, 10)
                }
            }
            
            if progressViewModel.isLoading {
                ProgressLoadingView()
            }
        }
        .background(np_jap_indigo)
        .onAppear {
            if moodModelController.moods.isEmpty {
                moodModelController.loadFromFirestore()
            }
            
            progressViewModel.loadData()
        }
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
        let firstName = authModel.user?.firstName ?? ""
        
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("\(firstName)'s Report")
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
                        .foregroundColor(np_gray)
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
                
                HStack(spacing: 30) {
                    // MARK: Current Streak
                    VStack(alignment: .center, spacing: 15) {
                        Text("Current")
                            .font(.system(size: 10))
                            .fontWeight(.semibold)
                            .kerning(3)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                        
                        Text("👑")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        Text("\(moodModelController.currentStreak)")
                            .font(.title)
                            .fontWeight(.heavy)
                            .kerning(3)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                    }
                    
                    Capsule()
                        .frame(width: 0.5, height: 100)
                        .foregroundColor(np_gray)
                    
                    // MARK: Best Streak
                    VStack(alignment: .center, spacing: 15) {
                        Text("Best")
                            .font(.system(size: 10))
                            .fontWeight(.semibold)
                            .kerning(3)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                        
                        Text("🏆")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        Text("\(moodModelController.bestStreak)")
                            .font(.title)
                            .fontWeight(.heavy)
                            .kerning(3)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                    }
                    
                    Capsule()
                        .frame(width: 0.5, height: 100)
                        .foregroundColor(np_gray)
                    
                    // MARK: Best Streak
                    VStack(alignment: .center, spacing: 15) {
                        Text("Total")
                            .font(.system(size: 10))
                            .fontWeight(.semibold)
                            .kerning(3)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                        
                        Text("📆")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        Text("\(moodModelController.totalDaysLogged)")
                            .font(.title)
                            .fontWeight(.heavy)
                            .kerning(3)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal, 15)
        }
    }
}

// MARK: - 3 Month View
struct LastMonthView: View {
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

// MARK: Chart View
struct ChartView: View {
    struct MoodDataModel: Identifiable {
        var id = UUID()
        var emotion: String
        var count: Double
        var color: Color
    }
    
    @ObservedObject var moodCount: DayStateViewModel = DayStateViewModel()
    
    // Initialize moodData with counts from moodCount
    private func initializeMoodData() -> [MoodDataModel] {
        return [
            .init(emotion: "Amazing", count: Double(moodCount.frequency(for: .amazing)), color: np_green),
            .init(emotion: "Good", count: Double(moodCount.frequency(for: .good)), color: np_turq),
            .init(emotion: "Okay", count: Double(moodCount.frequency(for: .okay)), color: np_yellow),
            .init(emotion: "Bad", count: Double(moodCount.frequency(for: .bad)), color: np_orange),
            .init(emotion: "Terrible", count: Double(moodCount.frequency(for: .terrible)), color: np_red)
        ]
    }
    
    // Use a computed property to get the mood data with updated counts
    private var moodData: [MoodDataModel] {
        initializeMoodData()
    }
    
    // Calculate the total count of all moods
    private var totalMoodCount: Double {
        moodData.reduce(0) { $0 + $1.count }
    }
    
    private func percentage(for emotion: DayMoodState?) -> String {
        guard let emotion = emotion, totalMoodCount > 0 else {
            return "0%" // Handle the case where totalMoodCount is zero or emotion is nil
        }
        let count = moodCount.frequency(for: emotion) // frequency returns a non-optional Int
        let roundedPercentage = (Double(count) / totalMoodCount * 100).rounded(.toNearestOrEven)
        return String(format: "%.0f%%", roundedPercentage)
    }
    
    // Convert counts to percentages of the total
    private var moodDataInPercentages: [MoodDataModel] {
        // Ensure we're not dividing by zero
        guard totalMoodCount > 0 else {
            return moodData.map { mood in
                var moodCopy = mood
                moodCopy.count = 0
                return moodCopy
            }
        }
        
        return moodData.map { mood in
            var moodCopy = mood
            let percentage = (mood.count / totalMoodCount * 100)
            moodCopy.count = percentage
            return moodCopy
        }
    }
    
    var body: some View {
        ZStack {
            // MARK: Mood Count Summary
            VStack(alignment: .center, spacing: 10) {
                HStack {
                    Text("Mood Analysis:")
                        .font(.system(size: 13))
                        .fontWeight(.bold)
                        .kerning(3)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    Spacer()
                }
                
                Spacer()
                    .frame(height: 50)
                
                DonutChart(data: moodDataInPercentages)
                
                Spacer()
                    .frame(height: 50)
                
                // MARK: Chart Key
                HStack(spacing: 30) {
                    ForEach(moodDataInPercentages, id: \.id) { mood in
                        VStack {
                            Circle()
                                .fill(mood.color)
                                .frame(width: 30)
                            
                            Text(mood.emotion)
                                .font(.caption2)
                                .fontWeight(.regular)
                                .kerning(1)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                            
                            Text(percentage(for: DayMoodState(rawValue: mood.emotion.lowercased()) ?? .none))
                                .font(.subheadline)
                                .fontWeight(.heavy)
                                .kerning(3)
                                .foregroundColor(np_white)
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal, 15)
        }
    }
}

struct DonutChart: View {
    var data: [ChartView.MoodDataModel]
    var body: some View {
        ZStack {
            ForEach(data) { datum in
                Circle()
                    .trim(from: 0, to: CGFloat(datum.count) / 100) // Use percentages for trim
                    .stroke(datum.color, lineWidth: 100) // Adjust your line width for the donut thickness
                    .rotationEffect(.degrees(startAngle(datum: datum)))
                    .frame(width: 200, height: 200)
            }
        }
    }
    
    // Calculate the start angle of each donut chart segment
    private func startAngle(datum: ChartView.MoodDataModel) -> Double {
        var startAngle: Double = 0
        for d in data {
            if d.id == datum.id {
                break
            }
            startAngle += (d.count / 100) * 360 // Convert the percentage to an angle
        }
        return startAngle
    }
}

extension DayMoodState {
    var displayString: String {
        switch self {
        case .amazing: return "Amazing"
        case .good: return "Good"
        case .okay: return "Okay"
        case .bad: return "Bad"
        case .terrible: return "Terrible"
        }
    }
    
    var color: Color {
        switch self {
        case .amazing: return np_green
        case .good: return np_turq
        case .okay: return np_yellow
        case .bad: return np_orange
        case .terrible: return np_red
        }
    }
}
