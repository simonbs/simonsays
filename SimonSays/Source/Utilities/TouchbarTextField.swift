//
//  TouchbarTextField.swift
//  SimonSays
//
//  Created by Simon Støvring on 07/01/2017.
//  Copyright © 2017 Simon Støvring. All rights reserved.
//

import Foundation
import AppKit

class TouchbarTextField: NSTextField {
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

class VerticallyCenteredTextFieldCell: NSTextFieldCell {
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        let textHeight = attributedStringValue.size().height
        let newRect = NSRect(x: 0, y: (rect.size.height - textHeight) / 2, width: rect.size.width, height: textHeight)
        return super.drawingRect(forBounds: newRect)
    }
}
