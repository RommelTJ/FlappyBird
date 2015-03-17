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
    var bg = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //Set the background.
        var bgTexture = SKTexture(imageNamed: "FlappyBirdImages/bg.png")
        var movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        var replaceBg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        var moveBgForever = SKAction.repeatActionForever(SKAction.sequence([movebg, replaceBg]))

        //Looping the Background
        for var i:CGFloat=0; i<3; i++ {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            self.addChild(bg)
            bg.runAction(moveBgForever)
            
        }
        
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
        
        //Set physics
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        
        //Add the bird
        self.addChild(bird)
        
        //Define the ground.
        var ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false
        self.addChild(ground)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        bird.physicsBody?.velocity = CGVectorMake(0, 0)
        bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
