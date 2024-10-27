//
//  File.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import Foundation
import UIKit

extension UIColor {
    
    static let bgColor = UIColor(hex: "070615")
    static let mainInfoColor = UIColor(hex: "100D2C")
    static let mainSecondaryColor = UIColor(hex: "23175F")
    static let buttonColor = UIColor(hex: "6D59D3")
    static let mainGrayColor = UIColor(hex: "525878")
    static let redColor = UIColor(hex: "D92929")
   
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexFormatted = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hexFormatted).scanHexInt64(&int)
        let red, green, blue: CGFloat
        switch hexFormatted.count {
        case 3:
            (red, green, blue) = (
                CGFloat((int >> 8) * 17) / 255,
                CGFloat((int >> 4 & 0xF) * 17) / 255,
                CGFloat((int & 0xF) * 17) / 255
            )
        case 6:
            (red, green, blue) = (
                CGFloat((int >> 16) & 0xFF) / 255,
                CGFloat((int >> 8) & 0xFF) / 255,
                CGFloat(int & 0xFF) / 255
            )
        default:
            (red, green, blue) = (1, 1, 1)
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
