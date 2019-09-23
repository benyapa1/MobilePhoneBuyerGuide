//
//  ViewController.swift
//  MobilePhoneBuyerGuide
//
//  Created by SparePcland on 17/9/2562 BE.
//  Copyright © 2562 SparePcland. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var mobileList: [Mobile] = []
    private var mobilesListShow: [Mobile] = []
    private var isHidden: Bool = false //favourite button should be hidden
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var alert: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "MobileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MobileTableViewCellIdentifier")
        allButton.isSelected = true
        self.alert = createAlert()
        tableView.tableFooterView = UIView()
        if let listFav = UserDefaults.standard.array(forKey: "mobileFav") as? [Int],
            let sortData = UserDefaults.standard.object(forKey: "sorting") as? SortingData{
            getAPI()
            self.mobileList = self.mobileList.map { (mobile) -> Mobile in
                if listFav.contains(mobile.id){
                    return Mobile(thumbImageURL: mobile.thumbImageURL, brand: mobile.brand, price: mobile.price, description: mobile.description, name: mobile.name, rating: mobile.rating, id: mobile.id, isFav: true)
                }
                return mobile
            }

            switch sortData {
            case .priceLowToHigh :
               self.mobileList.sort(by: { (mobile1, mobile2) -> Bool in
                    return mobile1.price < mobile2.price
                })
            case .priceHighToLow:
                self.mobileList.sort(by: { (mobile1, mobile2) -> Bool in
                    return mobile1.price > mobile2.price
                })
            case .rating:
                self.mobileList.sort(by: { (mobile1, mobile2) -> Bool in
                    return mobile1.rating > mobile2.rating
                })
            }
        } else {
            getAPI()
        }
//        getAPI()
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let sendToUserDefault = self.mobileList.filter { (mobile) -> Bool in return mobile.isFav }
//        let sendToUserDefaultID = sendToUserDefault.map({ (mobile) -> Int in
//            return mobile.id
//        })
//        UserDefaults.standard.set(sendToUserDefaultID, forKey: "mobileFav")
//        UserDefaults.standard.set(SortingData.priceHighToLow, forKey: "sorting")
//        print(UserDefaults.standard.array(forKey: "mobileFav"))
//        print("eiei")
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let item = sender as? Mobile,
            segue.identifier == "showDetail",
            let viewController =  segue.destination as? MobileDetailViewController{
            viewController.item = item
        }
    }
    
    func getAPI() {
        APIManager().getListFromAPI(){
            [weak self] (mobiles) in
            self?.mobileList.append(contentsOf: mobiles)
            self?.mobilesListShow = self?.mobileList ?? []
            DispatchQueue.main.sync {
                self?.tableView.reloadData()
            }
        }
    }
    
    func createAlert() -> UIAlertController {
        alert = UIAlertController(title: "Alert", message: "Alert with more than 2 buttons", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Price Low to high", style: .default, handler: { (_) in
            self.mobileList.sort(by: { (mobile1, mobile2) -> Bool in
                return mobile1.price < mobile2.price
            })
            if self.isHidden {
                self.mobilesListShow = self.mobileList.filter { (item) -> Bool in
                    return item.isFav
                }
            } else {
                self.mobilesListShow = self.mobileList
            }
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Price high to low", style: .default, handler: { (_) in
            self.mobileList.sort(by: { (mobile1, mobile2) -> Bool in
                return mobile1.price > mobile2.price
            })
            if self.isHidden {
                self.mobilesListShow = self.mobileList.filter { (item) -> Bool in
                    return item.isFav
                }
            } else {
                self.mobilesListShow = self.mobileList
            }
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Rating", style: .default, handler: { (_) in
            self.mobileList.sort(by: { (mobile1, mobile2) -> Bool in
                return mobile1.rating > mobile2.rating
            })
            if self.isHidden {
                self.mobilesListShow = self.mobileList.filter { (item) -> Bool in
                    return item.isFav
                }
            } else {
                self.mobilesListShow = self.mobileList
            }
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alert
    }
    
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
        self.present(alert, animated: true, completion: nil)
    }
    
    func searchShowItemInActualArray(indexRow: Int)  -> Int{
        let id = mobilesListShow[indexRow].id
        if let index = mobileList.firstIndex(where: { (item) -> Bool in
            if item.id == id {
                return true
            }
            return false
            })
        {
            return index
        }else {
            return -1
        }
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mobilesListShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MobileTableViewCellIdentifier", for: indexPath) as? MobileTableViewCell else {
            return UITableViewCell()
        }
        let item = mobilesListShow[indexPath.row]
        cell.setViewByItem(mobile: item, isHidden: isHidden)
        cell.delegate = self
        return cell
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.performSegue(withIdentifier: "showDetail", sender: mobilesListShow[indexPath.row])
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //if this view is favourite page, table view can delete
        return isHidden
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let index = searchShowItemInActualArray(indexRow: indexPath.row)
            mobileList[index].isFav = false
            mobilesListShow.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

extension ViewController: MobileTableViewCellDelegate{
    func doClickFav(cell: MobileTableViewCell, isFav: Bool) {
        if let indexInView = tableView.indexPath(for: cell){
            let index = searchShowItemInActualArray(indexRow: indexInView.row)
            mobileList[index].isFav = isFav
            mobilesListShow[indexInView.row].isFav = isFav
        }
    }
}
