//
//  DayCell.swift
//  OpenWeatherData
//
//  Created by James Hager on 4/7/22.
//

import UIKit

class DayCell: WeatherDataCell {
    
    // MARK: - View Methods
    
    func configure(with day: Day, timezone: String) {
        setUpViews()
        
        dateLabel.text = dayString(fromDt: day.dt, timezone: timezone)
        
        if let weather = day.weather {
            mainLabel.text = weather.main
        }
        
        let maxTemp = string(fromFloat: day.temp.max)
        let minTemp = string(fromFloat: day.temp.min)
        tempLabel.text = "\(maxTemp)/\(minTemp)°F"
        
        let dayTemp = string(fromFloat: day.feelsLike.day)
        let nightTemp = string(fromFloat: day.feelsLike.night)
        dataLabels[.feelsLike]?.text = "\(dayTemp)/\(nightTemp)°F"
        let presInHg = day.pressure / 1000 * 29.53
        dataLabels[.pressure]?.text = "\(string(fromFloat: presInHg, withDecimals: true))\u{00a0}inHg"
        dataLabels[.humidity]?.text = "\(day.humidity)%"
        dataLabels[.dewPoint]?.text = "\(string(fromFloat: day.dewPoint))°"
        dataLabels[.wind]?.text = windText(windSpeed: day.windSpeed, windDeg: day.windDeg, windGust: day.windGust)
        dataLabels[.wind]?.numberOfLines = 0
        dataLabels[.clouds]?.text = "\(string(fromFloat: day.clouds))%"
        dataLabels[.uvi]?.text = string(fromFloat: day.uvi, withDecimals: true)
        dataLabels[.sunrise]?.text = sunRiseSetString(fromDt: day.sunriseDt, timezone: timezone)
        dataLabels[.sunset]?.text = sunRiseSetString(fromDt: day.sunsetDt, timezone: timezone)
        
        fetchIconImage(for: day.weather?.icon)
    }
    
    override func setUpDataKeys() {
        dataKeys = [
            .feelsLike,
            .pressure,
            .humidity,
            .dewPoint,
            .wind,
            .clouds,
            .uvi,
            .sunrise,
            .sunset
        ]
    }
    
    // MARK: - Misc Methods
    
    func dayString(fromDt dt: Int, timezone: String) -> String {
        let date = Date(timeIntervalSince1970: Double(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        return dateFormatter.string(from: date)
    }
    
    func sunRiseSetString(fromDt dt: Int, timezone: String) -> String {
        let date = Date(timeIntervalSince1970: Double(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a z"
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        return dateFormatter.string(from: date)
    }
}
