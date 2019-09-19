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
    var item: Mobile?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getAPI()
        setView()
        
    }
    
    func setView() {
        guard let item = item else { return }
        self.title = item.name
        detailTextView.text = item.description
    }
    
    func getAPI() {
        guard let item = item else { return }
        APIManager().getImageFromApi(mobileId: item.id) {
            (mobileImage) in
//            [weak self] (mobiles) in
            print(mobileImage)
        }
    }
    

}
