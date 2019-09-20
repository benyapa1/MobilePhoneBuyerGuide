//
//  APIManager.swift
//  MobilePhoneBuyerGuide
//
//  Created by SparePcland on 17/9/2562 BE.
//  Copyright © 2562 SparePcland. All rights reserved.
//

import Foundation
class APIManager {
    
    func getListFromAPI(completion: @escaping ([Mobile]) -> Void){
        let urlGetListString: String = "https://scb-test-mobile.herokuapp.com/api/mobiles/"
        if let url = URL(string: urlGetListString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let _ = error {
                    print("error")
                } else if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        do {
                            let mobile = try JSONDecoder().decode([Mobile].self, from: data)
                            completion(mobile)
                            
                        } catch {
                            print("parse JSON failed")
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func getImageFromApi(mobileId: Int, completion: @escaping ([mobileImage]) -> Void) {
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
                            let image = try JSONDecoder().decode([mobileImage].self, from: data)
                            completion(image)
                            
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
