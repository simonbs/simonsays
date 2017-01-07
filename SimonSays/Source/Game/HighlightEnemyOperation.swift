//
//  HighlightEnemyOperation.swift
//  SimonSays
//
//  Created by Simon Støvring on 07/01/2017.
//  Copyright © 2017 Simon Støvring. All rights reserved.
//

import Foundation

class HighlightEnemyOperation: AsyncOperation {
    private let duration: TimeInterval = 0.15
    private var timer: Timer?
    
    let enemy: Enemy
    private weak var enemyButton: EnemyButton?
    
    private let soundEffects = SoundEffects()
    
    init(enemy: Enemy, enemyButton: EnemyButton) {
        self.enemy = enemy
        self.enemyButton = enemyButton
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
        enemyButton?.isHighlighted = true
        soundEffects.playSound(for: enemy)
    }
    
    dynamic private func timerDidFire() {
        defer { finish() }
        guard !isCancelled else { return }
        enemyButton?.isHighlighted = false
    }
}
