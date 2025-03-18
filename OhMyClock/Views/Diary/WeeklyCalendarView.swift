//
//  WeeklyMoodView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-11-20.
//

import SwiftUI

struct WeeklyCalendarView: View {
    @ObservedObject var moodModelController: MoodModelController
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Journal Diary Log")
                    .font(.system(size: 8, weight: .semibold))
                    .kerning(3)
                    .textCase(.uppercase)
                    .foregroundColor(np_white)
                    .padding(.leading, 10)
                
                RoundedRectangle(cornerRadius: 10)
                    .background(np_arsenic)
                    .opacity(0.15)
                    .frame(width: width - 20, height: 100)
                    .overlay {
                        VStack(spacing: 10) {
                            WeekDayLabelsView()
                            
                            WeekMoodsView(moodModelController: moodModelController, weekDates: currentWeekDates)
                        }
                        .padding(10)
                    }
            }
        }
        .padding(10)
        .edgesIgnoringSafeArea(.all)
    }
    
    // Logic to calculate the dates for the current week
    private var currentWeekDates: [Date] {
        let calendar = Calendar.current
        let today = Date()
        let weekDay = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - weekDay, to: today) }
        
        return days
    }
}

#Preview {
    WeeklyCalendarView(moodModelController: MoodModelController())
}

// MARK: Labels for the week
struct WeekDayLabelsView: View {
    private let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(weekdays, id: \.self) { weekday in
                Text(weekday)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(np_white)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

// MARK: Displays moods for the week
struct WeekMoodsView: View {
    @ObservedObject var moodModelController: MoodModelController
    var weekDates: [Date]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(weekDates, id: \.self) { date in
                DayMoodView(moodModelController: moodModelController, date: date)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: Displays daily mood
struct DayMoodView: View {
    @ObservedObject var moodModelController: MoodModelController
    var date: Date
    
    var body: some View {
        VStack {
            if let mood = moodForDate(date) {
                moodImageView(mood: mood)
                    .frame(width: 30, height: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(np_white, lineWidth: 1))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(np_gray)
                    .opacity(0.15)
                    .frame(width: 30, height: 30)
            }
        }
    }
    
    private func moodForDate(_ date: Date) -> Mood? {
        moodModelController.moods.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    private func moodImageView(mood: Mood) -> some View {
        Image(mood.emotion.state.description)
            .resizable()
            .scaledToFill()
    }
}
