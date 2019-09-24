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
  func getSortData(request: MobileList.showListWithSorting.Request)
  var model: [Mobile]? { get }
    var error: Error? { get }
    func addFav(request: MobileList.addfav.Request)
}

class MobileListInteractor: MobileListInteractorInterface {
  var presenter: MobileListPresenterInterface!
  var worker: MobileListWorker?
  var model: [Mobile]?
  var error: Error?
    
  // MARK: - Business logic

  func getAPI(request: MobileList.ShowListMobile.Request) {
    worker?.doGetDataFromAPI { [weak self] (result) in
      if case let .success(data) = result{
        self?.model = data
      } else if case let .failure(data) = result{
        self?.error = data
    }
        let response = MobileList.ShowListMobile.Response(list: self?.model, error: self?.error)
        self?.presenter.presentfromAPI(response: response)
    }
  }
    func getSortData(request: MobileList.showListWithSorting.Request) {
        guard var list = self.model,
            let isFav = request.isFav,
            let sortType = request.sortingType else {
            return
        }
        switch sortType {
        case .priceHighToLow:
            list.sort(by: { (mobile1, mobile2) -> Bool in
                let doCompare1 = doCompare(isMoreThan: true)
                return doCompare1(mobile1.price, mobile2.price)
            })
        case .priceLowToHigh:
            list.sort(by: { (mobile1, mobile2) -> Bool in
                let doCompare1 = doCompare(isMoreThan: false)
                return doCompare1(mobile1.price, mobile2.price)
            })
        case .rating:
            list.sort(by: { (mobile1, mobile2) -> Bool in
                let doCompare1 = doCompare(isMoreThan: true)
                return doCompare1(mobile1.rating, mobile2.rating)
            })
        }
        self.model? = list
        if isFav {
            list = list.filter { (item) -> Bool in
                return item.isFav
            }
        }
        let response = MobileList.showListWithSorting.Response(list: list)
        self.presenter.presentFromSortingOrFilterFav(response: response)
    }
    
    private func doCompare(isMoreThan: Bool) -> (Float, Float) -> Bool {
        func lessThan(mobile1: Float, mobile2: Float) -> Bool {
            return mobile1 < mobile2
        }
        func moreThan(mobile1: Float, mobile2: Float) -> Bool {
            return mobile1 > mobile2
        }
        return isMoreThan ? moreThan : lessThan
    }
    
    func addFav(request: MobileList.addfav.Request) {
        self.model?[request.index].isFav = request.isFav
        let response = MobileList.addfav.Response(list: self.model)
//        self.presenter.
    }
}


