//
//  ForecastViewController.swift
//  OpenWeatherData
//
//  Created by James Hager on 4/6/22.
//

import UIKit

class ForecastViewController: UIViewController {

    let weatherDataController = WeatherDataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let lat = 35.342
        let lon = -106.453
        weatherDataController.fetchWeatherData(lat: lat, lon: lon) { result in
            switch result {
            case .success(let weatherData):
                print(weatherData)
            case .failure(let error):
                print(error)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
