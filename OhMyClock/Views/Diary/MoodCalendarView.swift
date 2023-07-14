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
            WeekdaysView()
                .background(np_arsenic)
            
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
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("\(month.monthNameYear)")
                        .font(.title2)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                GridStack(rows: month.monthRows, columns: month.monthDays.count) { row, col in
                    if month.monthDays[col+1]![row].dayDate == Date(timeIntervalSince1970: 0) {
                        Text("").frame(width: 30, height: 30)
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

// MARK: - Weekday View
struct WeekdaysView: View {
    let weekdays = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    let colors = DiaryColors()
    
    var body: some View {
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
        .padding(.top, 30)
        .padding(.bottom, 20)
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
                            .padding(2)
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
                    .frame(width: 30, height: 30)
                    .opacity(1)
            }
        }
        return Image(imageName)
            .resizable()
            .frame(width: 30, height: 30)
            .opacity(0)
    }
}
