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
}

enum MoodColor: String, Codable {
    case angryColor = "angryColor"
    case upsetColor = "upsetColor"
    case okayColor = "okayColor"
    case goodColor = "goodColor"
    case greatColor = "greatColor"
}

struct Emotion: Codable {
    var state: EmotionState
    var color: MoodColor
    
    var moodColor: Color {
        switch color {
        case .angryColor:
            return .red
        case .upsetColor:
            return .orange
        case .okayColor:
            return .gray
        case .goodColor:
            return .purple
        case .greatColor:
            return .green
        }
    }
}

struct Mood: Codable, Equatable, Identifiable {
    var id = UUID()
    let emotion: Emotion
    var comment: String?
    let date: Date
    
    init(emotion: Emotion, comment: String?, date: Date) {
        self.emotion = emotion
        self.comment = comment
        self.date = date
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

