//
//  ViewController.swift
//  SimonSays
//
//  Created by Simon Støvring on 05/01/2017.
//  Copyright © 2017 Simon Støvring. All rights reserved.
//

import Cocoa

extension MainViewController {
    enum Error: Swift.Error {
        case buttonDoesNotExistForEnemy(Enemy)
        case enemyDoesNotExistForButton(EnemyButton)
    }
}

class MainViewController: NSViewController {
    fileprivate let startButton = TouchbarButton(title: localize("START_GAME"), target: nil, action: nil).sbs_make { me in
        me.width = 100
    }
    fileprivate let blueEnemyButton = EnemyButton(title: "", target: nil, action: nil).sbs_make { me in
        me.color = Enemy.blue.color
        me.title = ""
    }
    fileprivate let greenEnemyButton = EnemyButton(title: "", target: nil, action: nil).sbs_make { me in
        me.color = Enemy.green.color
        me.title = ""
    }
    fileprivate let yellowEnemyButton = EnemyButton(title: "", target: nil, action: nil).sbs_make { me in
        me.color = Enemy.yellow.color
        me.title = ""
    }
    fileprivate let orangeEnemyButton = EnemyButton(title: "", target: nil, action: nil).sbs_make { me in
        me.color = Enemy.orange.color
        me.title = ""
    }
    fileprivate let redEnemyButton = EnemyButton(title: "", target: nil, action: nil).sbs_make { me in
        me.color = Enemy.red.color
        me.title = ""
    }
    fileprivate let scoreLabel = TouchbarTextField().sbs_make { me in
        me.cell = VerticallyCenteredTextFieldCell()
        me.width = 70
        me.isBezeled = false
        me.isEditable = false
        me.isSelectable = false
        me.isHidden = true
        me.alignment = .right
        me.cell?.isScrollable = false
        me.drawsBackground = false
    }
    fileprivate var allEnemyButtons: [EnemyButton] {
        return [ blueEnemyButton, greenEnemyButton, yellowEnemyButton, orangeEnemyButton, redEnemyButton ]
    }
    
    private var isGameStarted = false
    private var isAddingEnemy = false
    private var sequence: [Enemy] = []
    private var enteredSequence: [Enemy] = []
    private var highlightSequenceQueue = OperationQueue.main.sbs_make { me in
        me.maxConcurrentOperationCount = 1
    }
    private var highlightEnemyQueue = OperationQueue.main.sbs_make { me in
        me.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
    }
    private var nextEnemyInSequence = 0
    private var score = 0 {
        didSet { updateDisplayedScore() }
    }
    private let countdown = Countdown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.target = self
        startButton.action = #selector(startStopPressed)
        allEnemyButtons.forEach {
            $0.target = self
            $0.action = #selector(didPressEnemyButton)
            if #available(OSX 10.12.2, *) {
                $0.sendAction(on: .leftMouseDown)
            }
            ($0.cell as? NSButtonCell)?.highlightsBy = []
        }
        updateDisplayedScore()
        endGame()
    }
    
    dynamic private func startStopPressed() {
        if isGameStarted {
            endGame()
        } else {
            startGame()
        }
    }
    
    dynamic private func didPressEnemyButton(button: EnemyButton) {
        guard !isAddingEnemy else { return }
        do {
            let enemy = try self.enemy(for: button)
            highlightEnemyQueue.operations.forEach { operation in
                // Cancel all current highlights of that enemy.
                guard let operation = operation as? HighlightEnemyOperation, operation.enemy == enemy else { return }
                operation.cancel()
            }
            // Highlight the enemy.
            let highlightOperation = HighlightEnemyOperation(enemy: enemy, enemyButton: button)
            self.highlightEnemyQueue.addOperation(highlightOperation)
            if isNextEnemyInSequence(enemy) {
                // Player chose the right enemy.
                nextEnemyInSequence += 1
                let didPressLastEnemy = nextEnemyInSequence >= sequence.count
                if didPressLastEnemy {
                    // Player did enter the entire sequence.
                    allEnemyButtons.forEach { $0.isEnabled = false }
                    highlightOperation.completionBlock = { [weak self] in
                        DispatchQueue.main.async {
                            self?.didEnterSequence()
                        }
                    }
                }
            } else {
                // Player chose a wrong enemy.
                endGame()
            }
        } catch {
            // If we end up here, we forgot to map an enemy in the enemyToButtonMap.
            print(error)
            endGame()
        }
    }
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [
            .start,
            .flexibleSpace,
            .blueEnemy,
            .fixedSpaceSmall,
            .greenEnemy,
            .fixedSpaceSmall,
            .yellowEnemy,
            .fixedSpaceSmall,
            .orangeEnemy,
            .fixedSpaceSmall,
            .redEnemy,
            .flexibleSpace,
            .score,
            .flexibleSpace ]
        return touchBar
    }
    
    private func startGame() {
        isGameStarted = true
        isAddingEnemy = false
        nextEnemyInSequence = 0
        score = 0
        sequence = []
        enteredSequence = []
        scoreLabel.isHidden = false
        startButton.isEnabled = false
        allEnemyButtons.forEach { $0.showsDisabled = false }
        countdown.countdown(from: 3, tick: { [weak self] count in
            if count > 0 {
                self?.startButton.title = localize("COUNTDOWN", [ count ])
            } else {
                self?.startButton.isHidden = true
            }
        }, completion: { [weak self] in
            self?.startButton.isHidden = true
            self?.addEnemy()
        })
    }
    
    private func endGame() {
        isGameStarted = false
        isAddingEnemy = false
        nextEnemyInSequence = 0
        sequence = []
        enteredSequence = []
        startButton.isEnabled = true
        startButton.isHidden = false
        startButton.title = localize("START_GAME")
        allEnemyButtons.forEach {
            $0.isEnabled = false
            $0.showsDisabled = true
            $0.isHighlighted = false
        }
        highlightSequenceQueue.cancelAllOperations()
        highlightEnemyQueue.cancelAllOperations()
    }
    
    private func addEnemy() {
        guard let enemy = Enemy.all.random else { return }
        isAddingEnemy = true
        sequence.append(enemy)
        highlightSequence()
    }
    
    private func highlightSequence() {
        allEnemyButtons.forEach { $0.isEnabled = false }
        highlightSequenceQueue.cancelAllOperations()
        do {
            let operations = try sequence.map { HighlightSequenceOperation(enemy: $0, enemyButton: try button(for: $0)) }
            let finishedOperation = Operation()
            finishedOperation.completionBlock = { [weak self] in
                DispatchQueue.main.async {
                    self?.didHighlightSequence()
                }
            }
            highlightSequenceQueue.addOperations(operations + [ finishedOperation ], waitUntilFinished: false)
        } catch {
            // If we end up here, we forgot to map an enemy in the enemyToButtonMap.
            print(error)
            endGame()
        }
    }
    
    private func didHighlightSequence() {
        allEnemyButtons.forEach { $0.isEnabled = true }
        isAddingEnemy = false
    }
    
    private func didEnterSequence() {
        score += 1
        nextEnemyInSequence = 0
        let waitOperation = WaitOperation(duration: 0.9)
        waitOperation.completionBlock = { [weak self] in
            DispatchQueue.main.async {
                self?.addEnemy()
            }
        }
        highlightEnemyQueue.addOperation(waitOperation)
    }
    
    private func isNextEnemyInSequence(_ enemy: Enemy) -> Bool {
        return enemy == sequence[nextEnemyInSequence]
    }
    
    private func updateDisplayedScore() {
        scoreLabel.stringValue = localize("SCORE", [ score ])
    }
}

extension MainViewController {
    private var enemyToButtonMap: [Enemy: EnemyButton] {
        return [
            .blue: blueEnemyButton,
            .green: greenEnemyButton,
            .yellow: yellowEnemyButton,
            .orange: orangeEnemyButton,
            .red: redEnemyButton
        ]
    }
    
    fileprivate func button(for enemy: Enemy) throws -> EnemyButton {
        guard let button = enemyToButtonMap[enemy] else {
            throw MainViewController.Error.buttonDoesNotExistForEnemy(enemy)
        }
        return button
    }
    
    fileprivate func enemy(for button: EnemyButton) throws -> Enemy {
        guard let enemy = enemyToButtonMap.filter({ $0.value == button }).first?.key else {
            throw MainViewController.Error.enemyDoesNotExistForButton(button)
        }
        return enemy
    }
}

extension MainViewController: NSTouchBarDelegate {
    @available(OSX 10.12.2, *)
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        switch identifier {
        case NSTouchBarItemIdentifier.start:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = startButton
            return item
        case NSTouchBarItemIdentifier.blueEnemy:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = blueEnemyButton
            return item
        case NSTouchBarItemIdentifier.greenEnemy:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = greenEnemyButton
            return item
        case NSTouchBarItemIdentifier.yellowEnemy:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = yellowEnemyButton
            return item
        case NSTouchBarItemIdentifier.orangeEnemy:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = orangeEnemyButton
            return item
        case NSTouchBarItemIdentifier.redEnemy:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = redEnemyButton
            return item
        case NSTouchBarItemIdentifier.score:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = scoreLabel
            return item
        default:
            return nil
        }
    }
}

extension NSTouchBarItemIdentifier {
    static var start = NSTouchBarItemIdentifier("dk.simonbs.SimonSays.TouchBar.StartStop")
    static var blueEnemy = NSTouchBarItemIdentifier("dk.simonbs.SimonSays.TouchBar.Blue")
    static var greenEnemy = NSTouchBarItemIdentifier("dk.simonbs.SimonSays.TouchBar.Green")
    static var yellowEnemy = NSTouchBarItemIdentifier("dk.simonbs.SimonSays.TouchBar.Yellow")
    static var orangeEnemy = NSTouchBarItemIdentifier("dk.simonbs.SimonSays.TouchBar.Orange")
    static var redEnemy = NSTouchBarItemIdentifier("dk.simonbs.SimonSays.TouchBar.Red")
    static var score = NSTouchBarItemIdentifier("dk.simonbs.SimonSays.TouchBar.Score")
}
