//
//  ForecastViewController.swift
//  OpenWeatherData
//
//  Created by James Hager on 4/6/22.
//

import UIKit
import CoreLocation

class ForecastViewController: UITableViewController {

    let weatherDataController = WeatherDataController()
    
    var locationName = ""
    var lat: Double!
    var lon: Double!
    var weatherData: WeatherData!
    
    var current: Current { weatherData.current }
    var daily: [Day] { weatherData.daily }
    
    enum Identifier {
        static let header = "headerView"
        static let current = "currentCell"
        static let day = "dayCell"
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNav()
        setUpViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard weatherData == nil else { return }
        presentAddLocationAlert()
    }
    
    // MARK: - View Methods
    
    func setUpNav() {
        
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEditButtonTapped))
        navigationItem.setLeftBarButton(editBarButton, animated: false)
        
        let refreshBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(handleRefreshButtonTapped))
        navigationItem.setRightBarButton(refreshBarButton, animated: false)
    }
    
    func setUpViews() {
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: Identifier.header)
        tableView.register(CurrentCell.self, forCellReuseIdentifier: Identifier.current)
        tableView.register(DayCell.self, forCellReuseIdentifier: Identifier.day)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func updateViews() {
        title = locationName
        tableView.reloadData()
    }
    
    func getWeather(lat: Double, lon: Double, name: String) {
        print("\(#function) - lat, lon: \(lat), \(lon)")
        weatherDataController.fetchWeatherData(lat: lat, lon: lon) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherData):
                    self.locationName = name
                    self.lat = lat
                    self.lon = lon
                    self.weatherData = weatherData
                    self.updateViews()
                    print(weatherData)
                case .failure(let error):
                    self.presentErrorAlert(for: error)
                }
            }
        }
    }
    
    // MARK: - Location Methods
    
    func presentAddLocationAlert() {
        let alert = UIAlertController(title: "Set Location Using...", message: nil, preferredStyle: .actionSheet)
        
        let address = UIAlertAction(title: "Address", style: .default) { _ in
            alert.dismiss(animated: true)
            self.presentAddLocationByAddressAlert()
        }
        
        let gpsCoords = UIAlertAction(title: "GPS Coordinates", style: .default) { _ in
            alert.dismiss(animated: true)
            self.presentAddLocationByGPSCoordsAlert()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(address)
        alert.addAction(gpsCoords)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func presentAddLocationByAddressAlert() {
        let alert = UIAlertController(title: "Set Location Using Address", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Address..."
        }
        
        alert.addTextField { textField in
            textField.placeholder = "[Name...]"
        }
        
        let set = UIAlertAction(title: "Set", style: .default) { [weak alert] _ in
            guard let textFields = alert?.textFields,
                  textFields.count > 1,
                  let address = textFields[0].text,
                  !address.isEmpty,
                  let name = textFields[1].text
            else { return }
            
            let locationName: String
            if name.isEmpty {
                locationName = address
            } else {
                locationName = name
            }
            
            LocationHelper.getCoords(for: address) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let coordinate):
                        self.getWeather(lat: coordinate.latitude, lon: coordinate.longitude, name: locationName)
                    case .failure(let error):
                        self.presentErrorAlert(for: error)
                    }
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(set)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func presentAddLocationByGPSCoordsAlert() {
        let alert = UIAlertController(title: "Set Location Using GPS Coordinates", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Name..."
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Latitude (37.33)..."
            textField.keyboardType = .numberPad
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Longitude (-122.01)..."
            textField.keyboardType = .numberPad
        }
        
        let set = UIAlertAction(title: "Set", style: .default) { [weak alert] _ in
            guard let textFields = alert?.textFields,
                  textFields.count > 2,
                  let name = textFields[0].text,
                  !name.isEmpty,
                  let latString = textFields[1].text,
                  let lat = Double(latString),
                  let lonString = textFields[2].text,
                  let lon = Double(lonString)
            else { return }
            
            self.getWeather(lat: lat, lon: lon, name: name)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(set)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    @objc func handleEditButtonTapped() {
        presentAddLocationAlert()
    }
    
    @objc func handleRefreshButtonTapped() {
        print(#function)
        guard !locationName.isEmpty,
              let lat = lat,
              let lon = lon
        else { return }
        
        getWeather(lat: lat, lon: lon, name: locationName)
    }
}

// MARK: - UITableViewDataSource

extension ForecastViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if weatherData == nil {
            return 0
        }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return daily.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.current, for: indexPath) as? CurrentCell
            else { return UITableViewCell() }
            cell.configure(with: current, timezone: weatherData.timezone)
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.day, for: indexPath) as? DayCell
            else { return UITableViewCell() }
            cell.configure(with: daily[indexPath.row], timezone: weatherData.timezone)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension ForecastViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Identifier.header) as? HeaderView
        else { return nil }
        
        if section == 0 {
            headerView.configure(withTitle: "Current Conditions")
        } else {
            headerView.configure(withTitle: "Forecast")
        }
        
        return headerView
    }
}
