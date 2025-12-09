//
//  checkUpdate.swift
//  ⌘英かな
//
//  MIT License
//  Copyright (c) 2016 iMasanari
//

import Cocoa

// MARK: - ReleaseInfo

struct ReleaseInfo {
  let version: String
  let description: String
  let releaseUrl: String
}

// MARK: - JSON Parsing

func parseReleaseJSON(_ data: Data) -> ReleaseInfo? {
  do {
    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    else {
      return nil
    }

    // tag_name から "v" プレフィックスを除去してバージョン番号を取得
    var version = ""
    if let tagName = json["tag_name"] as? String {
      version = tagName.hasPrefix("v") ? String(tagName.dropFirst()) : tagName
    }

    // versionが空の場合はnil
    if version.isEmpty {
      return nil
    }

    // リリース名を説明として使用
    let description = json["name"] as? String ?? ""

    // リリースページのURL
    let releaseUrl =
      json["html_url"] as? String ?? "https://github.com/dominion525/cmd-eikana/releases"

    return ReleaseInfo(version: version, description: description, releaseUrl: releaseUrl)
  } catch {
    return nil
  }
}

// MARK: - Check Update

func checkUpdate(_ callback: ((_ isNewVer: Bool?) -> Void)? = nil) {
  // GitHub Releases API
  let url = URL(string: "https://api.github.com/repos/dominion525/cmd-eikana/releases/latest")!
  var request = URLRequest(url: url)
  request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

  let handler = { (data: Data?, _: URLResponse?, error: Error?) in
    let currentVersion =
      Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"

    // JSONパース
    guard let data = data, let releaseInfo = parseReleaseJSON(data) else {
      DispatchQueue.main.async {
        callback?(nil)
      }
      return
    }

    // バージョン比較
    let isAbleUpdate: Bool? = compareVersions(releaseInfo.version, currentVersion)

    if isAbleUpdate == true {
      DispatchQueue.main.async {
        let alert = NSAlert()
        alert.messageText = "⌘英かな ver.\(releaseInfo.version) が利用可能です"
        alert.informativeText = releaseInfo.description
        alert.addButton(withTitle: "Download")
        alert.addButton(withTitle: "Cancel")
        let ret = alert.runModal()

        if ret == NSApplication.ModalResponse.alertFirstButtonReturn {
          if let url = URL(string: releaseInfo.releaseUrl) {
            NSWorkspace.shared.open(url)
          }
        }
      }
    }

    if let callback = callback {
      DispatchQueue.main.async {
        callback(isAbleUpdate)
      }
    }
  }

  let config = URLSessionConfiguration.default
  let session = URLSession(configuration: config)
  let task = session.dataTask(with: request, completionHandler: handler)
  task.resume()
}

// セマンティックバージョニングで比較 (new > current なら true)
func compareVersions(_ newVersion: String, _ currentVersion: String) -> Bool {
  let newParts = newVersion.split(separator: ".").compactMap { Int($0) }
  let currentParts = currentVersion.split(separator: ".").compactMap { Int($0) }

  let maxLength = max(newParts.count, currentParts.count)
  let paddedNew = newParts + Array(repeating: 0, count: maxLength - newParts.count)
  let paddedCurrent = currentParts + Array(repeating: 0, count: maxLength - currentParts.count)

  for (newPart, currentPart) in zip(paddedNew, paddedCurrent) {
    if newPart > currentPart {
      return true
    } else if newPart < currentPart {
      return false
    }
  }

  return false  // 同じバージョン
}
