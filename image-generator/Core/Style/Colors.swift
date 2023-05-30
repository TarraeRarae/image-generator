//
//  Colors.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

import UIKit

extension UIColor {

    // MARK: Custom colors

    static let defaultBackground: UIColor = UIColor(rgb: 0xF5F5F5)
    static let whiteBackground: UIColor = UIColor(rgb: 0xFFFFFF)
    static let textColor: UIColor = UIColor(rgb: 0x000000)
    static let shadowColor: UIColor = UIColor(rgb: 0x000000)
    static let placeholderColor: UIColor = UIColor(rgb: 0x3C3C43)
    static let buttonBackgroundColor: UIColor = UIColor(rgb: 0x844AFF)
    static let borderColor: UIColor = UIColor(rgb: 0xB2B2B)
    static let grayBackground: UIColor = UIColor(rgb: 0xEAEAEA)
    static let buttonTextColor: UIColor = UIColor(rgb: 0xFFFFFF)
    static let goldColor: UIColor = UIColor(rgb: 0xFFE500)

    // MARK: Hex inits

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
