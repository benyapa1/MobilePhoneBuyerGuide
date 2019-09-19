//
//  ViewController.swift
//  MobilePhoneBuyerGuide
//
//  Created by SparePcland on 17/9/2562 BE.
//  Copyright © 2562 SparePcland. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var mobileList: [mobileItem] = []
    private var mobilesListShow: [mobileItem] = []
    private var state: Bool = true //state true = All, false = Favourite


    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "MobileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MobileTableViewCellIdentifier")
        allButton.isSelected = true
        getAPI()
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Alert", message: "Alert with more than 2 buttons", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Price Low to high", style: .default, handler: { (_) in
            print("You've pressed Price Low to high")
        }))
        
        alert.addAction(UIAlertAction(title: "Price high to low", style: .default, handler: { (_) in
            print("You've pressed Price high to low")
        }))
        alert.addAction(UIAlertAction(title: "Rating", style: .default, handler: { (_) in
            print("You've pressed Rating")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("You've pressed Cancel")
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func getAPI() {
        APIManager().getListFromAPI(){
            [weak self] (mobiles) in
            for mobile in mobiles {
                self?.mobileList.append(mobileItem(mobileDetail: mobile, isFav: false))
            }
            self?.mobilesListShow = self?.mobileList ?? []
            DispatchQueue.main.sync {
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func didClickAllButton(_ sender: Any) {
        self.state = true
        allButton.isSelected = true
        favButton.isSelected = false
        self.mobilesListShow = mobileList
        tableView.reloadData()
    }
    
    @IBAction func didClickFavButton(_ sender: Any) {
        self.state = false
        favButton.isSelected = true
        allButton.isSelected = false
        self.mobilesListShow = mobileList.filter { (mobileItem) -> Bool in
            return mobileItem.isFav
        }
        tableView.reloadData()
    }
    

    @IBAction func didClickSortButton(_ sender: Any){
        showAlert()
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
        cell.setViewByItem(mobileItem: item)
        cell.delegate = self
        return cell
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("Select Row")
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !state
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let id = mobilesListShow[indexPath.row].mobileDetail.id
            if let index = mobileList.firstIndex(where: { (item) -> Bool in
                if item.mobileDetail.id == id {
                    return true
                }
                return false
            }){
                mobileList[index].isFav = false
                mobilesListShow.remove(at: indexPath.row)
                tableView.reloadData()
                print("mobile list is fav \(mobileList[index].isFav)")
                
            }
            
        }
    }
}

extension ViewController: MobileTableViewCellDelegate{
    func doClickFav(cell: MobileTableViewCell, isFav: Bool) {
        if let index = tableView.indexPath(for: cell){
            mobileList[index.row].isFav = isFav
            print(mobileList[index.row].isFav, index.row)
        }
    }
    
    
    
}

