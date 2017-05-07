//
//  ReusableView.swift
//  Gourmi.es
//
//  Created by Eugène Peschard on 01/04/2017.
//  Copyright © 2017 PeschApps. All rights reserved.
//

import UIKit

protocol ReusableView: class {}

extension ReusableView /*where Self: UIView*/ {
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
}
