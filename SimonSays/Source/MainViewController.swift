//
//  ViewController.swift
//  SimonSays
//
//  Created by Simon Støvring on 05/01/2017.
//  Copyright © 2017 Simon Støvring. All rights reserved.
//

import Cocoa

enum Enemy {
    case green
    case red
    case blue
    case yellow
    
    var color: NSColor {
        switch self {
        case .green: return NSColor(hex: 0x5AC95E)
        case .red: return NSColor(hex: 0xF03661)
        case .blue: return NSColor(hex: 0x34B5EA)
        case .yellow: return NSColor(hex: 0xF8D957)
        }
    }
}

class MainViewController: NSViewController {
    fileprivate let startStopButton = NSButton(title: localize("START_GAME"), target: nil, action: nil)
    fileprivate let greenButton = NSButton(title: "", target: nil, action: nil).sbs_make { me in
        me.title = ""
    }
    fileprivate let redButton = NSButton(title: "", target: nil, action: nil).sbs_make { me in
        me.title = ""
    }
    fileprivate let blueButton = NSButton(title: "", target: nil, action: nil).sbs_make { me in
        me.title = ""
    }
    fileprivate let yellowButton = NSButton(title: "", target: nil, action: nil).sbs_make { me in
        me.title = ""
    }
    
    private var isGameStarted = false
    private var isAddingEnemy = false
    private var sequence: [Enemy] = []
    private var enteredSequence: [Enemy] = []
    private var sequenceQueue = OperationQueue.main.sbs_make { me in
        me.maxConcurrentOperationCount = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startStopButton.target = self
        startStopButton.action = #selector(startStopPressed)
        endGame()
    }
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [
            .startStopButton,
            .flexibleSpace,
            .greenButton,
            .fixedSpaceSmall,
            .redButton,
            .fixedSpaceSmall,
            .blueButton,
            .fixedSpaceSmall,
            .yellowButton,
            .flexibleSpace ]
        return touchBar
    }
    
    dynamic func startStopPressed() {
        if isGameStarted {
            endGame()
        } else {
            startGame()
        }
    }
    
    private func startGame() {
        isGameStarted = true
        isAddingEnemy = false
        sequence = []
        enteredSequence = []
        startStopButton.title = localize("END_GAME")
        greenButton.alphaValue = 1
        redButton.alphaValue = 1
        blueButton.alphaValue = 1
        yellowButton.alphaValue = 1
    }
    
    private func endGame() {
        isGameStarted = false
        isAddingEnemy = false
        sequence = []
        enteredSequence = []
        startStopButton.title = localize("START_GAME")
        greenButton.isEnabled = false
        redButton.isEnabled = false
        blueButton.isEnabled = false
        yellowButton.isEnabled = false
        greenButton.alphaValue = 0.4
        redButton.alphaValue = 0.4
        blueButton.alphaValue = 0.4
        yellowButton.alphaValue = 0.4
        if #available(OSX 10.12.2, *) {
            greenButton.bezelColor = Enemy.green.color
            redButton.bezelColor = Enemy.red.color
            blueButton.bezelColor = Enemy.blue.color
            yellowButton.bezelColor = Enemy.yellow.color
        }
    }
    
    private func addEnemey() {
        isAddingEnemy = true
    }
    
    private func highlightCurrentSequence() {
        
    }
}

extension MainViewController: NSTouchBarDelegate {
    @available(OSX 10.12.2, *)
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        switch identifier {
        case NSTouchBarItemIdentifier.startStopButton:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = startStopButton
            return item
        case NSTouchBarItemIdentifier.greenButton:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = greenButton
            return item
        case NSTouchBarItemIdentifier.redButton:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = redButton
            return item
        case NSTouchBarItemIdentifier.blueButton:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = blueButton
            return item
        case NSTouchBarItemIdentifier.yellowButton:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = yellowButton
            return item
        default:
            return nil
        }
    }
}

extension NSTouchBarItemIdentifier {
    static var startStopButton = NSTouchBarItemIdentifier("dk.simonbs.SimonSays.TouchBar.StartStop")
    static var greenButton = NSTouchBarItemIdentifier("dk.simonbs.SimonSays.TouchBar.Green")
    static var redButton = NSTouchBarItemIdentifier("dk.simonbs.SimonSays.TouchBar.Red")
    static var blueButton = NSTouchBarItemIdentifier("dk.simonbs.SimonSays.TouchBar.Blue")
    static var yellowButton = NSTouchBarItemIdentifier("dk.simonbs.SimonSays.TouchBar.Yellow")
}
