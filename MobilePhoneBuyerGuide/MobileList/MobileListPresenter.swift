//
//  MobileListPresenter.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 23/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

protocol MobileListPresenterInterface {
  func presentfromAPI(response: MobileList.ShowListMobile.Response)
  func presentFromSorting(response: MobileList.showListWithSorting.Response)
  func presentFromAddFav(response: MobileList.addfav.Response)
  func presentFromChangePage(response: MobileList.changePage.Response)
  func presentFromDeletePage(response: MobileList.deleteFav.Response)
}

class MobileListPresenter: MobileListPresenterInterface {
  weak var viewController: MobileListViewControllerInterface!

  // MARK: - Presentation logic

  func presentfromAPI(response: MobileList.ShowListMobile.Response) {
    let viewModel = MobileList.ShowListMobile.ViewModel(list: response.list, error: response.error)
    viewController.displayTableViewFromApi(viewModel: viewModel)
  }
    
    func presentFromSorting(response: MobileList.showListWithSorting.Response) {
        let viewModel = MobileList.showListWithSorting.ViewModel(list: response.list)
        viewController.displayViewFromSortingData(viewModel: viewModel)
    }
    
    func presentFromAddFav(response: MobileList.addfav.Response) {
        let viewModel = MobileList.addfav.ViewModel(list: response.list)
        viewController.displayViewFromChangeFav(viewModel: viewModel)
        
    }
    
    func presentFromChangePage(response: MobileList.changePage.Response) {
        let viewModel = MobileList.changePage.ViewModel(list: response.list)
        viewController.displayViewByPage(viewModel: viewModel)
    }
    
    func presentFromDeletePage(response: MobileList.deleteFav.Response) {
        let viewModel = MobileList.deleteFav.ViewModel(list: response.list)
        viewController.displayViewFromDeleteFav(viewModel: viewModel)
    }
    
    func formatToString(list: [Mobile]) -> [MobileForShow] {
        return list.map { (mobile) -> MobileForShow in
            return MobileForShow(thumbImageURL: mobile.thumbImageURL,
                                 brand: mobile.brand,
                                 price: "Price: $\(String(format: "%.2f",mobile.price))",
                                 description: mobile.description,
                                 name: mobile.name,
                                 rating: "Price: $\(String(format: "%.2f",mobile.rating))",
                                 id: mobile.id)
        }
    }
}
