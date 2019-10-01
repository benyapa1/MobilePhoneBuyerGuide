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
        var response: Any?
        
        
        
        func presentFromSorting(response: MobileList.showListWithSorting.Response) {
            presentSortingCalled = true
            self.response = response
        }
        
        func presentFromAddFav(response: MobileList.addfav.Response) {
            presentAddFavCalled = true
            self.response = response
        }
        
        func presentFromChangePage(response: MobileList.changePage.Response) {
            presentChangePageCalled = true
            self.response = response
        }
        
        func presentFromDeletePage(response: MobileList.deleteFav.Response) {
            presentFromDeleteCalled = true
            self.response = response
        }
        
        func presentfromAPI(response: MobileList.ShowListMobile.Response){
            presentFromAPICalled = true
            self.response = response
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
                                id: 1,
                                isFav: true),
                        Mobile(thumbImageURL: "",
                                brand: "samsung",
                                price: 170.0,
                                description: "blah blah",
                                name: "samsung galaxy",
                                rating: 3.1,
                                id: 2,
                                isFav: false)]
        
        
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
        XCTAssertNotNil(sut?.model)
        XCTAssertNil(sut?.error)
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
    let mockMobileArray: [Mobile] =  [Mobile(thumbImageURL: "",
                  brand: "samsung",
                  price: 166.0,
                  description: "blah blah",
                  name: "samsung galaxy",
                  rating: 4.6,
                  id: 1,
                  isFav: true),
           Mobile(thumbImageURL: "",
                  brand: "samsung",
                  price: 170.0,
                  description: "blah blah",
                  name: "samsung galaxy",
                  rating: 3.1,
                  id: 2,
                  isFav: false),
            Mobile(thumbImageURL: "",
                    brand: "samsung",
                    price: 150.0,
                    description: "blah blah",
                    name: "samsung galaxy",
                    rating: 3.2,
                    id: 3,
                    isFav: true)]
    
    func testGetSortDataTypeIsPriceHighToLowOnAllPage() {
        //Given
        sut.model = mockMobileArray
        let expectedMobileList = [ Mobile(thumbImageURL: "",
                                           brand: "samsung",
                                           price: 170.0,
                                           description: "blah blah",
                                           name: "samsung galaxy",
                                           rating: 3.1,
                                           id: 2,
                                           isFav: false),
                                    Mobile(thumbImageURL: "",
                                            brand: "samsung",
                                            price: 166.0,
                                            description: "blah blah",
                                            name: "samsung galaxy",
                                            rating: 4.6,
                                            id: 1,
                                            isFav: true) ]

        //When
        let request = MobileList.showListWithSorting.Request(sortingType: .priceHighToLow, isFav: false)
        sut.getSortData(request: request)
        //Then
        XCTAssert(mobileListPresenterSpy.presentSortingCalled)
        XCTAssertEqual(sut.model?[0], expectedMobileList[0])
        XCTAssertEqual(sut.model?[1], expectedMobileList[1])
    }
    
    func testGetSortDataTypeIsPriceHighToLowOnFavPage() {
        sut.model = mockMobileArray
        let expectedMobileList = [ Mobile(thumbImageURL: "",
                                           brand: "samsung",
                                           price: 170.0,
                                           description: "blah blah",
                                           name: "samsung galaxy",
                                           rating: 3.1,
                                           id: 2,
                                           isFav: false),
                                    Mobile(thumbImageURL: "",
                                            brand: "samsung",
                                            price: 166.0,
                                            description: "blah blah",
                                            name: "samsung galaxy",
                                            rating: 4.6,
                                            id: 1,
                                            isFav: true) ]
        //When
        let request = MobileList.showListWithSorting.Request(sortingType: .priceHighToLow, isFav: true)
        sut.getSortData(request: request)
        //Then
        XCTAssert(mobileListPresenterSpy.presentSortingCalled)
        XCTAssertEqual(sut.model?[0], expectedMobileList[0])
        XCTAssertEqual(sut.model?[1], expectedMobileList[1])
    }
    
    func testGetSortDataTypeIsPriceLowToHighOnAllPage() {
        //Given
        sut.model = mockMobileArray
        let expectedMobileList = [ Mobile(thumbImageURL: "",
                                            brand: "samsung",
                                            price: 150.0,
                                            description: "blah blah",
                                            name: "samsung galaxy",
                                            rating: 3.2,
                                            id: 3,
                                            isFav: true),
                                    Mobile(thumbImageURL: "",
                                            brand: "samsung",
                                            price: 166.0,
                                            description: "blah blah",
                                            name: "samsung galaxy",
                                            rating: 4.6,
                                            id: 1,
                                            isFav: true)]
        //When
        let request = MobileList.showListWithSorting.Request(sortingType: .priceLowToHigh, isFav: false)
        sut.getSortData(request: request)
        //Then
        XCTAssert(mobileListPresenterSpy.presentSortingCalled)
        XCTAssertEqual(sut.model?[0], expectedMobileList[0])
        XCTAssertEqual(sut.model?[1], expectedMobileList[1])
    }
    
    func testGetSortDataTypeIsRatingHighToLowAllPage() {
        //Given
        sut.model = mockMobileArray
        let expectedMobileList = [ Mobile(thumbImageURL: "",
                                            brand: "samsung",
                                            price: 166.0,
                                            description: "blah blah",
                                            name: "samsung galaxy",
                                            rating: 4.6,
                                            id: 1,
                                            isFav: true),
                                    Mobile(thumbImageURL: "",
                                            brand: "samsung",
                                            price: 150.0,
                                            description: "blah blah",
                                            name: "samsung galaxy",
                                            rating: 3.2,
                                            id: 3,
                                            isFav: true)]
        //When
        let request = MobileList.showListWithSorting.Request(sortingType: .rating, isFav: false)
        sut.getSortData(request: request)
        //Then
        XCTAssert(mobileListPresenterSpy.presentSortingCalled)
        XCTAssertEqual(sut.model?[0], expectedMobileList[0])
        XCTAssertEqual(sut.model?[1], expectedMobileList[1])
    }
    
    func testSortDataModelIsEmpty() {
        //Given
        //When
        let request = MobileList.showListWithSorting.Request(sortingType: .rating, isFav: false)
        sut.getSortData(request: request)
        //Then
        XCTAssertFalse(mobileListPresenterSpy.presentSortingCalled)
    }
    
    func testAddFav(){
        //Given
        sut.model = mockMobileArray
        let expectedMobile =  Mobile(thumbImageURL: "",
                         brand: "samsung",
                         price: 170.0,
                         description: "blah blah",
                         name: "samsung galaxy",
                         rating: 3.1,
                         id: 2,
                         isFav: true)
        //When
        let request = MobileList.addfav.Request(index: 1, isFav: true)
        sut.addFav(request: request)
        //Then
        XCTAssertEqual(sut.model?[1], expectedMobile)
        XCTAssert(mobileListPresenterSpy.presentAddFavCalled)
    }
    
    func testAddFavModelIsEmpty(){
        //Given
        //When
        let request = MobileList.addfav.Request(index: 1, isFav: true)
        sut.addFav(request: request)
        //Then
        XCTAssert(mobileListPresenterSpy.presentAddFavCalled)
    }
    
    func testGetDataFromFavPage()  {
        //Given
        sut.model = mockMobileArray
        let expectedMobileList = [ Mobile(thumbImageURL: "",
                brand: "samsung",
                price: 166.0,
                description: "blah blah",
                name: "samsung galaxy",
                rating: 4.6,
                id: 1,
                isFav: true),
        Mobile(thumbImageURL: "",
                brand: "samsung",
                price: 150.0,
                description: "blah blah",
                name: "samsung galaxy",
                rating: 3.2,
                id: 3,
                isFav: true)]
        //When
        let request = MobileList.changePage.Request(isFavPage: true)
        sut.getDataFromPage(request: request)
        //Then
        XCTAssert(mobileListPresenterSpy.presentChangePageCalled)
        let response = mobileListPresenterSpy.response as? MobileList.changePage.Response
        XCTAssertEqual(response?.list[0], expectedMobileList[0])
        XCTAssertEqual(response?.list[1], expectedMobileList[1])
    }
    
    func testGetDataFromAllPage()  {
           //Given
           sut.model = mockMobileArray
           let expectedMobileList = [ Mobile(thumbImageURL: "",
                  brand: "samsung",
                  price: 166.0,
                  description: "blah blah",
                  name: "samsung galaxy",
                  rating: 4.6,
                  id: 1,
                  isFav: true),
           Mobile(thumbImageURL: "",
                  brand: "samsung",
                  price: 170.0,
                  description: "blah blah",
                  name: "samsung galaxy",
                  rating: 3.1,
                  id: 2,
                  isFav: false),]
           //When
           let request = MobileList.changePage.Request(isFavPage: false)
           sut.getDataFromPage(request: request)
           //Then
           XCTAssert(mobileListPresenterSpy.presentChangePageCalled)
           let response = mobileListPresenterSpy.response as? MobileList.changePage.Response
           XCTAssertEqual(response?.list[0], expectedMobileList[0])
           XCTAssertEqual(response?.list[1], expectedMobileList[1])
    }
    
    func testGetDataAndResponseListIsEmpty() {
        //Given
        //When
        let request = MobileList.changePage.Request(isFavPage: false)
        sut.getDataFromPage(request: request)
        //Then
        XCTAssert(mobileListPresenterSpy.presentChangePageCalled)
        let response = mobileListPresenterSpy.response as? MobileList.changePage.Response
        XCTAssert(response?.list == [])
    }
    
    func testSwipeDeleteFav(){
        //Given
        sut.model = mockMobileArray
        let mockListActual: [MobileForShow] = [ MobileForShow(thumbImageURL: "",
                brand: "samsung",
                price: "Price: $166.00",
                description: "blah blah",
                name: "samsung galaxy",
                rating: "Rating: 4.6",
                id: 1,
                isFav: true),
        MobileForShow(thumbImageURL: "",
                brand: "samsung",
                price: "Price: $150.00",
                description: "blah blah",
                name: "samsung galaxy",
                rating: "Rating: 3.2",
                id: 3,
                isFav: true)]
        let mobileExpected = Mobile(thumbImageURL: "",
                                    brand: "samsung",
                                    price: 166.0,
                                    description: "blah blah",
                                    name: "samsung galaxy",
                                    rating: 4.6,
                                    id: 1,
                                    isFav: false)
        //When
        let request = MobileList.deleteFav.Request(id: 1, index: 0, list: mockListActual)
        sut.deleteFav(request: request)
        //Then
        XCTAssert(mobileListPresenterSpy.presentFromDeleteCalled)
        let response = mobileListPresenterSpy.response as? MobileList.deleteFav.Response
        XCTAssertEqual(sut.model?[0], mobileExpected)
        XCTAssertEqual(response?.list[0], mockListActual[1])
    }
    
}
