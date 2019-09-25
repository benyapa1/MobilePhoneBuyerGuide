//
//  MobileDetailStore.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 25/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import Foundation

/*
 
 The MobileDetailStore class implements the MobileDetailStoreProtocol.
 
 The source for the data could be a database, cache, or a web service.
 
 You may remove these comments from the file.
 
 */

class MobileDetailStore: MobileDetailStoreProtocol {
    func getData(url: String, _ completion: @escaping (Result<[MobileImage],Error>) -> Void) {
        if let url = URL(string: url) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        do {
                            let images = try JSONDecoder().decode([MobileImage].self, from: data)
                            completion(Result.success(images))
                            
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
