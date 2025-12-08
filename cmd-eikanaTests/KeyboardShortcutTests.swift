//
//  KeyboardShortcutTests.swift
//  cmd-eikanaTests
//

import CoreGraphics
import Foundation
import Testing

@testable import _英かな

struct KeyboardShortcutTests {

  // MARK: - Constants

  // CGEventFlags values
  let maskCommand: UInt64 = 0x0010_0000  // 1048576
  let maskShift: UInt64 = 0x0002_0000  // 131072
  let maskControl: UInt64 = 0x0004_0000  // 262144
  let maskAlternate: UInt64 = 0x0008_0000  // 524288
  let maskSecondaryFn: UInt64 = 0x0080_0000  // 8388608
  let maskAlphaShift: UInt64 = 0x0001_0000  // 65536 (CapsLock)

  // Modifier key codes
  let commandL: UInt16 = 55
  let commandR: UInt16 = 54
  let shiftL: UInt16 = 56
  let shiftR: UInt16 = 60
  let controlL: UInt16 = 59
  let controlR: UInt16 = 62
  let optionL: UInt16 = 58
  let optionR: UInt16 = 61
  let fnKey: UInt16 = 63
  let capsLock: UInt16 = 57

  // MARK: - Helper

  func createShortcut(keyCode: UInt16 = 0, flags: UInt64 = 0) -> KeyboardShortcut {
    KeyboardShortcut(keyCode: CGKeyCode(keyCode), flags: CGEventFlags(rawValue: flags))
  }

  func createDictionary(keyCode: Int = 0, flags: Int = 0) -> [AnyHashable: Any] {
    ["keyCode": keyCode, "flags": flags]
  }

  // MARK: - 1. Initialization Tests

  @Test func initDefault() {
    let shortcut = KeyboardShortcut()
    #expect(shortcut.keyCode == 0)
    #expect(shortcut.flags.rawValue == 0)
  }

  @Test func initWithKeyCode() {
    let shortcut = KeyboardShortcut(keyCode: 55)
    #expect(shortcut.keyCode == 55)
    #expect(shortcut.flags.rawValue == 0)
  }

  @Test func initWithKeyCodeAndFlags() {
    let shortcut = createShortcut(keyCode: 0, flags: maskCommand)
    #expect(shortcut.keyCode == 0)
    #expect(shortcut.flags.rawValue == maskCommand)
  }

  @Test func initFromValidDictionary() {
    let dictionary = createDictionary(keyCode: 55, flags: 1048576)
    let shortcut = KeyboardShortcut(dictionary: dictionary)

    #expect(shortcut != nil)
    #expect(shortcut?.keyCode == 55)
    #expect(shortcut?.flags.rawValue == 1048576)
  }

  @Test func initFromMissingKeyCode() {
    let dictionary: [AnyHashable: Any] = ["flags": 0]
    let shortcut = KeyboardShortcut(dictionary: dictionary)
    #expect(shortcut == nil)
  }

  @Test func initFromMissingFlags() {
    let dictionary: [AnyHashable: Any] = ["keyCode": 55]
    let shortcut = KeyboardShortcut(dictionary: dictionary)
    #expect(shortcut == nil)
  }

  @Test func initFromInvalidTypes() {
    // keyCodeが文字列
    let dictionary: [AnyHashable: Any] = ["keyCode": "55", "flags": 0]
    let shortcut = KeyboardShortcut(dictionary: dictionary)
    #expect(shortcut == nil)
  }

  // MARK: - 2. Serialization Tests

  @Test func toDictionary() {
    let shortcut = createShortcut(keyCode: 55, flags: maskCommand)
    let dictionary = shortcut.toDictionary()

    #expect(dictionary["keyCode"] as? Int == 55)
    #expect(dictionary["flags"] as? Int == Int(maskCommand))
  }

  @Test func toDictionaryWithLargeFlags() {
    // 複数のフラグを組み合わせた大きな値
    let combinedFlags = maskCommand | maskShift | maskControl
    let shortcut = createShortcut(keyCode: 0, flags: combinedFlags)
    let dictionary = shortcut.toDictionary()

    #expect(dictionary["flags"] as? Int == Int(combinedFlags))
  }

  @Test func roundTrip() {
    let original = createShortcut(keyCode: 54, flags: maskCommand | maskShift)
    let dictionary = original.toDictionary()
    let restored = KeyboardShortcut(dictionary: dictionary)

    #expect(restored != nil)
    #expect(restored?.keyCode == original.keyCode)
    #expect(restored?.flags.rawValue == original.flags.rawValue)
  }

  @Test func roundTripWithMaxValues() {
    // 大きなkeyCode値とフラグ値での往復
    let original = createShortcut(keyCode: 999, flags: maskCommand | maskShift | maskControl | maskAlternate)
    let dictionary = original.toDictionary()
    let restored = KeyboardShortcut(dictionary: dictionary)

    #expect(restored?.keyCode == 999)
    #expect(restored?.flags.rawValue == original.flags.rawValue)
  }

  // MARK: - 3. toString Tests

  @Test func toStringWithKnownKeyCode() {
    // keyCode 0 = "A"
    let shortcut = createShortcut(keyCode: 0, flags: 0)
    #expect(shortcut.toString() == "A")
  }

  @Test func toStringWithUnknownKeyCode() {
    // keyCodeDictionaryにない値は空文字を返す
    let shortcut = createShortcut(keyCode: 9999, flags: 0)
    #expect(shortcut.toString() == "")
  }

  @Test func toStringWithCommandFlag() {
    let shortcut = createShortcut(keyCode: 0, flags: maskCommand)
    #expect(shortcut.toString() == "⌘A")
  }

  @Test func toStringWithShiftFlag() {
    let shortcut = createShortcut(keyCode: 0, flags: maskShift)
    #expect(shortcut.toString() == "⇧A")
  }

  @Test func toStringWithControlFlag() {
    let shortcut = createShortcut(keyCode: 0, flags: maskControl)
    #expect(shortcut.toString() == "⌃A")
  }

  @Test func toStringWithAlternateFlag() {
    let shortcut = createShortcut(keyCode: 0, flags: maskAlternate)
    #expect(shortcut.toString() == "⌥A")
  }

  @Test func toStringWithFnFlag() {
    let shortcut = createShortcut(keyCode: 0, flags: maskSecondaryFn)
    #expect(shortcut.toString() == "(fn)A")
  }

  @Test func toStringWithMultipleFlags() {
    // 複数フラグ: (fn)⇪⌘⇧⌃⌥ の順で表示される
    let shortcut = createShortcut(keyCode: 0, flags: maskCommand | maskShift)
    #expect(shortcut.toString() == "⌘⇧A")
  }

  // MARK: - 4. Flag Check Tests

  // isCommandDown - keyCode 54/55 は除外
  @Test func isCommandDownTrue() {
    let shortcut = createShortcut(keyCode: 0, flags: maskCommand)
    #expect(shortcut.isCommandDown() == true)
  }

  @Test func isCommandDownFalseNoFlag() {
    let shortcut = createShortcut(keyCode: 0, flags: 0)
    #expect(shortcut.isCommandDown() == false)
  }

  @Test func isCommandDownFalseCommandL() {
    // Command_L自身はisCommandDownでfalse
    let shortcut = createShortcut(keyCode: commandL, flags: maskCommand)
    #expect(shortcut.isCommandDown() == false)
  }

  @Test func isCommandDownFalseCommandR() {
    // Command_R自身もisCommandDownでfalse
    let shortcut = createShortcut(keyCode: commandR, flags: maskCommand)
    #expect(shortcut.isCommandDown() == false)
  }

  // isShiftDown - keyCode 56/60 は除外
  @Test func isShiftDownTrue() {
    let shortcut = createShortcut(keyCode: 0, flags: maskShift)
    #expect(shortcut.isShiftDown() == true)
  }

  @Test func isShiftDownFalseShiftL() {
    let shortcut = createShortcut(keyCode: shiftL, flags: maskShift)
    #expect(shortcut.isShiftDown() == false)
  }

  @Test func isShiftDownFalseShiftR() {
    let shortcut = createShortcut(keyCode: shiftR, flags: maskShift)
    #expect(shortcut.isShiftDown() == false)
  }

  // isControlDown - keyCode 59/62 は除外
  @Test func isControlDownTrue() {
    let shortcut = createShortcut(keyCode: 0, flags: maskControl)
    #expect(shortcut.isControlDown() == true)
  }

  @Test func isControlDownFalseControlL() {
    let shortcut = createShortcut(keyCode: controlL, flags: maskControl)
    #expect(shortcut.isControlDown() == false)
  }

  @Test func isControlDownFalseControlR() {
    let shortcut = createShortcut(keyCode: controlR, flags: maskControl)
    #expect(shortcut.isControlDown() == false)
  }

  // isAlternateDown - keyCode 58/61 は除外
  @Test func isAlternateDownTrue() {
    let shortcut = createShortcut(keyCode: 0, flags: maskAlternate)
    #expect(shortcut.isAlternateDown() == true)
  }

  @Test func isAlternateDownFalseOptionL() {
    let shortcut = createShortcut(keyCode: optionL, flags: maskAlternate)
    #expect(shortcut.isAlternateDown() == false)
  }

  @Test func isAlternateDownFalseOptionR() {
    let shortcut = createShortcut(keyCode: optionR, flags: maskAlternate)
    #expect(shortcut.isAlternateDown() == false)
  }

  // isSecondaryFnDown - keyCode 63 は除外
  @Test func isSecondaryFnDownTrue() {
    let shortcut = createShortcut(keyCode: 0, flags: maskSecondaryFn)
    #expect(shortcut.isSecondaryFnDown() == true)
  }

  @Test func isSecondaryFnDownFalseFnKey() {
    let shortcut = createShortcut(keyCode: fnKey, flags: maskSecondaryFn)
    #expect(shortcut.isSecondaryFnDown() == false)
  }

  // isCapslockDown - keyCode 57 は除外
  @Test func isCapslockDownTrue() {
    let shortcut = createShortcut(keyCode: 0, flags: maskAlphaShift)
    #expect(shortcut.isCapslockDown() == true)
  }

  @Test func isCapslockDownFalseCapsLock() {
    let shortcut = createShortcut(keyCode: capsLock, flags: maskAlphaShift)
    #expect(shortcut.isCapslockDown() == false)
  }

  // MARK: - 5. isCover Tests

  @Test func isCoverExactMatch() {
    // 同一の修飾キーでtrue
    let a = createShortcut(keyCode: 0, flags: maskCommand)
    let b = createShortcut(keyCode: 0, flags: maskCommand)
    #expect(a.isCover(b) == true)
  }

  @Test func isCoverSuperset() {
    // 自分がより多い修飾キーを持っている場合はtrue
    let a = createShortcut(keyCode: 0, flags: maskCommand | maskShift)
    let b = createShortcut(keyCode: 0, flags: maskCommand)
    #expect(a.isCover(b) == true)
  }

  @Test func isCoverSubset() {
    // 相手がより多い修飾キーを持っている場合はfalse
    let a = createShortcut(keyCode: 0, flags: maskCommand)
    let b = createShortcut(keyCode: 0, flags: maskCommand | maskShift)
    #expect(a.isCover(b) == false)
  }

  @Test func isCoverNoFlags() {
    // 両方フラグなしでtrue
    let a = createShortcut(keyCode: 0, flags: 0)
    let b = createShortcut(keyCode: 0, flags: 0)
    #expect(a.isCover(b) == true)
  }

  @Test func isCoverMixedFlags() {
    // 異なるフラグの組み合わせでfalse
    let a = createShortcut(keyCode: 0, flags: maskCommand)
    let b = createShortcut(keyCode: 0, flags: maskShift)
    #expect(a.isCover(b) == false)
  }

  @Test func isCoverSelfModifierKey() {
    // 自分が修飾キー自身の場合（例: Command_L）
    // Command_Lは keyCode=55 で、isCommandDown()がfalseになる
    let commandLShortcut = createShortcut(keyCode: commandL, flags: maskCommand)
    let regularWithCommand = createShortcut(keyCode: 0, flags: maskCommand)

    // commandLShortcutは isCommandDown() == false なので、
    // regularWithCommand (isCommandDown() == true) をカバーできない
    #expect(commandLShortcut.isCover(regularWithCommand) == false)
  }

  // MARK: - 6. Edge Cases & Reference Type Tests

  @Test func referenceTypeSemantics() {
    let original = createShortcut(keyCode: 55, flags: maskCommand)
    let reference = original

    reference.keyCode = 100

    #expect(original.keyCode == 100)
    #expect(reference.keyCode == 100)
  }

  @Test func equalityIsReferenceBasedNotValue() {
    let a = createShortcut(keyCode: 55, flags: maskCommand)
    let b = createShortcut(keyCode: 55, flags: maskCommand)

    // 同じ値でも異なるインスタンスはisEqualでfalse
    #expect(a.isEqual(b) == false)
    #expect(a !== b)

    // 同一参照ならtrue
    let c = a
    #expect(a.isEqual(c) == true)
    #expect(a === c)
  }

  @Test func initFromDictionaryWithExtraKeys() {
    let dictionary: [AnyHashable: Any] = [
      "keyCode": 55,
      "flags": 0,
      "extra": "ignored",
      "another": 123,
    ]
    let shortcut = KeyboardShortcut(dictionary: dictionary)

    #expect(shortcut != nil)
    #expect(shortcut?.keyCode == 55)
  }

  // MARK: - Additional Tests

  @Test func initFromFlagsAsString() {
    // flagsが文字列の場合
    let dictionary: [AnyHashable: Any] = ["keyCode": 55, "flags": "0"]
    let shortcut = KeyboardShortcut(dictionary: dictionary)
    #expect(shortcut == nil)
  }

  @Test func toStringModifierKeyItself() {
    // 修飾キー自身のtoString
    let shortcut = createShortcut(keyCode: commandL, flags: maskCommand)
    // keyCode 55 = "Command_L"
    // isCommandDown() == false なので ⌘ は付かない
    #expect(shortcut.toString() == "Command_L")
  }

  @Test func toStringWithCapsLockFlag() {
    let shortcut = createShortcut(keyCode: 0, flags: maskAlphaShift)
    #expect(shortcut.toString() == "⇪A")
  }

  @Test func toStringAllFlags() {
    // 全フラグ: (fn)⇪⌘⇧⌃⌥ の順
    let allFlags = maskSecondaryFn | maskAlphaShift | maskCommand | maskShift | maskControl | maskAlternate
    let shortcut = createShortcut(keyCode: 0, flags: allFlags)
    #expect(shortcut.toString() == "(fn)⇪⌘⇧⌃⌥A")
  }
}
