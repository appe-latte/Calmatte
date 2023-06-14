//
//  Models.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-05.
//

import SwiftUI
import CoreData

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
}
