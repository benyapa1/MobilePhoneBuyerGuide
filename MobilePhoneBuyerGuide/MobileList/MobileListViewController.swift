//
//  MobileListViewController.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 23/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

protocol MobileListViewControllerInterface: class {
  func displaySomething(viewModel: MobileList.Something.ViewModel)
}

class MobileListViewController: UIViewController, MobileListViewControllerInterface {
  var interactor: MobileListInteractorInterface!
  var router: MobileListRouter!
    
    private var mobileList: [Mobile] = []
    private var mobilesListShow: [Mobile] = []
    private var isHidden: Bool = false //favourite button should be hidden
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var alert: UIAlertController!

  // MARK: - Object lifecycle

  override func awakeFromNib() {
    super.awakeFromNib()
    configure(viewController: self)
  }

  // MARK: - Configuration

  private func configure(viewController: MobileListViewController) {
    let router = MobileListRouter()
    router.viewController = viewController

    let presenter = MobileListPresenter()
    presenter.viewController = viewController

    let interactor = MobileListInteractor()
    interactor.presenter = presenter
    interactor.worker = MobileListWorker(store: MobileListStore())

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

    let request = MobileList.Something.Request()
    interactor.doSomething(request: request)
  }

  // MARK: - Display logic

  func displaySomething(viewModel: MobileList.Something.ViewModel) {
    // NOTE: Display the result from the Presenter

    // nameTextField.text = viewModel.name
  }

  // MARK: - Router

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    router.passDataToNextScene(segue: segue)
  }

  @IBAction func unwindToMobileListViewController(from segue: UIStoryboardSegue) {
    print("unwind...")
    router.passDataToNextScene(segue: segue)
  }
}

