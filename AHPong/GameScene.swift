//
//  GameScene.swift
//  AHPong
//
//  Created by Andrea Houg on 2/21/15.
//  Copyright (c) 2015 a. All rights reserved.
//

struct PhysicsCategory {
    static let None     : UInt32 = 0
    static let All      : UInt32 = UInt32.max
    static let Paddle   : UInt32 = 0b1
    static let Ball     : UInt32 = 0b10
}

import SpriteKit

let kPaddleWidth:CGFloat = 20
let kPaddleHeight:CGFloat = 60
let kBallDiameter:CGFloat = 20
let startingVx:CGFloat = 130
let startingVy:CGFloat = -130

class GameScene: SKScene, SKPhysicsContactDelegate {

    let paddleLeft = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(kPaddleWidth, kPaddleHeight))
    let paddleRight = SKSpriteNode(color:UIColor.redColor(), size: CGSizeMake(kPaddleWidth, kPaddleHeight))
    let ball = SKShapeNode(circleOfRadius: kBallDiameter/2)
    
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = UIColor.blackColor()

        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self;
        
        //ball
        ball.fillColor = UIColor.whiteColor()
        ball.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(kBallDiameter, kBallDiameter))
        ball.physicsBody?.dynamic = true
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.Paddle
        ball.physicsBody?.collisionBitMask = PhysicsCategory.None //i think i want to handle this myself
        ball.position = CGPoint(x: size.width / 2, y: size.height + kBallDiameter)
        addChild(ball)
        
        paddleLeft.physicsBody = SKPhysicsBody(rectangleOfSize: paddleLeft.size);
        paddleLeft.physicsBody?.dynamic = true
        paddleLeft.physicsBody?.categoryBitMask = PhysicsCategory.Paddle
        paddleLeft.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        paddleLeft.physicsBody?.collisionBitMask = PhysicsCategory.None
        paddleLeft.position = CGPoint(x: size.width / 20, y: size.height / 2)
        addChild(paddleLeft)

        paddleRight.physicsBody = SKPhysicsBody(rectangleOfSize: paddleRight.size);
        paddleRight.physicsBody?.dynamic = true
        paddleRight.physicsBody?.categoryBitMask = PhysicsCategory.Paddle
        paddleRight.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        paddleRight.physicsBody?.collisionBitMask = PhysicsCategory.None
        paddleRight.position = CGPoint(x: size.width - (size.width / 20), y: size.height / 2)
        addChild(paddleRight)
        
        startGame()
        
    }
    
    func startGame() {
        ball.physicsBody?.velocity = CGVectorMake(startingVx, startingVy);
    }
        
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
     
    }

    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}
