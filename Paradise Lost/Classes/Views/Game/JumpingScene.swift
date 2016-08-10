//
//  JumpingScene.swift
//  Paradise Lost
//
//  Created by jason on 5/7/2016.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

protocol JumpingSceneDelegate {
    func exitGame()
}

class JumpingScene: SKScene, SKPhysicsContactDelegate {
    
    var actionDelegate: JumpingSceneDelegate? = nil
    
    private let player = SKSpriteNode(imageNamed: "player")
    private let motionManager = CMMotionManager()
    private var exitButton = SKLabelNode()
    
    private let MaxPlayerVelocityX: CGFloat = 600
    
    private struct BodyMask {
        static let player: UInt32 = 1 << 0
        static let boder: UInt32 = 1 << 1
    }
    
    // MARK: life cycle
    
    deinit {
        stopMonitoringAccelertation()
    }
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        
        // title
        let title = SKLabelNode(fontNamed: "Chalkduster")
        title.text = LanguageManager.getAppLanguageString("game.jumping.title.text")
        title.fontSize = 25
        title.fontColor = SKColor.blackColor()
        title.position = CGPoint(x: size.width / 2, y: size.height - 64)
        addChild(title)
        
        // button
        exitButton = SKLabelNode(fontNamed: "BradleyHandITCTT-Bold")
        exitButton.text = LanguageManager.getAppLanguageString("game.jumping.exitbutton.text")
        exitButton.fontSize = 15
        exitButton.fontColor = SKColor.blackColor()
        exitButton.position = CGPoint(x: size.width - 60, y: size.height - 84)
        addChild(exitButton)
        
        // player
        player.position = CGPoint(x: size.width / 2, y: size.height / 2)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height * 0.8)
        player.physicsBody?.friction = 0
        player.physicsBody?.restitution = 1.0
        player.physicsBody?.linearDamping = 0
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.mass = 0.5
        //player.physicsBody?.categoryBitMask = BodyMask.player
        addChild(player)
        
        // border
        let boderBody = SKPhysicsBody(edgeLoopFromRect: frame)
        boderBody.friction = 0
        //boderBody.categoryBitMask = BodyMask.boder
        physicsBody = boderBody
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.speed = 1.0
        physicsWorld.contactDelegate = self
        
        motionManager.accelerometerUpdateInterval = 0.2
        startMonitoringAccelertation()
        
        // TODO: add SKAction of platform
    }
    
    override func update(currentTime: NSTimeInterval) {
        updatePlayerAccelerationFromMotionManager()
        //updatePlayer()
    }
    
    // MARK: event reponse
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if exitButton.containsPoint(location) {
                actionDelegate?.exitGame()
            }
        }
    }
    
    func startMonitoringAccelertation() {
        if motionManager.accelerometerAvailable {
            motionManager.startAccelerometerUpdates()
        }
    }
    
    func stopMonitoringAccelertation() {
        if motionManager.accelerometerAvailable && motionManager.accelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    // MARK: private methods
    
    private func updatePlayerAccelerationFromMotionManager() {
        if let acceleration = motionManager.accelerometerData?.acceleration {
            player.physicsBody?.velocity.dx = MaxPlayerVelocityX * CGFloat(acceleration.x)
        }
    }
    
    private func updatePlayer() {
        // TODO:
    }
}
