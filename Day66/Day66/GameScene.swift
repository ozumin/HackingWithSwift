//
//  GameScene.swift
//  Day66
//
//  Created by Mizuo Nagayama on 2021/04/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var scoreLabel: SKLabelNode!
    var pizzaTimer: Timer?
    var gameTimer: Timer?
    let velocityRange = 300...700
    let sizeRange = 0.1...0.3

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    override func didMove(to view: SKView) {
        backgroundColor = .black

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)

        score = 0

        pizzaTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(throwPizza), userInfo: nil, repeats: true)

        gameTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(gameOver), userInfo: nil, repeats: false)
    }

    @objc func gameOver() {
        pizzaTimer?.invalidate()

        for node in self.children {
            if node.name == "salami" || node.name == "mashroom" {
                node.removeFromParent()
            }
        }

        let finalScore = SKLabelNode(text: "GAME OVER")
        finalScore.position = CGPoint(x: 512, y: 300)
        finalScore.fontName = "Chalkduster"
        finalScore.zPosition = 1
        addChild(finalScore)

        return
    }

    @objc func throwPizza() {
        guard let pizza = ["salami", "mashroom"].randomElement() else { return }

        let sprite = SKSpriteNode(imageNamed: pizza)
        sprite.name = pizza
        let size = Double.random(in: sizeRange)
        sprite.size = CGSize(width: sprite.size.width * CGFloat(size), height: sprite.size.height * CGFloat(size))
        if Int.random(in: 1...3) == 3 {
            sprite.position = CGPoint(x: 1200, y: 350)
        } else {
            sprite.position = CGPoint(x: -100, y: [100, 600].randomElement()!)
        }
        addChild(sprite)

        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.affectedByGravity = false
        if sprite.position.x == -100 {
            sprite.physicsBody?.velocity = CGVector(dx: Int.random(in: velocityRange), dy: 0)
        } else {
            sprite.physicsBody?.velocity = CGVector(dx: -1 * Int.random(in: velocityRange), dy: 0)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        for node in tappedNodes {
            if node.name == "salami" {
                score -= 5
                node.removeFromParent()
            } else if node.name == "mashroom" {
                score += 5
                node.removeFromParent()
            }
        }
    }
}
