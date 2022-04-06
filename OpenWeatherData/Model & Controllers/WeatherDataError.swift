//
//  WeatherDataError.swift
//  OpenWeatherData
//
//  Created by James Hager on 4/6/22.
//

import Foundation

enum WeatherDataError: LocalizedError {
    
    case invalidURL(RequestType)
    case urlSessionError(RequestType, Error)
    case httpResponseStatusCode(RequestType, Int)  // Int is for statusCode
    case noData(RequestType)
    case unableToDecodeWeatherData(Error)
    case unableToDecodeIcon
    
    var errorDescription: String? {
        switch self {
        case .invalidURL(let requestType):
            return "The \(requestType) request had an invalid URL."
        case .urlSessionError(let requestType, let error):
            return "There was an error downloading \(requestType) data: \(error.localizedDescription)"
        case .httpResponseStatusCode(let requestType, let statusCode):
            return "The server responded to the \(requestType) request with status \(statusCode)."
        case .noData(let requestType):
            return "There was no data returned for the \(requestType) request."
        case .unableToDecodeWeatherData(let error):
            return "Unable to decode weatherData data: \(error.localizedDescription)"
        case .unableToDecodeIcon:
            return "Unable to decode the icon data."
        }
    }
}
