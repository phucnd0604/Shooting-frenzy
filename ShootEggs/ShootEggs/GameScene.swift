//
//  GameScene.swift
//  ShootEggs
//
//  Created by phuc on 4/16/15.
//  Copyright (c) 2015 phuc nguyen. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  
  var level: Level!
  let TileWidth: CGFloat = 30.0
  let TileHeight: CGFloat = 36.0
  let gameLayer = SKNode()
  let eggsLayer = SKNode()
  var lastUpdateTime: CFTimeInterval = 0
  required init?(coder aDecoder: NSCoder) {
    fatalError("initWithCode not impliment")
  }
  
  override init(size: CGSize) {
    super.init(size: size)
    
    addChild(gameLayer)
    
    let layerPosition = CGPoint(
      x: 0,
      y: 0
    )
    eggsLayer.position = layerPosition
    gameLayer.addChild(eggsLayer)
  }
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
    
  }
  func addEggs(eggs: Set<EggNote>) {
    for egg in eggs {
      egg.position = pointForColumn(egg.column, row:egg.row)
      eggsLayer.addChild(egg)
    }
  }
  
  func pointForColumn(column: Int, row: Int) -> CGPoint {
    return CGPoint(
      x: CGFloat(column)*TileWidth + TileWidth,
      y: CGFloat(rowsNumber - row)*TileHeight + TileHeight + 300)
  }
}
