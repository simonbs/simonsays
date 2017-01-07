//
//  NSColor+Hex.swift
//  SimonSays
//
//  Created by Simon Støvring on 05/01/2017.
//  Copyright © 2017 Simon Støvring. All rights reserved.
//

import Foundation
import AppKit

extension NSColor {
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    convenience init(hex: Int, alpha: Float) {
        self.init(
            red: CGFloat((hex >> 16) & 0xff) / 255.0,
            green: CGFloat((hex >> 8) & 0xff) / 255.0,
            blue: CGFloat(hex & 0xff) / 255.0,
            alpha: CGFloat(alpha))
    }
}
