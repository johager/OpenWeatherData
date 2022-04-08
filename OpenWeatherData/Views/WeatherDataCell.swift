//
//  WeatherDataCell.swift
//  OpenWeatherData
//
//  Created by James Hager on 4/6/22.
//

import UIKit

class WeatherDataCell: UITableViewCell {

    // MARK: - Views
    
    var dateLabel: UILabel!
    var stackView: UIStackView!
    var mainLabel: UILabel!  // weather text like "Clear"
    var tempLabel: UILabel!
    var iconImageView: UIImageView!
    var dataLabels: [DataKey: UILabel]!
    
    // MARK: - Properties
    
    var dataKeys = [DataKey]()
    
    // MARK: - View Methods
    
    func setUpViews() {
        guard stackView == nil
        else {
            iconImageView.image = nil
            return
        }
        
        selectionStyle = .none
        
        let contentLayoutMargins = contentView.layoutMarginsGuide
        
        dateLabel = label(textStyle: .body)
        contentView.addSubview(dateLabel)
        dateLabel.pin(top: contentLayoutMargins.topAnchor, trailing: contentLayoutMargins.trailingAnchor, bottom: nil, leading: contentLayoutMargins.leadingAnchor, margin: [0, 0, 0, 0])
        
        stackView = UIStackView()
        contentView.addSubview(stackView)
        stackView.pin(top: dateLabel.bottomAnchor, trailing: contentLayoutMargins.trailingAnchor, bottom: contentLayoutMargins.bottomAnchor, leading: contentLayoutMargins.leadingAnchor, margin: [8, 0, 0, 0])
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        
        setUpDataKeys()
        
        setUpStackView()
        
        iconImageView = UIImageView()
        contentView.addSubview(iconImageView)
        iconImageView.pin(top: tempLabel.bottomAnchor, trailing: contentLayoutMargins.trailingAnchor, bottom: nil, leading: nil, margin: [4, -4, 0, 0])
    }
    
    // override
    func setUpDataKeys() {
    }
    
    func setUpStackView() {
        addMainAndTempLabels()
        
        dataLabels = [DataKey: UILabel]()
        for dataKey in dataKeys {
            addDataStackView(forDataKey: dataKey, dataLabels: &dataLabels)
        }
    }
    
    func addMainAndTempLabels() {
        let topStackView = UIStackView()
        topStackView.axis = .horizontal
        topStackView.distribution = .equalSpacing
        topStackView.spacing = 4
        
        mainLabel = label(textStyle: .headline)
        
        tempLabel = label(textStyle: .headline)
        tempLabel.textAlignment = .center
        tempLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        topStackView.addArrangedSubview(mainLabel)
        topStackView.addArrangedSubview(tempLabel)
        
        stackView.addArrangedSubview(topStackView)
        
        topStackView.pin(top: nil, trailing: stackView.trailingAnchor, bottom: nil, leading: stackView.leadingAnchor, margin: [0, -4, 0, 0])
    }
    
    func addDataStackView(forDataKey dataKey: DataKey, dataLabels: inout [DataKey: UILabel]) {
        let dataStackView = UIStackView()
        dataStackView.axis = .horizontal
        dataStackView.alignment = .firstBaseline
        dataStackView.spacing = 4
        
        let descLabel = label(withText: dataKey.description)
        dataStackView.addArrangedSubview(descLabel)
        
        let dataLabel = label()
        dataStackView.addArrangedSubview(dataLabel)
        
        dataLabels[dataKey] = dataLabel
        
        stackView.addArrangedSubview(dataStackView)
    }
    
    func label(withText text: String) -> UILabel {
        let label = label()
        label.text = text
        label.textAlignment = .right
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return label
    }
    
    func label(textStyle: UIFont.TextStyle = .footnote) -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: textStyle)
        label.adjustsFontForContentSizeCategory = true
        return label
    }
    
    // MARK: - Get and Set iconImage
    
    func fetchIconImage(for icon: String?) {
        guard let icon = icon else { return }
        
        WeatherDataController().fetchIcon(iconID: icon) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let iconImage):
                    self.iconImageView.image = iconImage
                case .failure(let error):
                    print("\(#function) error: \(error)")
                }
            }
        }
    }
    
    // MARK: - Misc Methods
    
    func string(fromFloat float: Float, withDecimals: Bool = false) -> String {
        if withDecimals {
            return String(format: "%.2f", float)
        } else {
            return String(Int(round(float)))
        }
    }
    
    func windText(windSpeed: Float, windDeg: Int, windGust: Float?) -> String {
        let windDirText = compassDirText(from: windDeg)
        let windSpeedText = string(fromFloat: windSpeed)
        var windText = "\(windDirText) at \(windSpeedText)\u{00a0}mph"
        
        // only show gusts if greater than 5 over windSpeed
        if let windGust = windGust, Int(round(windGust)) - Int(round(windSpeed)) > 5 {
            windText += "\ngusting to \(string(fromFloat: windGust))\u{00a0}mph"
        }
        
        return windText
    }
    
    func compassDirText(from dirIntIn: Int, makePos: Bool = false) -> String {
        var dirInt = dirIntIn
        if makePos && dirInt < 0 {
            dirInt += 360
        }
        switch dirInt {
        case 350...360, 0...11: return "N"
        case 12...33: return "NNE"
        case 34...56: return "NE"
        case 57...79: return "ENE"
        case 80...101: return "E"
        case 102...124: return "ESE"
        case 125...146: return "SE"
        case 147...169: return "SSE"
        case 170...191: return "S"
        case 192...214: return "SSW"
        case 215...236: return "SW"
        case 237...259: return "WSW"
        case 260...281: return "NW"
        case 282...304: return "WNW"
        case 305...326: return "NW"
        case 327...349: return "NNW"
        case -10, 999: return "Variable"
        default: return "Unknown"
        }
    }
}
