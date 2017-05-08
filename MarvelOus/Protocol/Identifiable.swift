//
//  Identifiable.swift
//  Gourmi.es
//
//  Created by Eugène Peschard on 29/04/2017.
//

import UIKit

protocol Identifiable: class {}

extension Identifiable where Self: UIViewController {
  
  static var identifier: String {
    return String(describing: self)
  }
  
}
