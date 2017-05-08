//
//  Creator.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 07/05/2017.
//

import RealmSwift

class Creator: Object {
  dynamic var resourceURI = ""
  dynamic var name = ""
  dynamic var role: String?
  
  override class func primaryKey() -> String? { return "resourceURI" }
}
