//
//  RequestType.swift
//  OpenWeatherData
//
//  Created by James Hager on 4/6/22.
//

import Foundation

enum RequestType: String, CustomStringConvertible {
    case weatherData
    case icon
    
    var description: String { rawValue }
}
