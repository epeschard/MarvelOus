//
//  Series.swift
//  PruebaWallapop
//
//  Created by Eugène Peschard on 05/05/2017.
//  Copyright © 2017 PeschApps. All rights reserved.
//

import RealmSwift

class Series: Object {
  dynamic var resourceURI = ""
  dynamic var name = ""
  
  
  
  override class func primaryKey() -> String? { return "resourceURI" }
}
