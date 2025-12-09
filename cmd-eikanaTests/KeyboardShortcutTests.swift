//
//  KeyboardShortcutTests.swift
//  cmd-eikanaTests
//

import CoreGraphics
import Foundation
import Testing

@testable import _英かな

struct KeyboardShortcutTests {

  typealias Constants = KeyboardShortcutTestConstants

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
    let shortcut = createShortcut(keyCode: 0, flags: Constants.maskCommand)
    #expect(shortcut.keyCode == 0)
    #expect(shortcut.flags.rawValue == Constants.maskCommand)
  }

  @Test func initFromValidDictionary() {
    let dictionary = createShortcutDictionary(keyCode: 55, flags: 1_048_576)
    let shortcut = KeyboardShortcut(dictionary: dictionary)

    #expect(shortcut != nil)
    #expect(shortcut?.keyCode == 55)
    #expect(shortcut?.flags.rawValue == 1_048_576)
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

  @Test func initFromFlagsAsString() {
    // flagsが文字列の場合
    let dictionary: [AnyHashable: Any] = ["keyCode": 55, "flags": "0"]
    let shortcut = KeyboardShortcut(dictionary: dictionary)
    #expect(shortcut == nil)
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

  // MARK: - 2. Serialization Tests

  @Test func toDictionary() {
    let shortcut = createShortcut(keyCode: 55, flags: Constants.maskCommand)
    let dictionary = shortcut.toDictionary()

    #expect(dictionary["keyCode"] as? Int == 55)
    #expect(dictionary["flags"] as? Int == Int(Constants.maskCommand))
  }

  @Test func toDictionaryWithLargeFlags() {
    // 複数のフラグを組み合わせた大きな値
    let combinedFlags = Constants.maskCommand | Constants.maskShift | Constants.maskControl
    let shortcut = createShortcut(keyCode: 0, flags: combinedFlags)
    let dictionary = shortcut.toDictionary()

    #expect(dictionary["flags"] as? Int == Int(combinedFlags))
  }

  @Test func roundTrip() {
    let original = createShortcut(keyCode: 54, flags: Constants.maskCommand | Constants.maskShift)
    let dictionary = original.toDictionary()
    let restored = KeyboardShortcut(dictionary: dictionary)

    #expect(restored != nil)
    #expect(restored?.keyCode == original.keyCode)
    #expect(restored?.flags.rawValue == original.flags.rawValue)
  }

  @Test func roundTripWithMaxValues() {
    // 大きなkeyCode値とフラグ値での往復
    let flags =
      Constants.maskCommand | Constants.maskShift | Constants.maskControl | Constants.maskAlternate
    let original = createShortcut(keyCode: 999, flags: flags)
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
    let shortcut = createShortcut(keyCode: 0, flags: Constants.maskCommand)
    #expect(shortcut.toString() == "⌘A")
  }

  @Test func toStringWithShiftFlag() {
    let shortcut = createShortcut(keyCode: 0, flags: Constants.maskShift)
    #expect(shortcut.toString() == "⇧A")
  }

  @Test func toStringWithControlFlag() {
    let shortcut = createShortcut(keyCode: 0, flags: Constants.maskControl)
    #expect(shortcut.toString() == "⌃A")
  }

  @Test func toStringWithAlternateFlag() {
    let shortcut = createShortcut(keyCode: 0, flags: Constants.maskAlternate)
    #expect(shortcut.toString() == "⌥A")
  }

  @Test func toStringWithFnFlag() {
    let shortcut = createShortcut(keyCode: 0, flags: Constants.maskSecondaryFn)
    #expect(shortcut.toString() == "(fn)A")
  }

  @Test func toStringWithMultipleFlags() {
    // 複数フラグ: (fn)⇪⌘⇧⌃⌥ の順で表示される
    let shortcut = createShortcut(keyCode: 0, flags: Constants.maskCommand | Constants.maskShift)
    #expect(shortcut.toString() == "⌘⇧A")
  }

  @Test func toStringModifierKeyItself() {
    // 修飾キー自身のtoString
    let shortcut = createShortcut(keyCode: Constants.commandL, flags: Constants.maskCommand)
    // keyCode 55 = "Command_L"
    // isCommandDown() == false なので ⌘ は付かない
    #expect(shortcut.toString() == "Command_L")
  }

  @Test func toStringWithCapsLockFlag() {
    let shortcut = createShortcut(keyCode: 0, flags: Constants.maskAlphaShift)
    #expect(shortcut.toString() == "⇪A")
  }

  @Test func toStringAllFlags() {
    // 全フラグ: (fn)⇪⌘⇧⌃⌥ の順
    let allFlags =
      Constants.maskSecondaryFn | Constants.maskAlphaShift | Constants.maskCommand
      | Constants.maskShift | Constants.maskControl | Constants.maskAlternate
    let shortcut = createShortcut(keyCode: 0, flags: allFlags)
    #expect(shortcut.toString() == "(fn)⇪⌘⇧⌃⌥A")
  }

  // MARK: - 4. isCover Tests

  @Test func isCoverExactMatch() {
    // 同一の修飾キーでtrue
    let source = createShortcut(keyCode: 0, flags: Constants.maskCommand)
    let target = createShortcut(keyCode: 0, flags: Constants.maskCommand)
    #expect(source.isCover(target) == true)
  }

  @Test func isCoverSuperset() {
    // 自分がより多い修飾キーを持っている場合はtrue
    let source = createShortcut(keyCode: 0, flags: Constants.maskCommand | Constants.maskShift)
    let target = createShortcut(keyCode: 0, flags: Constants.maskCommand)
    #expect(source.isCover(target) == true)
  }

  @Test func isCoverSubset() {
    // 相手がより多い修飾キーを持っている場合はfalse
    let source = createShortcut(keyCode: 0, flags: Constants.maskCommand)
    let target = createShortcut(keyCode: 0, flags: Constants.maskCommand | Constants.maskShift)
    #expect(source.isCover(target) == false)
  }

  @Test func isCoverNoFlags() {
    // 両方フラグなしでtrue
    let source = createShortcut(keyCode: 0, flags: 0)
    let target = createShortcut(keyCode: 0, flags: 0)
    #expect(source.isCover(target) == true)
  }

  @Test func isCoverMixedFlags() {
    // 異なるフラグの組み合わせでfalse
    let source = createShortcut(keyCode: 0, flags: Constants.maskCommand)
    let target = createShortcut(keyCode: 0, flags: Constants.maskShift)
    #expect(source.isCover(target) == false)
  }

  @Test func isCoverSelfModifierKey() {
    // 自分が修飾キー自身の場合（例: Command_L）
    // Command_Lは keyCode=55 で、isCommandDown()がfalseになる
    let commandLShortcut = createShortcut(keyCode: Constants.commandL, flags: Constants.maskCommand)
    let regularWithCommand = createShortcut(keyCode: 0, flags: Constants.maskCommand)

    // commandLShortcutは isCommandDown() == false なので、
    // regularWithCommand (isCommandDown() == true) をカバーできない
    #expect(commandLShortcut.isCover(regularWithCommand) == false)
  }

  // MARK: - 5. Reference Type Tests

  @Test func referenceTypeSemantics() {
    let original = createShortcut(keyCode: 55, flags: Constants.maskCommand)
    let reference = original

    reference.keyCode = 100

    #expect(original.keyCode == 100)
    #expect(reference.keyCode == 100)
  }

  @Test func equalityIsReferenceBasedNotValue() {
    let first = createShortcut(keyCode: 55, flags: Constants.maskCommand)
    let second = createShortcut(keyCode: 55, flags: Constants.maskCommand)

    // 同じ値でも異なるインスタンスはisEqualでfalse
    #expect(first.isEqual(second) == false)
    #expect(first !== second)

    // 同一参照ならtrue
    let sameReference = first
    #expect(first.isEqual(sameReference) == true)
    #expect(first === sameReference)
  }
}
