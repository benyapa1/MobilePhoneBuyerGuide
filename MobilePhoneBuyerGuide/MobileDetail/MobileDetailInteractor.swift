//
//  MobileDetailInteractor.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 25/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

protocol MobileDetailInteractorInterface {
  func doSomething(request: MobileDetail.Something.Request)
  var model: [MobileImage]? { get }
}

class MobileDetailInteractor: MobileDetailInteractorInterface {
  var presenter: MobileDetailPresenterInterface!
  var worker: MobileDetailWorker?
  var model: [MobileImage]?

  // MARK: - Business logic

  func doSomething(request: MobileDetail.Something.Request) {
    worker?.doSomeWork { [weak self] in
      if case let Result.success(data) = $0 {
        // If the result was successful, we keep the data so that we can deliver it to another view controller through the router.
        self?.model = data
      }

      // NOTE: Pass the result to the Presenter. This is done by creating a response model with the result from the worker. The response could contain a type like UserResult enum (as declared in the SCB Easy project) with the result as an associated value.
      let response = MobileDetail.Something.Response()
      self?.presenter.presentSomething(response: response)
    }
  }
}
