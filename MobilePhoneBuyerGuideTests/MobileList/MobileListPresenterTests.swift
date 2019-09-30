//
//  MobileListPresenterTests.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 26/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

@testable import MobilePhoneBuyerGuide
import XCTest

class MobileListPresenterTests: XCTestCase {

  // MARK: - Subject under test

  var sut: MobileListPresenter!

  // MARK: - Test lifecycle

  override func setUp() {
    super.setUp()
    setupMobileListPresenter()
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
  }

  // MARK: - Test setup

  func setupMobileListPresenter() {
    sut = MobileListPresenter()
  }

  // MARK: - Test doubles
    class MobileListViewControllerSpy: MobileListViewControllerInterface {
        var displayTableViewFromApiCalled = false
        var displayViewFromSortingDataCalled = false
        var displayViewByPageCalled = false
        var displayViewFromDeleteFavCalled = false
        var displayViewFromChangeFavCalled = false
        
        func displayTableViewFromApi(viewModel: MobileList.ShowListMobile.ViewModel) {
            displayTableViewFromApiCalled = true
        }
        
        func displayViewFromSortingData(viewModel: MobileList.showListWithSorting.ViewModel) {
            displayViewFromSortingDataCalled = true
        }
        
        func displayViewByPage(viewModel: MobileList.changePage.ViewModel) {
            displayViewByPageCalled = true
        }
        
        func displayViewFromDeleteFav(viewModel: MobileList.deleteFav.ViewModel) {
            displayViewFromDeleteFavCalled = true
        }
        
        func displayViewFromChangeFav(viewModel: MobileList.addfav.ViewModel) {
            displayViewFromChangeFavCalled = true
        }
    }
  // MARK: - Tests

  func testPresentFromAPI() {
    // Given
    
    // When
    
    // Then
  }
}
