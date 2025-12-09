//
//  KeyboardShortcutFlagTests.swift
//  cmd-eikanaTests
//

import CoreGraphics
import Foundation
import Testing

@testable import _英かな

struct KeyboardShortcutFlagTests {

  typealias Constants = KeyboardShortcutTestConstants

  // MARK: - isCommandDown Tests

  @Test func isCommandDownTrue() {
    let shortcut = createShortcut(keyCode: 0, flags: Constants.maskCommand)
    #expect(shortcut.isCommandDown() == true)
  }

  @Test func isCommandDownFalseNoFlag() {
    let shortcut = createShortcut(keyCode: 0, flags: 0)
    #expect(shortcut.isCommandDown() == false)
  }

  @Test func isCommandDownFalseCommandL() {
    // Command_L自身はisCommandDownでfalse
    let shortcut = createShortcut(keyCode: Constants.commandL, flags: Constants.maskCommand)
    #expect(shortcut.isCommandDown() == false)
  }

  @Test func isCommandDownFalseCommandR() {
    // Command_R自身もisCommandDownでfalse
    let shortcut = createShortcut(keyCode: Constants.commandR, flags: Constants.maskCommand)
    #expect(shortcut.isCommandDown() == false)
  }

  // MARK: - isShiftDown Tests

  @Test func isShiftDownTrue() {
    let shortcut = createShortcut(keyCode: 0, flags: Constants.maskShift)
    #expect(shortcut.isShiftDown() == true)
  }

  @Test func isShiftDownFalseShiftL() {
    let shortcut = createShortcut(keyCode: Constants.shiftL, flags: Constants.maskShift)
    #expect(shortcut.isShiftDown() == false)
  }

  @Test func isShiftDownFalseShiftR() {
    let shortcut = createShortcut(keyCode: Constants.shiftR, flags: Constants.maskShift)
    #expect(shortcut.isShiftDown() == false)
  }

  // MARK: - isControlDown Tests

  @Test func isControlDownTrue() {
    let shortcut = createShortcut(keyCode: 0, flags: Constants.maskControl)
    #expect(shortcut.isControlDown() == true)
  }

  @Test func isControlDownFalseControlL() {
    let shortcut = createShortcut(keyCode: Constants.controlL, flags: Constants.maskControl)
    #expect(shortcut.isControlDown() == false)
  }

  @Test func isControlDownFalseControlR() {
    let shortcut = createShortcut(keyCode: Constants.controlR, flags: Constants.maskControl)
    #expect(shortcut.isControlDown() == false)
  }

  // MARK: - isAlternateDown Tests

  @Test func isAlternateDownTrue() {
    let shortcut = createShortcut(keyCode: 0, flags: Constants.maskAlternate)
    #expect(shortcut.isAlternateDown() == true)
  }

  @Test func isAlternateDownFalseOptionL() {
    let shortcut = createShortcut(keyCode: Constants.optionL, flags: Constants.maskAlternate)
    #expect(shortcut.isAlternateDown() == false)
  }

  @Test func isAlternateDownFalseOptionR() {
    let shortcut = createShortcut(keyCode: Constants.optionR, flags: Constants.maskAlternate)
    #expect(shortcut.isAlternateDown() == false)
  }

  // MARK: - isSecondaryFnDown Tests

  @Test func isSecondaryFnDownTrue() {
    let shortcut = createShortcut(keyCode: 0, flags: Constants.maskSecondaryFn)
    #expect(shortcut.isSecondaryFnDown() == true)
  }

  @Test func isSecondaryFnDownFalseFnKey() {
    let shortcut = createShortcut(keyCode: Constants.fnKey, flags: Constants.maskSecondaryFn)
    #expect(shortcut.isSecondaryFnDown() == false)
  }

  // MARK: - isCapslockDown Tests

  @Test func isCapslockDownTrue() {
    let shortcut = createShortcut(keyCode: 0, flags: Constants.maskAlphaShift)
    #expect(shortcut.isCapslockDown() == true)
  }

  @Test func isCapslockDownFalseCapsLock() {
    let shortcut = createShortcut(keyCode: Constants.capsLock, flags: Constants.maskAlphaShift)
    #expect(shortcut.isCapslockDown() == false)
  }
}
