//
//  Counter.swift
//  SimonSays
//
//  Created by Simon Støvring on 07/01/2017.
//  Copyright © 2017 Simon Støvring. All rights reserved.
//

import Foundation

class Countdown {
    private var tick: ((Int) -> Void)?
    private var completion: ((Void) -> Void)?
    private var count = 0
    private var timer: Timer?
    
    func countdown(from count: Int, tick: @escaping (Int) -> Void, completion: @escaping (Void) -> Void) {
        timer?.invalidate()
        self.count = count
        self.tick = tick
        self.completion = completion
        tick(count)
        timer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDidTick), userInfo: nil, repeats: true)
    }
    
    dynamic private func timerDidTick() {
        if count == 0 {
            timer?.invalidate()
            completion?()
            tick = nil
            completion = nil
        } else {
            count -= 1
            tick?(count)
        }
    }
}
