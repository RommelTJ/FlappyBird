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
    var pipe1 = SKSpriteNode()
    var pipe2 = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //Define Flappy Bird
        //Set the bird textures.
        var birdTexture = SKTexture(imageNamed: "FlappyBirdImages/flappy1.png")
        var birdTexture2 = SKTexture(imageNamed: "FlappyBirdImages/flappy2.png")

        //Set the flap animations.
        var animation = SKAction.animateWithTextures([birdTexture, birdTexture2], timePerFrame: 0.1)
        var makeBirdFlap = SKAction.repeatActionForever(animation)
        
        //Initialize the bird Sprite Node, sprite position, animation, and zPosition
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.runAction(makeBirdFlap)
        bird.zPosition = 10
        
        //Set physics
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        
        //Add the bird
        self.addChild(bird)
        
        //Set a timer 
        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
        
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
        
        //Define the ground.
        var ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false
        self.addChild(ground)
        
        //Define the ceiling.
        var ceiling = SKNode()
        ceiling.position = CGPointMake(0, self.frame.size.height)
        ceiling.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ceiling.physicsBody?.dynamic = false
        self.addChild(ceiling)
        
    }
    
    func makePipes() {
        //Define the gap between pipes
        let gapHeight = bird.size.height * 4 //Gap of 4 birds
        var movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        var pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
        
        //Move the pipes
        var movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width/100))
        var removePipes = SKAction.removeFromParent()
        var moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        //Adding the pipes
        var pipe1Texture = SKTexture(imageNamed: "FlappyBirdImages/pipe1.png")
        var pipe2Texture = SKTexture(imageNamed: "FlappyBirdImages/pipe2.png")
        pipe1 = SKSpriteNode(texture: pipe1Texture)
        pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipe1.size.height / 2 + gapHeight / 2 + pipeOffset)
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipe2.size.height / 2 - gapHeight / 2 + pipeOffset)
        pipe1.runAction(moveAndRemovePipes)
        pipe2.runAction(moveAndRemovePipes)
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipe1.size)
        pipe1.physicsBody?.dynamic = false
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2.size)
        pipe2.physicsBody?.dynamic = false
        self.addChild(pipe1)
        self.addChild(pipe2)
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
