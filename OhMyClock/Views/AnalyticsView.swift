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
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
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
                    // MARK: Statistics
                    StatisticsView(moodModelController: moodModelController)
//                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    
                    // MARK: Mood Cards
                    MoodCountView()
                    
                    // MARK: CHart
                    ChartView()
                        .frame(height: 500)
                    
                    // MARK: This Month
                    VStack {
                        HStack {
                            Label("This Month", systemImage: "")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .kerning(2)
                                .textCase(.uppercase)
                                .foregroundColor(np_jap_indigo)
                                .padding(5)
                                .background(np_white)
                                .clipShape(Capsule())
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        MoodCalendarView(start: Date(), monthsToShow: 1, daysSelectable: true, moodController: moodModelController)
                            .frame(maxWidth: width - 20, maxHeight: height * 0.6)
                        
                    }
                }
            }
        }
    }
    
    //    func getMoodPredictionScore() -> Double {
    //        return calculateMoodPredictionScore(moods: moodModelController.moods)
    //    }
    
    
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
                            .font(.custom("Butler", size: 27))
                            .kerning(2)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(np_white)
                        
                        Spacer()
                    }
                    
                    // MARK: Description
                    Text("\(reportDescription)")
                        .font(.custom("Butler", size: 16))
                        .kerning(3)
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

// MARK: - Streak View
struct StatisticsView: View {
    @ObservedObject var moodModelController: MoodModelController
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Show Streak
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Label("Summary", systemImage: "")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .kerning(2)
                        .textCase(.uppercase)
                        .foregroundColor(np_jap_indigo)
                        .padding(5)
                        .background(np_white)
                        .clipShape(Capsule())
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack(spacing: 30) {
                    // MARK: Top Recurring Emotion
                    VStack(spacing: 15) {
                        Text("Most")
                            .font(.system(size: 15, weight: .semibold))
                            .kerning(3)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                        
                        if let topMoodState = moodModelController.calculateTopMood(moods: moodModelController.moods) {
                            Image(String(describing: topMoodState))
                                .resizable()
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .frame(width: 50, height: 85)
                        } else {
                            Text("-")
                                .font(.subheadline)
                                .foregroundColor(np_white)
                        }
                    }
                    .frame(alignment: .center)
                    
                    Capsule()
                        .frame(width: 0.5, height: 100)
                        .foregroundColor(np_gray)
                    
                    // MARK: Mood Prediction Score
                    VStack(spacing: 15) {
                        Text("Mood Score")
                            .font(.system(size: 15, weight: .semibold))
                            .kerning(3)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                        
                        Circle()
                            .fill(np_gray.opacity(0.1))
                            .frame(width: 85, height: 85)
                            .clipShape(Circle())
                            .overlay {
                                VStack {
                                    Text("\(moodModelController.calculateMoodPredictionScore(), specifier: "%.0f")")
                                        .font(.title)
                                        .fontWeight(.heavy)
                                        .kerning(2)
                                    
                                    Text("out of 100")
                                        .font(.system(size: 6, weight: .bold))
                                        .kerning(2)
                                        .textCase(.uppercase)
                                }
                            }                    }
                    .frame(alignment: .center)
                    
                    Capsule()
                        .frame(width: 0.5, height: 100)
                        .foregroundColor(np_gray)
                    
                    // MARK: Total days logged
                    VStack(spacing: 15) {
                        Text("Days")
                            .font(.system(size: 15, weight: .semibold))
                            .kerning(3)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                        
                        Text("📆")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        Text("\(moodModelController.totalDaysLogged)")
                            .font(.custom("Butler", size: 30))
                            .foregroundColor(np_white)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal, 5)
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
            VStack {
                
                // MARK: Month Title
                HStack {
                    Text("\(month.monthNameYear)")
                        .font(.custom("Butler", size: 24))
                        .textCase(.uppercase)
                        .scaledToFill()
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                // MARK: Weekdays
                HStack {
                    GridStack(rows: 1, columns: 7) { row, col in
                        Text(weekdays[col])
                            .font(.custom("Butler", size: 18))
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
                .font(.custom("Butler", size: 20))
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
            .init(emotion: "Terrible", count: Double(moodCount.frequency(for: .terrible)), color: np_red),
            .init(emotion: "Meh", count: Double(moodCount.frequency(for: .meh)), color: np_purple)
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
                    Label("Mood Chart", systemImage: "")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .kerning(2)
                        .textCase(.uppercase)
                        .foregroundColor(np_jap_indigo)
                        .padding(5)
                        .background(np_white)
                        .clipShape(Capsule())
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
                    .frame(height: 50)
                
                DonutChart(data: moodDataInPercentages)
                
                Spacer()
                    .frame(height: 50)
                
                // MARK: Chart Key
                HStack(spacing: 20) {
                    ForEach(moodDataInPercentages, id: \.id) { mood in
                        VStack(spacing: 5) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(mood.color)
                                .frame(height: 30)
                            
                            Text(mood.emotion)
                                .font(.system(size: 8))
                                .fontWeight(.regular)
                                .kerning(1)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                            
                            Text(percentage(for: DayMoodState(rawValue: mood.emotion.lowercased()) ?? .none))
                                .font(.system(size: 12))
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
        case .meh: return "Meh"
        }
    }
    
    var color: Color {
        switch self {
        case .amazing: return np_green
        case .good: return np_turq
        case .okay: return np_yellow
        case .bad: return np_orange
        case .terrible: return np_red
        case .meh: return np_purple
        }
    }
}
