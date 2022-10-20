//
//  UIButton+.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 04.10.2022.
//

import UIKit

extension UIButton {
    func setUnderlinedTitle(_ text: String?, for state: UIControl.State) {
        if let text = text {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: text.count))

            self.setAttributedTitle(attributedString, for: state)
        } else {
            self.setAttributedTitle(nil, for: state)
        }
    }
}
