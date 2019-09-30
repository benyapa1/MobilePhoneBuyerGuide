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
    var viewController: MobileListViewControllerSpy!
    let mockMobileArray = [Mobile(thumbImageURL: "",
                                  brand: "samsung",
                                  price: 166.0,
                                  description: "blah blah",
                                  name: "samsung galaxy",
                                  rating: 4.6,
                                  id: 1,
                                  isFav: true)]
    let mockMobileArrayExpected = [MobileForShow(thumbImageURL: "",
                                                 brand: "samsung",
                                                 price: "Price: $166.00",
                                                 description: "blah blah",
                                                 name: "samsung galaxy",
                                                 rating: "Rating: 4.6",
                                                 id: 1,
                                                 isFav: true)]
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
        viewController = MobileListViewControllerSpy()
        sut.viewController = viewController
    }
    
    // MARK: - Test doubles
    class MobileListViewControllerSpy: MobileListViewControllerInterface {
        var displayTableViewFromApiCalled = false
        var displayViewFromSortingDataCalled = false
        var displayViewByPageCalled = false
        var displayViewFromDeleteFavCalled = false
        var displayViewFromChangeFavCalled = false
        var viewModel: Any?
        
        func displayTableViewFromApi(viewModel: MobileList.ShowListMobile.ViewModel) {
            displayTableViewFromApiCalled = true
            self.viewModel = viewModel
        }
        
        func displayViewFromSortingData(viewModel: MobileList.showListWithSorting.ViewModel) {
            displayViewFromSortingDataCalled = true
            self.viewModel = viewModel
        }
        
        func displayViewByPage(viewModel: MobileList.changePage.ViewModel) {
            displayViewByPageCalled = true
            self.viewModel = viewModel
        }
        
        func displayViewFromDeleteFav(viewModel: MobileList.deleteFav.ViewModel) {
            displayViewFromDeleteFavCalled = true
            self.viewModel = viewModel
        }
        
        func displayViewFromChangeFav(viewModel: MobileList.addfav.ViewModel) {
            displayViewFromChangeFavCalled = true
            self.viewModel = viewModel
        }
    }
    // MARK: - Tests
    
    func testPresentFromAPICaseSuccess() {
        // Given
        // When
        let response = MobileList.ShowListMobile.Response(list: mockMobileArray, error: nil)
        sut.presentfromAPI(response: response)
        // Then
        let viewModel = viewController.viewModel as? MobileList.ShowListMobile.ViewModel
        XCTAssertEqual(viewModel?.list?[0], mockMobileArrayExpected[0])
        XCTAssertNil(viewModel?.error)
        XCTAssert(viewController.displayTableViewFromApiCalled)
    }
    func testPresentFromAPICaseFail() {
        // Given
        // When
        let response = MobileList.ShowListMobile.Response(list: nil, error: NSError(domain: "", code: 0, userInfo: nil))
        sut.presentfromAPI(response: response)
        // Then
        let viewModel = viewController.viewModel as? MobileList.ShowListMobile.ViewModel
        XCTAssertNil(viewModel?.list)
        XCTAssertNotNil(viewModel?.error)
        XCTAssert(viewController.displayTableViewFromApiCalled)
    }
    
    func testPresentFromSorting() {
        // Given
        // When
        let response = MobileList.showListWithSorting.Response(list: mockMobileArray)
        sut.presentFromSorting(response: response)
        // Then
        let viewModel = viewController.viewModel as? MobileList.showListWithSorting.ViewModel
        XCTAssertEqual(viewModel?.list[0], mockMobileArrayExpected[0])
    XCTAssert(viewController.displayViewFromSortingDataCalled)
    }
    
    func testPresentFromAddFav() {
        // Given
        // When
        let response = MobileList.addfav.Response(list: mockMobileArray)
        sut.presentFromAddFav(response: response)
        // Then
        let viewModel = viewController.viewModel as? MobileList.addfav.ViewModel
        XCTAssertEqual(viewModel?.list[0], mockMobileArrayExpected[0])
    XCTAssert(viewController.displayViewFromChangeFavCalled)
    }
    
    func testPresentFromChangePage() {
        // Given
        // When
        let response = MobileList.changePage.Response(list: mockMobileArray)
        sut.presentFromChangePage(response: response)
        // Then
        let viewModel = viewController.viewModel as? MobileList.changePage.ViewModel
        XCTAssertEqual(viewModel?.list[0], mockMobileArrayExpected[0])
    XCTAssert(viewController.displayViewByPageCalled)
    }
    
    func testPresentFromDeletePage() {
        // Given
        //When
        let response = MobileList.deleteFav.Response(list: mockMobileArrayExpected)
        sut.presentFromDeletePage(response: response)
        // Then
        let viewModel = viewController.viewModel as? MobileList.deleteFav.ViewModel
        XCTAssertEqual(viewModel?.list[0], mockMobileArrayExpected[0])
    XCTAssert(viewController.displayViewFromDeleteFavCalled)
    }
    
}
