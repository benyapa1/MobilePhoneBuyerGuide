//
//  AllListScreenStore.swift
//  MobilePhoneBuyerGuide
//
//  Created by SparePcland on 17/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import Foundation

/*

 The AllListScreenStore class implements the AllListScreenStoreProtocol.

 The source for the data could be a database, cache, or a web service.

 You may remove these comments from the file.

 */

class AllListScreenStore: AllListScreenStoreProtocol {
  func getData(_ completion: @escaping (Result<MobileDetail>) -> Void) {
    // Simulates an asynchronous background thread that calls back on the main thread after 2 seconds
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//      completion(Result.success(MobileDetail()))
    }
  }
}
