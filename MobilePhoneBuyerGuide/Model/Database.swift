//
//  Database.swift
//  MobilePhoneBuyerGuide
//
//  Created by Papada Preedagorn on 13/3/2563 BE.
//  Copyright © 2563 SparePcland. All rights reserved.
//

import Foundation
import RealmSwift

class Favourite: Object {
  @objc dynamic var id = 0
  
  override static func primaryKey() -> String? {
    return "id"
  }
}
