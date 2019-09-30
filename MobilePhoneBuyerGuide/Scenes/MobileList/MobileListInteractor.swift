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
    func getDataFromPage(request: MobileList.changePage.Request)
    func addFav(request: MobileList.addfav.Request)
    func deleteFav(request: MobileList.deleteFav.Request)
    
    var model: [Mobile]? { get }
    var error: Error? { get }
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
        guard var list = self.model else {
            return
        }
        if  let sortType = request.sortingType {
            switch sortType {
            case .priceHighToLow:
                list = list.sorted { $0.price > $1.price }
            case .priceLowToHigh:
                list = list.sorted { $0.price < $1.price }
            case .rating:
                list = list.sorted { $0.rating > $1.rating }
            }
            self.model? = list
        }
        if let isFav = request.isFav, isFav {
            list = list.filter { (item) -> Bool in
                return item.isFav
            }
        }
        let response = MobileList.showListWithSorting.Response(list: list)
        self.presenter.presentFromSorting(response: response)
    }
    
    func addFav(request: MobileList.addfav.Request) {
        self.model?[request.index].isFav = request.isFav
        let response = MobileList.addfav.Response(list: self.model ?? [])
        self.presenter.presentFromAddFav(response: response)
    }
    
    func getDataFromPage(request: MobileList.changePage.Request) {
//        guard let isFavPage = request.isFavPage else { return }
        var list: [Mobile]?
        if request.isFavPage {
            list = self.model?.filter { (item) -> Bool in
                return item.isFav
            }
        } else {
            list = self.model
        }
        let response = MobileList.changePage.Response(list: list ?? [])
        self.presenter.presentFromChangePage(response: response)
    }
    
    func deleteFav(request: MobileList.deleteFav.Request) {
        var list = request.list
        if let index = self.model?.firstIndex(where: {$0.id == request.id}){
            self.model?[index].isFav = false
            list.remove(at: request.index)
        }
        let response = MobileList.deleteFav.Response(list: list)
        self.presenter.presentFromDeletePage(response: response)
    }
}


