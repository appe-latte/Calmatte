//
//  WeeklyMoodView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-11-20.
//

import SwiftUI

struct WeeklyMoodView: View {
    @ObservedObject var moodModelController: MoodModelController
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                WeekDayLabelsView()
                    .foregroundColor(np_white)
                
                WeekMoodsView(moodModelController: moodModelController, weekDates: currentWeekDates)
                    .foregroundColor(np_white)
            }
        }
        .padding(10)
        .edgesIgnoringSafeArea(.all)
    }
    
    private var currentWeekDates: [Date] {
        // Logic to calculate the dates for the current week
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
    WeeklyMoodView(moodModelController: MoodModelController())
}

// MARK: Labels for the week
struct WeekDayLabelsView: View {
    private let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(weekdays, id: \.self) { weekday in
                Text(weekday)
                    .font(.custom("Butler", size: 18))
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
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(np_gray)
                    .opacity(0.15)
                    .frame(width: 40, height: 40)
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
