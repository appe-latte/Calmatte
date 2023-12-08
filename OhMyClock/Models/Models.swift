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
    var taskDescription: String
    var taskCategory: Category
    var isCompleted: Bool
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
