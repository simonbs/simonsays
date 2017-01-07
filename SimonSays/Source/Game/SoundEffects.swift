//
//  SoundEffects.swift
//  SimonSays

//  Created by Simon Støvring on 07/01/17.
//  Copyright (c) 2015 SimonBS. All rights reserved.
//

import AudioToolbox

class SoundEffects {
    fileprivate let soundHelper = SystemSoundHelper()
    
    func playSound(for enemy: Enemy) {
        playSound(enemy.soundName, ofType: "")
    }
    
    private func playSound(_ soundName: String, ofType type: String) {
        if let path = Bundle.main.path(forResource: soundName, ofType: type) {
            playSoundAtPath(path)
        }
    }
    
    fileprivate func playSoundAtPath(_ path: String) {
        let url = URL(fileURLWithPath: path)
        var audioEffect: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url as CFURL, &audioEffect)
        AudioServicesPlaySystemSound(audioEffect)
    }
}
