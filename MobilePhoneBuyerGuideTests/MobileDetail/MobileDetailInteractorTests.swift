//
//  MobileDetailInteractorTests.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 30/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

@testable import MobilePhoneBuyerGuide
import XCTest

class MobileDetailInteractorTests: XCTestCase {

  // MARK: - Subject under test

  var sut: MobileDetailInteractor!

  // MARK: - Test lifecycle

  override func setUp() {
    super.setUp()
    setupMobileDetailInteractor()
  }

  override func tearDown() {
    super.tearDown()
  }

  // MARK: - Test setup

  func setupMobileDetailInteractor() {
    sut = MobileDetailInteractor()
  }

  // MARK: - Test doubles

  // MARK: - Tests

  func testSomething() {
    // Given

    // When

    // Then
  }
}
