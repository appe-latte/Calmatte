//
//  Weather.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-05-09.
//

import Foundation

struct WeatherResponse : Decodable {
    let currentWeather : Weather
}

struct Weather : Decodable {
    let temperature : Double
    let humidity : Double
    let conditionCode : String
}
