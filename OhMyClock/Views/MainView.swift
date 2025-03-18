//
//  MainView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import SwiftUI
import Combine
import Alamofire
import SwiftyJSON
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

struct MainView: View {
    @ObservedObject var moodModel: MoodModel
    @ObservedObject var moodModelController = MoodModelController()
    @ObservedObject var authModel = AuthViewModel()
    @StateObject var progressViewModel = AppViewModel()
    @ObservedObject var moodCount: DayStateViewModel = DayStateViewModel()
    @Binding var tabBarSelection: Int
    
    // MARK: Task Manager
    @ObservedObject var taskManager = TaskManager()
    @State private var currentDay: Date = .init()
    @State private var addNewTask: Bool = false
    @State private var selectedTaskIndex: Int?
    @State private var showCompletionAnimation = false
    @State private var showAlert = false
    @State private var tasksComplete = false
    
    // MARK: Routine Items
    @StateObject var routineManager = RoutineManager()
    @State var showRoutineEntry = false
    
    @EnvironmentObject var appLockViewModel: AppLockViewModel
    
    @State private var insightsMode: InsightsType = .today
    @State private var showSettingsSheet = false
    @State private var showAnxietyTestSheet = false
    @State private var refreshTrigger = false
    @State var showJournalEntry = false
    
    @State var userFname = ""
    //    @State var txt = ""
    //    @State var docID = ""
    //    @State var remove = false
    
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    
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
    
    var body: some View {
        let firstName = authModel.user?.firstName ?? ""
        
        NavigationStack {
            ZStack {
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: 15) {
                        // MARK: User Greeting
                        VStack {
                            HStack {
                                Text(greeting)
                                    .font(.system(size: 10, weight: .bold))
                                    .minimumScaleFactor(0.5)
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text("\(firstName).")
                                    .font(.custom("Butler", size: 30))
                                    .minimumScaleFactor(0.5)
                                
                                Spacer()
                            }
                        }
                        .frame(width: width - 20, alignment: .leading)
                        .scaledToFill()
                        .textCase(.uppercase)
                        .kerning(5)
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(np_white)
                        .padding(.top, 20)
                        
                        // MARK: Summary Section
                        Text("Wellness Summary")
                            .kerning(5)
                            .textCase(.uppercase)
                            .font(.system(size: 8))
                            .fontWeight(.bold)
                            .frame(width: width, height: 20)
                            .background(np_white)
                            .foregroundColor(np_jap_indigo)
                        
                        // MARK: "7-Day Journal" View
                        VStack(alignment: .center) {
                            WeeklyCalendarView(moodModelController: MoodModelController())
                        }
                        .padding(.horizontal, 10)
                        
                        // MARK: Mood Summary
                        MoodSummaryView(moodModelController: moodModelController, showAnxietyTestSheet: $showAnxietyTestSheet, showJournalEntry: $showJournalEntry)
                        
                        Divider()
                            .background(np_gray)
                        
                        // MARK: "Routines" View
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Daily")
                                    .font(.custom("Butler", size: 20))
                                    .minimumScaleFactor(0.5)
                                    .kerning(2)
                                    .foregroundColor(np_white)
                                
                                Text("Routine")
                                    .font(.custom("Butler", size: 27))
                                    .textCase(.uppercase)
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(np_white)
                            }
                            
                            Spacer()
                            
                            // MARK: "Add Routine Entry" Button
                            Button {
                                showRoutineEntry.toggle()
                            } label: {
                                VStack(alignment: .center) {
                                    Text("+")
                                        .font(.system(size: 17, weight: .heavy))
                                }
                            }
                            .frame(width: 45, height: 45)
                            .background(np_white)
                            .foregroundColor(np_jap_indigo)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .frame(width: width - 20)
                        
                        // MARK: Displays the Routine Cards
                        if routineManager.routines.isEmpty {
                            Text("No routines to display")
                                .font(.system(size: 10))
                                .foregroundStyle(np_white)
                                .fontWeight(.medium)
                                .textCase(.uppercase)
                                .kerning(2)
                                .padding()
                        } else {
                            ForEach(routineManager.routines) { routine in
                                RoutineCardView(routineManager: routineManager, routine: routine)
                                    .padding()
                            }
                        }
                    }
                }
                .background(background())
                .frame(maxWidth: .infinity)
                .sheet(isPresented: self.$showJournalEntry) {
                    LogMoodView(moodModelController: self.moodModelController)
                }
                .sheet(isPresented: self.$showRoutineEntry) {
                    AddRoutineView(routineManager: routineManager)
                }
                .sheet(isPresented: self.$showAnxietyTestSheet) {
                    MoodAnxietyTestView()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
        .onAppear {
            //                locationManager.requestWhenInUseAuthorization()
            //                locationManager.startUpdatingLocation()
            if UserDefaults.standard.bool(forKey: "RemindersEnabled") {
                let reminderTimeDouble = UserDefaults.standard.double(forKey: "reminderTime")
                let reminderTime = Date(timeIntervalSince1970: reminderTimeDouble)
                ReminderManager.scheduleReminders(for: reminderTime)
            } else {
                ReminderManager.cancelScheduledReminders()
            }
        }
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Rectangle()
                .fill(np_jap_indigo)
                .frame(height: size.height, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
    
    // MARK: Salutation function
    func getTime() -> String {
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        
        return format.string(from: Date())
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "good morning,"
        case 12..<17:
            return "good afternoon,"
        case 17..<22:
            return "good evening,"
        default:
            return "good night,"
        }
    }
}

// MARK: "Share sheet" function
func shareSheet() {
    guard let data = URL(string: "https://apps.apple.com/us/app/ohmyclock/id1667124410") else { return }
    let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
    UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
}


// MARK: - Mood Summary
struct MoodSummaryView: View {
    @ObservedObject var moodModelController: MoodModelController
    @Binding var showAnxietyTestSheet: Bool
    @Binding var showJournalEntry: Bool
    
    var width = UIScreen.main.bounds.width
    
    @State var txt = ""
    @State var docID = ""
    @State var remove = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // MARK: Mood Summary
            HStack(spacing: 20) {
                // MARK: Top Recurring Emotion
                VStack(spacing: 15) {
                    Text("Top Emotion")
                        .font(.system(size: 8, weight: .semibold))
                        .kerning(3)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    if let topMoodState = moodModelController.calculateTopMood(moods: moodModelController.moods) {
                        Image(String(describing: topMoodState))
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 25))
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
                        .font(.system(size: 8, weight: .semibold))
                        .kerning(3)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(np_gray.opacity(0.1))
                        .frame(width: 85, height: 85)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(np_white, lineWidth: 1))
                        .overlay {
                            VStack {
                                Text("\(moodModelController.calculateMoodPredictionScore(), specifier: "%.0f")")
                                    .font(.system(size: 24, weight: .black))
                                    .kerning(2)
                                
                                Text("out of 100")
                                    .font(.system(size: 6, weight: .bold))
                                    .kerning(2)
                                    .textCase(.uppercase)
                            }
                            .foregroundStyle(np_white)
                        }
                }
                .frame(alignment: .center)
                
                Capsule()
                    .frame(width: 0.5, height: 100)
                    .foregroundColor(np_gray)
                
                // MARK: Total days logged
                VStack(spacing: 15) {
                    Text("Mood Chart")
                        .font(.system(size: 8, weight: .semibold))
                        .kerning(3)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    DonutChartView()
                        .frame(width: 85, height: 85)
                        .clipShape(Circle())
                }
                .frame(alignment: .center)
            }
            .frame(width: width - 20, alignment: .center)
            
            Spacer()
                .frame(height: 5)
            
            // MARK: Chart Key
            DonutChartKeyView()
            
            Spacer()
                .frame(height: 5)
            
            // MARK: Anxiety Test
            VStack(spacing: 5) {
                HStack(spacing: 5) {
                    // MARK: Journal Log
                    Button {
                        self.txt = ""
                        self.docID = ""
                        self.showJournalEntry.toggle()
                    } label: {
                        Text("+ Journal Entry")
                            .font(.system(size: 10, weight: .heavy))
                            .kerning(2)
                            .textCase(.uppercase)
                            .foregroundStyle(np_white)
                    }
                    .frame(width: 150, height: 45)
                    .background(np_arsenic)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(np_white, lineWidth: 1))
                    
                    // MARK: Assessment Button
                    Button {
                        self.showAnxietyTestSheet.toggle() // Toggles the binding from MainView
                    } label: {
                        Text("Wellness Assessment")
                            .font(.system(size: 10, weight: .heavy))
                            .kerning(2)
                            .textCase(.uppercase)
                            .foregroundStyle(np_jap_indigo)
                    }
                    .frame(width: 150, height: 45)
                    .background(np_white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(np_jap_indigo, lineWidth: 1))
                }
            }
            .frame(width: width - 20, alignment: .center)
        }
        .padding(.vertical, 15)
        .background(np_arsenic)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct MoodEntry: Identifiable {
    let id = UUID()
    let date: Date
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
            // MARK: Donut Chart Graphic
            DonutChart(data: moodDataInPercentages)
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
                    .stroke(datum.color, lineWidth: 25) // Adjust your line width for the donut thickness
                    .rotationEffect(.degrees(startAngle(datum: datum)))
                    .frame(width: 65, height: 65)
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

// MARK: Donut Chart Key
struct DonutChartKeyView: View {
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
        HStack(spacing: 5) {
            ForEach(moodDataInPercentages, id: \.id) { mood in
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 5) {
                        Capsule()
                            .fill(mood.color)
                            .frame(width: 20, height: 10)
                        
                        Text(percentage(for: DayMoodState(rawValue: mood.emotion.lowercased()) ?? .none))
                            .font(.system(size: 6))
                            .fontWeight(.bold)
                            .kerning(3)
                            .foregroundColor(np_white)
                    }
                    
                    Text(mood.emotion)
                        .font(.system(size: 6))
                        .fontWeight(.medium)
                        .kerning(1)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                }
            }
        }
        .frame(width: width - 10, alignment: .center)
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
            
            ForEach(data, id: \.id) { mood in
                VStack(spacing: 5) {
                    Rectangle()
                        .fill(mood.color)
                        .frame(width: 50, height: normalizedHeight(for: mood.count))
                    
                    HStack(spacing: 5) {
                        Text(mood.emotion)
                            .font(.system(size: 7))
                            .fontWeight(.medium)
                            .kerning(1)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                            .lineLimit(1)
                        
                        Text("\(Int(mood.count))")
                            .font(.caption)
                            .fontWeight(.bold)
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
