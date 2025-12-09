//
//  CheckUpdateTests.swift
//  cmd-eikanaTests
//

import Foundation
import Testing

@testable import _英かな

struct CheckUpdateTests {

  // MARK: - Helper

  func createJSON(tagName: String?, name: String?, htmlUrl: String?) -> Data {
    var dict: [String: Any] = [:]
    if let tagName = tagName {
      dict["tag_name"] = tagName
    }
    if let name = name {
      dict["name"] = name
    }
    if let htmlUrl = htmlUrl {
      dict["html_url"] = htmlUrl
    }
    return try! JSONSerialization.data(withJSONObject: dict, options: [])
  }

  // MARK: - compareVersions Tests

  @Test func newerMajorVersion() {
    #expect(compareVersions("3.0.0", "2.3.0") == true)
  }

  @Test func newerMinorVersion() {
    #expect(compareVersions("2.4.0", "2.3.0") == true)
  }

  @Test func newerPatchVersion() {
    #expect(compareVersions("2.3.1", "2.3.0") == true)
  }

  @Test func sameVersion() {
    #expect(compareVersions("2.3.0", "2.3.0") == false)
  }

  @Test func olderMajorVersion() {
    #expect(compareVersions("1.0.0", "2.3.0") == false)
  }

  @Test func olderMinorVersion() {
    #expect(compareVersions("2.2.0", "2.3.0") == false)
  }

  @Test func olderPatchVersion() {
    #expect(compareVersions("2.3.0", "2.3.1") == false)
  }

  // 数値比較が正しく動作することを確認（文字列比較だと "2.10.0" < "2.9.0" になる）
  @Test func twoDigitVersion() {
    #expect(compareVersions("2.10.0", "2.9.0") == true)
  }

  @Test func differentLengthVersions() {
    #expect(compareVersions("2.3.1", "2.3") == true)
    #expect(compareVersions("2.3", "2.3.1") == false)
  }

  // MARK: - parseReleaseJSON Tests

  @Test func parseValidJSON() {
    let data = createJSON(
      tagName: "v3.0.0",
      name: "Release 3.0.0",
      htmlUrl: "https://github.com/dominion525/cmd-eikana/releases/tag/v3.0.0"
    )
    let result = parseReleaseJSON(data)

    #expect(result != nil)
    #expect(result?.version == "3.0.0")
    #expect(result?.description == "Release 3.0.0")
    #expect(result?.releaseUrl == "https://github.com/dominion525/cmd-eikana/releases/tag/v3.0.0")
  }

  @Test func parseJSONWithVPrefix() {
    let data = createJSON(tagName: "v2.5.1", name: nil, htmlUrl: nil)
    let result = parseReleaseJSON(data)

    #expect(result != nil)
    #expect(result?.version == "2.5.1")
  }

  @Test func parseJSONWithoutVPrefix() {
    let data = createJSON(tagName: "2.5.1", name: nil, htmlUrl: nil)
    let result = parseReleaseJSON(data)

    #expect(result != nil)
    #expect(result?.version == "2.5.1")
  }

  @Test func parseJSONMissingTagName() {
    let data = createJSON(tagName: nil, name: "Release", htmlUrl: "https://example.com")
    let result = parseReleaseJSON(data)

    #expect(result == nil)
  }

  @Test func parseJSONEmptyTagName() {
    let data = createJSON(tagName: "", name: "Release", htmlUrl: "https://example.com")
    let result = parseReleaseJSON(data)

    #expect(result == nil)
  }

  @Test func parseJSONMissingName() {
    let data = createJSON(tagName: "v1.0.0", name: nil, htmlUrl: "https://example.com")
    let result = parseReleaseJSON(data)

    #expect(result != nil)
    #expect(result?.description == "")
  }

  @Test func parseJSONMissingHtmlUrl() {
    let data = createJSON(tagName: "v1.0.0", name: "Release", htmlUrl: nil)
    let result = parseReleaseJSON(data)

    #expect(result != nil)
    #expect(result?.releaseUrl == "https://github.com/dominion525/cmd-eikana/releases")
  }

  @Test func parseInvalidJSON() {
    let data = "not valid json".data(using: .utf8)!
    let result = parseReleaseJSON(data)

    #expect(result == nil)
  }

  @Test func parseEmptyData() {
    let data = Data()
    let result = parseReleaseJSON(data)

    #expect(result == nil)
  }

  // MARK: - Integration Tests (Real API)

  @Test func fetchRealGitHubAPI() async throws {
    let url = URL(string: "https://api.github.com/repos/dominion525/cmd-eikana/releases/latest")!
    var request = URLRequest(url: url)
    request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

    let (data, response) = try await URLSession.shared.data(for: request)

    // HTTPレスポンスの確認
    let httpResponse = response as! HTTPURLResponse
    #expect(httpResponse.statusCode == 200)

    // JSONパースの確認
    let releaseInfo = parseReleaseJSON(data)
    #expect(releaseInfo != nil)
    #expect(releaseInfo?.version.isEmpty == false)
    #expect(releaseInfo?.releaseUrl.contains("github.com") == true)
  }
}
