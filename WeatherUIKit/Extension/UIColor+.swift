//
//  UIColor+.swift
//  Weather
//
//  Created by Павел Барташов on 17.09.2022.
//

import UIKit

extension UIColor {
    static var brandOrange: UIColor {
        getBrandColor(named: "OrangeColor")
    }

    static var brandLightGray: UIColor {
        getBrandColor(named: "LightGrayColor")
    }

    static var brandDarkGray: UIColor {
        getBrandColor(named: "DarkGrayColor")
    }

    static var brandTextColor: UIColor {
        getBrandColor(named: "TextColor")
    }

    static var brandYellow: UIColor {
        getBrandColor(named: "YellowColor")
    }

    static var brandLightPurple: UIColor {
        getBrandColor(named: "LightPurpleColor")
    }

    static var brandTextGrayColor: UIColor {
        getBrandColor(named: "TextGrayColor")
    }

    static var brandPurpleColor: UIColor {
        getBrandColor(named: "PurpleColor")
    }

    static func getBrandColor(named colorName: String) -> UIColor {
        guard let color = UIColor(named: colorName) else {
            fatalError("""
                Failed to load the "\(colorName)" color.
                Make sure the color set is included in the project and the color name is spelled correctly.
            """
            )
        }
        return color
    }
}
