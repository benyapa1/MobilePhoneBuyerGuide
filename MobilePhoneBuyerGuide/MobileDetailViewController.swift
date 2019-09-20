//
//  MobileDetailViewController.swift
//  MobilePhoneBuyerGuide
//
//  Created by SparePcland on 18/9/2562 BE.
//  Copyright © 2562 SparePcland. All rights reserved.
//

import UIKit

class MobileDetailViewController: UIViewController {
    
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    var item: Mobile?
    private var mobileImages: [mobileImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getAPI()
        setView()
    }
    
    func setView() {
        guard let item = item else { return }
        self.title = item.name
        detailTextView.text = item.description
        ratingLabel.text = "Rating: \(String(format: "%.1f",item.rating))"
        priceLabel.text = "Price: $\(String(format: "%.2f",item.price))"
    }
    
    func getAPI() {
        guard let item = item else { return }
        APIManager().getImageFromApi(mobileId: item.id) {
            [weak self] (mobileImages) in
            self?.mobileImages.append(contentsOf: mobileImages)
            DispatchQueue.main.sync {
                self?.collectionView.reloadData()
            }
        }
    }
}

extension MobileDetailViewController: UICollectionViewDelegate{
    
}

extension MobileDetailViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mobileImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MobileDetailCollectionCell", for: indexPath) as? MobileDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configCell(urlImage: mobileImages[indexPath.row].url)
        return cell
    }
}
