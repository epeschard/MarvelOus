//
//  Banner.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 08/05/2017.
//

import UIKit

class Banner: UILabel {
  
  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
  }
  
}
