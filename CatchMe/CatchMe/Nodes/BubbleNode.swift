//
//  BubbleNode.swift
//  CatchMe
//
//  Created by Nadia on 3/23/20.
//  Copyright © 2020 Nadzeya. All rights reserved.
//

import ARKit

class BubbleNode: SKSpriteNode {
    let bubbleTextureName = "bubble"
    let minimumScale = 8
    let maximumScale = 16
    
    var isMoving = false
    
    init() {
        let texture = SKTexture(imageNamed: bubbleTextureName)
        super.init(texture: texture, color: .clear, size: texture.size())
 
        self.name = bubbleTextureName
        self.size = generateSize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func generateSize() -> CGSize {
        let scaleNumber = CGFloat(Int.random(in: minimumScale ..< maximumScale))
        return CGSize(width: size.width / scaleNumber, height: size.height / scaleNumber)
    }
}
