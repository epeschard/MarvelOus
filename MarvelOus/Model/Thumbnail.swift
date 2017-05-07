//
//  Thumbnail.swift
//  PruebaWallapop
//
//  Created by Eugène Peschard on 05/05/2017.
//  Copyright © 2017 PeschApps. All rights reserved.
//

import RealmSwift

class Thumbnail: Object {
  dynamic var path = ""
  dynamic var ext = ""
  dynamic var data: NSData? = nil
  dynamic var bigData: NSData? = nil
  
  override class func primaryKey() -> String? { return "path" }
}
