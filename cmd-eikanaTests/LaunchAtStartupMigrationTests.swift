//
//  LaunchAtStartupMigrationTests.swift
//  cmd-eikanaTests
//
//  Copyright © 2025 eikana. All rights reserved.
//

import Testing

@testable import _英かな

struct LaunchAtStartupMigrationTests {

  // バージョンが同じ場合は再登録しない
  @Test func sameVersionShouldNotReregister() {
    let result = shouldReregisterLaunchAtStartup(
      lastVersion: "2.4.0",
      currentVersion: "2.4.0",
      launchAtStartupEnabled: true
    )
    #expect(result == false)
  }

  // バージョンが異なり、自動起動オンなら再登録する
  @Test func differentVersionWithEnabledShouldReregister() {
    let result = shouldReregisterLaunchAtStartup(
      lastVersion: "2.4.0",
      currentVersion: "2.4.1",
      launchAtStartupEnabled: true
    )
    #expect(result == true)
  }

  // バージョンが異なっても、自動起動オフなら再登録しない
  @Test func differentVersionWithDisabledShouldNotReregister() {
    let result = shouldReregisterLaunchAtStartup(
      lastVersion: "2.4.0",
      currentVersion: "2.4.1",
      launchAtStartupEnabled: false
    )
    #expect(result == false)
  }

  // 初回起動（lastVersion == nil）で自動起動オンなら再登録する
  @Test func firstLaunchWithEnabledShouldReregister() {
    let result = shouldReregisterLaunchAtStartup(
      lastVersion: nil,
      currentVersion: "2.4.1",
      launchAtStartupEnabled: true
    )
    #expect(result == true)
  }

  // 初回起動（lastVersion == nil）で自動起動オフなら再登録しない
  @Test func firstLaunchWithDisabledShouldNotReregister() {
    let result = shouldReregisterLaunchAtStartup(
      lastVersion: nil,
      currentVersion: "2.4.1",
      launchAtStartupEnabled: false
    )
    #expect(result == false)
  }

  // 両方nilの場合（エッジケース）は再登録しない
  @Test func bothNilShouldNotReregister() {
    let result = shouldReregisterLaunchAtStartup(
      lastVersion: nil,
      currentVersion: nil,
      launchAtStartupEnabled: true
    )
    #expect(result == false)
  }
}
