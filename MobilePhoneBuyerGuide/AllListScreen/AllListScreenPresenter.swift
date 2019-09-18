//
//  AllListScreenPresenter.swift
//  MobilePhoneBuyerGuide
//
//  Created by SparePcland on 17/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

protocol AllListScreenPresenterInterface {
  func presentSomething(response: AllListScreen.Something.Response)
}

class AllListScreenPresenter: AllListScreenPresenterInterface {
  weak var viewController: AllListScreenViewControllerInterface!

  // MARK: - Presentation logic

  func presentSomething(response: AllListScreen.Something.Response) {
    // NOTE: Format the response from the Interactor and pass the result back to the View Controller. The resulting view model should be using only primitive types. Eg: the view should not need to involve converting date object into a formatted string. The formatting is done here.

    let viewModel = AllListScreen.Something.ViewModel()
    viewController.displaySomething(viewModel: viewModel)
  }
}
