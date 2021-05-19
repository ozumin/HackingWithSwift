//
//  GameScene.swift
//  Project26
//
//  Created by Mizuo Nagayama on 2021/05/16.
//

import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?

    var motionManager: CMMotionManager?
    var isGameOver = false

    var scoreLabel: SKLabelNode!

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        self.scoreLabel  = SKLabelNode(fontNamed: "Chalkduster")
        self.scoreLabel.text = "Score: 0"
        self.scoreLabel.horizontalAlignmentMode = .left
        self.scoreLabel.position = CGPoint(x: 16, y: 16)
        self.scoreLabel.zPosition = 2
        addChild(self.scoreLabel)

        self.loadLevel()
        self.createPlayer()

        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        self.motionManager = CMMotionManager()
        self.motionManager?.startAccelerometerUpdates()
    }

    func loadLevel() {
        guard let levelURL = Bundle.main.url(forResource: "level1", withExtension: "txt") else {
            fatalError("Could not find level1.txt in the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not find level1.txt in the app bundle.")
        }

        let lines = levelString.components(separatedBy: "\n")

        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: 64 * column + 32, y: 64 * row + 32)

                if letter == "x" {
                    // load wall
                    let node = self.initializeNode(imageName: "block", position: position)
                    node.updatePhysicsBody(rectangleOf: node.size, categoryBitMask: .wall)
                    addChild(node)
                } else if letter == "v" {
                    // load vortex
                    let node = self.initializeNode(imageName: "vortex", position: position, nodeName: "vortex")
                    node.updatePhysicsBody(circleOfRadius: node.size.width / 2, categoryBitMask: .vortex, contactTestBitMask: .player, collisionBitMask: 0)
                    node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
                    addChild(node)
                } else if letter == "s" {
                    // load star
                    let node = self.initializeNode(imageName: "star", position: position, nodeName: "star")
                    node.updatePhysicsBody(circleOfRadius: node.size.width / 2, categoryBitMask: .star, contactTestBitMask: .player, collisionBitMask: 0)
                    addChild(node)
                } else if letter == "f" {
                    // load finish point
                    let node = self.initializeNode(imageName: "finish", position: position, nodeName: "finish")
                    node.updatePhysicsBody(circleOfRadius: node.size.width / 2, categoryBitMask: .finish, contactTestBitMask: .player, collisionBitMask: 0)
                    addChild(node)
                } else if letter == " " {
                    // this is an empty space - do nothing!
                } else {
                    fatalError("Unknown level letter: \(letter)")
                }
            }
        }
    }

    func initializeNode(imageName: String, position: CGPoint, nodeName: String? = nil) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: imageName)
        node.position = position
        if let nodeName = nodeName {
            node.name = nodeName
        }
        return node
    }

    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1

        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5

        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue |
            CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        self.lastTouchPosition = location
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        self.lastTouchPosition = location
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.lastTouchPosition = nil
    }

    override func update(_ currentTime: TimeInterval) {
        guard self.isGameOver == false else { return }

        #if targetEnvironment(simulator)
        if let lastTouchPosition = self.lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - self.player.position.x, y: lastTouchPosition.y - self.player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = self.motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA == self.player {
            self.playerCollided(with: nodeB)
        } else if nodeB == self.player {
            self.playerCollided(with: nodeA)
        }
    }

    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            self.player.physicsBody?.isDynamic = false
            self.isGameOver = true
            self.score -= 1

            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])

            self.player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            self.score += 1
        } else if node.name == "finish" {
            // next level
        }
    }
}

extension SKSpriteNode {
    func updatePhysicsBody(rectangleOf: CGSize? = nil, circleOfRadius: CGFloat? = nil, categoryBitMask: CollisionTypes, contactTestBitMask: CollisionTypes? = nil, collisionBitMask: UInt32? = nil) {
        if let rectangleOf = rectangleOf {
            self.physicsBody = SKPhysicsBody(rectangleOf: rectangleOf)
        }
        if let circleOfRadius = circleOfRadius {
            self.physicsBody = SKPhysicsBody(circleOfRadius: circleOfRadius)
        }
        self.physicsBody?.categoryBitMask = categoryBitMask.rawValue
        self.physicsBody?.isDynamic = false
        if let contactTestBitMask = contactTestBitMask {
            self.physicsBody?.contactTestBitMask = contactTestBitMask.rawValue
        }
        if let collisionBitMask = collisionBitMask {
            self.physicsBody?.collisionBitMask = collisionBitMask
        }
    }
}
