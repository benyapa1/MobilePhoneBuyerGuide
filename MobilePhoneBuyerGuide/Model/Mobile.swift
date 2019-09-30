//
//  MobileListEntity.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 23/9/2562 BE.
//  Copyright (c) 2562 SparePcland. All rights reserved.
//

import Foundation

/*

 The Entity class is the business object.
 The Result enumeration is the domain model.

 1. Rename this file to the desired name of the model.
 2. Rename the Entity class with the desired name of the model.
 3. Move this file to the Models folder.
 4. If the project already has a declaration of Result enumeration, you may remove the declaration from this file.
 5. Remove the following comments from this file.

 */

enum SortType {
    case priceLowToHigh
    case priceHighToLow
    case rating
}

struct Mobile: Codable, Equatable {
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

struct MobileForShow: Equatable {
    let thumbImageURL: String
    let brand: String
    let price: String
    let description: String
    let name: String
    let rating: String
    let id: Int
    var isFav: Bool
}

struct MobileImage: Codable, Equatable {
    let mobileId: Int
    var url: String
    let id: Int
    
    private enum CodingKeys: String, CodingKey {
        case mobileId = "mobile_id"
        case url
        case id
    }
}
