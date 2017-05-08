//
//  NibLoadableView.swift
//  Gourmi.es
//
//  Created by Eugène Peschard on 01/04/2017.
//

import UIKit

protocol NibLoadableView: class {}

extension NibLoadableView where Self: UIView {
  
  static var nibName: String {
    return String(describing: self)
  }
  
}
