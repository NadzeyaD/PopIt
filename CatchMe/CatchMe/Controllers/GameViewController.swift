//
//  ViewController.swift
//  CatchMe
//
//  Created by Nadia on 3/23/20.
//  Copyright © 2020 Nadzeya. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class GameViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var poppedBubbles = 0
    var maxBubbleCount = 24
    var currentScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)

            if let updaterScene = (scene as? Scene) {
                updaterScene.scoreUpdater = self
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        runSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        openMenu(UIButton())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        pauseSession()
    }
    
    func fillScoreLabel(total: Int, popped: Int) {
        var score = generateScoreString(total: total, popped: popped)
        if total > maxBubbleCount {
            gameOver()
            score = generateScoreString(total: 0, popped: poppedBubbles)
        }
        
        scoreLabel.text = score
    }
    
    func gameOver() {
        saveRecord()
        pauseGame()
        clearScene()
        showGameOverScreen()
    }
    
    func generateScoreString(total: Int, popped: Int) -> String {
        return "Total: \(total) / Popped: \(popped)"
    }
    
    func saveRecord() {
        let previousRecord = CurrentRunEnvironment.recordScore
        
        if poppedBubbles > previousRecord {
            CurrentRunEnvironment.recordScore = poppedBubbles
        }
    }
    
    func clearScene() {
        guard let scene = sceneView.scene else { return }
        
        scene.removeAllChildren()
    }
    
    func pauseGame() {
        guard let scene = sceneView.scene else { return }
        
        scene.isPaused = true
    }
    
    func unpauseGame() {
        guard let scene = sceneView.scene as? Scene else { return }
        
        scene.isPaused = false
        scene.onUnpause()
    }
    
    
    func restartGame() {
        clearScene()
        poppedBubbles = 0
        scoreLabel.text = generateScoreString(total: 0, popped: poppedBubbles)
        unpauseGame()
    }
    
    @IBAction func openMenu(_ sender: UIButton) {
        pauseGame()
        showMenuScreen()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameOverViewController = segue.destination as? GameOverViewController {
            gameOverViewController.score = poppedBubbles
            gameOverViewController.onDismiss = {
                self.poppedBubbles = 0
                self.unpauseGame()
            }
        }
        if let menuViewController = segue.destination as? MenuViewController {
            menuViewController.onDismiss = {
                self.unpauseGame()
            }
            menuViewController.onNewGame = {
                self.restartGame()
            }
        }
    }
    
    func pauseSession() {
        sceneView.session.pause()
    }
    
    func runSession() {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
}

 // MARK: - ARSKViewDelegate
extension GameViewController {
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        return BubbleNode()
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        pauseSession()
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        runSession()
    }
    
}

// MARK: - ScoreUpdaterDelegate
extension GameViewController: ScoreUpdaterDelegate {
    func updateScore(total: Int, justPopped: Int) {
        poppedBubbles += justPopped
        fillScoreLabel(total: total, popped: poppedBubbles)
    }
}

// MARK: - Navigation
extension GameViewController {
    func showMenuScreen() {
        performSegue(withIdentifier: Constants.Navigation.showMenuSegueName, sender: self)
    }
    
    func showGameOverScreen() {
        performSegue(withIdentifier: Constants.Navigation.showGameOverSegueName, sender: self)
    }
}

/// - BLUR
/// - Spawning faster
