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
        print(#function)
        setUpViews()
        
        dateLabel.text = string(fromDt: current.dt, timezone: timezone)
        
        dataLabels[.feelsLike]?.text = "\(string(fromFloat: current.feelsLike))°"
        dataLabels[.pressure]?.text = string(fromFloat: current.pressure, withDecimals: true)
        dataLabels[.humidity]?.text = "\(current.humidity)%"
        dataLabels[.dewPoint]?.text = "\(string(fromFloat: current.dewPoint))°"
        dataLabels[.wind]?.text = "\(string(fromFloat: current.windSpeed)) mph"
        dataLabels[.clouds]?.text = "\(current.clouds)%"
        dataLabels[.uvi]?.text = string(fromFloat: current.uvi, withDecimals: true)
    }
    
    override func setUpDataKeys() {
        print(#function)
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
}
