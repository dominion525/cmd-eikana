//
//  MappingMenu.swift
//  ⌘英かな
//
//  MIT License
//  Copyright (c) 2016 iMasanari
//

import Cocoa

class MappingMenu: NSPopUpButton {
  var row: Int?

  func up() {
    if let row = self.row, row - 1 != -1 {
      let keyMapping = keyMappingList[row]

      keyMappingList[row] = keyMappingList[row - 1]
      keyMappingList[row - 1] = keyMapping
    }
  }
  func move(_ targetIndex: Int) {
    var index = targetIndex
    if let row = self.row {
      let keyMapping = keyMappingList[row]

      if index < 0 {
        index = 0
      } else if index > keyMappingList.count - 1 {
        index = keyMappingList.count - 1
      }

      keyMappingList.remove(at: row)
      keyMappingList.insert(keyMapping, at: index)
    }
  }
  func down() {
    if let row = self.row, row + 1 != keyMappingList.count {
      let keyMapping = keyMappingList[row]

      keyMappingList[row] = keyMappingList[row + 1]
      keyMappingList[row + 1] = keyMapping
    }
  }
  func remove() {
    keyMappingList.remove(at: self.row!)
  }
}
