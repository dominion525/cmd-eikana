//
//  ShortcutsControllerTests.swift
//  cmd-eikanaTests
//

import CoreGraphics
import Foundation
import Testing

@testable import _英かな

@Suite(.serialized)
struct ShortcutsControllerTests {

  // MARK: - Helper

  func createShortcut(keyCode: UInt16 = 0, flags: UInt64 = 0) -> KeyboardShortcut {
    KeyboardShortcut(keyCode: CGKeyCode(keyCode), flags: CGEventFlags(rawValue: flags))
  }

  func createMapping(inputKeyCode: UInt16, outputKeyCode: UInt16, enable: Bool = true)
    -> KeyMapping
  {
    KeyMapping(
      input: createShortcut(keyCode: inputKeyCode),
      output: createShortcut(keyCode: outputKeyCode),
      enable: enable
    )
  }

  // MARK: - keyMappingListToShortcutList Tests

  @Test func enabledMappingsAreAddedToShortcutList() {
    // Setup
    let originalList = keyMappingList
    let originalShortcutList = shortcutList
    defer {
      keyMappingList = originalList
      shortcutList = originalShortcutList
    }

    keyMappingList = [
      createMapping(inputKeyCode: 55, outputKeyCode: 102, enable: true)
    ]

    // Execute
    keyMappingListToShortcutList()

    // Verify
    #expect(shortcutList[55] != nil)
    #expect(shortcutList[55]?.count == 1)
  }

  @Test func disabledMappingsAreNotAddedToShortcutList() {
    // Setup
    let originalList = keyMappingList
    let originalShortcutList = shortcutList
    defer {
      keyMappingList = originalList
      shortcutList = originalShortcutList
    }

    keyMappingList = [
      createMapping(inputKeyCode: 55, outputKeyCode: 102, enable: false)
    ]

    // Execute
    keyMappingListToShortcutList()

    // Verify
    #expect(shortcutList[55] == nil)
  }

  @Test func mixedEnableMappingsFilteredCorrectly() {
    // Setup
    let originalList = keyMappingList
    let originalShortcutList = shortcutList
    defer {
      keyMappingList = originalList
      shortcutList = originalShortcutList
    }

    keyMappingList = [
      createMapping(inputKeyCode: 55, outputKeyCode: 102, enable: true),  // Command_L -> 英数
      createMapping(inputKeyCode: 54, outputKeyCode: 104, enable: false),  // Command_R -> かな (disabled)
      createMapping(inputKeyCode: 56, outputKeyCode: 103, enable: true),  // Shift_L -> something
    ]

    // Execute
    keyMappingListToShortcutList()

    // Verify
    #expect(shortcutList[55] != nil)  // enabled
    #expect(shortcutList[54] == nil)  // disabled
    #expect(shortcutList[56] != nil)  // enabled
  }

  @Test func emptyMappingListResultsInEmptyShortcutList() {
    // Setup
    let originalList = keyMappingList
    let originalShortcutList = shortcutList
    defer {
      keyMappingList = originalList
      shortcutList = originalShortcutList
    }

    keyMappingList = []

    // Execute
    keyMappingListToShortcutList()

    // Verify
    #expect(shortcutList.isEmpty)
  }

  @Test func multipleMappingsWithSameInputKeyCode() {
    // Setup
    let originalList = keyMappingList
    let originalShortcutList = shortcutList
    defer {
      keyMappingList = originalList
      shortcutList = originalShortcutList
    }

    // 同じキーコードで複数のマッピング（有効なもののみカウント）
    keyMappingList = [
      createMapping(inputKeyCode: 55, outputKeyCode: 102, enable: true),
      createMapping(inputKeyCode: 55, outputKeyCode: 104, enable: true),
      createMapping(inputKeyCode: 55, outputKeyCode: 103, enable: false),  // disabled
    ]

    // Execute
    keyMappingListToShortcutList()

    // Verify
    #expect(shortcutList[55]?.count == 2)  // 有効な2つのみ
  }
}
