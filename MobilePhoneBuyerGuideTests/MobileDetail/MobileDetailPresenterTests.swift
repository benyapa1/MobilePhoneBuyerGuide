//
//  MobileDetailPresenterTests.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 30/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

@testable import MobilePhoneBuyerGuide
import XCTest

class MobileDetailPresenterTests: XCTestCase {

  // MARK: - Subject under test

  var sut: MobileDetailPresenter!
    var viewController: MobileDetailViewControllerSpy!
    let mockMobileImageArrayActual: [MobileImage] = [MobileImage(mobileId: 1,
    url: "https://www.picture.com",
    id: 1)]

  // MARK: - Test lifecycle

  override func setUp() {
    super.setUp()
    setupMobileDetailPresenter()
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
  }

  // MARK: - Test setup

  func setupMobileDetailPresenter() {
    sut = MobileDetailPresenter()
    viewController = MobileDetailViewControllerSpy()
    sut.viewController = viewController
  }

  // MARK: - Test doubles

    class MobileDetailViewControllerSpy: MobileDetailViewControllerInterface {
        
        var displayImage = false
        var viewModel: MobileDetail.ShowScene.ViewModel?
        
        func displayImage(viewModel: MobileDetail.ShowScene.ViewModel) {
            self.displayImage = true
            self.viewModel = viewModel
        }
    }
  // MARK: - Tests

  func testPresentImageCollectionView() {
    // Given
    // When
    let response = MobileDetail.ShowScene.Response(success: mockMobileImageArrayActual, fail: nil)
    sut.presentImageCollectionView(response: response)
    // Then
    XCTAssertEqual(mockMobileImageArrayActual[0], viewController.viewModel?.success?[0])
    XCTAssertNil(viewController.viewModel?.fail)
    
  }
}
