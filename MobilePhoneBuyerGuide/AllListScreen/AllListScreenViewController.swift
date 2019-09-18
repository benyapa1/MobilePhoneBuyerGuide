//
//  AllListScreenViewController.swift
//  MobilePhoneBuyerGuide
//
//  Created by SparePcland on 17/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

protocol AllListScreenViewControllerInterface: class {
  func displaySomething(viewModel: AllListScreen.Something.ViewModel)
}

class AllListScreenViewController: UIViewController, AllListScreenViewControllerInterface {
  var interactor: AllListScreenInteractorInterface!
  var router: AllListScreenRouter!

  // MARK: - Object lifecycle

  override func awakeFromNib() {
    super.awakeFromNib()
    configure(viewController: self)
  }

  // MARK: - Configuration

  private func configure(viewController: AllListScreenViewController) {
    let router = AllListScreenRouter()
    router.viewController = viewController

    let presenter = AllListScreenPresenter()
    presenter.viewController = viewController

    let interactor = AllListScreenInteractor()
    interactor.presenter = presenter
    interactor.worker = AllListScreenWorker(store: AllListScreenStore())

    viewController.interactor = interactor
    viewController.router = router
  }

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    doSomethingOnLoad()
  }

  // MARK: - Event handling

  func doSomethingOnLoad() {
    // NOTE: Ask the Interactor to do some work

    let request = AllListScreen.Something.Request()
    interactor.doSomething(request: request)
  }

  // MARK: - Display logic

  func displaySomething(viewModel: AllListScreen.Something.ViewModel) {
    // NOTE: Display the result from the Presenter

    // nameTextField.text = viewModel.name
  }

  // MARK: - Router

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    router.passDataToNextScene(segue: segue)
  }

  @IBAction func unwindToAllListScreenViewController(from segue: UIStoryboardSegue) {
    print("unwind...")
    router.passDataToNextScene(segue: segue)
  }
}
