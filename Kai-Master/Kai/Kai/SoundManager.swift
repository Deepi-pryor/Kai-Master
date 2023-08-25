//
//  SoundManager.swift
//  Kai
//
//  Created by Deepi Pryor on 8/17/23.
//

import SpriteKit

extension GameScene {
    
    // Play sound effect
    func playSoundEffect(_ soundFileName: String) {
        run(SKAction.playSoundFileNamed("sounds/\(soundFileName)", waitForCompletion: false))
    }
    
    // Play jump sound effect
    func playJumpSound() {
        playSoundEffect("jump")
    }
    
    // Play die sound effect
    func playDieSound() {
        playSoundEffect("die")
    }
    
    // ... (other sound-related methods)
    
}
