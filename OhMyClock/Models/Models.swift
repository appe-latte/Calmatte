//
//  Models.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-05.
//

import SwiftUI
import CoreData
import Foundation

struct WeatherModel : Codable {
    let current : CurrentWeather
    let timezone : String
}

struct CurrentWeather : Codable {
    let temp : Float
    let feels_like : Float
    let humidity : Int
    let weather : [WeatherInfo]
}

struct WeatherInfo : Codable {
    let main : String
    let description : String
}

struct LocationResults : Codable {
    var latitude : String
    var longitude : String
    var city : String
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case city
    }
}

struct TaskItem : Codable, Identifiable {
    var id: UUID = .init()
    var dateAdded: Date
    var taskName: String
    var taskCategory: Category
    var isCompleted: Bool
}

struct Routine: Identifiable, Codable {
    var id: UUID = .init()
    var name: String
    var daysOfWeek: [Int]
    var startTime: Date
    var reminderEnabled: Bool
    var reminderType: ReminderType

    func asDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "name": name,
            "daysOfWeek": daysOfWeek,
            "startTime": startTime,
            "reminderEnabled": reminderEnabled,
            "reminderType": reminderType.rawValue // Assuming ReminderType is an enum with RawRepresentable
        ]
    }
}

enum ReminderType: String, Codable, CaseIterable {
    case time = "Time"
    case manual = "Manual"
}

enum Theme {
    static let background = np_red
    static let detailBackground = np_orange
    static let text = np_green
    static let pill = np_blue
}

struct SoundCard: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
    let audioFileName: String
}

struct WellnessCard: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingScreen {
    let id: UUID = UUID()
    let title: String
    let image: String
    let description: String
}

struct ThoughtRecord: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var negativeThought: String
    var emotion: String
    var evidenceFor: String
    var evidenceAgainst: String
    var alternativeThought: String
    
    func asDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "date": date,
            "negativeThought": negativeThought,
            "emotion": emotion,
            "evidenceFor": evidenceFor,
            "evidenceAgainst": evidenceAgainst,
            "alternativeThought": alternativeThought
        ]
    }
}

struct GratitudeEntry: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var gratitudeText: String
    
    // Convert GratitudeEntry to a dictionary
    func asDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "date": date,
            "gratitudeText": gratitudeText
        ]
    }
}

