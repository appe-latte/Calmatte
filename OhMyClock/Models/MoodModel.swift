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
    case awful
    case bad
    case okay
    case good
    case great
}

/// Type of insights for saved mood data
enum InsightsType: String, CaseIterable {
    case today = "Today"
    case thisWeek = "This Week"
    
    /// This will determine how many times a day the user can set the same mood
    var maximumMoodCheckins: Int {
        switch self {
        case .today:
            return 3
        case .thisWeek:
            return 21
        }
    }
}

// MARK: Push Notification messages
enum DailyPushNotification: String, CaseIterable {
    case morning = "Hey, how are you feeling this morning?"
    case noon = "Is your day going great so far?"
    case evening = "Let's do one more check-in for today"
    
    var time: DateComponents {
        var components = DateComponents()
        switch self {
        case .morning:
            components.hour = 9
        case .noon:
            components.hour = 13
        case .evening:
            components.hour = 15
        }
        return components
    }
}

/// Main model to track mood
class MoodModel: ObservableObject {
    
    /// Start with `okay` mood
    @Published var moodType: MoodType = .okay
    
    /// Insights type change when user selects between `Today` and `This Week`
    @Published var insightsType: InsightsType = .today
    
    /// Saved data key
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
    
    /// Saved data based on the key/date
    private var savedMoodData: [String: Int]? {
        /// Today's saved mood data
        if insightsType == .today {
            if let data = UserDefaults.standard.dictionary(forKey: savedDataKey) as? [String: Int] {
                return data
            }
        /// This week's saved mood data
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
    
    /// Mood gradient and emoji
    func moodDetails(type: MoodType? = nil) -> (colors: [Color], emoji: String) {
        switch type ?? moodType {
        case .awful:
            return ([Color(#colorLiteral(red: 0.8357443213, green: 0.3479825258, blue: 0.05522660166, alpha: 1)), Color(#colorLiteral(red: 0.9966509938, green: 0.5569254756, blue: 0.353095293, alpha: 1))], "😡")
        case .bad:
            return ([Color(#colorLiteral(red: 0.8351245522, green: 0.4202041626, blue: 0.04885386676, alpha: 1)), Color(#colorLiteral(red: 0.9953574538, green: 0.6651614308, blue: 0.3195463419, alpha: 1))], "😠")
        case .okay:
            return ([Color(#colorLiteral(red: 0.8664215207, green: 0.471901536, blue: 0.03596238419, alpha: 1)), Color(#colorLiteral(red: 0.9981095195, green: 0.7487973571, blue: 0.3268273473, alpha: 1))], "😐")
        case .good:
            return ([Color(#colorLiteral(red: 0.8534171581, green: 0.5596296191, blue: 0.09391685575, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.8204076886, blue: 0.3298537731, alpha: 1))], "🙂")
        case .great:
            return ([Color(#colorLiteral(red: 0.4156033397, green: 0.6713014841, blue: 0.3754302263, alpha: 1)), Color(#colorLiteral(red: 0.6896948814, green: 0.7423496842, blue: 0.3255423903, alpha: 1))], "😃")
        }
    }
    
    /// Get mood insights for mood type based on the saved data/key
    func moodCount(type: MoodType) -> Int {
        if let count = savedMoodData?[type.rawValue] {
            return count > insightsType.maximumMoodCheckins ? insightsType.maximumMoodCheckins : count
        }
        return 0
    }
    
    // MARK: - User's intent/actions
    func saveMood() {
        /// Get existing saved mood details for today's date
        var data = savedMoodData ?? [String: Int]()
        
        /// Append the new mood to the saved data
        if let moodCount = data[moodType.rawValue] {
            data[moodType.rawValue] = moodCount + 1
        } else {
            data[moodType.rawValue] = 1
        }
        
        /// Save updated mood count
        UserDefaults.standard.set(data, forKey: savedDataKey)
        UserDefaults.standard.synchronize()
    }
    
    func didChangeInsights(type: InsightsType) {
        insightsType = type
    }
}

