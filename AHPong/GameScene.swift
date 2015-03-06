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
    static let Ball     : UInt32 = 0b1
    static let Paddle   : UInt32 = 0b10
    static let Border   :UInt32 = 0b100
}

import SpriteKit

let kPaddleWidth:CGFloat = 20
let kPaddleHeight:CGFloat = 60
let kBallDiameter:CGFloat = 20
let initialSpeed:CGFloat = 130

class GameScene: SKScene, SKPhysicsContactDelegate {

    let paddleLeft = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(kPaddleWidth, kPaddleHeight))
    let paddleRight = SKSpriteNode(color:UIColor.redColor(), size: CGSizeMake(kPaddleWidth, kPaddleHeight))
    let ball = SKShapeNode(circleOfRadius: kBallDiameter/2)

    var leftScore = 0
    var rightScore = 0
    let rightScoreNode = SKLabelNode()
    let leftScoreNode = SKLabelNode()
    
    let messageLabel = SKLabelNode()
    let button = SKLabelNode(text: "OK")
    
    var startingVx:CGFloat = Int(arc4random_uniform(2)) > 0 ? -initialSpeed : initialSpeed
    var startingVy:CGFloat = -initialSpeed
    
    override func didMoveToView(view: SKView) {
        messageLabel.position = CGPoint(x: size.width/2, y: size.height - size.height/3)
        button.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundColor = UIColor.blackColor()

        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self;
        
        //border
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Border
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        //ball
        ball.fillColor = UIColor.whiteColor()
        ball.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(kBallDiameter, kBallDiameter))
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.dynamic = true
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.Paddle
        ball.physicsBody?.collisionBitMask = PhysicsCategory.None
        ball.position = CGPoint(x: size.width / 2, y: size.height + 1)
        addChild(ball)
        
        //paddles
        paddleLeft.physicsBody = SKPhysicsBody(rectangleOfSize: paddleLeft.size);
        paddleLeft.physicsBody?.dynamic = true
        paddleLeft.physicsBody?.categoryBitMask = PhysicsCategory.Paddle
        paddleLeft.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        paddleLeft.physicsBody?.collisionBitMask = PhysicsCategory.None
        paddleLeft.position = CGPoint(x: size.width / 20, y: size.height / 2)
        addChild(paddleLeft)

        paddleRight.physicsBody = SKPhysicsBody(rectangleOfSize: paddleRight.size);
        paddleRight.physicsBody?.dynamic = true
        paddleRight.physicsBody?.angularDamping = 0
        paddleRight.physicsBody?.categoryBitMask = PhysicsCategory.Paddle
        paddleRight.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        paddleRight.physicsBody?.collisionBitMask = PhysicsCategory.None
        paddleRight.position = CGPoint(x: size.width - (size.width / 20), y: size.height / 2)
        addChild(paddleRight)
        
        //labels
        var spacing = CGFloat(20)
        leftScoreNode.text = String(leftScore)
        leftScoreNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        leftScoreNode.position = CGPoint(x: size.width/2.0 - leftScoreNode.frame.size.width - spacing, y: size.height - leftScoreNode.frame.size.height - spacing)
        addChild(leftScoreNode)
        
        rightScoreNode.text = String(rightScore)
        rightScoreNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        rightScoreNode.position = CGPoint(x: size.width/2.0 + rightScoreNode.frame.size.width + spacing, y: size.height - rightScoreNode.frame.size.height - spacing)
        addChild(rightScoreNode)
        
        showMessage("Start game")
    }
    
    func showMessage(title: String) {
        messageLabel.text = title
        addChild(messageLabel)
        addChild(button)
    }
    
    func okClicked() {
        rightScore = 0
        rightScoreNode.text = String(rightScore)
        leftScore = 0
        leftScoreNode.text = String(leftScore)
        releaseBall()
    }
    
    func releaseBall() {
        let moveAction = SKAction.moveTo(CGPoint(x: size.width / 2, y: size.height + 1), duration: NSTimeInterval(0))
        let velocityAction = SKAction.runBlock { self.ball.physicsBody?.velocity = CGVectorMake(self.startingVx, self.startingVy); return () }
        ball.runAction(SKAction.sequence([moveAction, velocityAction]))
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = nodeAtPoint(location)
            if (node == button) {
                messageLabel.removeFromParent()
                button.removeFromParent()
                okClicked()
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch in touches {
            
            let touchLocation = touch.locationInNode(self)
            
            if (touchLocation.x < size.width/3) {
                paddleLeft.position.y = touchLocation.y;
            }
            else if (touchLocation.x > size.width - size.width/3) {
                paddleRight.position.y = touchLocation.y;
            }
        }
    }

    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Ball != 0) && (secondBody.categoryBitMask & PhysicsCategory.Paddle != 0)) {
            firstBody.velocity.dx = -firstBody.velocity.dx
        }
        
        else if ((firstBody.categoryBitMask & PhysicsCategory.Ball != 0) && (secondBody.categoryBitMask & PhysicsCategory.Border != 0)) {
            //check if left side
            if (firstBody.node?.position.x <= firstBody.node!.frame.size.width) {
                setScore(false)
            }
            //check if right side
            if (firstBody.node?.position.x >= (size.width - firstBody.node!.frame.size.width))
            {
                setScore(true)
            }
            else {
                firstBody.velocity.dy = -firstBody.velocity.dy

            }
        }
    }
    
    func setScore(leftPoint: Bool)
    {
        if (leftPoint) {
            leftScore++
            leftScoreNode.text = String(leftScore)
            startingVx = -initialSpeed
        }
        else {
            rightScore++
            rightScoreNode.text = String(rightScore)
            startingVx = initialSpeed
        }
        if (leftScore >= 10 || rightScore >= 10) {
            showMessage("Game over")
        }
        else {
            releaseBall()
        }
    }
}
