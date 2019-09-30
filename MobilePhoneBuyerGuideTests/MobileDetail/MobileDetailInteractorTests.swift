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
    var mobileDetailPresenterSpy: MobileDetailPresenterSpy!
    let mockMobileImageArrayExpected: [MobileImage] = [MobileImage(mobileId: 1,
                                                           url: "https://www.picture.com",
                                                           id: 1)]
    var mockMobileImageActual: [MobileImage] = [MobileImage(mobileId: 1,
                                                            url: "www.picture.com",
                                                            id: 1)]
    var mockMobileImageActualNoPrefix: [MobileImage] = [MobileImage(mobileId: 1,
                                                            url: "picture.com",
                                                            id: 1)]
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupMobileDetailInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: - Test setup
    
    func setupMobileDetailInteractor() {
        sut = MobileDetailInteractor()
        mobileDetailPresenterSpy = MobileDetailPresenterSpy()
        sut.presenter = mobileDetailPresenterSpy
        
    }
    
    // MARK: - Test doubles
    
    class MobileDetailPresenterSpy: MobileDetailPresenterInterface {
        var presentImageCollectionViewCalled: Bool = false
        var response: MobileDetail.ShowScene.Response?
    
        func presentImageCollectionView(response: MobileDetail.ShowScene.Response){
            presentImageCollectionViewCalled = true
            self.response = response
        }
    }
    
    class MobileDetailWorkerSpy: MobileDetailWorker {
        var isSuccess = true
        var mockMobileImage: [MobileImage] = []
        
        
        override func doGetAPI(url: String,_ completion: @escaping (Result<[MobileImage],Error>) -> Void) {
            if isSuccess {
                completion(.success(mockMobileImage))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
        }
    }
    
    // MARK: - Tests
    
    func testGetAPISuccessAndWebsiteIsStartWithWWW() {
        // Given
        let mobileDetailWorkerSpy = MobileDetailWorkerSpy(store: MobileDetailStore())
        mobileDetailWorkerSpy.mockMobileImage = mockMobileImageActual
        sut.worker = mobileDetailWorkerSpy
        // When
        let request = MobileDetail.ShowScene.Request(mobileId: 1)
        sut.doGetAPI(request: request)
        // Then
        XCTAssertTrue(mobileDetailPresenterSpy.presentImageCollectionViewCalled)
        XCTAssertEqual(sut.images?[0], mockMobileImageArrayExpected[0])
        XCTAssertNil(sut.error)
    }
    
    func testGetAPISuccessAndWebsiteIsNotHavePrefix() {
        // Given
        let mobileDetailWorkerSpy = MobileDetailWorkerSpy(store: MobileDetailStore())
        mobileDetailWorkerSpy.mockMobileImage = mockMobileImageActualNoPrefix
        sut.worker = mobileDetailWorkerSpy
        // When
        let request = MobileDetail.ShowScene.Request(mobileId: 1)
        sut.doGetAPI(request: request)
        // Then
        XCTAssertTrue(mobileDetailPresenterSpy.presentImageCollectionViewCalled)
        XCTAssertEqual(sut.images?[0], mockMobileImageArrayExpected[0])
        XCTAssertNil(sut.error)
    }
    
    func testGetAPISuccessAndWebsiteIsStartWithHttps() {
        // Given
        let mobileDetailWorkerSpy = MobileDetailWorkerSpy(store: MobileDetailStore())
        mobileDetailWorkerSpy.mockMobileImage = mockMobileImageArrayExpected
        sut.worker = mobileDetailWorkerSpy
        // When
        let request = MobileDetail.ShowScene.Request(mobileId: 1)
        sut.doGetAPI(request: request)
        // Then
        XCTAssertTrue(mobileDetailPresenterSpy.presentImageCollectionViewCalled)
        XCTAssertEqual(sut.images?[0], mockMobileImageArrayExpected[0])
        XCTAssertNil(sut.error)
    }
    
    func testGetAPIFail() {
        // Given
        let mobileDetailWorkerSpy = MobileDetailWorkerSpy(store: MobileDetailStore())
        mobileDetailWorkerSpy.isSuccess = false
        sut.worker = mobileDetailWorkerSpy
        // When
        let request = MobileDetail.ShowScene.Request(mobileId: 1)
        sut.doGetAPI(request: request)
        // Then
        XCTAssertTrue(mobileDetailPresenterSpy.presentImageCollectionViewCalled)
        XCTAssertNil(sut.images)
        XCTAssertNotNil(sut.error)
    }
}
