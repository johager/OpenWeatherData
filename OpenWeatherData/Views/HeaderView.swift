//
//  HeaderView.swift
//  OpenWeatherData
//
//  Created by James Hager on 4/7/22.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {

    var titleLabel: UILabel!
    
    func configure(withTitle title: String) {
        setUpView()
        titleLabel.text = title
    }
    
    func setUpView() {
        guard titleLabel == nil else { return }
        contentView.backgroundColor = Colors.headerBackground
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = Colors.headerText
        
        let contentLayoutMargins = contentView.layoutMarginsGuide
        contentView.addSubview(titleLabel)
        titleLabel.pin(top: contentLayoutMargins.topAnchor, trailing: contentLayoutMargins.trailingAnchor, bottom: contentLayoutMargins.bottomAnchor, leading: contentLayoutMargins.leadingAnchor, margin: [0, 0, 0, 0])
    }
}
