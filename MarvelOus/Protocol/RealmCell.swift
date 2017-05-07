//
//  RealmCell.swift
//  Gourmi.es
//
//  Created by Eugène Peschard on 01/04/2017.
//  Copyright © 2017 PeschApps. All rights reserved.
//

import UIKit
import RealmSwift

protocol RealmCell: ReusableView  {
  
  associatedtype Entity: Object
  
  var object: Entity? { get set }
  
  func updateUI()
  
}

extension RealmCell where Self: UITableViewCell {
  
//  func updateUI() {
//    textLabel?.text = object?.description
//  }
  
}
