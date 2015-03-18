//
//  GameScene.swift
//  FlappyBird
//
//  Created by Rommel Rico on 3/17/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var pipe1 = SKSpriteNode()
    var pipe2 = SKSpriteNode()
    var labelHolder = SKSpriteNode()
    
    let BIRD_GROUP: UInt32 = 1
    let OBJECT_GROUP: UInt32 = 2
    let GAP_GROUP: UInt32 = 0 << 3
    
    var gameOver = 0
    
    var movingObjects = SKNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //Set up physics
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -5)
        
        //Add the moving Objects node (contains the pipes)
        self.addChild(movingObjects)
        
        //Set the label for the score.
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
        scoreLabel.zPosition = 10
        self.addChild(scoreLabel)
        
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
        bird.physicsBody?.categoryBitMask = BIRD_GROUP
        bird.physicsBody?.collisionBitMask = GAP_GROUP
        bird.physicsBody?.contactTestBitMask = OBJECT_GROUP
        
        //Add the bird
        self.addChild(bird)
        
        //Set a timer 
        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
        
        //Set the Background
        makeBackground()
        
        //Set the game over label
        self.addChild(labelHolder)
        
        //Define the ground.
        var ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = OBJECT_GROUP
        self.addChild(ground)
        
        //Define the ceiling.
        var ceiling = SKNode()
        ceiling.position = CGPointMake(0, self.frame.size.height)
        ceiling.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ceiling.physicsBody?.dynamic = false
        ceiling.physicsBody?.categoryBitMask = OBJECT_GROUP
        self.addChild(ceiling)
        
    }
    
    func makeBackground() {
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
            movingObjects.addChild(bg)
            bg.runAction(moveBgForever)
            
        }
    }
    
    func makePipes() {
        
        if gameOver == 0 {
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
            pipe1.physicsBody?.categoryBitMask = OBJECT_GROUP
            pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2.size)
            pipe2.physicsBody?.dynamic = false
            pipe2.physicsBody?.categoryBitMask = OBJECT_GROUP
            movingObjects.addChild(pipe1)
            movingObjects.addChild(pipe2)
            
            //Define the gap between the pipes for scoring.
            var gap = SKNode()
            gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeOffset)
            gap.runAction(moveAndRemovePipes)
            gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width, gapHeight))
            gap.physicsBody?.dynamic = false
            gap.physicsBody?.collisionBitMask = GAP_GROUP
            gap.physicsBody?.categoryBitMask = GAP_GROUP
            gap.physicsBody?.contactTestBitMask = BIRD_GROUP
            movingObjects.addChild(gap)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        //Collision between BIRD_GROUP and OBJECT_GROUP
        if contact.bodyA.categoryBitMask == GAP_GROUP || contact.bodyB.categoryBitMask == GAP_GROUP {
            //Add points
            score++
            scoreLabel.text = "\(score)"
        } else {
            if gameOver == 0 {
                gameOver = 1
                movingObjects.speed = 0
                
                //Set the label for game over.
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.fontSize = 30
                gameOverLabel.text = "Game Over! Tap to play again."
                gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                gameOverLabel.zPosition = 10
                labelHolder.addChild(gameOverLabel)
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if (gameOver == 0) {
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
        } else {
            //Restart the game
            score = 0
            scoreLabel.text = "0"
            movingObjects.removeAllChildren()
            makeBackground()
            bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            labelHolder.removeAllChildren()
            gameOver = 0
            movingObjects.speed = 1
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
