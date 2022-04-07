//
//  LocationError.swift
//  OpenWeatherData
//
//  Created by James Hager on 4/6/22.
//

import Foundation

enum LocationError: LocalizedError {
    case thrownError(Error)
    case noPlacemark
    
    var errorDescription: String? {
        switch self {
        case .thrownError(let error):
            return "Error determining location: \(error.localizedDescription)"
        case .noPlacemark:
            return "Error determining location."
        }
    }
}
