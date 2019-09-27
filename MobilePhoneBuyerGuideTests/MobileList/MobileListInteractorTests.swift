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
    var mobileListPresenterSpy: MobileListPresenterSpy!
    
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupMobileListInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: - Test setup
    
    func setupMobileListInteractor() {
        sut = MobileListInteractor()
        mobileListPresenterSpy = MobileListPresenterSpy()
        sut.presenter = mobileListPresenterSpy
    }
    
    // MARK: - Test doubles
    // stubs, mocks, spies
    class MobileListPresenterSpy: MobileListPresenterInterface {
        var presentSortingCalled = false
        var presentAddFavCalled = false
        var presentChangePageCalled = false
        var presentFromDeleteCalled = false
        var presentFromAPICalled = false
        
        
        func presentFromSorting(response: MobileList.showListWithSorting.Response) {
            presentSortingCalled = true
        }
        
        func presentFromAddFav(response: MobileList.addfav.Response) {
            presentAddFavCalled = true
        }
        
        func presentFromChangePage(response: MobileList.changePage.Response) {
            presentChangePageCalled = true
        }
        
        func presentFromDeletePage(response: MobileList.deleteFav.Response) {
            presentFromDeleteCalled = true
        }
        
        func presentfromAPI(response: MobileList.ShowListMobile.Response){
            presentFromAPICalled = true
        }
    }
    
    class MobileListWorkerSpy: MobileListWorker {
        var doGetDataFromAPICalled = false
        var shouldFail: Bool = false
        var mockMobileList = [Mobile(thumbImageURL: "",
                                brand: "samsung",
                                price: 166.0,
                                description: "blah blah",
                                name: "samsung galaxy",
                                rating: 4.6,
                                id: 1),
                        Mobile(thumbImageURL: "",
                                brand: "samsung",
                                price: 170.0,
                                description: "blah blah",
                                name: "samsung galaxy",
                                rating: 3.1,
                                id: 2)]
        
        
        override func doGetDataFromAPI(_ completion: @escaping (Result<[Mobile], Error>) -> Void) {
            doGetDataFromAPICalled = true
            if shouldFail {
                completion(.failure(NSError()))
            } else {
                completion(.success(mockMobileList))
            }
            
        }
    }
    // MARK: - Tests
    
    func testGetAPIWithSuccess() {
        // Given
        let mobileListWorkerSpy = MobileListWorkerSpy(store: MobileListStore())
        sut.worker = mobileListWorkerSpy
        
        // When
        let request = MobileList.ShowListMobile.Request()
        sut.getAPI(request: request)
        
        // Then
        
        XCTAssert(sut?.model != nil)
        XCTAssert(sut?.error == nil)
        XCTAssert(mobileListPresenterSpy.presentFromAPICalled)
        XCTAssert(mobileListWorkerSpy.doGetDataFromAPICalled)
        
    }
    
    func testGetAPIWithFailure() {
        // Given
        let mobileListWorkerSpy = MobileListWorkerSpy(store: MobileListStore())
        mobileListWorkerSpy.shouldFail = true
        sut.worker = mobileListWorkerSpy
        // When
        let request = MobileList.ShowListMobile.Request()
        sut.getAPI(request: request)
        
        // Then
        
        XCTAssert(sut?.model == nil)
        XCTAssert(sut?.error != nil)
        XCTAssert(mobileListPresenterSpy.presentFromAPICalled)
        XCTAssert(mobileListWorkerSpy.doGetDataFromAPICalled)
        
    }
    
    func testGetSortDataTypeIsPriceHighToLowOnAllPage() {
        //Given
        sut.model = [Mobile(thumbImageURL: "",
                            brand: "samsung",
                            price: 166.0,
                            description: "blah blah",
                            name: "samsung galaxy",
                            rating: 4.6,
                            id: 1),
                     Mobile(thumbImageURL: "",
                            brand: "samsung",
                            price: 170.0,
                            description: "blah blah",
                            name: "samsung galaxy",
                            rating: 3.1,
                            id: 2)]
        
        //When
        let request = MobileList.showListWithSorting.Request(sortingType: .priceHighToLow, isFav: false)
        sut.getSortData(request: request)
        //Then
        XCTAssert(mobileListPresenterSpy.presentSortingCalled)
    }
}
