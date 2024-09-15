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
    @ObservedObject var moodCount: DayStateViewModel = DayStateViewModel()
    
    let startDate: Date
    let monthsToDisplay: Int
    var selectableDays: Bool
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    @State private var reportDescription = "Here's a summary of your mood statistics over time."
    
    // Initialization of mood frequency percentages for the bar chart
    private func initializeMoodData() -> [BarChartView.MoodDataModel] {
        return [
            .init(emotion: "Amazing", count: Double(moodCount.frequency(for: .amazing)), color: np_green),
            .init(emotion: "Good", count: Double(moodCount.frequency(for: .good)), color: np_turq),
            .init(emotion: "Okay", count: Double(moodCount.frequency(for: .okay)), color: np_yellow),
            .init(emotion: "Meh", count: Double(moodCount.frequency(for: .meh)), color: np_purple),
            .init(emotion: "Bad", count: Double(moodCount.frequency(for: .bad)), color: np_orange),
            .init(emotion: "Terrible", count: Double(moodCount.frequency(for: .terrible)), color: np_red)
        ]
    }
    
    init(start: Date, monthsToShow: Int, daysSelectable: Bool = true, moodController: MoodModelController) {
        self.startDate = start
        self.monthsToDisplay = monthsToShow
        self.selectableDays = daysSelectable
        self.moodModelController = moodController
    }
    
    public var body: some View {
        let moodData = initializeMoodData()
        
        ZStack {
            background()
            
            VStack(spacing: 10) {
                HeaderView()
                
                ScrollView(.vertical, showsIndicators: false){
                    // MARK: Summary
                    MoodSummaryView(moodModelController: moodModelController)
                        .padding(.bottom, 30)
                    
                    // MARK: "This Month" Calendar View
                    VStack {
                        HStack {
                            Label("This Month", systemImage: "")
                                .font(.system(size: 10))
                                .fontWeight(.semibold)
                                .kerning(2)
                                .textCase(.uppercase)
                                .foregroundColor(np_jap_indigo)
                                .padding(5)
                                .background(np_white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                            Spacer()
                        }
                        .padding()
                        
                        MonthlyCalendarView(start: Date(), monthsToShow: 1, daysSelectable: true, moodController: moodModelController)
                            .frame(maxWidth: width - 20, maxHeight: height * 0.6)
                    }
                    
                    // MARK: Bar Chart
                    BarChartView(data: moodData)
                    
                    // MARK: Donut Chart
                    DonutChartView()
                        .frame(height: 500)
                }
            }
        }
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
//            Image("img-bg")
//                .resizable()
//                .scaledToFill()
//                .frame(height: size.height, alignment: .bottom)
            
            Rectangle()
                .fill(np_jap_indigo)
//                .opacity(0.98)
                .frame(height: size.height, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
    
    // MARK: "Header View"
    @ViewBuilder
    func HeaderView() -> some View {
        let firstName = authModel.user?.firstName ?? ""
        
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("\(firstName)'s Report")
                            .font(.system(size: 27, weight: .semibold, design: .rounded))
                            .kerning(1)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(np_white)
                        
                        Spacer()
                    }
                    
                    // MARK: Description
                    Text("\(reportDescription)")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .kerning(1)
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

// MARK: - Mood Summary
struct MoodSummaryView: View {
    @ObservedObject var moodModelController: MoodModelController
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Show Streak
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Label("Summary", systemImage: "")
                        .font(.system(size: 10))
                        .fontWeight(.semibold)
                        .kerning(2)
                        .textCase(.uppercase)
                        .foregroundColor(np_jap_indigo)
                        .padding(5)
                        .background(np_white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack(spacing: 30) {
                    // MARK: Top Recurring Emotion
                    VStack(spacing: 15) {
                        Text("Most")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
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
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
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
                                        .font(.system(size: 24, weight: .heavy, design: .rounded))
                                        .kerning(2)
                                    
                                    Text("out of 100")
                                        .font(.system(size: 6, weight: .bold, design: .rounded))
                                        .kerning(2)
                                        .textCase(.uppercase)
                                }
                            }
                    }
                    .frame(alignment: .center)
                    
                    Capsule()
                        .frame(width: 0.5, height: 100)
                        .foregroundColor(np_gray)
                    
                    // MARK: Total days logged
                    VStack(spacing: 15) {
                        Text("Days")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .kerning(3)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                        
                        Text("📆")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        Text("\(moodModelController.totalDaysLogged)")
                            .font(.system(size: 27, weight: .semibold, design: .rounded))
                            .foregroundColor(np_white)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal, 5)
        }
    }
}

struct MoodEntry: Identifiable {
    let id = UUID()
    let date: Date
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

// MARK: Donut Chart View
struct DonutChartView: View {
    let width = UIScreen.main.bounds.width
    
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
            .init(emotion: "Meh", count: Double(moodCount.frequency(for: .meh)), color: np_purple),
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
                    Label("Donut Chart", systemImage: "")
                        .font(.system(size: 10))
                        .fontWeight(.semibold)
                        .kerning(2)
                        .textCase(.uppercase)
                        .foregroundColor(np_jap_indigo)
                        .padding(5)
                        .background(np_white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
                    .frame(height: 50)
                
                DonutChart(data: moodDataInPercentages)
                
                Spacer()
                    .frame(height: 50)
                
                // MARK: Chart Key
                HStack(spacing: 10) {
                    ForEach(moodDataInPercentages, id: \.id) { mood in
                        VStack(spacing: 5) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(mood.color)
                                .frame(height: 30)
                            
                            Text(mood.emotion)
                                .font(.system(size: 7))
                                .fontWeight(.medium)
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
                .frame(width: width - 10, alignment: .center)
            }
        }
    }
}

struct DonutChart: View {
    var data: [DonutChartView.MoodDataModel]
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
    private func startAngle(datum: DonutChartView.MoodDataModel) -> Double {
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

// MARK: Bar Chart View
struct BarChartView: View {
    struct MoodDataModel: Identifiable {
        var id = UUID()
        var emotion: String
        var count: Double
        var color: Color
    }
    
    var data: [MoodDataModel]
    
    let maxBarHeight: CGFloat = 200 // Maximum height for bars
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            HStack {
                Label("Bar Chart", systemImage: "")
                    .font(.system(size: 10))
                    .fontWeight(.semibold)
                    .kerning(2)
                    .textCase(.uppercase)
                    .foregroundColor(np_jap_indigo)
                    .padding(5)
                    .background(np_white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Spacer()
            }
            .padding(.horizontal)
            
            Spacer()
                .frame(height: 50)
            
            HStack(alignment: .bottom, spacing: 10) {
                ForEach(data, id: \.id) { mood in
                    VStack(spacing: 5) {
                        Text("\(Int(mood.count))")
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        Rectangle()
                            .fill(mood.color)
                            .frame(width: 50, height: normalizedHeight(for: mood.count))
                            .cornerRadius(5, corners: [.topLeft, .topRight])
                        
                        Text(mood.emotion)
                            .font(.system(size: 7))
                            .fontWeight(.medium)
                            .kerning(1)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                            .lineLimit(1)
                    }
                }
            }
            .frame(width: width - 20, alignment: .center)
        }
        .padding(.horizontal, 15)
    }
    
    private func normalizedHeight(for count: Double) -> CGFloat {
        CGFloat(count) / 100.0 * maxBarHeight
    }
}

struct YAxisView: View {
    var maxHeight: CGFloat
    var step: CGFloat = 5 // Adjust step for more/less grid lines
    
    var body: some View {
        VStack {
            // Convert the stride to an Array
            ForEach(Array(stride(from: 20, through: 0, by: -step)), id: \.self) { value in
                HStack {
                    Text("\(Int(value))")
                        .font(.caption)
                        .frame(width: 30)
                    
                    Divider()
                        .foregroundColor(np_white)
                }
                .frame(height: maxHeight / (100 / step))
            }
        }
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
