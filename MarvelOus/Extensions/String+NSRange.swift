//
//  String+NSRange.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 06/05/2017.
//

import Foundation

extension String {
  
  func nsRange(from range: Range<String.Index>) -> NSRange {
    let from = range.lowerBound.samePosition(in: utf16)
    let to = range.upperBound.samePosition(in: utf16)
    return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                   length: utf16.distance(from: from, to: to))
  }
  
}
