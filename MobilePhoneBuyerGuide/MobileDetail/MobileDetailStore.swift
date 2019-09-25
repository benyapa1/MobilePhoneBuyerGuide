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
    func getData(mobileId: Int, _ completion: @escaping (Result<[MobileImage],Error>) -> Void) {
        // Simulates an asynchronous background thread that calls back on the main thread after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //      completion(Result.success())
        }
        
        let urlGetListString: String = "https://scb-test-mobile.herokuapp.com/api/mobiles/\(mobileId)/images/"
        if let url = URL(string: urlGetListString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let _ = error {
                    print("error")
                } else if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        do {
                            let images = try JSONDecoder().decode([MobileImage].self, from: data)
                            completion(Result.success(images))
                            
                        } catch {
                            print("parse JSON failed")
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
