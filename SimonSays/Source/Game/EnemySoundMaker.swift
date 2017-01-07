//
//  EnemySounds.swift
//  SimonSays
//
//  Created by Simon Støvring on 07/01/2017.
//  Copyright © 2017 Simon Støvring. All rights reserved.
//

import Foundation
import AVFoundation

class EnemySoundMaker {
    static let shared = EnemySoundMaker()
    private let players: [Enemy: AVAudioPlayer] = [:]
    
    private init() { }
    
    func prepareSounds() {
        for enemy in Enemy.all {
            
        }
    }
    
    func playSound(for enemy: Enemy) {
        players[enemy]?.play()
    }
}
