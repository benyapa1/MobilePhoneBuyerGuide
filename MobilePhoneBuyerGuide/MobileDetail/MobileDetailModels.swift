//
//  MobileDetailModels.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 25/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

struct MobileDetail {
  /// This structure represents a use case
  struct ShowScene {
    /// Data struct sent to Interactor
    struct Request {
        let mobileId: Int
    }
    /// Data struct sent to Presenter
    struct Response {
        let success: [MobileImage]?
        let fail: Error?
    }
    /// Data struct sent to ViewController
    struct ViewModel {
        let success: [MobileImage]?
        let fail: Error?
        
    }
  }
}
