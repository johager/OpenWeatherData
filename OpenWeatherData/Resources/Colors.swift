//
//  Colors.swift
//  OpenWeatherData
//
//  Created by James Hager on 4/7/22.
//

import UIKit

struct Colors {
    
    static var background: UIColor {
        return color(colorLight: .white, colorDark: .black)
    }
    
    static var secondary: UIColor {
        return avantiGreen
    }
    
    static var headerBackground: UIColor {
        return color(colorLight: light1HGreen, colorDark: dark3HGreen)
    }
    
    static var headerText: UIColor {
        return color(colorLight: dark2Green, colorDark: lightGreen)
    }
    
    static var textSelectable: UIColor {
        return color(colorLight: avantiGreen, colorDark: avantiOrange)
    }
    
    static var tableViewSelectedBackgroundColor: UIColor {
        let darkColor = UIColor(white: 0.11, alpha: 1)
        return color(colorLight: light2Green, colorDark: darkColor)
    }
    
    static var tableViewSeparatorColor: UIColor {
        return color(colorLight: medium3Green, colorDark: darkGreen)
    }
    
    // MARK: - Select Light/Dark Mode color
    
    static func color(colorLight: UIColor, colorDark: UIColor) -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return colorDark
            } else {
                return colorLight
            }
        }
    }
    
    // MARK: - Reference Colors
    
    static let avantiGreen = UIColor(red: 0, green: 84/255.0, blue: 73/255.0, alpha: 1)
    static let darkGreen = UIColor(red: 0, green: 0.22, blue: 0.19, alpha: 1)  // 35% black
    static let dark2Green = UIColor(red: 0, green: 0.18, blue: 0.16, alpha: 1)  // 45% black
    static let dark3HGreen = UIColor(red: 0, green: 0.13, blue: 0.11, alpha: 1)  // 60% black
    static let medium3Green = UIColor(red: 179/255.0, green: 204/255.0, blue: 201/255.0, alpha: 1)  // 70% white
    static let lightGreen = UIColor(red: 215/255.0, green: 229/255.0, blue: 227/255.0, alpha: 1)  // 84% white
    static let light1HGreen = UIColor(red: 230/255.0, green: 238/255.0, blue: 237/255.0, alpha: 1)  // 90% white
    static let light2Green = UIColor(red: 242/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)  // 95% white

    static let avantiOrange = UIColor(red: 230/255.0, green: 160/255.0, blue: 12/255.0, alpha: 1)
}
