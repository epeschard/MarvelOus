//
//  Thumbnail.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 05/05/2017.
//

import RealmSwift

class Thumbnail: Object {
  dynamic var path = ""
  dynamic var ext = ""
  dynamic var data: NSData? = nil
  dynamic var bigData: NSData? = nil
  
  override class func primaryKey() -> String? { return "path" }
}
