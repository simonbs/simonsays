//
//  WaitOperation.swift
//  SimonSays
//
//  Created by Simon Støvring on 07/01/2017.
//  Copyright © 2017 Simon Støvring. All rights reserved.
//

import Foundation

class WaitOperation: AsyncOperation {
    private let duration: TimeInterval
    private var timer: Timer?
    
    init(duration: TimeInterval) {
        self.duration = duration
        super.init()
    }
    
    override func start() {
        super.start()
        timer = .scheduledTimer(
            timeInterval: duration,
            target: self,
            selector: #selector(timerDidFire),
            userInfo: nil,
            repeats: false)
    }
    
    dynamic private func timerDidFire() {
        finish()
    }
}
