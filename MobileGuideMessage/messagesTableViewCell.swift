//
//  messagesTableViewCell.swift
//  MobileGuideMessage
//
//  Created by Papada Preedagorn on 11/11/2562 BE.
//  Copyright © 2562 SparePcland. All rights reserved.
//

import UIKit

class messagesTableViewCell: UITableViewCell {
  
  @IBOutlet weak var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func updateUI(text: String){
    messageLabel.text = text
  }

}
