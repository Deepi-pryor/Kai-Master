//
//  GameScene.swift
//  Kai
//
//  Created by Deepi Pryor on 8/17/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    // Nodes
    var gameNode: SKNode!
    var groundNode: SKNode!
    var backgroundNode: SKNode!
    var cactusNode: SKNode!
    var doggoNode: SKNode!
    var birdNode: SKNode!
    var treeNode: SKNode!
    
    // Score
    var scoreNode: SKLabelNode!
    var resetInstructions: SKLabelNode!
    var score = 0 as Int
    
    // Sound effects
    let jumpSound = SKAction.playSoundFileNamed("sounds/jump", waitForCompletion: false)
    let dieSound = SKAction.playSoundFileNamed("sounds/die", waitForCompletion: false)
    
    // Sprites
    var dogSprite: SKSpriteNode!
    
    // Spawning variables
    var spawnRate = 1.5 as Double
    var timeSinceLastSpawn = 0.0 as Double
    var spawnRandom = 3.0 as Double
    
    // Generic variables
    var groundHeight: CGFloat?
    var dogYPosition: CGFloat?
    var groundSpeed = 500 as CGFloat
    
    // Constants
    let dogHopForce = 700 as Int
    let cloudSpeed = 50 as CGFloat
    let moonSpeed = 10 as CGFloat
    
    let backgroundZPosition = 0 as CGFloat
    let foregroundZPosition = 1 as CGFloat
    
    // Collision categories
    let groundCategory = 1 << 0 as UInt32
    let dogCategory = 1 << 1 as UInt32
    let cactusCategory = 1 << 2 as UInt32
    let birdCategory = 1 << 3 as UInt32
    let treeCategory = 1 << 2 as UInt32
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        
        setupNodes() // Call this method to set up game nodes
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(gameNode.speed < 1.0){
            resetGame()
            return
        }
        
        for _ in touches {
            if let groundPosition = dogYPosition {
                if dogSprite.position.y <= groundPosition && gameNode.speed > 0 {
                    dogSprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: dogHopForce))
                    run(jumpSound)
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameNode.speed > 0 {
            groundSpeed += 0.2
            
            score += 1
            scoreNode.text = "Score: \(score / 5)"
            
            if currentTime - timeSinceLastSpawn > spawnRate {
                timeSinceLastSpawn = currentTime
                spawnRate = Double.random(in: 1.0 ..< 3.5)
                spawnRandom = Double.random(in: 0.0...1.0) // Random value between 0.0 and 1.0
                
                if spawnRandom <= 0.33 {
                    spawnCactus()
                } else if spawnRandom <= 0.66 {
                    spawnBird()
                } else {
                    spawnTree()
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if(hitCactus(contact) || hitBird(contact)){
            run(dieSound)
            gameOver()
        }
    }
    
    func hitCactus(_ contact: SKPhysicsContact) -> Bool {
        return contact.bodyA.categoryBitMask & cactusCategory == cactusCategory ||
        contact.bodyB.categoryBitMask & cactusCategory == cactusCategory
    }
    
    func hitBird(_ contact: SKPhysicsContact) -> Bool {
        return contact.bodyA.categoryBitMask & birdCategory == birdCategory ||
        contact.bodyB.categoryBitMask & birdCategory == birdCategory
    }
    
    func resetGame() {
        gameNode.speed = 1.0
        timeSinceLastSpawn = 0.0
        groundSpeed = 500
        score = 0
        
        cactusNode.removeAllChildren()
        birdNode.removeAllChildren()
        
        resetInstructions.fontColor = SKColor.white
        
        let dogTexture1 = SKTexture(imageNamed: "doggo/dogOne")
        let dogTexture2 = SKTexture(imageNamed: "doggo/dogTwo")
        let dogTexture3 = SKTexture(imageNamed: "doggo/dogThree")
        let dogTexture4 = SKTexture(imageNamed: "doggo/dogFour")
        let dogTexture5 = SKTexture(imageNamed: "doggo/dogFive")
        let dogTexture6 = SKTexture(imageNamed: "doggo/dogSix")
        let dogTexture7 = SKTexture(imageNamed: "doggo/dogSeven")
        let dogTexture8 = SKTexture(imageNamed: "doggo/dogEight")
        
        
        dogTexture1.filteringMode = .nearest
        dogTexture2.filteringMode = .nearest
        dogTexture3.filteringMode = .nearest
        dogTexture4.filteringMode = .nearest
        dogTexture5.filteringMode = .nearest
        dogTexture6.filteringMode = .nearest
        dogTexture7.filteringMode = .nearest
        dogTexture8.filteringMode = .nearest
        
        
        let runningAnimation = SKAction.animate(with: [dogTexture1, dogTexture2, dogTexture3, dogTexture4, dogTexture5, dogTexture6, dogTexture7, dogTexture8], timePerFrame: 0.12)
        
        dogSprite.position = CGPoint(x: self.frame.size.width * 0.15, y: dogYPosition!)
        dogSprite.run(SKAction.repeatForever(runningAnimation))
    }
    
    func gameOver() {
        gameNode.speed = 0.0
        
        resetInstructions.fontColor = SKColor.gray
        
        let deaddogTexture = SKTexture(imageNamed: "doggo/dogDead")
        deaddogTexture.filteringMode = .nearest
        
        dogSprite.removeAllActions()
        dogSprite.texture = deaddogTexture
    }
    
}
