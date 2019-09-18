//
//  AllListScreenWorker.swift
//  MobilePhoneBuyerGuide
//
//  Created by SparePcland on 17/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

protocol AllListScreenStoreProtocol {
  func getData(_ completion: @escaping (Result<MobileDetail>) -> Void)
}

class AllListScreenWorker {

  var store: AllListScreenStoreProtocol

  init(store: AllListScreenStoreProtocol) {
    self.store = store
  }

  // MARK: - Business Logic

  func doSomeWork(_ completion: @escaping (Result<MobileDetail>) -> Void) {
    // NOTE: Do the work
    store.getData {
      // The worker may perform some small business logic before returning the result to the Interactor
      completion($0)
    }
  }
}
