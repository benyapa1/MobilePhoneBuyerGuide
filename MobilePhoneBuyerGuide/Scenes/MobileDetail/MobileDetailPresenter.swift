//
//  MobileDetailPresenter.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 25/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

protocol MobileDetailPresenterInterface {
    func presentImageCollectionView(response: MobileDetail.ShowScene.Response)
}

class MobileDetailPresenter: MobileDetailPresenterInterface {
    weak var viewController: MobileDetailViewControllerInterface!
    
    // MARK: - Presentation logic
    
    func presentImageCollectionView(response: MobileDetail.ShowScene.Response) {
        let viewModel = MobileDetail.ShowScene.ViewModel(success: response.success, fail: response.fail)
        viewController.displayImage(viewModel: viewModel)
    }
}
