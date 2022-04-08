//
//  WeatherDataController.swift
//  OpenWeatherData
//
//  Created by James Hager on 4/6/22.
//
//
//  The "private" API key handling was inspired by https://peterfriese.dev/posts/reading-api-keys-from-plist-files/
//
//  Remember to remove the OpenWeather-Info.plist file from the repo before the first commit.
//

import Foundation
import UIKit

class WeatherDataController {
    
    // https://api.openweathermap.org/data/2.5/onecall?lat=[latitude]&lon=[longitude]&exclude=minutely&units=imperial&appid=[ApiKey]
    // https://openweathermap.org/img/wn/10d@2x.png
    
    private let apiBaseURL = URL(string: "https://api.openweathermap.org")
    private let onecallEndpoint = "data/2.5/onecall"
    
    private let iconBaseURL = URL(string: "https://openweathermap.org/img/wn")
    
    private lazy var apiKey: String = {
        let fileName = "OpenWeather-Info"
        
        guard let filePath = Bundle.main.url(forResource: fileName, withExtension: "plist")
        else { fatalError("Could not find the file '\(fileName)'") }
        
        do {
            let plistData = try Data(contentsOf: filePath)
            
            guard let dict = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any]
            else { fatalError("Could not decode the '\(fileName).plist' file.") }
            
            guard let apiKey = dict["API Key"] as? String
            else { fatalError("The '\(fileName).plist' file does not contain an API Key.") }
            
            if apiKey.hasPrefix("_") {
                fatalError("Install a proper API Key in the '\(fileName).plist' file.")
            }
            
            print("apiKey: '\(apiKey)'")
            return apiKey
        } catch {
            fatalError("Error reding the plist file: \(error), \(error.localizedDescription)")
        }
    }()
    
    // MARK: - Methods
    
    func fetchWeatherData(lat: Double, lon: Double, completion: @escaping (Result<WeatherData, WeatherDataError>) -> Void) {
        let requestType: RequestType = .weatherData
        
        guard var url = apiBaseURL else { return completion(.failure(.invalidURL(requestType))) }
        
        url.appendPathComponent(onecallEndpoint)
        
        let queryItems = [
            "lat": "\(lat)",
            "lon": "\(lon)",
            "exclude": "minutely,hourly",
            "units": "imperial",
            "appid": apiKey
        ]
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems.map { URLQueryItem(name: $0, value: $1) }
        
        guard let fullURL = components?.url else { return completion(.failure(.invalidURL(requestType)))}
        
        print("fetchWeatherData URL: \(fullURL)")
        
        let urlSessionConfig = URLSessionConfiguration.default
        urlSessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData  // force a new request each time
        urlSessionConfig.timeoutIntervalForRequest = 30  // 30 seconds instead of the default 60 seconds
        
        URLSession(configuration: urlSessionConfig).dataTask(with: fullURL) { data, response, error in
            if let error = error {
                return completion(.failure(.urlSessionError(.weatherData, error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    return completion(.failure(.httpResponseStatusCode(requestType, response.statusCode)))
                }
            }
            
            guard let data = data else { return completion(.failure(.noData(requestType))) }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(.success(weatherData))
            } catch {
                print("\(requestType) data decode error: \(error), \(error.localizedDescription)")
                completion(.failure(.unableToDecodeWeatherData(error)))
            }
        }.resume()
    }
    
    func fetchIcon(iconID: String, completion: @escaping (Result<UIImage, WeatherDataError>) -> Void) {
        let requestType: RequestType = .icon
        
        guard var url = iconBaseURL else { return completion(.failure(.invalidURL(requestType))) }
        
        let iconFileName = "\(iconID)@2x.png"
        url.appendPathComponent(iconFileName)
        
        print("fetchIcon URL: \(url)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.failure(.urlSessionError(.weatherData, error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    return completion(.failure(.httpResponseStatusCode(requestType, response.statusCode)))
                }
            }
            
            guard let data = data else { return completion(.failure(.noData(requestType))) }
            
            guard let iconImage = UIImage(data: data) else { return completion(.failure(.unableToDecodeIcon)) }
            
            completion(.success(iconImage))
        }.resume()
    }
}
