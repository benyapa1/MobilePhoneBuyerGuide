//
//  MobileDetailStore.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 25/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import Foundation
import Alamofire

class MobileDetailStore: MobileDetailStoreProtocol {
    func getData(url: String, _ completion: @escaping (Result<[MobileImage]>) -> Void) {
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success( _):
                guard let rawData =  response.data else { return }
                do {
                    let images = try JSONDecoder().decode([MobileImage].self, from: rawData)
                    completion(Result.success(images))
                } catch {
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
}
