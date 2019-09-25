//
//  MobileDetailInteractor.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 25/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

protocol MobileDetailInteractorInterface {
    func doGetAPI(request: MobileDetail.ShowScene.Request)
    var images: [MobileImage]? { get }
    var error: Error? { get }
    var URL_GET_API: String? { get }
    
}

class MobileDetailInteractor: MobileDetailInteractorInterface {
    var presenter: MobileDetailPresenterInterface!
    var worker: MobileDetailWorker?
    var images: [MobileImage]?
    var error: Error?
    var URL_GET_API: String?
    
    
    // MARK: - Business logic
    
    func doGetAPI(request: MobileDetail.ShowScene.Request) {
        self.URL_GET_API =  "https://scb-test-mobile.herokuapp.com/api/mobiles/\(request.mobileId)/images/"
        worker?.doGetAPI(url: self.URL_GET_API ?? "") { [weak self] in
            if case let Result.success(images) = $0 {
                self?.images = images.map({ (image) -> MobileImage in
                    if (image.url.starts(with: "https://")){
                        return image
                    } else {
                        if let index = image.url.firstIndex(of: "w") , image.url.contains("www."){
                            let url = image.url.suffix(from: index)
                            return MobileImage(mobileId: image.mobileId,
                                               url: "https://" + String(url),
                                               id: image.id)
                        }
                        return image
                    }
                })
            } else if case let .failure(error) = $0{
                self?.error = error
            }
            let response = MobileDetail.ShowScene.Response(success: self?.images, fail: self?.error)
            self?.presenter.presentImageCollectionView(response: response)
        }
    }
}

