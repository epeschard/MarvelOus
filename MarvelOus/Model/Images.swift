//
//  Images.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 05/05/2017.
//

import RealmSwift

class Images: Object {
  dynamic var path = ""
  dynamic var ext = ""
  
  override class func primaryKey() -> String? { return "path" }
}
