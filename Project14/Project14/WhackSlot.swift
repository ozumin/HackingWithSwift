//
//  WhackSlot.swift
//  Project14
//
//  Created by Mizuo Nagayama on 2021/04/06.
//
import SpriteKit
import UIKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    var isVisible = false
    var isHit = false

    func configure(at position: CGPoint) {
        self.position = position

        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)

        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")

        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)

        addChild(cropNode)
    }

    func show(hideTime: Double) {
        if isVisible { return }

        charNode.xScale = 1
        charNode.yScale = 1

        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false

        if let mudParticle = SKEmitterNode(fileNamed: "mudParticle") {
            mudParticle.position = CGPoint(x: charNode.xScale, y: charNode.yScale - 20)
            mudParticle.zPosition = 1
            addChild(mudParticle)
        }

        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)){ [weak self] in
            self?.hide()
        }
    }

    func hide() {
        if !isVisible { return }

        if let mudParticle = SKEmitterNode(fileNamed: "mudParticle") {
            mudParticle.position = CGPoint(x: charNode.xScale, y: charNode.yScale + 10)
            mudParticle.zPosition = 0
            addChild(mudParticle)
        }

        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }

    func hit() {
        isHit = true

        if let smokeParticle = SKEmitterNode(fileNamed: "smokeParticle") {
            smokeParticle.position = charNode.position
            smokeParticle.zPosition = 1
            addChild(smokeParticle)
        }

        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in
            self?.isVisible = false
        }
        let sequence = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequence)
    }
}
