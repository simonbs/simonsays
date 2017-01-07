//
//  Enemy.swift
//  SimonSays
//
//  Created by Simon Støvring on 07/01/2017.
//  Copyright © 2017 Simon Støvring. All rights reserved.
//

import Foundation
import AppKit
import AVFoundation

enum Enemy {
    static var all: [Enemy] {
        return [ .blue, .green, .yellow, .orange, .red ]
    }
    
    case blue
    case green
    case yellow
    case orange
    case red
    
    private static let blueSound = NSSound(named: "enemy-blue")
    private static let greenSound = NSSound(named: "enemy-green")
    private static let yellowSound = NSSound(named: "enemy-yellow")
    private static let orangeSound = NSSound(named: "enemy-orange")
    private static let redSound = NSSound(named: "enemy-red")
    
    var color: NSColor {
        switch self {
        case .blue: return NSColor(hex: 0x34B5EA)
        case .green: return NSColor(hex: 0x5AC95E)
        case .yellow: return NSColor(hex: 0xF8D957)
        case .orange: return NSColor(hex: 0xF5A05A)
        case .red: return NSColor(hex: 0xF03661)
        }
    }
    
    var soundName: String {
        switch self {
        case .blue: return "enemy-blue.mp4"
        case .green: return "enemy-green.mp4"
        case .yellow: return "enemy-yellow.mp4"
        case .orange: return "enemy-orange.mp4"
        case .red: return "enemy-red.mp4"
        }
    }
}
