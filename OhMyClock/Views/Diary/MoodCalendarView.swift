//
//  MoodCalendarView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-13.
//

import SwiftUI

struct MoodCalendarView: View {
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
                .background(LinearGradient(colors: [np_arsenic, np_arsenic, np_arsenic, np_jap_indigo], startPoint: .top, endPoint: .bottom))
                .padding(.top, 20)
            
            ScrollView(.vertical, showsIndicators: false) {
                MonthView(moodModelController: moodModelController, month: Month(startDate: startDate, selectableDays: selectableDays))
                    .font(.headline)
                    .fontWeight(.bold)
                    .kerning(3)
                    .textCase(.uppercase)
                    .foregroundColor(np_white)
                
                if monthsToDisplay > 1 {
                    ForEach(1..<monthsToDisplay) {
                        MonthView(moodModelController: moodModelController,
                                  month: Month(startDate: nextMonth(currentMonth: startDate, add: $0),
                                               selectableDays: selectableDays))
                    }
                    .font(.headline)
                    .fontWeight(.bold)
                    .kerning(3)
                    .textCase(.uppercase)
                }
            }
            
            Spacer()
        }
        .background(np_jap_indigo)
        .edgesIgnoringSafeArea(.all)
    }
    
    func nextMonth(currentMonth: Date, add: Int) -> Date {
        var components = DateComponents()
        components.month = add
        return Calendar.current.date(byAdding: components, to: currentMonth)!
    }
}

struct MoodCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MoodCalendarView(start: Date(), monthsToShow: 2, moodController: MoodModelController())
    }
}

// MARK: - Month View
struct MonthView: View {
    @ObservedObject var moodModelController: MoodModelController
    var month: Month
    let weekdays = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    let colors = DiaryColors()
    
    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                
                // MARK: Month Title
                HStack {
                    Spacer()
                    
                    Text("\(month.monthNameYear)")
                        .font(.title)
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
                            .frame(width: 30, height: 30)
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
        .background(np_jap_indigo)
    }
}

// MARK: - Streak View
struct StreakView: View {
    @ObservedObject var moodModelController: MoodModelController
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                
                Text("Mood Log")
                    .font(.title)
                    .fontWeight(.bold)
                    .kerning(3)
                    .textCase(.uppercase)
                    .foregroundColor(np_white)
            }
            .padding(.horizontal)
            
            // MARK: Show Streak
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Journal entry Statistics:")
                        .font(.system(size: 15))
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
                            Text("Current Streak")
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
                            Text("Best Streak 👑")
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
                            Text("Total Days")
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
            .padding(15)
            //            .padding(.horizontal)
        }
        .padding(.top, 20)
    }
}

// MARK: - Grid Stack
struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ForEach(0..<rows) { row in
                HStack(alignment: .center, spacing: 0) {
                    ForEach(0..<columns) { col in
                        content(row, col)
                            .padding(1)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

// MARK: - Cells for the day
struct DayCellView: View {
    @ObservedObject var moodModelController: MoodModelController
    @ObservedObject var day: Day
    
    var body: some View {
        VStack {
            Text(day.dayName)
                .frame(width: 40, height: 40)
                .foregroundColor(day.textColor)
                .clipped()
            
            VStack {
                moodText()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            .background(np_arsenic)
            .clipShape(Circle())
        }
    }
    
    func moodText() -> some View {
        var imageName = "none"
        for mood in moodModelController.moods {
            if mood.monthString == day.monthString && mood.dayAsInt == day.dayAsInt && mood.year == day.year {
                switch mood.emotion.state {
                case .great:
                    imageName = "great"
                case .good:
                    imageName = "good"
                case .okay:
                    imageName = "okay"
                case .upset:
                    imageName = "upset"
                case .angry:
                    imageName = "angry"
                case .low:
                    imageName = "low"
                case .meh:
                    imageName = "meh"
                case .sad:
                    imageName = "sad"
                case .shock:
                    imageName = "shock"
                case .loved:
                    imageName = "loved"
                }
                return Image(imageName)
                    .resizable()
                    .frame(width: 35, height: 35)
                    .opacity(1)
            }
        }
        return Image(imageName)
            .resizable()
            .frame(width: 30, height: 30)
            .opacity(0)
    }
}
