//
//  bullet_file.swift
//  SlimeZerkTest
//
//  Created by Charmi Mehta on 2019-02-25.
//  Copyright © 2019 Parrot. All rights reserved.
//

import Foundation
import SpriteKit
class bullet_file:SKSpriteNode {
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        // default constructor
        let texture = SKTexture(imageNamed: "Orange")
        let size = texture.size()
        let color = UIColor.clear
        
        super.init(texture: texture, color: color, size: size)
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        //physicsBody?.affectedByGravity = false
        
      //  physicsBody?.name = "bullet"
        physicsBody?.isDynamic = true
        physicsBody?.affectedByGravity = false
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
