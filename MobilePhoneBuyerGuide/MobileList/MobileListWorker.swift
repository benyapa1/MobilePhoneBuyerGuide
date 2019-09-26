//
//  MobileListWorker.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 23/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit
import Alamofire

protocol MobileListStoreProtocol {
  func getData(_ completion: @escaping (Result<[Mobile]>) -> Void)
}

class MobileListWorker {

  var store: MobileListStoreProtocol
    private var mobileList: [Mobile] = []

  init(store: MobileListStoreProtocol) {
    self.store = store
  }

  // MARK: - Business Logic

  func doGetDataFromAPI(_ completion: @escaping (Result<[Mobile]>) -> Void) {
    // NOTE: Do the work
    store.getData { (result) in
        completion(result)
    }
  }
}

