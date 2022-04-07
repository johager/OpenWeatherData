//
//  WeatherData.swift
//  OpenWeatherData
//
//  Created by James Hager on 4/6/22.
//

import Foundation

struct WeatherData: Decodable {
    let timezone: String
    let current: Current
    let daily: [Day]
}

struct Current: Decodable {
    let dt: Int
    let temp: Float
    let feelsLike: Float
    let pressure: Float
    let humidity: Int
    let dewPoint: Float
    let windSpeed: Float
    let windDeg: Int
    let windGust: Float?
    let clouds: Float
    let uvi: Float
    let weatherArray: [Weather]
    
    var date: Date { Date(timeIntervalSince1970: Double(dt))}
    var weather: Weather? { weatherArray.first }

    enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case clouds
        case uvi
        case weatherArray = "weather"
    }
}

struct Day: Decodable {
    let dt: Int
    let sunriseDt: Int
    let sunsetDt: Int
    let temp: Temp
    let feelsLike: Temp
    let humidity: Int
    let dewPoint: Float
    let windSpeed: Float
    let windDeg: Int
    let windGust: Float?
    let clouds: Int
    let uvi: Float
    let pop: Float
    let weatherArray: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dt
        case sunriseDt = "sunrise"
        case sunsetDt = "sunset"
        case temp
        case feelsLike = "feels_like"
        case humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case clouds
        case uvi
        case pop
        case weatherArray = "weather"
    }
}

struct Weather: Decodable {
    let main: String
    let icon: String
}

struct Temp: Decodable {
    let day: Float
    let night: Float
}
