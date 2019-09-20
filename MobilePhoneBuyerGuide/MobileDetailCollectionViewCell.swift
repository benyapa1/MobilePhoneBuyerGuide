//
//  MobileImageCollectionViewCell.swift
//  MobilePhoneBuyerGuide
//
//  Created by SparePcland on 19/9/2562 BE.
//  Copyright © 2562 SparePcland. All rights reserved.
//

import UIKit
import Kingfisher

class MobileDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mobileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(urlImage: String) {
        mobileImageView.kf.setImage(with: URL(string: urlImage))
    }
}
