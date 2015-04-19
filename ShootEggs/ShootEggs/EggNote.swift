//
//  EggNote.swift
//  ShootEggs
//
//  Created by phuc on 4/16/15.
//  Copyright (c) 2015 phuc nguyen. All rights reserved.
//

import Foundation
import SpriteKit

enum EggType: Int, Printable {
  case Unknown = 0, Red = 1, Blue = 2, White = 3
  var eggName: String {
    let eggNames = ["ball_2", "ball_4", "ball_0"]
    return eggNames[rawValue - 1]
  }
  var description: String {
    return eggName
  }
  static func random() -> EggType {
    return EggType(rawValue: Int(arc4random_uniform(3)) + 1)!
  }
}

class EggNote: SKSpriteNode, Hashable {
  var column: Int!
  var row: Int!
  var eggType: EggType!
  var mustbeDestroy = false
  override var hashValue: Int {
    return row*10 + column
  }
  override var description: String {
    return "\(eggType)-[\(column):\(row)]"
  }
  init(imageName: String, column: Int, row: Int, type: EggType) {
    let texture = SKTexture(imageNamed: imageName)
    super.init(texture: texture, color: nil, size: texture.size())
    self.column = column
    self.row = row
    self.eggType = type
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}
func ==(lhs: EggNote, rhs: EggNote) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}