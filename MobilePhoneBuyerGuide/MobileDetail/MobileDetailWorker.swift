//
//  MobileDetailWorker.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 25/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

protocol MobileDetailStoreProtocol {
    func getData(mobileId: Int, _ completion: @escaping (Result<[MobileImage],Error>) -> Void)
}

class MobileDetailWorker {

  var store: MobileDetailStoreProtocol

  init(store: MobileDetailStoreProtocol) {
    self.store = store
  }

  // MARK: - Business Logic

  func doSomeWork(_ completion: @escaping (Result<[MobileImage],Error>) -> Void) {
    // NOTE: Do the work
    store.getData(mobileId: 10) {
      // The worker may perform some small business logic before returning the result to the Interactor
      completion($0)
    }
  }
}
