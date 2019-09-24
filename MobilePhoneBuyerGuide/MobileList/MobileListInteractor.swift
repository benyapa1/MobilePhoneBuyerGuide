//
//  MobileListInteractor.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 23/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

protocol MobileListInteractorInterface {
  func getAPI(request: MobileList.ShowListMobile.Request)
  var model: Any? { get }
}

class MobileListInteractor: MobileListInteractorInterface {
  var presenter: MobileListPresenterInterface!
  var worker: MobileListWorker?
  var model: Any?
    

  // MARK: - Business logic

  func getAPI(request: MobileList.ShowListMobile.Request) {
    worker?.doGetDataFromAPI { [weak self] (result) in
      if case let .success(data) = result{
        self?.model = data
      } else if case let .failure(data) = result{
        self?.model = data
    }
        let response = MobileList.ShowListMobile.Response(model: self?.model as Any)
        self?.presenter.presentfromAPI(response: response)
    }
  }
}
