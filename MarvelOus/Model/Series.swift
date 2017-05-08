//
//  Series.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 05/05/2017.
//

import RealmSwift

class Series: Object {
  dynamic var resourceURI = ""
  dynamic var name = ""
  
  
  
  override class func primaryKey() -> String? { return "resourceURI" }
}
