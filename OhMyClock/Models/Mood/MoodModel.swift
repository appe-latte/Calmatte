//
//  MoodModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-29.
//

import SwiftUI
import Foundation

// MARK: Mood Types
enum MoodType: String, CaseIterable {
    case amazing, good, okay, bad, terrible, meh
}

enum InsightsType: String, CaseIterable {
    case today = "Today"
    case thisWeek = "This Week"
    
    var maximumMoodCheckins: Int {
        switch self {
        case .today:
            return 7
        case .thisWeek:
            return 21
        }
    }
}

class MoodModel: ObservableObject {
    @Published var moodType: MoodType = .good
    @Published var insightsType: InsightsType = .today
    
    // MARK: "Saved Data" key
    private var savedDataKey: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, dd"
        return dateFormatter.string(from: Date())
    }
    
    private var thisWeekDaysSavedDataKey: [String] {
        var keys = [String]()
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 2
        let today = calendar.startOfDay(for: Date())
        var week = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, dd"
        week.forEach({ keys.append(dateFormatter.string(from: $0)) })
        return keys
    }
    
    // MARK: Save Key / Date 
    private var savedMoodData: [String: Int]? {
        // MARK: Today's mood data
        if insightsType == .today {
            if let data = UserDefaults.standard.dictionary(forKey: savedDataKey) as? [String: Int] {
                return data
            }
            
            // MARK: This Week's mood data
        } else if insightsType == .thisWeek {
            var data = [String: Int]()
            thisWeekDaysSavedDataKey.forEach { (savedWeekDayDataKey) in
                if let savedData = UserDefaults.standard.dictionary(forKey: savedWeekDayDataKey) as? [String: Int] {
                    savedData.forEach { (moodType, checkinsCount) in
                        if let existingCheckins = data[moodType] {
                            data[moodType] = existingCheckins + checkinsCount
                        } else {
                            data[moodType] = checkinsCount
                        }
                    }
                }
            }
            return data
        }
        return nil
    }
    
    func didChangeInsights(type: InsightsType) {
        insightsType = type
    }
}

