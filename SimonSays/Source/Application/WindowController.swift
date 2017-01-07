//
//  WindowController.swift
//  SimonSays
//
//  Created by Simon Støvring on 05/01/2017.
//  Copyright © 2017 Simon Støvring. All rights reserved.
//

import Foundation
import AppKit

class WindowController: NSWindowController {
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        return contentViewController?.makeTouchBar()
    }
}
