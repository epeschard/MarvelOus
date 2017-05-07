//
//  SearchableCell.swift
//  Gourmi.es
//
//  Created by Eugène Peschard on 03/04/2017.
//  Copyright © 2017 PeschApps. All rights reserved.
//

import Foundation

protocol SearchableCell: RealmCell, NibLoadableView {
  
  var query: String { get set }
  
  func highlighted(_ query:String, in string:String, with attributes: [String: AnyObject]) -> NSAttributedString
  
}

extension SearchableCell {
  
}
