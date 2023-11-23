//
//  DiaryMood.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-11.
//

import Foundation
import SwiftUI

enum EmotionState: String, Codable, CaseIterable, CustomStringConvertible {
    case angry, cheeky, happy, loved, meh, sad, sick, sleepy, smiling, upset
    
    var description: String {
        switch self {
        case .angry:
            return "angry"
        case .cheeky:
            return "cheeky"
        case .happy:
            return "happy"
        case .loved:
            return "loved"
        case .meh:
            return "meh"
        case .sad:
            return "sad"
        case .sick:
            return "sick"
        case .sleepy:
            return "sleepy"
        case .smiling:
            return "smiling"
        case .upset:
            return "upset"
        }
    }
}

enum DayMoodState: String, Codable, CaseIterable {
    case amazing, good, okay, meh, bad, terrible
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
    var dayStates: [DayMoodState] // This will store the day states
    
    init(emotion: Emotion, comment: String?, date: Date, dayStates: [DayMoodState]) {
        self.emotion = emotion
        self.comment = comment
        self.date = date
        self.dayStates = dayStates
    }
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError(domain: "MoodSerializationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize Mood"])
        }
        return dictionary
    }
    
    var dateString: String {
        Mood.dateFormatter.string(from: date)
    }
    
    var monthString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLL"
        return dateFormatter.string(from: date)
    }
    
    var dayAsInt: Int {
        Calendar.current.component(.day, from: date)
    }
    
    var year: String {
        Calendar.current.component(.year, from: date).description
    }
    
    static func == (lhs: Mood, rhs: Mood) -> Bool {
        lhs.id == rhs.id
    }
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()


// MARK: Mood Prediction Score
enum MoodScoreCategory {
    case amazing, good, okay, meh, bad, terrible
    
    init(score: Double){
        switch score {
        case 85...100: self = .amazing
        case 65..<85: self = .good
        case 55..<65: self = .okay
        case 45..<55: self = .meh
        case 30..<45: self = .bad
        case 0..<30: self = .terrible
        default: self = .okay
        }
    }
    
    var scoreColor: Color {
        switch self {
        case .amazing
            : return np_green
        case .good:
            return np_turq
        case .okay:
            return np_yellow
        case .meh:
            return np_purple
        case .bad:
            return np_yellow
        case .terrible:
            return np_red
        }
    }
}
