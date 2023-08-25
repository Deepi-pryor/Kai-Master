//
//  GameNodeManager.swift
//  Kai
//
//  Created by Deepi Pryor on 8/17/23.
//

import SpriteKit

extension GameScene {
    
    func setupNodes() {
        // Initialize and add nodes to appropriate parent nodes
        
        // Ground Node
        groundNode = SKNode()
        groundNode.zPosition = backgroundZPosition
        createAndMoveGround()
        addCollisionToGround()
        
        // Background Node
        backgroundNode = SKNode()
        backgroundNode.zPosition = backgroundZPosition
        createMoon()
        createClouds()
        
        // Doggo Node
        doggoNode = SKNode()
        doggoNode.zPosition = foregroundZPosition
        createDoggo()
        
        // Other nodes (cacti, trees, birds, etc.)
        cactusNode = SKNode()
        cactusNode.zPosition = foregroundZPosition
        
        treeNode = SKNode()
        treeNode.zPosition = foregroundZPosition
        
        birdNode = SKNode()
        birdNode.zPosition = foregroundZPosition
        
        // Score Node
        score = 0
        scoreNode = SKLabelNode(fontNamed: "Arial")
        scoreNode.fontSize = 30
        scoreNode.zPosition = foregroundZPosition
        scoreNode.text = "Score: 0"
        scoreNode.fontColor = SKColor.gray
        scoreNode.position = CGPoint(x: 150, y: 100)
        
        // Reset Instructions Node
        resetInstructions = SKLabelNode(fontNamed: "Arial")
        resetInstructions.fontSize = 50
        resetInstructions.text = "Tap to Restart"
        resetInstructions.fontColor = SKColor.white
        resetInstructions.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        // Parent Game Node
        gameNode = SKNode()
        gameNode.addChild(groundNode)
        gameNode.addChild(backgroundNode)
        gameNode.addChild(doggoNode)
        gameNode.addChild(cactusNode)
        gameNode.addChild(treeNode)
        gameNode.addChild(birdNode)
        gameNode.addChild(scoreNode)
        gameNode.addChild(resetInstructions)
        self.addChild(gameNode)
    }
    
    func createAndMoveGround() {
        let screenWidth = self.frame.size.width
        
        //ground texture
        let groundTexture = SKTexture(imageNamed: "landscape/ground")
        groundTexture.filteringMode = .nearest
        
        let homeButtonPadding = 50.0 as CGFloat
        groundHeight = groundTexture.size().height + homeButtonPadding
        
        //ground actions
        let moveGroundLeft = SKAction.moveBy(x: -groundTexture.size().width,
                                             y: 0.0, duration: TimeInterval(screenWidth / groundSpeed))
        let resetGround = SKAction.moveBy(x: groundTexture.size().width, y: 0.0, duration: 0.0)
        let groundLoop = SKAction.sequence([moveGroundLeft, resetGround])
        
        //ground nodes
        let numberOfGroundNodes = 1 + Int(ceil(screenWidth / groundTexture.size().width))
        
        for i in 0 ..< numberOfGroundNodes {
            let node = SKSpriteNode(texture: groundTexture)
            node.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            node.position = CGPoint(x: CGFloat(i) * groundTexture.size().width, y: groundHeight!)
            groundNode.addChild(node)
            node.run(SKAction.repeatForever(groundLoop))
        }
    }
    
    func addCollisionToGround() {
        let groundContactNode = SKNode()
        groundContactNode.position = CGPoint(x: 0, y: groundHeight! - 30)
        groundContactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width * 3,
                                                                          height: groundHeight!))
        groundContactNode.physicsBody?.friction = 0.0
        groundContactNode.physicsBody?.isDynamic = false
        groundContactNode.physicsBody?.categoryBitMask = groundCategory
        
        groundNode.addChild(groundContactNode)
    }
    
    func createMoon() {
        //texture
        let moonTexture = SKTexture(imageNamed: "landscape/moon")
        let moonScale = 3.0 as CGFloat
        moonTexture.filteringMode = .nearest
        
        //moon sprite
        let moonSprite = SKSpriteNode(texture: moonTexture)
        moonSprite.setScale(moonScale)
        //add to scene
        backgroundNode.addChild(moonSprite)
        
        //animate the moon
        animateMoon(sprite: moonSprite, textureWidth: moonTexture.size().width * moonScale)
    }
    
    func animateMoon(sprite: SKSpriteNode, textureWidth: CGFloat) {
        let screenWidth = self.frame.size.width
        let screenHeight = self.frame.size.height
        
        let distanceOffscreen = 50.0 as CGFloat // want to start the moon offscreen
        let distanceBelowTop = 150 as CGFloat
        
        //moon actions
        let moveMoon = SKAction.moveBy(x: -screenWidth - textureWidth - distanceOffscreen,
                                       y: 0.0, duration: TimeInterval(screenWidth / moonSpeed))
        let resetMoon = SKAction.moveBy(x: screenWidth + distanceOffscreen, y: 0.0, duration: 0)
        let moonLoop = SKAction.sequence([moveMoon, resetMoon])
        
        sprite.position = CGPoint(x: screenWidth + distanceOffscreen, y: screenHeight - distanceBelowTop)
        sprite.run(SKAction.repeatForever(moonLoop))
    }
    
    func createClouds() {
        //texture
        let cloudTexture = SKTexture(imageNamed: "landscape/cloud")
        let cloudScale = 3.0 as CGFloat
        cloudTexture.filteringMode = .nearest
        
        //clouds
        let numClouds = 3
        for i in 0 ..< numClouds {
            //create sprite
            let cloudSprite = SKSpriteNode(texture: cloudTexture)
            cloudSprite.setScale(cloudScale)
            //add to scene
            backgroundNode.addChild(cloudSprite)
            
            //animate the cloud
            animateCloud(cloudSprite, cloudIndex: i, textureWidth: cloudTexture.size().width * cloudScale)
        }
    }
    
    func animateCloud(_ sprite: SKSpriteNode, cloudIndex i: Int, textureWidth: CGFloat) {
        let screenWidth = self.frame.size.width
        let screenHeight = self.frame.size.height
        
        let cloudOffscreenDistance = (screenWidth / 3.0) * CGFloat(i) + 100 as CGFloat
        let cloudYPadding = 50 as CGFloat
        let cloudYPosition = screenHeight - (CGFloat(i) * cloudYPadding) - 200
        
        let distanceToMove = screenWidth + cloudOffscreenDistance + textureWidth
        
        //actions
        let moveCloud = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(distanceToMove / cloudSpeed))
        let resetCloud = SKAction.moveBy(x: distanceToMove, y: 0.0, duration: 0.0)
        let cloudLoop = SKAction.sequence([moveCloud, resetCloud])
        
        sprite.position = CGPoint(x: screenWidth + cloudOffscreenDistance, y: cloudYPosition)
        sprite.run(SKAction.repeatForever(cloudLoop))
    }
    
    func createDoggo() {
        let screenWidth = self.frame.size.width
        let dogScale = 4.0 as CGFloat
        
        //textures
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
        
        dogSprite = SKSpriteNode()
        dogSprite.size = dogTexture1.size()
        dogSprite.setScale(dogScale)
        doggoNode.addChild(dogSprite)
        
        let physicsBox = CGSize(width: dogTexture1.size().width * dogScale,
                                height: dogTexture1.size().height * dogScale)
        
        dogSprite.physicsBody = SKPhysicsBody(rectangleOf: physicsBox)
        dogSprite.physicsBody?.isDynamic = true
        dogSprite.physicsBody?.mass = 1.0
        dogSprite.physicsBody?.categoryBitMask = dogCategory
        dogSprite.physicsBody?.contactTestBitMask = birdCategory | cactusCategory
        dogSprite.physicsBody?.collisionBitMask = groundCategory
        
        dogYPosition = getGroundHeight() + dogTexture1.size().height * dogScale
        dogSprite.position = CGPoint(x: screenWidth * 0.15, y: dogYPosition!)
        dogSprite.run(SKAction.repeatForever(runningAnimation))
    }
    
    func spawnCactus() {
        let cactusTextures = ["cactus2", "cactus3", "doubleCactus", "tripleCactus"]
        let cactusScale = 3.0 as CGFloat
        
        //texture
        let cactusTexture = SKTexture(imageNamed: "cacti/" + cactusTextures.randomElement()!)
        cactusTexture.filteringMode = .nearest
        
        //sprite
        let cactusSprite = SKSpriteNode(texture: cactusTexture)
        cactusSprite.setScale(cactusScale)
        
        //physics
        let contactBox = CGSize(width: cactusTexture.size().width * cactusScale,
                                height: cactusTexture.size().height * cactusScale)
        cactusSprite.physicsBody = SKPhysicsBody(rectangleOf: contactBox)
        cactusSprite.physicsBody?.isDynamic = true
        cactusSprite.physicsBody?.mass = 1.0
        cactusSprite.physicsBody?.categoryBitMask = cactusCategory
        cactusSprite.physicsBody?.contactTestBitMask = dogCategory
        cactusSprite.physicsBody?.collisionBitMask = groundCategory
        
        //add to scene
        cactusNode.addChild(cactusSprite)
        //animate
        animateCactus(sprite: cactusSprite, texture: cactusTexture)
    }
    
    func animateCactus(sprite: SKSpriteNode, texture: SKTexture) {
        let screenWidth = self.frame.size.width
        let distanceOffscreen = 50.0 as CGFloat
        let distanceToMove = screenWidth + distanceOffscreen + texture.size().width
        
        //actions
        let moveCactus = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(screenWidth / groundSpeed))
        let removeCactus = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([moveCactus, removeCactus])
        
        sprite.position = CGPoint(x: distanceToMove, y: getGroundHeight() + texture.size().height)
        sprite.run(moveAndRemove)
    }
    
    func spawnTree() {
        let treeTextures = ["bark1", "bark2"]
            let treeScale = 3.0 as CGFloat
            
            //texture
        let treeTexture = SKTexture(imageNamed: "tree/" + treeTextures.randomElement()!)
            treeTexture.filteringMode = .nearest
            
            //sprite
            let treeSprite = SKSpriteNode(texture: treeTexture)
            treeSprite.setScale(treeScale)
            
            //physics
            let contactBox = CGSize(width: treeTexture.size().width * treeScale,
                                    height: treeTexture.size().height * treeScale)
            treeSprite.physicsBody = SKPhysicsBody(rectangleOf: contactBox)
            treeSprite.physicsBody?.isDynamic = true
           treeSprite.physicsBody?.mass = 1.0
           treeSprite.physicsBody?.categoryBitMask = treeCategory
           treeSprite.physicsBody?.contactTestBitMask = dogCategory
           treeSprite.physicsBody?.collisionBitMask = groundCategory
            
            //add to scene
            treeNode.addChild(treeSprite)
            //animate
            animateTree(sprite: treeSprite, texture: treeTexture)
    }
    
    func animateTree(sprite: SKSpriteNode, texture: SKTexture) {
        let screenWidth = self.frame.size.width
        let distanceOffscreen = 50.0 as CGFloat
        let distanceToMove = screenWidth + distanceOffscreen + texture.size().width
        
        //actions
        let moveTree = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(screenWidth / groundSpeed))
        let removeTree = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([moveTree, removeTree])
        
        sprite.position = CGPoint(x: distanceToMove, y: getGroundHeight() + texture.size().height)
        sprite.run(moveAndRemove)
    }
    
    func spawnBird() {
        //textures
        let birdTexture1 = SKTexture(imageNamed: "doggo/flyer1")
        let birdTexture2 = SKTexture(imageNamed: "doggo/flyer2")
        let birdScale = 3.0 as CGFloat
        birdTexture1.filteringMode = .nearest
        birdTexture2.filteringMode = .nearest
        
        //animation
        let screenWidth = self.frame.size.width
        let distanceOffscreen = 50.0 as CGFloat
        let distanceToMove = screenWidth + distanceOffscreen + birdTexture1.size().width * birdScale
        
        let flapAnimation = SKAction.animate(with: [birdTexture1, birdTexture2], timePerFrame: 0.5)
        let moveBird = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(screenWidth / groundSpeed))
        let removeBird = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([moveBird, removeBird])
        
        //sprite
        let birdSprite = SKSpriteNode()
        birdSprite.size = birdTexture1.size()
        birdSprite.setScale(birdScale)
        
        //physics
        let birdContact = CGSize(width: birdTexture1.size().width * birdScale,
                                 height: birdTexture1.size().height * birdScale)
        birdSprite.physicsBody = SKPhysicsBody(rectangleOf: birdContact)
        birdSprite.physicsBody?.isDynamic = false
        birdSprite.physicsBody?.mass = 1.0
        birdSprite.physicsBody?.categoryBitMask = birdCategory
        birdSprite.physicsBody?.contactTestBitMask = dogCategory
        
        birdSprite.position = CGPoint(x: distanceToMove,
                                      y: getGroundHeight() + birdTexture1.size().height * birdScale + 20)
        birdSprite.run(SKAction.group([moveAndRemove, SKAction.repeatForever(flapAnimation)]))
        
        //add to scene
        birdNode.addChild(birdSprite)
    }
    
    func getGroundHeight() -> CGFloat {
        if let gHeight = groundHeight {
            return gHeight
        } else {
            print("Ground size wasn't previously calculated")
            exit(0)
        }
    }
    
    // ... (other methods related to node creation)
    
}
