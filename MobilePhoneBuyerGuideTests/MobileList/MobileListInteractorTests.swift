//
//  MobileListInteractorTests.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 26/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

@testable import MobilePhoneBuyerGuide
import XCTest

class MobileListInteractorTests: XCTestCase {

  // MARK: - Subject under test

  var sut: MobileListInteractor!

  // MARK: - Test lifecycle

  override func setUp() {
    super.setUp()
    setupMobileListInteractor()
  }

  override func tearDown() {
    super.tearDown()
  }

  // MARK: - Test setup

  func setupMobileListInteractor() {
    sut = MobileListInteractor()
  }

  // MARK: - Test doubles

  // MARK: - Tests

  func testSomething() {
    // Given

    // When

    // Then
  }
}
