//
//  Models.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-05.
//

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
