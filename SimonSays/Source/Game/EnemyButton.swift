//
//  EnemyButton.swift
//  SimonSays
//
//  Created by Simon Støvring on 07/01/2017.
//  Copyright © 2017 Simon Støvring. All rights reserved.
//

import Foundation
import AppKit

class EnemyButton: NSButton {
    var color: NSColor? {
        didSet {
            if #available(OSX 10.12.2, *) {
                bezelColor = color
            }
        }
    }
    
    var showsDisabled: Bool = false {
        didSet { updateAlpha() }
    }
    
    override var isHighlighted: Bool {
        didSet { updateAlpha() }
    }
    
    private func updateAlpha() {
        if isHighlighted {
            alphaValue = 1
        } else if showsDisabled {
            alphaValue = 0.16
        } else {
            alphaValue = 0.37
        }
    }
}
