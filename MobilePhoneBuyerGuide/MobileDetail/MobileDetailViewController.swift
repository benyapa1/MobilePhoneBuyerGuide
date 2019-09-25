//
//  MobileDetailViewController.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 25/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import UIKit

protocol MobileDetailViewControllerInterface: class {
    func displayImage(viewModel: MobileDetail.ShowScene.ViewModel)
}

class MobileDetailViewController: UIViewController, MobileDetailViewControllerInterface {
    var interactor: MobileDetailInteractorInterface!
    var router: MobileDetailRouter!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    var item: MobileForShow?
    private var mobileImages: [MobileImage] = []
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure(viewController: self)
    }
    
    // MARK: - Configuration
    
    private func configure(viewController: MobileDetailViewController) {
        let router = MobileDetailRouter()
        router.viewController = viewController
        
        let presenter = MobileDetailPresenter()
        presenter.viewController = viewController
        
        let interactor = MobileDetailInteractor()
        interactor.presenter = presenter
        interactor.worker = MobileDetailWorker(store: MobileDetailStore())
        
        viewController.interactor = interactor
        viewController.router = router
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doGetAPIOnLoad()
    }
    
    // MARK: - Event handling
    
    func doGetAPIOnLoad() {
        // NOTE: Ask the Interactor to do some work
        guard let item = item else { return }
        let request = MobileDetail.ShowScene.Request(mobileId: item.id)
        interactor.doGetAPI(request: request)
    }
    
    // MARK: - Display logic
    
    func displayImage(viewModel: MobileDetail.ShowScene.ViewModel) {
        if let list = viewModel.success {
             self.mobileImages = list
             DispatchQueue.main.sync {
                guard let item = item else { return }
                self.title = item.name
                detailTextView.text = item.description
                ratingLabel.text = item.rating
                priceLabel.text = item.price
                 self.collectionView.reloadData()
             }
        } else if let error = viewModel.fail{
             showErrorAlert(error: error)
         }
    }
    
    // MARK: - Create alert
    func showErrorAlert(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.sync {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Router
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
    
    @IBAction func unwindToMobileDetailViewController(from segue: UIStoryboardSegue) {
        print("unwind...")
        router.passDataToNextScene(segue: segue)
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
