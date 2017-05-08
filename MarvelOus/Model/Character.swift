//
//  Character.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 05/05/2017.
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
