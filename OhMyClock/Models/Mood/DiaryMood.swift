//
//  DiaryMood.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-11.
//

import Foundation
import SwiftUI

enum EmotionState: String, Codable, CaseIterable {
    case angry, cheeky, happy, loved, meh, sad, sick, sleepy, smiling, upset
}

enum DayState: String, Codable {
    case amazing, good, okay, bad, terrible
}

enum MoodColor: String, Codable, CaseIterable {
    case angryColor = "angryColor", cheekyColor = "cheekyColor", happyColor = "happyColor", lovedColor = "lovedColor", mehColor = "mehColor", sadColor = "sadColor", sickColor = "sickColor", sleepyColor = "sleepyColor", smilingColor = "smilingColor", upsetColor = "upsetColor"
}

struct Emotion: Codable {
    var state: EmotionState
    var color: MoodColor
    
    var moodColor: Color {
        switch color {
        case .angryColor:
            return np_red
        case .cheekyColor:
            return np_blue
        case .happyColor:
            return np_orange
        case .lovedColor:
            return np_pink
        case .mehColor:
            return np_turq
        case .sadColor:
            return np_purple
        case .sickColor:
            return np_green
        case .sleepyColor:
            return np_tan
        case .smilingColor:
            return np_yellow
        case .upsetColor:
            return np_tuscan
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

