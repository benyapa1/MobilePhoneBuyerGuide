//
//  MobileListRouter.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 23/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

protocol MobileListRouterInput {
}

class MobileListRouter: MobileListRouterInput {
  weak var viewController: MobileListViewController!

  // MARK: - Navigation

  // MARK: - Communication

    func passDataToDetailScene(segue: UIStoryboardSegue, sender: Any?) {
    // NOTE: Teach the router which scenes it can communicate with
    if segue.identifier == "showDetail"{
        passDataToView(segue: segue, sender: sender)
    }
  }

    func passDataToView(segue: UIStoryboardSegue, sender: Any?) {
    // NOTE: Teach the router how to pass data to the next scene
    if let viewController =  segue.destination as? MobileDetailViewController, let item = sender as? Mobile {
        viewController.item = item
    }
  }
}
