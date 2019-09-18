//
//  MobileDetail.swift
//  MobilePhoneBuyerGuide
//
//  Created by SparePcland on 17/9/2562 BE.
//  Copyright © 2562 SparePcland. All rights reserved.
//

import Foundation

struct mobileDetail: Codable {
    
    let thumbImageURL: String
    let brand: String
    let price: Float
    let description: String
    let name: String
    let rating: Float
    let id: Int
}

struct mobileItem {
    let mobileDetail: mobileDetail
    var isFav: Bool = false
}

struct mobileImage: Codable{
    let mobileId: Int
    let url: String
    let id: Int
}

