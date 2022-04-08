//
//  DataKey.swift
//  OpenWeatherData
//
//  Created by James Hager on 4/6/22.
//

import Foundation

enum DataKey: String, CustomStringConvertible {
    case temp = "Temperature:"
    case feelsLike = "Feels Like:"
    case pressure = "Pressure:"
    case humidity = "Humidity:"
    case dewPoint = "Dewpoint:"
    case wind = "Wind:"
    case clouds = "Clouds:"
    case uvi = "UV Index:"
    case pop = "Prob of Precip:"
    case sunrise = "Sunrise:"
    case sunset = "Sunset:"
    
    var description: String { rawValue }
}
