//
//  GameScene.swift
//  FlappyBird
//
//  Created by Rommel Rico on 3/17/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var bird = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //Set the bird textures.
        var birdTexture = SKTexture(imageNamed: "FlappyBirdImages/flappy1.png")
        var birdTexture2 = SKTexture(imageNamed: "FlappyBirdImages/flappy2.png")
        
        //Set the flap animations.
        var animation = SKAction.animateWithTextures([birdTexture, birdTexture2], timePerFrame: 0.1)
        var makeBirdFlap = SKAction.repeatActionForever(animation)
        
        //Initialize the bird Sprite Node, set its position and animation.
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.runAction(makeBirdFlap)
        
        self.addChild(bird)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
