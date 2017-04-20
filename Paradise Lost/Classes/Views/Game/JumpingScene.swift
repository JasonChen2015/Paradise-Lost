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
    
    fileprivate let player = SKSpriteNode(imageNamed: "player")
    fileprivate let motionManager = CMMotionManager()
    fileprivate var exitButton = SKLabelNode()
    
    fileprivate let MaxPlayerVelocityX: CGFloat = 600
    
    fileprivate struct BodyMask {
        static let player: UInt32 = 1 << 0
        static let boder: UInt32 = 1 << 1
    }
    
    // MARK: life cycle
    
    deinit {
        stopMonitoringAccelertation()
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        // title
        let title = SKLabelNode(fontNamed: "Chalkduster")
        title.text = LanguageManager.getGameString(forKey: "jumping.title.text")
        title.fontSize = 25
        title.fontColor = SKColor.black
        title.position = CGPoint(x: size.width / 2, y: size.height - 64)
        addChild(title)
        
        // button
        exitButton = SKLabelNode(fontNamed: "BradleyHandITCTT-Bold")
        exitButton.text = LanguageManager.getPublicString(forKey: "exit")
        exitButton.fontSize = 15
        exitButton.fontColor = SKColor.black
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
        let boderBody = SKPhysicsBody(edgeLoopFrom: frame)
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
    
    override func update(_ currentTime: TimeInterval) {
        updatePlayerAccelerationFromMotionManager()
        //updatePlayer()
    }
    
    // MARK: event reponse
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if exitButton.contains(location) {
                actionDelegate?.exitGame()
            }
        }
    }
    
    func startMonitoringAccelertation() {
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates()
        }
    }
    
    func stopMonitoringAccelertation() {
        if motionManager.isAccelerometerAvailable && motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    // MARK: private methods
    
    fileprivate func updatePlayerAccelerationFromMotionManager() {
        if let acceleration = motionManager.accelerometerData?.acceleration {
            player.physicsBody?.velocity.dx = MaxPlayerVelocityX * CGFloat(acceleration.x)
        }
    }
    
    fileprivate func updatePlayer() {
        // TODO:
    }
}
