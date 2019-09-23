//
//  MobileListInteractor.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 23/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

protocol MobileListInteractorInterface {
  func doSomething(request: MobileList.Something.Request)
  var model: Entity? { get }
}

class MobileListInteractor: MobileListInteractorInterface {
  var presenter: MobileListPresenterInterface!
  var worker: MobileListWorker?
  var model: Entity?

  // MARK: - Business logic

  func doSomething(request: MobileList.Something.Request) {
    worker?.doSomeWork { [weak self] in
      if case let Result.success(data) = $0 {
        // If the result was successful, we keep the data so that we can deliver it to another view controller through the router.
        self?.model = data
      }

      // NOTE: Pass the result to the Presenter. This is done by creating a response model with the result from the worker. The response could contain a type like UserResult enum (as declared in the SCB Easy project) with the result as an associated value.
      let response = MobileList.Something.Response()
      self?.presenter.presentSomething(response: response)
    }
  }
}
