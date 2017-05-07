//
//  Images.swift
//  PruebaWallapop
//
//  Created by Eugène Peschard on 05/05/2017.
//  Copyright © 2017 PeschApps. All rights reserved.
//

import RealmSwift

class Images: Object {
  dynamic var path = ""
  dynamic var ext = ""
  
  override class func primaryKey() -> String? { return "path" }
}
