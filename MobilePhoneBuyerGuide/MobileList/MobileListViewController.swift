//
//  MobileListViewController.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 23/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

protocol MobileListViewControllerInterface: class {
    func displayTableViewFromApi(viewModel: MobileList.ShowListMobile.ViewModel)
    func displayViewFromSortingData(viewModel: MobileList.showListWithSorting.ViewModel)
    func displayViewByPage(viewModel: MobileList.changePage.ViewModel)
    func displayViewFromDeleteFav(viewModel: MobileList.deleteFav.ViewModel)
    func displayViewFromChangeFav(viewModel: MobileList.addfav.ViewModel)
}

class MobileListViewController: UIViewController, MobileListViewControllerInterface {
    var interactor: MobileListInteractorInterface!
    var router: MobileListRouter!
    
    private var mobiles: [MobileForShow] = []
    private var isFavPage: Bool = false //favourite button should be hidden
    private var sortType: SortType?
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var alert: UIAlertController!
    private let tableNibName = "MobileTableViewCell"
    private let tableCellIdentifier = "MobileTableViewCellIdentifier"
    private let segueName = "showDetail"
    
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
        let nib = UINib(nibName: tableNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: tableCellIdentifier)
        allButton.isSelected = true
        tableView.tableFooterView = UIView()
        requestGetAPI()
    }
    
    // MARK: - Event handling
    
    func requestGetAPI() {
        // NOTE: Ask the Interactor to do some work
        let request = MobileList.ShowListMobile.Request()
        interactor.getAPI(request: request)
    }
    
    func requestSortData(sortType: SortType?, isFav: Bool?) {
        let request = MobileList.showListWithSorting.Request(sortingType: sortType, isFav: isFav)
        interactor.getSortData(request: request)
    }
    func requestChangePage(isFavPage: Bool) {
        let request = MobileList.changePage.Request(isFavPage: isFavPage)
        interactor.getDataFromPage(request: request)
    }
    func requestAddtoFav(index: Int, isFav: Bool) {
        let request = MobileList.addfav.Request(index: index, isFav: isFav)
        interactor.addFav(request: request)
    }
    func requestDeleteFav(id: Int, index: Int) {
        let request = MobileList.deleteFav.Request(id: id,index: index, list: self.mobiles)
        interactor.deleteFav(request: request)
    }
    
    @IBAction func didClickAllButton(_ sender: Any) {
        if self.isFavPage == true {
            self.isFavPage = false
            allButton.isSelected = true
            favButton.isSelected = false
            requestChangePage(isFavPage: self.isFavPage)
        }
    }
    
    @IBAction func didClickFavButton(_ sender: Any) {
        if self.isFavPage == false {
            self.isFavPage = true
            favButton.isSelected = true
            allButton.isSelected = false
            requestChangePage(isFavPage: self.isFavPage)
        }
    }
    
    @IBAction func didClickSortButton(_ sender: Any){
        showSortAlert()
    }
    
    // MARK: - Display logic
    
    func displayTableViewFromApi(viewModel: MobileList.ShowListMobile.ViewModel) {
        if let list = viewModel.list {
            self.mobiles = list
            DispatchQueue.main.async { [weak self] () in
                self?.tableView.reloadData()
            }
        } else if let error = viewModel.error {
            showErrorAlert(error: error)
        }
    }
    
    func displayViewFromSortingData(viewModel: MobileList.showListWithSorting.ViewModel) {
        self.mobiles = viewModel.list
        self.tableView.reloadData()
    }
    
    func displayViewFromChangeFav(viewModel: MobileList.addfav.ViewModel) {
        self.mobiles = viewModel.list
        self.tableView.reloadData()
    }
    func displayViewByPage(viewModel: MobileList.changePage.ViewModel) {
        self.mobiles = viewModel.list
        self.tableView.reloadData()
    }
    
    func displayViewFromDeleteFav(viewModel: MobileList.deleteFav.ViewModel) {
        self.mobiles = viewModel.list
        self.tableView.reloadData()
    }
    
    // MARK: - Create alert
    func showErrorAlert(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async { [weak self] () in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func showSortAlert() {
        let alert = UIAlertController(title: "Alert", message: "Select button to sorting data in table view", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Price Low to high", style: .default, handler: { [weak self] (_) in
            if self?.sortType != .priceLowToHigh {
                self?.sortType = .priceLowToHigh
                self?.requestSortData(sortType: .priceLowToHigh, isFav: self?.isFavPage ?? false)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Price high to low", style: .default, handler: { [weak self] (_) in
            if self?.sortType != .priceHighToLow {
                self?.sortType = .priceHighToLow
                self?.requestSortData(sortType: .priceHighToLow, isFav: self?.isFavPage ?? false)
            }
        }))
        alert.addAction(UIAlertAction(title: "Rating", style: .default, handler: { [weak self] (_) in
            if self?.sortType != .rating {
                self?.sortType = .rating
                self?.requestSortData(sortType: .rating, isFav: self?.isFavPage ?? false)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Router
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToDetailScene(segue: segue, sender: sender)
    }
}

// MARK: - Extension
extension MobileListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mobiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as? MobileTableViewCell else {
            return UITableViewCell()
        }
        let item = mobiles[indexPath.row]
        cell.setViewByItem(mobile: item, isHidden: self.isFavPage)
        cell.delegate = self
        return cell
    }
}

extension MobileListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.performSegue(withIdentifier: segueName, sender: mobiles[indexPath.row])
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //if this view is favourite page, table view can delete
        return self.isFavPage
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let id = self.mobiles[indexPath.row].id
            requestDeleteFav(id: id, index: indexPath.row)
        }
    }
}

extension MobileListViewController: MobileTableViewCellDelegate{
    func doClickFav(cell: MobileTableViewCell, isFav: Bool) {
        if let indexInView = tableView.indexPath(for: cell){
            requestAddtoFav(index: indexInView.row, isFav: isFav)
        }
    }
}


