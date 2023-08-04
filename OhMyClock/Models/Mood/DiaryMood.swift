//
//  DiaryMood.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-11.
//

import Foundation
import SwiftUI

enum EmotionState: String, Codable {
    case angry
    case upset
    case okay
    case good
    case great
    case sad
    case low
    case shock
    case sick
    case meh
}

enum DayState: String, Codable {
    case fun
    case productive
    case busy
    case bored
    case tiring
    case angry
    case meh
    case okay
    case exciting
    case sad
}

enum MoodColor: String, Codable {
    case angryColor = "angryColor"
    case upsetColor = "upsetColor"
    case okayColor = "okayColor"
    case goodColor = "goodColor"
    case greatColor = "greatColor"
    case sadColor = "sadColor"
    case lowColor = "lowColor"
    case shockColor = "shockColor"
    case sickColor = "sickColor"
    case mehColor = "mehColor"
}

struct Emotion: Codable {
    var state: EmotionState
    var color: MoodColor
    
    var moodColor: Color {
        switch color {
        case .angryColor:
            return np_red
        case .upsetColor:
            return np_orange
        case .okayColor:
            return np_tan
        case .goodColor:
            return np_green
        case .greatColor:
            return cov_green
        case .sadColor:
            return np_tuscan
        case .lowColor:
            return np_purple
        case .shockColor:
            return np_dark_blue
        case .sickColor:
            return np_arsenic
        case .mehColor:
            return np_gray
        }
    }
}

struct Mood: Codable, Equatable, Identifiable {
    var id = UUID()
    let emotion: Emotion
    var comment: String?
    let date: Date
    var dayStates: [DayState] // This will store the day states
    
    init(emotion: Emotion, comment: String?, date: Date, dayStates: [DayState]) {
        self.emotion = emotion
        self.comment = comment
        self.date = date
        self.dayStates = dayStates
    }
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }

    var dateString: String {
        dateFormatter.string(from: date)
    }
    
    var monthString: String {
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "LLL"
        
        let month = dateFormatter1.string(from: date)
        
        return month
    }
    
    var dayAsInt: Int {
        let day = Calendar.current.component(.day, from: date)
        return day
    }
    
    var year: String {
        return Calendar.current.component(.year, from: date).description
    }
    
    static func == (lhs: Mood, rhs: Mood) -> Bool {
        if lhs.date == rhs.date {
            return true
        } else {
            return false
        }
    }
}


let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

