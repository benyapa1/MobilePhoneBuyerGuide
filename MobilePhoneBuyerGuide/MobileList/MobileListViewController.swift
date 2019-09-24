//
//  MobileListViewController.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 23/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

protocol MobileListViewControllerInterface: class {
  func displayTableView(viewModel: MobileList.ShowListMobile.ViewModel)
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
    let nib = UINib(nibName: "MobileTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "MobileTableViewCellIdentifier")
    allButton.isSelected = true
    requestGetAPI()
  }

  // MARK: - Event handling

  func requestGetAPI() {
    // NOTE: Ask the Interactor to do some work

    let request = MobileList.ShowListMobile.Request()
    interactor.getAPI(request: request)
  }

  // MARK: - Display logic

  func displayTableView(viewModel: MobileList.ShowListMobile.ViewModel) {
    // NOTE: Display the result from the Presenter
    if let list = viewModel as? [Mobile] {
        self.mobileList = list
    } else if let error = viewModel as? Error {
        showErrorAlert(error: error)
    }
  }

  // MARK: - Router

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    router.passDataToNextScene(segue: segue)
  }

//  @IBAction func unwindToMobileListViewController(from segue: UIStoryboardSegue) {
//    print("unwind...")
//    router.passDataToNextScene(segue: segue)
//  }
    
    @IBAction func didClickAllButton(_ sender: Any) {
        self.isHidden = false
        allButton.isSelected = true
        favButton.isSelected = false
        self.mobilesListShow = mobileList
        tableView.reloadData()
    }
    
    @IBAction func didClickFavButton(_ sender: Any) {
        self.isHidden = true
        favButton.isSelected = true
        allButton.isSelected = false
        self.mobilesListShow = mobileList.filter { (item) -> Bool in
            return item.isFav
        }
        tableView.reloadData()
    }
    
    @IBAction func didClickSortButton(_ sender: Any){
        showSortAlert()
    }
    
    func showErrorAlert(error: Error) {
        
    }
    
    func showSortAlert() {
        let alert = UIAlertController(title: "Alert", message: "Select button to sorting data in table view", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Price Low to high", style: .default, handler: { [weak self] (_) in
            self?.mobileList.sort(by: { (mobile1, mobile2) -> Bool in
                return mobile1.price < mobile2.price
            })
            if self?.isHidden ?? false {
                self?.mobilesListShow = self?.mobileList.filter { (item) -> Bool in
                    return item.isFav
                    } ?? []
            } else {
                self?.mobilesListShow = self?.mobileList ?? []
            }
            self?.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Price high to low", style: .default, handler: { [weak self] (_) in
            self?.mobileList.sort(by: { (mobile1, mobile2) -> Bool in
                return mobile1.price > mobile2.price
            })
            if self?.isHidden ?? false {
                self?.mobilesListShow = self?.mobileList.filter { (item) -> Bool in
                    return item.isFav
                } ?? []
            } else {
                self?.mobilesListShow = self?.mobileList ?? []
            }
            self?.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Rating", style: .default, handler: { [weak self] (_) in
            self?.mobileList.sort(by: { (mobile1, mobile2) -> Bool in
                return mobile1.rating > mobile2.rating
            })
            if self?.isHidden ?? false{
                self?.mobilesListShow = self?.mobileList.filter { (item) -> Bool in
                    return item.isFav
                } ?? []
            } else {
                self?.mobilesListShow = self?.mobileList ?? []
            }
            self?.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
extension MobileListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mobilesListShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MobileTableViewCellIdentifier", for: indexPath) as? MobileTableViewCell else {
            return UITableViewCell()
        }
        let item = mobilesListShow[indexPath.row]
        cell.setViewByItem(mobile: item, isHidden: isHidden)
//        cell.delegate = self as! MobileTableViewCellDelegate
        return cell
    }
}

//extension ViewController: MobileTableViewCellDelegate{
//    func doClickFav(cell: MobileTableViewCell, isFav: Bool) {
//        if let indexInView = tableView.indexPath(for: cell){
//            let index = searchShowItemInActualArray(indexRow: indexInView.row)
//            mobileList[index].isFav = isFav
//            mobilesListShow[indexInView.row].isFav = isFav
//        }
//    }
//}


