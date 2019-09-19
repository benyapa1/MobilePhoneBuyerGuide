//
//  MobileTableViewCell.swift
//  MobilePhoneBuyerGuide
//
//  Created by SparePcland on 18/9/2562 BE.
//  Copyright © 2562 SparePcland. All rights reserved.
//

import UIKit
import Kingfisher

protocol MobileTableViewCellDelegate {
    func doClickFav(cell: MobileTableViewCell, isFav: Bool)
}

class MobileTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var mobileImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var delegate: MobileTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func clickFav(_ sender: Any) {
        if favButton.isSelected {
            favButton.isSelected = false
        } else {
            favButton.isSelected = true
        }
        delegate?.doClickFav(cell: self, isFav: favButton.isSelected)
        
    }
    
    func hideFavButton(isHidden: Bool) {
        favButton.isHidden = isHidden
    }
    
    func setViewByItem(mobileItem: mobileItem) {
        descriptionLabel.text = mobileItem.mobileDetail.description
        nameLabel.text = mobileItem.mobileDetail.name
        priceLabel.text = "Price: $\(mobileItem.mobileDetail.price)"
        ratingLabel.text = "Rating: \(mobileItem.mobileDetail.rating)"

        mobileImageView.kf.setImage(with: URL(string: mobileItem.mobileDetail.thumbImageURL))
    }
    
}
