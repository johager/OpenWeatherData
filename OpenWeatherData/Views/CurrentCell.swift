//
//  CurrentCell.swift
//  OpenWeatherData
//
//  Created by James Hager on 4/6/22.
//

import UIKit

class CurrentCell: WeatherDataCell {
    
    // MARK: - View Methods
    
    func configure(with current: Current, timezone: String) {
        setUpViews()
        
        dateLabel.text = string(fromDt: current.dt, timezone: timezone)
        
        if let weather = current.weather {
            mainLabel.text = weather.main
        }
        
        tempLabel.text = "\(string(fromFloat: current.temp))°F"
        
        dataLabels[.feelsLike]?.text = "\(string(fromFloat: current.feelsLike))°F"
        let presInHg = current.pressure / 1000 * 29.53
        dataLabels[.pressure]?.text = "\(string(fromFloat: presInHg, withDecimals: true))\u{00a0}inHg"
        dataLabels[.humidity]?.text = "\(current.humidity)%"
        dataLabels[.dewPoint]?.text = "\(string(fromFloat: current.dewPoint))°"
        dataLabels[.wind]?.text = windText(windSpeed: current.windSpeed, windDeg: current.windDeg, windGust: current.windGust)
        dataLabels[.wind]?.numberOfLines = 0
        dataLabels[.clouds]?.text = "\(string(fromFloat: current.clouds))%"
        dataLabels[.uvi]?.text = string(fromFloat: current.uvi, withDecimals: true)
        
        fetchIconImage(for: current.weather?.icon)
    }
    
    override func setUpDataKeys() {
        dataKeys = [
            .feelsLike,
            .pressure,
            .humidity,
            .dewPoint,
            .wind,
            .clouds,
            .uvi
        ]
    }
    
    // MARK: - Misc Methods
    
    func string(fromDt dt: Int, timezone: String) -> String {
        let date = Date(timeIntervalSince1970: Double(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, h:mm a z"
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        return dateFormatter.string(from: date)
    }
}
