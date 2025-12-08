//
//  KeyMappingTests.swift
//  cmd-eikanaTests
//

import CoreGraphics
import Foundation
import Testing

@testable import _英かな

struct KeyMappingTests {

  // MARK: - Helper

  func createShortcut(keyCode: UInt16 = 0, flags: UInt64 = 0) -> KeyboardShortcut {
    KeyboardShortcut(keyCode: CGKeyCode(keyCode), flags: CGEventFlags(rawValue: flags))
  }

  func createShortcutDictionary(keyCode: Int = 0, flags: Int = 0) -> [AnyHashable: Any] {
    ["keyCode": keyCode, "flags": flags]
  }

  // MARK: - Initialization Tests

  @Test func initWithAllParameters() {
    let input = createShortcut(keyCode: 55)  // Command_L
    let output = createShortcut(keyCode: 102)  // 英数
    let mapping = KeyMapping(input: input, output: output, enable: false)

    #expect(mapping.input.keyCode == 55)
    #expect(mapping.output.keyCode == 102)
    #expect(mapping.enable == false)
  }

  @Test func initWithDefaultEnable() {
    let input = createShortcut(keyCode: 55)
    let output = createShortcut(keyCode: 102)
    let mapping = KeyMapping(input: input, output: output)

    #expect(mapping.enable == true)
  }

  @Test func initDefault() {
    let mapping = KeyMapping()

    #expect(mapping.input.keyCode == 0)
    #expect(mapping.output.keyCode == 0)
    #expect(mapping.enable == true)
  }

  // MARK: - Dictionary Initialization Tests

  @Test func initFromValidDictionary() {
    let dictionary: [AnyHashable: Any] = [
      "input": createShortcutDictionary(keyCode: 55, flags: 0),
      "output": createShortcutDictionary(keyCode: 102, flags: 0),
      "enable": true,
    ]
    let mapping = KeyMapping(dictionary: dictionary)

    #expect(mapping != nil)
    #expect(mapping?.input.keyCode == 55)
    #expect(mapping?.output.keyCode == 102)
    #expect(mapping?.enable == true)
  }

  @Test func initFromMissingInput() {
    let dictionary: [AnyHashable: Any] = [
      "output": createShortcutDictionary(keyCode: 102),
      "enable": true,
    ]
    let mapping = KeyMapping(dictionary: dictionary)

    #expect(mapping == nil)
  }

  @Test func initFromMissingOutput() {
    let dictionary: [AnyHashable: Any] = [
      "input": createShortcutDictionary(keyCode: 55),
      "enable": true,
    ]
    let mapping = KeyMapping(dictionary: dictionary)

    #expect(mapping == nil)
  }

  @Test func initFromMissingEnable() {
    let dictionary: [AnyHashable: Any] = [
      "input": createShortcutDictionary(keyCode: 55),
      "output": createShortcutDictionary(keyCode: 102),
    ]
    let mapping = KeyMapping(dictionary: dictionary)

    #expect(mapping == nil)
  }

  @Test func initFromInvalidInput() {
    // input辞書にkeyCodeがない
    let dictionary: [AnyHashable: Any] = [
      "input": ["invalid": "data"],
      "output": createShortcutDictionary(keyCode: 102),
      "enable": true,
    ]
    let mapping = KeyMapping(dictionary: dictionary)

    #expect(mapping == nil)
  }

  // MARK: - Serialization Tests

  @Test func toDictionary() {
    let input = createShortcut(keyCode: 55, flags: 256)  // Command flag
    let output = createShortcut(keyCode: 102)
    let mapping = KeyMapping(input: input, output: output, enable: false)

    let dictionary = mapping.toDictionary()

    let inputDict = dictionary["input"] as? [AnyHashable: Any]
    let outputDict = dictionary["output"] as? [AnyHashable: Any]

    #expect(inputDict?["keyCode"] as? Int == 55)
    #expect(inputDict?["flags"] as? Int == 256)
    #expect(outputDict?["keyCode"] as? Int == 102)
    #expect(dictionary["enable"] as? Bool == false)
  }

  @Test func roundTrip() {
    let input = createShortcut(keyCode: 54, flags: 1048840)  // Command_R with flags
    let output = createShortcut(keyCode: 104)  // かな
    let original = KeyMapping(input: input, output: output, enable: true)

    let dictionary = original.toDictionary()
    let restored = KeyMapping(dictionary: dictionary)

    #expect(restored != nil)
    #expect(restored?.input.keyCode == original.input.keyCode)
    #expect(restored?.input.flags.rawValue == original.input.flags.rawValue)
    #expect(restored?.output.keyCode == original.output.keyCode)
    #expect(restored?.enable == original.enable)
  }

  // MARK: - Edge Cases

  @Test func initFromDictionaryWithExtraKeys() {
    let dictionary: [AnyHashable: Any] = [
      "input": createShortcutDictionary(keyCode: 55),
      "output": createShortcutDictionary(keyCode: 102),
      "enable": true,
      "extra": "ignored",
      "another": 123,
    ]
    let mapping = KeyMapping(dictionary: dictionary)

    #expect(mapping != nil)
    #expect(mapping?.input.keyCode == 55)
  }

  @Test func enableFalse() {
    let input = createShortcut(keyCode: 55)
    let output = createShortcut(keyCode: 102)
    let mapping = KeyMapping(input: input, output: output, enable: false)

    #expect(mapping.enable == false)

    // toDictionaryでもfalseが保持される
    let dictionary = mapping.toDictionary()
    #expect(dictionary["enable"] as? Bool == false)

    // 往復でもfalseが保持される
    let restored = KeyMapping(dictionary: dictionary)
    #expect(restored?.enable == false)
  }

  // MARK: - Reference Type Behavior

  @Test func referenceTypeSemantics() {
    let input = createShortcut(keyCode: 55)
    let output = createShortcut(keyCode: 102)
    let original = KeyMapping(input: input, output: output, enable: true)
    let reference = original

    reference.enable = false

    #expect(original.enable == false)
    #expect(reference.enable == false)
  }

  @Test func nestedReferenceTypeSemantics() {
    // KeyboardShortcutも参照型なので、input/outputへの変更が共有される
    let input = createShortcut(keyCode: 55)
    let output = createShortcut(keyCode: 102)
    let mapping = KeyMapping(input: input, output: output, enable: true)

    // 元のinputを変更すると、mappingのinputも変わる
    input.keyCode = 999

    #expect(mapping.input.keyCode == 999)
    #expect(input.keyCode == 999)
  }

  @Test func sameShortcutForInputAndOutput() {
    // 同じインスタンスをinputとoutputに使った場合
    let shortcut = createShortcut(keyCode: 55)
    let mapping = KeyMapping(input: shortcut, output: shortcut, enable: true)

    // 片方を変更すると両方変わる（同一参照）
    mapping.input.keyCode = 100

    #expect(mapping.input.keyCode == 100)
    #expect(mapping.output.keyCode == 100)
    #expect(shortcut.keyCode == 100)
  }

  @Test func equalityIsReferenceBasedNotValue() {
    // NSObjectのデフォルト等価性は参照比較
    let input1 = createShortcut(keyCode: 55)
    let output1 = createShortcut(keyCode: 102)
    let a = KeyMapping(input: input1, output: output1, enable: true)

    let input2 = createShortcut(keyCode: 55)
    let output2 = createShortcut(keyCode: 102)
    let b = KeyMapping(input: input2, output: output2, enable: true)

    // 同じ値でも異なるインスタンスはisEqualでfalse
    #expect(a.isEqual(b) == false)
    #expect(a !== b)

    // 同一参照ならtrue
    let c = a
    #expect(a.isEqual(c) == true)
    #expect(a === c)
  }

  // MARK: - Additional Type Mismatch Tests

  @Test func initFromInputAsString() {
    // inputが辞書ではなく文字列
    let dictionary: [AnyHashable: Any] = [
      "input": "not a dictionary",
      "output": createShortcutDictionary(keyCode: 102),
      "enable": true,
    ]
    let mapping = KeyMapping(dictionary: dictionary)

    #expect(mapping == nil)
  }

  @Test func initFromOutputAsString() {
    // outputが辞書ではなく文字列
    let dictionary: [AnyHashable: Any] = [
      "input": createShortcutDictionary(keyCode: 55),
      "output": "not a dictionary",
      "enable": true,
    ]
    let mapping = KeyMapping(dictionary: dictionary)

    #expect(mapping == nil)
  }

  @Test func initFromEnableAsInt() {
    // enableがBoolではなくInt（Swiftでは1はtrueにならない）
    let dictionary: [AnyHashable: Any] = [
      "input": createShortcutDictionary(keyCode: 55),
      "output": createShortcutDictionary(keyCode: 102),
      "enable": 1,
    ]
    let mapping = KeyMapping(dictionary: dictionary)

    #expect(mapping == nil)
  }

  @Test func initFromEnableAsString() {
    // enableが文字列
    let dictionary: [AnyHashable: Any] = [
      "input": createShortcutDictionary(keyCode: 55),
      "output": createShortcutDictionary(keyCode: 102),
      "enable": "true",
    ]
    let mapping = KeyMapping(dictionary: dictionary)

    #expect(mapping == nil)
  }
}
