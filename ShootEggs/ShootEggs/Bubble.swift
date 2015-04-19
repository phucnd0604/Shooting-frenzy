//
//  Bubble.swift
//  ShootEggs
//
//  Created by phuc on 4/17/15.
//  Copyright (c) 2015 phuc nguyen. All rights reserved.
//

import Foundation
import SpriteKit

enum BubbleColor: Int {
  case GreyBall = 0, YellowBall = 1, RedBall = 2, BlueBall = 3, GreenBall = 4
  static func random() -> BubbleColor {
    return BubbleColor(rawValue: Int(arc4random_uniform(5)))!
  }
}

enum BubbleType: Int {
  case EBubbleStatic = 0,  EBubbleMoving = 1,  EBubbleDisabled = 2
}

class Bubble: SKSpriteNode {
  var bubbleType: BubbleType!
  var bubbleColor: BubbleColor!
  var mustBeDestroyed = false
  var mustBeHeld = false
  var column: Int = 0
  var row: Int = 0
  init(type: BubbleType, color: BubbleColor) {
    let imageName = "ball_\(color.rawValue).png"
    let texture = SKTexture(imageNamed: imageName)
    super.init(texture: texture, color: nil, size: texture.size())
    bubbleColor = color
    bubbleType = type
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}