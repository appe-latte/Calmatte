//
//  MoodCalendarView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-13.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

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
            MonthView(moodModelController: moodModelController, month: Month(startDate: startDate, selectableDays: selectableDays))
                .foregroundColor(np_white)
                .padding(20)
            
            if monthsToDisplay > 1 {
                ForEach(1..<monthsToDisplay) {
                    MonthView(moodModelController: moodModelController,
                              month: Month(startDate: nextMonth(currentMonth: startDate, add: $0),
                                           selectableDays: selectableDays))
                }
            }
            
            Spacer()
        }
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
    let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
    let colors = DiaryColors()
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                // MARK: Month Title
                HStack {
                    Text("\(month.monthNameYear)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
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
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
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
                .font(.system(size: 16, weight: .medium, design: .rounded))
            }
            .padding(.bottom, 10)
        }
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
                .frame(width: 30, height: 30)
                .foregroundColor(day.textColor)
                .clipped()
            
            VStack {
                if let mood = moodModelController.moods.first(where: {$0.monthString == day.monthString && $0.dayAsInt == day.dayAsInt && $0.year == day.year}) {
                    moodText()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(np_gray)
                        .opacity(0.15)
                        .frame(width: 40, height: 40)
                }
            }
            .background(np_arsenic)
        }
    }
    
    func moodText() -> some View {
        var imageName = "none"
        for mood in moodModelController.moods {
            if mood.monthString == day.monthString && mood.dayAsInt == day.dayAsInt && mood.year == day.year {
                switch mood.emotion.state {
                case .happy:
                    imageName = "happy"
                case .sad:
                    imageName = "sad"
                case .cheeky:
                    imageName = "cheeky"
                case .upset:
                    imageName = "upset"
                case .angry:
                    imageName = "angry"
                case .sleepy:
                    imageName = "sleepy"
                case .loved:
                    imageName = "loved"
                case .meh:
                    imageName = "meh"
                case .sick:
                    imageName = "sick"
                case .smiling:
                    imageName = "smiling"
                }
                return Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 35, height: 35)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .opacity(1)
            }
        }
        return Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 20, height: 20)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .opacity(0.1)
    }
}
