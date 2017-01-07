//
//  HighlightSequenceOperation.swift
//  SimonSays
//
//  Created by Simon Støvring on 07/01/2017.
//  Copyright © 2017 Simon Støvring. All rights reserved.
//

import Foundation

class HighlightSequenceOperation: AsyncOperation {
    private let stallDuration: TimeInterval = 0.3
    private let highlightDuration: TimeInterval = 0.22
    private var stallTimer: Timer?
    private var highlightTimer: Timer?
    
    private let enemy: Enemy
    private weak var enemyButton: EnemyButton?
    
    init(enemy: Enemy, enemyButton: EnemyButton) {
        self.enemy = enemy
        self.enemyButton = enemyButton
        super.init()
    }
    
    override func start() {
        super.start()
        stallTimer = .scheduledTimer(
            timeInterval: stallDuration,
            target: self,
            selector: #selector(stallTimerDidFire),
            userInfo: nil,
            repeats: false)
        highlightTimer = .scheduledTimer(
            timeInterval: highlightDuration,
            target: self,
            selector: #selector(highlightTimerDidFire),
            userInfo: nil,
            repeats: false)
        enemyButton?.isHighlighted = true
        SoundEffects().playSound(for: enemy)
    }
    
    dynamic private func stallTimerDidFire() {
        finish()
    }
    
    dynamic private func highlightTimerDidFire() {        
        guard !isCancelled else {
            stallTimer?.invalidate()
            finish()
            return
        }
        enemyButton?.isHighlighted = false
    }
}
