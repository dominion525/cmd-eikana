//
//  checkUpdate.swift
//  ⌘英かな
//
//  MIT License
//  Copyright (c) 2016 iMasanari
//

import Cocoa

func checkUpdate(_ callback: ((_ isNewVer: Bool?) -> Void)? = nil) {
    // GitHub Releases API
    let url = URL(string: "https://api.github.com/repos/dominion525/cmd-eikana/releases/latest")!
    var request = URLRequest(url: url)
    request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

    let handler = { (data: Data?, res: URLResponse?, error: Error?) -> Void in
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
        var newVersion = ""
        var description = ""
        var releaseUrl = "https://github.com/dominion525/cmd-eikana/releases"

        do {
            if let data = data,
               let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                // tag_name から "v" プレフィックスを除去してバージョン番号を取得
                if let tagName = json["tag_name"] as? String {
                    newVersion = tagName.hasPrefix("v") ? String(tagName.dropFirst()) : tagName
                }

                // リリース名を説明として使用
                if let name = json["name"] as? String {
                    description = name
                }

                // リリースページのURL
                if let htmlUrl = json["html_url"] as? String {
                    releaseUrl = htmlUrl
                }
            }
        } catch let error as NSError {
            print("JSON parse error: \(error.debugDescription)")
            DispatchQueue.main.async {
                callback?(nil)
            }
            return
        }

        // バージョン比較
        let isAbleUpdate: Bool? = (newVersion == "") ? nil : compareVersions(newVersion, version)

        if isAbleUpdate == true {
            DispatchQueue.main.async {
                let alert = NSAlert()
                alert.messageText = "⌘英かな ver.\(newVersion) が利用可能です"
                alert.informativeText = description
                alert.addButton(withTitle: "Download")
                alert.addButton(withTitle: "Cancel")
                let ret = alert.runModal()

                if ret == NSApplication.ModalResponse.alertFirstButtonReturn {
                    if let url = URL(string: releaseUrl) {
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

    for i in 0..<maxLength {
        let newPart = i < newParts.count ? newParts[i] : 0
        let currentPart = i < currentParts.count ? currentParts[i] : 0

        if newPart > currentPart {
            return true
        } else if newPart < currentPart {
            return false
        }
    }

    return false // 同じバージョン
}
