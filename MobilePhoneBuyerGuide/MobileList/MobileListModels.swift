//
//  MobileListModels.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 23/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

struct MobileList {
    
  struct ShowListMobile {
    struct Request {}
    struct Response {
        var list: [Mobile]?
        var error: Error?
    }
    struct ViewModel {
        var list: [MobileForShow]?
        var error: Error?
    }
  }
   
    struct showListWithSorting {
        struct Request {
            var sortingType: SortType?
            var isFav: Bool?
        }
        struct Response {
            var list: [Mobile]
        }
        struct ViewModel {
            var list: [MobileForShow]
        }
    }
    
    struct changePage {
        struct Request {
            var isFavPage: Bool?
        }
        struct Response {
            var list: [Mobile]
        }
        struct ViewModel {
            var list: [MobileForShow]
        }
    }
    
    struct addfav {
        struct Request {
            var index: Int
            var isFav: Bool
        }
        struct Response {
            var list: [Mobile]
        }
        struct ViewModel {
            var list: [MobileForShow]
        }
    }
    
    struct deleteFav {
        struct Request {
            var id: Int
            var index: Int
            var list: [MobileForShow]
        }
        struct Response {
            var list: [MobileForShow]
        }
        struct ViewModel {
            var list: [MobileForShow]
        }
    }
}

