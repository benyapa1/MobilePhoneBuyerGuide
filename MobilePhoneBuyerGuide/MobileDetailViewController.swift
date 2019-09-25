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
    private var mobileImages: [MobileImage] = []
    
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
            self?.mobileImages = mobileImages.map({ (image) -> MobileImage in
                if (image.url.starts(with: "https://")){
                    return image
                }else {
                    if let index = image.url.firstIndex(of: "w") , image.url.contains("www."){
                        let url = image.url.suffix(from: index)
                        return MobileImage(mobileId: image.mobileId,
                                           url: "https://" + String(url),
                                           id: image.id)
                    }
                    return image
                }
            })
            DispatchQueue.main.sync {
                self?.collectionView.reloadData()
            }
        }
    }
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
