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

class WeatherDataController {
    
    // https://api.openweathermap.org/data/2.5/onecall?lat=35.342&lon=-106.453&exclude=minutely&units=imperial&appid=08b4c56524f9f8eab8bab79d245c0c35
    
    private let baseURL = URL(string: "https://api.openweathermap.org")
    private let onecallEndpoint = "data/2.5/onecall"
    
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
        
        guard var url = baseURL else { return completion(.failure(.invalidURL(requestType))) }
        
        url.appendPathComponent(onecallEndpoint)
        
        let queryItems = [
            "lat": "\(lat)",
            "lon": "\(lon)",
            "units": "imperial",
            "appid": apiKey
        ]
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems.map { URLQueryItem(name: $0, value: $1) }
        
        guard let fullURL = components?.url else { return completion(.failure(.invalidURL(requestType)))}
        
        print("fetchWeatherData URL: \(fullURL)")
        
        URLSession.shared.dataTask(with: fullURL) { data, response, error in
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
                completion(.failure(.unableToDecodeWeatherData(error)))
            }
        }.resume()
    }
}
