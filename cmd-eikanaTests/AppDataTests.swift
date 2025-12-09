//
//  AppDataTests.swift
//  cmd-eikanaTests
//

import Foundation
import Testing

@testable import _英かな

struct AppDataTests {

  // MARK: - Initialization Tests

  @Test func initWithParameters() {
    let appData = AppData(name: "Safari", id: "com.apple.Safari")

    #expect(appData.name == "Safari")
    #expect(appData.id == "com.apple.Safari")
  }

  @Test func initDefault() {
    let appData = AppData()

    #expect(appData.name == "")
    #expect(appData.id == "")
  }

  // MARK: - Dictionary Initialization Tests

  @Test func initFromValidDictionary() {
    let dictionary: [AnyHashable: Any] = ["name": "Finder", "id": "com.apple.finder"]
    let appData = AppData(dictionary: dictionary)

    #expect(appData != nil)
    #expect(appData?.name == "Finder")
    #expect(appData?.id == "com.apple.finder")
  }

  @Test func initFromMissingName() {
    let dictionary: [AnyHashable: Any] = ["id": "com.apple.finder"]
    let appData = AppData(dictionary: dictionary)

    #expect(appData == nil)
  }

  @Test func initFromMissingId() {
    let dictionary: [AnyHashable: Any] = ["name": "Finder"]
    let appData = AppData(dictionary: dictionary)

    #expect(appData == nil)
  }

  @Test func initFromWrongType() {
    let dictionary: [AnyHashable: Any] = ["name": 123, "id": "com.apple.finder"]
    let appData = AppData(dictionary: dictionary)

    #expect(appData == nil)
  }

  // MARK: - Serialization Tests

  @Test func toDictionary() {
    let appData = AppData(name: "Terminal", id: "com.apple.Terminal")
    let dictionary = appData.toDictionary()

    #expect(dictionary["name"] as? String == "Terminal")
    #expect(dictionary["id"] as? String == "com.apple.Terminal")
  }

  @Test func roundTrip() {
    let original = AppData(name: "Xcode", id: "com.apple.dt.Xcode")
    let dictionary = original.toDictionary()
    let restored = AppData(dictionary: dictionary)

    #expect(restored != nil)
    #expect(restored?.name == original.name)
    #expect(restored?.id == original.id)
  }

  // MARK: - Edge Cases

  @Test func initWithEmptyStrings() {
    let appData = AppData(name: "", id: "")

    #expect(appData.name == "")
    #expect(appData.id == "")
  }

  @Test func initWithUnicodeCharacters() {
    let appData = AppData(name: "⌘英かな", id: "com.example.テスト")

    #expect(appData.name == "⌘英かな")
    #expect(appData.id == "com.example.テスト")
  }

  @Test func initFromDictionaryWithExtraKeys() {
    // 余分なキーは無視されるべき
    let dictionary: [AnyHashable: Any] = [
      "name": "Test",
      "id": "com.test",
      "extra": "ignored",
      "another": 123,
    ]
    let appData = AppData(dictionary: dictionary)

    #expect(appData != nil)
    #expect(appData?.name == "Test")
    #expect(appData?.id == "com.test")
  }

  @Test func initFromEmptyDictionary() {
    let dictionary: [AnyHashable: Any] = [:]
    let appData = AppData(dictionary: dictionary)

    #expect(appData == nil)
  }

  // MARK: - Reference Type Behavior

  @Test func referenceTypeSemantics() {
    // AppDataはクラス（参照型）なので、変更が共有される
    let original = AppData(name: "Original", id: "com.original")
    let reference = original

    reference.name = "Modified"

    #expect(original.name == "Modified")
    #expect(reference.name == "Modified")
  }

  @Test func equalityIsReferenceBasedNotValue() {
    // NSObjectのデフォルト等価性は参照比較
    let first = AppData(name: "Same", id: "com.same")
    let second = AppData(name: "Same", id: "com.same")

    // 同じ値でも異なるインスタンスはisEqualでfalse
    #expect(first.isEqual(second) == false)
    #expect(first !== second)

    // 同一参照ならtrue
    let sameReference = first
    #expect(first.isEqual(sameReference) == true)
    #expect(first === sameReference)
  }
}
