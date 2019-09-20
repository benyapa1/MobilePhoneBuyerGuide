//
//  MobileDetail.swift
//  MobilePhoneBuyerGuide
//
//  Created by SparePcland on 17/9/2562 BE.
//  Copyright © 2562 SparePcland. All rights reserved.
//

import Foundation

struct Mobile: Codable {
    
    let thumbImageURL: String
    let brand: String
    let price: Float
    let description: String
    let name: String
    let rating: Float
    let id: Int
    var isFav: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case thumbImageURL
        case brand
        case price
        case description
        case name
        case rating
        case id
    }
}

struct mobileImage: Codable{
    let mobileId: Int
    var url: String
    let id: Int
    
    private enum CodingKeys: String, CodingKey {
        case mobileId = "mobile_id"
        case url
        case id
    }
}

