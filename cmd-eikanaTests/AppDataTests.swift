//
//  AppDataTests.swift
//  cmd-eikanaTests
//

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
}
