//
//  GameScene.swift
//  SlimeZerkTest
//
//  Created by Parrot on 2019-02-25.
//  Copyright © 2019 Parrot. All rights reserved.
//

import SpriteKit
import GameplayKit

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

class GameScene: SKScene {
    // MARK: Variables for tracking time
    private var lastUpdateTime : TimeInterval = 0
    
    // MARK: Sprite variables
    var player:SKSpriteNode = SKSpriteNode()
    var upButton:SKSpriteNode = SKSpriteNode()
    var downButton:SKSpriteNode = SKSpriteNode()
    var leftButton:SKSpriteNode = SKSpriteNode()
    var rightButton:SKSpriteNode = SKSpriteNode()
   var maze:SKSpriteNode = SKSpriteNode()
    var exit:SKSpriteNode = SKSpriteNode()
    //var enemy:SKSpriteNode = SKSpriteNode()
    var musicButton:SKSpriteNode = SKSpriteNode()
    var bulletButton: SKSpriteNode = SKSpriteNode()
    var scoreLabel: SKLabelNode = SKLabelNode(text: "")
    
   // var liveLabel: SKSpriteNode = SKSpriteNode()
    
    // MARK: Label variables
    var livesLabel:SKLabelNode = SKLabelNode(text: "Lives: ")
      var bullet:bullet_file!
    
    
    // MARK: Scoring and Lives variables
    var score = 0;
    var lives = 2;
    
    // MARK: Game state variables
    // variables for dealing with game state
    var gameInProgress = true
     var currentLevel = 1
    var backgroundSound = true
     var backgroundSoundfile = SKAudioNode(fileNamed: "BackgroundMusic/Victory.mp3")
    var dir = 1
    
    // MARK: Default GameScene functions
    // -------------------------------------
    override func didMove(to view: SKView) {
        self.lastUpdateTime = 0
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.name = "wall"
        
        physicsBody!.categoryBitMask = PhysicsCategory.Floor
        // get sprites from Scene Editor
        
        self.player = self.childNode(withName: "player") as! SKSpriteNode
        self.upButton = self.childNode(withName: "upButton") as! SKSpriteNode
        self.downButton = self.childNode(withName: "downButton") as! SKSpriteNode
        self.leftButton = self.childNode(withName: "leftButton") as! SKSpriteNode
        self.rightButton = self.childNode(withName: "rightButton") as! SKSpriteNode
        self.maze = self.childNode(withName: "maze") as! SKSpriteNode
        self.exit = self.childNode(withName: "exit") as! SKSpriteNode
       // self.enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        self.musicButton = self.childNode(withName: "musicButton") as! SKSpriteNode
         self.bulletButton = self.childNode(withName: "bButton") as! SKSpriteNode
        self.scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
          self.livesLabel = self.childNode(withName: "livesLabel") as! SKLabelNode
        physicsWorld.contactDelegate = self
        
        self.scoreLabel.text = "Score:" + String(score)
        //self.livesLabel.color = SKColor.red
        self.livesLabel.text = "Lives: " + String(lives)
        //background sound
       
        self.addChild(backgroundSoundfile)
        

    
        
        
        //for player
        
        self.player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.player.physicsBody?.collisionBitMask = PhysicsCategory.Enemy | PhysicsCategory.Exit | PhysicsCategory.skull
        self.player.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy | PhysicsCategory.Exit | PhysicsCategory.skull
        
        //for exit
        
        self.exit.physicsBody?.categoryBitMask = PhysicsCategory.Exit
        self.exit.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        
        
//        for node in self.children {
//
//
//            if ( node.name == "maze") {
        
        //for maze
        self.maze.physicsBody?.categoryBitMask = PhysicsCategory.Maze
        self.maze.physicsBody?.contactTestBitMask = ~(PhysicsCategory.Player ) | PhysicsCategory.bullet | ~(PhysicsCategory.Enemy)
        
//
//            }
//        }
//
        
       
        
        
        
        
        
        // get labels from Scene Editor
        self.livesLabel = self.childNode(withName: "livesLabel") as! SKLabelNode
        
        self.exit.physicsBody?.isDynamic = true
        enemyPosition()
        
        
        
    }
    func enemyPosition(){
        
        var enemies:Int = 0
        
        for node in self.children {
            
            
            if ( node.name == "enemy") {
                
                //for enemy
                node.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
                node.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.bullet
                node.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.bullet
                
                //move towards player
                // Determine speed of the monster
               // let actualDuration = random(min: CGFloat(8.0), max: CGFloat(9.0))
                
                // Create the actions
                let actionMove = SKAction.move(to: CGPoint(x: player.position.x, y: player.position.y),
                                               duration: 60.0)
                let actionMoveDone = SKAction.removeFromParent()
                node.run(SKAction.sequence([actionMove, actionMoveDone]))
            }
           
            
            
        }
        
         print("enemy number:\(enemies)")
        
        if (enemies == 0) {
            
            print ("level is  complete")
            
        }
        
    }
    func playerPosition(node:SKNode)
    {
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: player.position.x, y: player.position.y),
                                       duration: 5.0)
        let actionMoveDone = SKAction.removeFromParent()
        node.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first  else {
            return
        }
        let mouseLocation = touch.location(in: self)
       // print("Finger starting position: \(mouseLocation)")
        
        // detect what sprite was touched
        let spriteTouched = self.atPoint(mouseLocation)
        if let name = spriteTouched.name {
            
            //code for game pad
         
            if name == "leftButton" {
                //move to left
                let moveAction: SKAction = SKAction.moveBy(x: -15, y: 0, duration: 1)
               
                if (self.player.xScale < 1) {
                    self.player.xScale  = self.player.xScale * -1
                }
                
                //self.player.xScale = -1
                enemyPosition()
                
               
                self.player.run(moveAction)
            }
            if name == "rightButton" {
                //move to right
                let moveAction: SKAction = SKAction.moveBy(x: 15, y: 0, duration: 1)
               // self.player.xScale = 1
                if (self.player.xScale < 1) {
                    self.player.xScale  = self.player.xScale * -1
                }
               enemyPosition()
               
                self.player.run(moveAction)
            }
            if name == "downButton" {
                //move to right
                let moveAction: SKAction = SKAction.moveBy(x: 0, y: -15, duration: 1)
                self.player.run(moveAction)
                
                enemyPosition()
            }
            if name == "upButton" {
                //move to right
                let moveAction: SKAction = SKAction.moveBy(x: 0, y: 15, duration: 1)
                self.player.run(moveAction)
                
                enemyPosition()
            }
            if name == "musicButton"{
                if(backgroundSound == true){
                    backgroundSoundfile.run(SKAction.stop())
                    self.musicButton.texture = SKTexture(imageNamed: "musicOff-light")
                    backgroundSound = false
                    
                }
                else{
                     backgroundSoundfile.run(SKAction.play())
                     self.musicButton.texture = SKTexture(imageNamed: "musicOn-light")
                    backgroundSound = true
                }
                
            }
            if(name == "bButton"){
                
                print("bullet")
                bullet = bullet_file()
                bullet.position = player.position
                bullet.name = "bullet"
                

                bullet.physicsBody?.categoryBitMask = PhysicsCategory.bullet
                bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
                // self.bullet.physicsBody?.collisionBitMask = PhysicsCategory.none
                bullet.physicsBody?.usesPreciseCollisionDetection = true
                
                addChild(bullet)
                


                print(self.player.xScale)
                // 9 - Create the actions
                if(self.player.xScale > -1 && self.player.xScale < 0){
                    print("first")
                    dir = 0
                }
                else if(self.player.xScale < 1 && self.player.xScale > 0){
                    print("second")
                     dir = Int(self.size.width)
                 
                }
                print(dir);
                let actionMove = SKAction.moveTo(x: CGFloat(dir), duration: 2.0)
                let actionMoveDone = SKAction.removeFromParent()
                bullet.run(SKAction.sequence([actionMove, actionMoveDone]))

               
            }
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    func addEvil() {
        
        // Create sprite
        let skull = SKSpriteNode(imageNamed: "Skull")
        skull.name = "evil"
         skull.physicsBody = SKPhysicsBody(rectangleOf: skull.size)
        
        skull.physicsBody?.categoryBitMask = PhysicsCategory.skull
        skull.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.bullet
        skull.physicsBody?.allowsRotation = false
        
        //skull.physicsBody = physicsBody.
        
        // Determine where to spawn the monster along the Y axis
        let actualY = random(min: skull.size.height/2, max: size.height - skull.size.height/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        skull.position = CGPoint(x: size.width + skull.size.width/2, y: actualY)
        
        // Add the monster to the scene
        addChild(skull)
        
        // Determine speed of the monster
      //  let actualDuration = random(min: CGFloat(8.0), max: CGFloat(9.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: player.position.x, y: player.position.y),
                                       duration: 5.0)
        let actionMoveDone = SKAction.removeFromParent()
        skull.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }

        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
    
        // HINT: This code prints "Hello world" every 5 seconds
        if (dt > 30) {
            print("HELLO WORLD!")
            addEvil()
            self.lastUpdateTime = currentTime
        }
        

        
    }
    
    func setLevel(levelNumber:Int) {
        self.currentLevel = levelNumber
    }
    func loadNextLevel(){
        // load the next level
        self.currentLevel = self.currentLevel + 1
        
        // try to load the next level
        guard let nextLevelScene = GameScene.loadLevel(levelNumber: self.currentLevel) else {
            print("Error when loading next level")
            return
        }
        
        // wait 1 second then switch to next leevl
        let waitAction = SKAction.wait(forDuration:1)
        
        let showNextLevelAction = SKAction.run {
            nextLevelScene.setLevel(levelNumber: self.currentLevel)
            let transition = SKTransition.flipVertical(withDuration: 2)
            nextLevelScene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(nextLevelScene, transition:transition)
        }
        
        let sequence = SKAction.sequence([waitAction, showNextLevelAction])
        
        self.run(sequence)
        
        //        perform(#selector(GameScene.restartGame), with: nil,
        //                afterDelay: 3)
    }
    class func loadLevel(levelNumber:Int) -> GameScene? {
        let fileName = "BerzerkLevel\(levelNumber)"
        
        // DEBUG nonsense
        print("Trying to load file: Level\(levelNumber).sks")
        
        guard let scene = GameScene(fileNamed: fileName) else {
            print("Cannot find level named: \(levelNumber).sks")
            return nil
        }
        
        scene.scaleMode = .aspectFill
        return scene
        
    }
    
    @objc func restartGame() {
        // load Level2.sks
        let scene = GameScene(fileNamed:"BerzerkLevel1")
        scene!.scaleMode = scaleMode
        view!.presentScene(scene)
    }
    
    func gameOver()
    {
        // increase the level number
        let message = SKLabelNode(text:"GAME OVER")
        message.position = CGPoint(x:self.size.width/2, y:self.size.height/2)
        message.fontColor = UIColor.magenta
        message.fontSize = 100
        message.fontName = "AvenirNext-Bold"
        
        addChild(message)
        
      
        
        perform(#selector(GameScene.restartGame), with: nil, afterDelay: 3)
        //restartGame()
    }
   
    func didBegin(_ contact: SKPhysicsContact) {

        print("COLLISION DETECTED!!!")

       
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        print("Firest:\(firstBody.node?.name)")

        print("second:\(secondBody.node?.name)")

        print("Firest:\(firstBody.categoryBitMask)")

        print("second:\(secondBody.categoryBitMask)")

        // 2
//        let enmey = firstBody.node as? SKSpriteNode
       
        
//        for node in self.children {
//
//            if(node.name == "player"){
            if(firstBody.node?.name == "player"){
                if(secondBody.node?.name == "enemy"){
                   // self.enemy.removeFromParent()
                    secondBody.node?.removeFromParent()
                    
                    //self.childNode(withName: "enemy")?.removeFromParent()
                    print("enemy")
                    lives = lives - 1
                    livesLabel.text = "Lives: " + String(lives)
                    if(lives == 0){
                        gameOver()
                    }
                   
                }
              
                else if(secondBody.node?.name == "exit"){
                    loadNextLevel()
                }
                else if(secondBody.node?.name == "evil"){
                   secondBody.node?.removeFromParent()
                    print("skull")
                    lives = lives - 1
                    livesLabel.text = "Lives: " + String(lives)
                    if(lives == 0){
                        gameOver()
                    }
                    
                }
            }
                
      
               else if(firstBody.node?.name == "enemy"){
                    if(secondBody.node?.name == "bullet"){
                        print("bullet")
                        
                        firstBody.node?.removeFromParent()
                        self.bullet.removeFromParent()
                        score = score + 50
                        scoreLabel.text = "Score: " + String(score)
                       // self.enemy.removeFromParent()
                        
                        
                        
                    }
                
               
               
            }
            
            
            
 
            else if(firstBody.node?.name == "bullet"){
                if(secondBody.node?.name == "maze"){
                    print("maze")
                    self.bullet.removeFromParent()
                }
                if(secondBody.node?.name == "evil"){
                    firstBody.node?.removeFromParent()
                }
        }
        
        }
   // }


    
    // MARK: Custom GameScene Functions
    // Your custom functions can go here
    // -------------------------------------
    
    
    struct PhysicsCategory {
        static let None:  UInt32 = 0
        static let Player:   UInt32 = 0b1      // 0x00000001 = 1
        static let Enemy: UInt32 = 0b10     // 0x00000010 = 2
        static let Exit:   UInt32 = 0b100    // 0x00000100 = 4
        static let Maze: UInt32 = 0b1000   // 0x00001000 = 8
        static let bullet: UInt32 = 0b10000   // 0x00001000 = 16
        static let Floor: UInt32 = 0b100000   // 0x00001000 = 32
         static let skull: UInt32 = 0b1000000   // 0x00001000 = 64
        
        // for cat to collide with bed and block, you say:
        // block | bed  == 0x010 | 0x100 = 0x110 = 6
        
        // for wooden block:
        //  - category = 0x010 (2)
        //  - collision mask = cat | other blocks = 0x001 | 0x010 = 0x011 = 2+1 = 3
    }
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
        print("Hit")
        projectile.removeFromParent()
        monster.removeFromParent()
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
}
