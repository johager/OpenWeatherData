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
    var dataLabels: [DataKey: UILabel]!
    
    // MARK: - Properties
    
    var dataKeys = [DataKey]()
    
    // MARK: - View Methods

    func setUpViews() {
        print(#function)
        guard stackView == nil else { return }
        
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
    }
    
    // override
    func setUpDataKeys() {
    }
    
    func setUpStackView() {
        print(#function)
        dataLabels = [DataKey: UILabel]()
        for dataKey in dataKeys {
            addDataStackView(forDataKey: dataKey, dataLabels: &dataLabels)
        }
    }
    
    func addDataStackView(forDataKey dataKey: DataKey, dataLabels: inout [DataKey: UILabel]) {
        print("\(#function) - dataKey: \(dataKey)")
        let dataStackView = UIStackView()
        dataStackView.axis = .horizontal
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
    
    // MARK: - Misc Methods
    
    func string(fromFloat float: Float, withDecimals: Bool = false) -> String {
        if withDecimals {
            return String(format: "%.2f", float)
        } else {
            return String(float.rounded())
        }
    }
    
    func string(fromDt dt: Int, timezone: String) -> String {
        let date = Date(timeIntervalSince1970: Double(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        return dateFormatter.string(from: date)
    }
}
