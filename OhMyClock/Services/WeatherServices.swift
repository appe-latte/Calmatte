//
//  WeatherServices.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-05-09.
//

import Foundation
import WeatherKit

enum NetworkError : Error {
    case badURL
}

class WeatherService {
    
    func getWeather() async throws -> Weather {
        guard let weatherURL = URL(string: "https://localhost:8080") else {
            throw NetworkError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: weatherURL)
        
        // MARK: Check for successful response
        let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
        return weatherResponse.currentWeather
    }
}
