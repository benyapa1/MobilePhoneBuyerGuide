//
//  MobileListStore.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 23/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import Foundation

/*

 The MobileListStore class implements the MobileListStoreProtocol.

 The source for the data could be a database, cache, or a web service.

 You may remove these comments from the file.

 */

class MobileListStore: MobileListStoreProtocol {
  func getData(_ completion: @escaping (Result<[Mobile], Error>) -> Void) {
    let urlGetListString: String = "https://scb-test-mobile.herokuapp.com/api/mobiles/"
    if let url = URL(string: urlGetListString) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(Result.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    do {
                        let mobiles = try JSONDecoder().decode([Mobile].self, from: data)
                        completion(Result.success(mobiles))
                        
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
  }
}
