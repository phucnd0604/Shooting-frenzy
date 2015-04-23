//
//  Array2D.swift
//  ShootEggs
//
//  Created by phuc on 4/16/15.
//  Copyright (c) 2015 phuc nguyen. All rights reserved.
//

import Foundation
class Array2D<T> {
  var columns: Int {
    didSet {
      
    }
  }
  var rows: Int
  var array: Array<T?>
  
  init(columns: Int, rows: Int) {
    self.columns = columns
    self.rows = rows
    array = Array<T?>(count: rows*columns*10, repeatedValue: nil)
  }
  
  subscript(column: Int, row: Int) -> T? {
    get {
      if ((row*columns + column) > array.count) {return nil}
        return array[row*columns + column]
    }
    set {
      array[row*columns + column] = newValue
    }
  }
}