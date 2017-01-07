//
//  TouchbarButton.swift
//  SimonSays
//
//  Created by Simon Støvring on 07/01/2017.
//  Copyright © 2017 Simon Støvring. All rights reserved.
//

import Foundation
import AppKit

class TouchbarButton: NSButton {
    var width: CGFloat = NSViewNoIntrinsicMetric {
        didSet {
            if width != oldValue {
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    override var intrinsicContentSize: NSSize {
        return CGSize(width: width, height: NSViewNoIntrinsicMetric)
    }
}
