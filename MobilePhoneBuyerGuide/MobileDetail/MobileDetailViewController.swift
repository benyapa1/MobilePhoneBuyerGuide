//
//  MobileDetailViewController.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 25/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

protocol MobileDetailViewControllerInterface: class {
  func displaySomething(viewModel: MobileDetail.Something.ViewModel)
}

class MobileDetailViewController: UIViewController, MobileDetailViewControllerInterface {
  var interactor: MobileDetailInteractorInterface!
  var router: MobileDetailRouter!

  // MARK: - Object lifecycle

  override func awakeFromNib() {
    super.awakeFromNib()
    configure(viewController: self)
  }

  // MARK: - Configuration

  private func configure(viewController: MobileDetailViewController) {
    let router = MobileDetailRouter()
    router.viewController = viewController

    let presenter = MobileDetailPresenter()
    presenter.viewController = viewController

    let interactor = MobileDetailInteractor()
    interactor.presenter = presenter
    interactor.worker = MobileDetailWorker(store: MobileDetailStore())

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

    let request = MobileDetail.Something.Request()
    interactor.doSomething(request: request)
  }

  // MARK: - Display logic

  func displaySomething(viewModel: MobileDetail.Something.ViewModel) {
    // NOTE: Display the result from the Presenter

    // nameTextField.text = viewModel.name
  }

  // MARK: - Router

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    router.passDataToNextScene(segue: segue)
  }

  @IBAction func unwindToMobileDetailViewController(from segue: UIStoryboardSegue) {
    print("unwind...")
    router.passDataToNextScene(segue: segue)
  }
}
