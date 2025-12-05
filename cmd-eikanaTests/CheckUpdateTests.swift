//
//  CheckUpdateTests.swift
//  cmd-eikanaTests
//

import Testing
@testable import _英かな

struct CheckUpdateTests {

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
}
