//
//  Identifiable.swift
//  Gourmi.es
//
//  Created by Eugène Peschard on 29/04/2017.
//  Copyright © 2017 PeschApps. All rights reserved.
//

import UIKit

protocol Identifiable: class {}

extension Identifiable where Self: UIViewController {
  
  static var identifier: String {
    return String(describing: self)
  }
  
}
