//
//  Constants.swift
//  test_lightApps
//
//  Created by Anton on 26.10.2024.
//

import Foundation
import UIKit

class Constants {
    static let containerViewHeight: CGFloat = {
        
        let screenHeight = UIScreen.main.bounds.height
        
        if screenHeight <= 667 {
            return 170
        } else {
            return 198
        }
    }()
    
    static let stackViewAncorHeight: CGFloat = {
        
        let screenHeight = UIScreen.main.bounds.height
        
        if screenHeight <= 667 {
            return 120
        } else {
            return 180
        }
    }()
    
    static let mainButtonHeight: CGFloat = {
        
        let screenHeight = UIScreen.main.bounds.height
        
        if screenHeight <= 667 {
            return 35
        } else {
            return 50
        }
    }()
    
}
