//
//  MobileListStore.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 23/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import Foundation
import Alamofire

class MobileListStore: MobileListStoreProtocol {
    private let urlGetListString: String = "https://scb-test-mobile.herokuapp.com/api/mobiles/"
    
    public func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return SessionManager.default.request(urlRequest)
    }
    
    func getData(_ completion: @escaping (Result<[Mobile]>) -> Void) {
        Alamofire.request(urlGetListString).responseJSON { (response) in
            switch response.result {
            case .success( _):
                guard let rawData =  response.data else { return }
                do {
                    let mobiles = try JSONDecoder().decode([Mobile].self, from: rawData)
                    completion(Result.success(mobiles))
                } catch {
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
//        if let url = URL(string: urlGetListString) {
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                if let error = error {
//                    completion(Result.failure(error))
//                } else if let data = data, let response = response as? HTTPURLResponse {
//                    if response.statusCode == 200 {
//                        do {
//                            let mobiles = try JSONDecoder().decode([Mobile].self, from: data)
//                            completion(Result.success(mobiles))
//
//                        } catch {
//                            completion(.failure(error))
//                        }
//                    }
//                }
//            }
//            task.resume()
//        }
    }
}
