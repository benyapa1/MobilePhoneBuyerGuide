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
    
    func setViewByItem(mobile: MobileForShow, isHidden: Bool) {
        descriptionLabel.text = mobile.description
        nameLabel.text = mobile.name
        priceLabel.text = mobile.price
        ratingLabel.text = mobile.rating
        favButton.isSelected = mobile.isFav
        mobileImageView.kf.setImage(with: URL(string: mobile.thumbImageURL))
        hideFavButton(isHidden: isHidden)
    }
    
}
