//
//  AysncOperation.swift
//  SimonSays
//
//  Created by Simon Støvring on 07/01/2017.
//  Copyright © 2017 Simon Støvring. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
    override var isAsynchronous: Bool {
        return true
    }
    
    var _executing = false
    override var isExecuting: Bool {
        get { return _executing }
        set {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    var _finished = false
    override var isFinished: Bool {
        get { return _finished }
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override func start() {
        guard !isCancelled else {
            print("Cancelled before started")
            print("  \(self)")
            finish()
            return
        }
        isExecuting = true
    }
    
    func finish() {
        isFinished = true
        isExecuting = false
    }
}
