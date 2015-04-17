//
//  GameScene.swift
//  ShootEggs
//
//  Created by phuc on 4/16/15.
//  Copyright (c) 2015 phuc nguyen. All rights reserved.
//

import SpriteKit
func + (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
  func sqrt(a: CGFloat) -> CGFloat {
  return CGFloat(sqrtf(Float(a)))
  }
#endif

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
}

struct PhysicsCategory {
  static let None      : UInt32 = 0
  static let All       : UInt32 = UInt32.max
  static let Egg       : UInt32 = 1
  static let FireEgg   : UInt32 = 2
  static let Wall      : UInt32 = 3
}
class GameScene: SKScene {
  
  
  var level: Level!
  let TileWidth: CGFloat = 30.0
  let TileHeight: CGFloat = 36.0
  let gameLayer = SKNode()
  let eggsLayer = SKNode()
  var lastUpdateTime: CFTimeInterval = 0
  var fireEgg: EggNote!
  var isStart = false
  var setEggs = Set<EggNote>()
  var chainEggs = Set<EggNote>()
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
    physicsWorld.gravity = CGVectorMake(0, 0)
    physicsWorld.contactDelegate = self
  }
  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)
  }
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
    
  }
  func addEggs(eggs: Set<EggNote>) {
    eggsLayer.removeAllChildren()
    for egg in eggs {
      egg.position = pointForColumn(egg.column, row:egg.row, isStarted: isStart)
      egg.physicsBody = SKPhysicsBody(circleOfRadius: egg.size.height / 2)
      egg.physicsBody?.dynamic = true // 2
      egg.physicsBody?.categoryBitMask = PhysicsCategory.Egg
      egg.physicsBody?.contactTestBitMask = PhysicsCategory.FireEgg
      egg.physicsBody?.collisionBitMask = PhysicsCategory.None
      eggsLayer.addChild(egg)
    }
  }
  
  func pointForColumn(column: Int, row: Int, isStarted: Bool) -> CGPoint {
    var delta: CGFloat
    if isStarted {
      delta = 0
    } else {
      delta = 300
    }
    return CGPoint(
      x: CGFloat(column)*TileWidth + TileWidth,
      y: CGFloat(rowsNumber - row)*TileHeight + TileHeight + delta)
  }
  
  func addFireEgg() {
    var eggType = EggType.random()
    let egg = EggNote(imageName: eggType.eggName, column: 0, row: 0, type: eggType)
    egg.position = CGPoint(x: 290 / 2, y: TileHeight)
    egg.physicsBody = SKPhysicsBody(circleOfRadius: egg.size.height / 2)
    egg.physicsBody?.dynamic = true // 2
    egg.physicsBody?.categoryBitMask = PhysicsCategory.FireEgg
    egg.physicsBody?.contactTestBitMask = PhysicsCategory.Egg
    egg.physicsBody?.collisionBitMask = PhysicsCategory.None
    egg.physicsBody?.friction = 0.0
    fireEgg = egg
    eggsLayer.addChild(fireEgg)
    isStart = true
  }
  
  func addEdgeWall() {
    let left = SKSpriteNode(color: UIColor.brownColor(), size: CGSize(width: 15, height: 1000))
    left.physicsBody = SKPhysicsBody(rectangleOfSize: left.size)
    left.physicsBody?.dynamic = true // 2
    left.physicsBody?.categoryBitMask = PhysicsCategory.Wall
    left.physicsBody?.contactTestBitMask = PhysicsCategory.FireEgg
    left.physicsBody?.collisionBitMask = PhysicsCategory.None
    left.physicsBody?.friction = 0.0
    left.position = CGPoint(x: 0, y: 0)
    let right = SKSpriteNode(color: UIColor.brownColor(), size: CGSize(width: 15, height: 1000))
    right.physicsBody = SKPhysicsBody(rectangleOfSize: left.size)
    right.physicsBody?.dynamic = true // 2
    right.physicsBody?.categoryBitMask = PhysicsCategory.Wall
    right.physicsBody?.contactTestBitMask = PhysicsCategory.FireEgg
    right.physicsBody?.collisionBitMask = PhysicsCategory.None
    right.physicsBody?.friction = 0.0
    right.position = CGPoint(x: 300, y: 0)
    eggsLayer.addChild(left)
    eggsLayer.addChild(right)
  }
  
  // touch
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    // 1 - Choose one of the touches to work with
    let touch = touches.first as! UITouch
    let touchLocation = touch.locationInNode(self)
    // 2 - Determine offset of location to projectile
    let offset = touchLocation - fireEgg.position
    // 3 - Bail out if you are shooting down or backwards
    if (offset.x < (-290)) { return }
    // 4 - Get the direction of where to shoot
    let direction = offset.normalized()
    // 5 - Make it shoot far enough to be guaranteed off screen
    let shootAmount = direction * 1000
    
    // 6 - Add the shoot amount to the current position
    let realDest = shootAmount + fireEgg.position
    // 7 - Create the actions
    let actionMove = SKAction.moveTo(realDest, duration: 2.0)
    let actionMoveDone = SKAction.removeFromParent()
    fireEgg.runAction(SKAction.sequence([actionMove, actionMoveDone]), completion: {
      self.fireEgg.removeFromParent()
      self.addFireEgg()
    })
  }
  // find Chain egg
  // collision
  func fireEggDidCollideWithEgg(fireEgg: EggNote, egg: EggNote) {
    println("Collision")
    let column = egg.column
    let row = egg.row + 1
    if row > rowsNumber - 1 {
      rowsNumber = row
      for row in 0..<rowsNumber {
        level.eggs.array.append(nil)
      }
    }
    fireEgg.column = column
    fireEgg.row = row
    fireEgg.position = CGPoint(x: egg.position.x, y: egg.position.y - 36)
    level.eggs.columns = columsNumber
    level.eggs.rows = rowsNumber
    fireEgg.physicsBody?.categoryBitMask = PhysicsCategory.Egg
    fireEgg.physicsBody?.contactTestBitMask = PhysicsCategory.FireEgg
    level.eggs[column, row] = fireEgg
    level.set.insert(fireEgg)
    println(fireEgg.position)
    fireEgg.removeAllActions()
    let actionMove = SKAction.moveTo(fireEgg.position, duration: 0)
    fireEgg.runAction(actionMove)
    if fireEgg.position.y < 30 {
      self.removeFromParent()
      return
    }
    let chain = findChainEggs(egg)
    if chain.count > 2 {
    for egg in  findChainEggs(fireEgg) {
      let actionDisApear = SKAction.scaleBy(0.1, duration: 0.25)
      egg.runAction(actionDisApear, completion: {
        
        egg.removeFromParent()
      })
    }
    }
    addFireEgg()
  }
  func findChainEggs(egg: EggNote) -> Set<EggNote>{
    var chain = Set<EggNote>()
    chain.insert(egg)
    // horizontal chain
      for coll in egg.column..<rowsNumber {
        if let aEgg = level.eggs[coll, egg.row] {
          if aEgg.eggType == egg.eggType {
            chain.insert(aEgg)
          } else {
            break
          }
        }
      }
      for coll in reverse(0..<egg.column) {
        if let aEgg = level.eggs[coll, egg.row] {
          if aEgg.eggType == egg.eggType {
            chain.insert(aEgg)
          } else {
            break
          }
        }
      }
    // vertical chain
    for row in reverse(0..<rowsNumber) {
      if let aEgg = level.eggs[egg.column, row] {
        if aEgg.eggType == egg.eggType {
          chain.insert(aEgg)
        } else {
          break
        }
      }
    }
    return chain
  }
}

extension GameScene: SKPhysicsContactDelegate {
  func didBeginContact(contact: SKPhysicsContact) {
    var firstObj: SKPhysicsBody? // fireEgg
    var secondObj: SKPhysicsBody? // egg
    if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
      firstObj = contact.bodyA
      secondObj = contact.bodyB
    } else {
      secondObj = contact.bodyA
      firstObj = contact.bodyB
    }
    if let a = firstObj?.node as? EggNote, let b = secondObj?.node as? EggNote {
        fireEggDidCollideWithEgg(firstObj!.node as! EggNote, egg: secondObj!.node as! EggNote)
    }
  }
}

