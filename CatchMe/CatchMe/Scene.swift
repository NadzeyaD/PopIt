//
//  Scene.swift
//  CatchMe
//
//  Created by Nadia on 3/23/20.
//  Copyright © 2020 Nadzeya. All rights reserved.
//

import SpriteKit
import ARKit

enum TransformConstants {
    static let initialDistance: Float = -0.3
    
    // Z transforms
    static let initialDistanceZ: Float = -0.3
    static let minimumScaleZ = 1
    static let maximumScaleZ = 3
    
    // X transforms
    static let startValueX: Float = 0.0
    static let initialDistanceKoefX: Float = 0.2
    static let minimumScaleX = -2
    static let maximumScaleX = 3
    
    // Y transforms
    static let startValueY: Float = 0.0
    static let initialDistanceKoefY: Float = 0.1
    static let minimumScaleY = -2
    static let maximumScaleY = 2
}

class Scene: SKScene {
    var timeIntPrev: TimeInterval!
    
    var scoreUpdater: ScoreUpdaterDelegate!
    
    let spawnSpeed = 1.2
    let popSound = SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false)
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if timeIntPrev == nil || (currentTime - timeIntPrev > spawnSpeed) {
            timeIntPrev = currentTime
            
            generateAnchor()
            scoreUpdater.updateScore(total: children.count, justPopped: 0)
        }

        for node in children {
            startMoving(time: 5, node: node)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView,
              let location = touches.first?.location(in: sceneView) else { return }
        
        let hitNodes = nodes(at: location)

        if let node = hitNodes.first,
           let anchor = sceneView.anchor(for: node) {
            run(popSound)
            sceneView.session.remove(anchor: anchor)
        }

        scoreUpdater.updateScore(total: children.count, justPopped: hitNodes.count)
    }
    
    func generateAnchor() {
        guard let sceneView = self.view as? ARSKView else { return }
        
        if let currentFrame = sceneView.session.currentFrame {
            var translation = matrix_identity_float4x4
             
            translation.columns.3.z = transformAxes(minimumTransformScale: TransformConstants.minimumScaleZ, maximumTransformScale: TransformConstants.maximumScaleZ)
            
            
            translation.columns.3.x = transformAxes(startValue: TransformConstants.startValueX, initalDistance: TransformConstants.initialDistanceKoefX, minTransformScale: TransformConstants.minimumScaleX, maxTransformScale: TransformConstants.maximumScaleX)
            translation.columns.3.y = transformAxes(startValue: TransformConstants.startValueY, initalDistance: TransformConstants.initialDistanceKoefY, minTransformScale: TransformConstants.minimumScaleY, maxTransformScale: TransformConstants.maximumScaleY)
                       
            let transform = simd_mul(currentFrame.camera.transform, translation)

            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
        }
    }
    // 
    func startMoving(time: TimeInterval, node: SKNode) {
        guard let bubbleNode = node as? BubbleNode, !bubbleNode.isMoving else { return }
        // let scale = SKAction.scale(to: node.position.x + 4, duration: time)
        let rotate = SKAction.rotate(toAngle: .pi / 4, duration: 2)
        //  let move = SKAction.moveBy(x: 5000, y: 0, duration: 15)
        // (to: CGPoint(x: node.position.x + 0.8, y: node.position.y + 1), duration: time)

        //  let scaleBack = SKAction.scale(to: start.xScale, duration: time)
        let rotateBack = SKAction.rotate(toAngle: .pi / 2, duration: 2)
     //   let moveBack = SKAction.moveBy(x: -50000, y: 0, duration: 15)
        
        let action = SKAction.repeatForever(.sequence([
            .group([rotate]),
            .group([rotateBack])
            ]))
        bubbleNode.isMoving = true
        bubbleNode.removeAllActions()
        bubbleNode.run(action)
    }
    
    
    func transformAxes(minimumTransformScale: Int, maximumTransformScale: Int) -> Float {
        let transformScale = generateRandomScale(minTransformScale: minimumTransformScale, maxTransformScale: maximumTransformScale)
        return TransformConstants.initialDistance * transformScale
    }
    
    func transformAxes(startValue: Float, initalDistance: Float, minTransformScale: Int, maxTransformScale: Int) -> Float {
        let transformScale = generateRandomScale(minTransformScale: minTransformScale, maxTransformScale: maxTransformScale)
        return startValue + initalDistance * transformScale
    }
    
    func generateRandomScale(minTransformScale: Int, maxTransformScale: Int) -> Float {
        return Float(Int.random(in: minTransformScale ..< maxTransformScale))
    }
    
    func onUnpause() {
        timeIntPrev = nil
    }
}

protocol ScoreUpdaterDelegate: class {
    func updateScore(total: Int, justPopped: Int)
}
