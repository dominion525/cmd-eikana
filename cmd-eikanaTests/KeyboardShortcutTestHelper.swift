//
//  KeyboardShortcutTestHelper.swift
//  cmd-eikanaTests
//

import CoreGraphics
import Foundation

@testable import _英かな

// MARK: - Constants

enum KeyboardShortcutTestConstants {
  // CGEventFlags values
  static let maskCommand: UInt64 = 0x0010_0000  // 1048576
  static let maskShift: UInt64 = 0x0002_0000  // 131072
  static let maskControl: UInt64 = 0x0004_0000  // 262144
  static let maskAlternate: UInt64 = 0x0008_0000  // 524288
  static let maskSecondaryFn: UInt64 = 0x0080_0000  // 8388608
  static let maskAlphaShift: UInt64 = 0x0001_0000  // 65536 (CapsLock)

  // Modifier key codes
  static let commandL: UInt16 = 55
  static let commandR: UInt16 = 54
  static let shiftL: UInt16 = 56
  static let shiftR: UInt16 = 60
  static let controlL: UInt16 = 59
  static let controlR: UInt16 = 62
  static let optionL: UInt16 = 58
  static let optionR: UInt16 = 61
  static let fnKey: UInt16 = 63
  static let capsLock: UInt16 = 57
}

// MARK: - Helper Functions

func createShortcut(keyCode: UInt16 = 0, flags: UInt64 = 0) -> KeyboardShortcut {
  KeyboardShortcut(keyCode: CGKeyCode(keyCode), flags: CGEventFlags(rawValue: flags))
}

func createShortcutDictionary(keyCode: Int = 0, flags: Int = 0) -> [AnyHashable: Any] {
  ["keyCode": keyCode, "flags": flags]
}
