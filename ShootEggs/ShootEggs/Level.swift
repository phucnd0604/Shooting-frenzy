//
//  Level.swift
//  ShootEggs
//
//  Created by phuc on 4/16/15.
//  Copyright (c) 2015 phuc nguyen. All rights reserved.
//

import Foundation

var columsNumber = 9
var rowsNumber = 9

class Level {
  var eggs = Array2D<EggNote>(columns: columsNumber, rows: rowsNumber)
  func eggColumn(column: Int, row: Int) -> EggNote? {
    assert(column >= 0 && column < columsNumber)
    assert(row >= 0 && row < rowsNumber)
    return eggs[column, row]
  }
  
  func shuffle() -> Set<EggNote> {
    return createInitialCookies()
  }
  
  private func createInitialCookies() -> Set<EggNote> {
    var set = Set<EggNote>()
    
    // 1 get col and row
    for row in 0..<rowsNumber {
      for column in 0..<columsNumber {        
        // 2 create random egg type
        var eggType = EggType.random()
        // 3 create egg and add to eggs array
        let egg = EggNote(imageName: eggType.eggName, column: column, row: row, type: eggType)
        eggs[column, row] = egg
        // 4 
        set.insert(egg)
      }
    }
    return set
  }
}