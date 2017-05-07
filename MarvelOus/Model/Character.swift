//
//  Character.swift
//  PruebaWallapop
//
//  Created by Eugène Peschard on 05/05/2017.
//  Copyright © 2017 PeschApps. All rights reserved.
//

import RealmSwift

class Character: Object {
  dynamic var id: String?
  dynamic var name = ""
  dynamic var resourceURI = ""
  dynamic var role: String?
  dynamic var desc: String?
  dynamic var modified: String?
  dynamic var thumbnail: Thumbnail?
  
  override class func primaryKey() -> String? { return "resourceURI" }
}
