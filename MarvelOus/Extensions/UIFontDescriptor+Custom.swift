//
//  UIFontDescriptor+Custom.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 08/05/2017.
//  Copyright © 2017 Wallapop. All rights reserved.
//

import UIKit

extension UIFontDescriptor {
  
  class func preferredCustomFontDesciptor(for textStyle: UIFontTextStyle) -> UIFontDescriptor {
    
    //TODO: Remove after getting font names
    //    let fontFamilies = UIFont.familyNames
    //    for fontFamily in fontFamilies {
    //      let fontNames = UIFont.fontNames(forFamilyName: fontFamily)
    //      print("\(fontFamily): \(fontNames)")
    //    }
    
    struct Static {
      static var onceToken : Int = 0
      static var fontNameTable : NSDictionary = NSDictionary()
      static var fontSizeTable : NSDictionary = NSDictionary()
    }
    
    Static.fontNameTable = [// "Marvel-Bold", "Marvel-Regular", "Marvel-Italic", "Marvel-BoldItalic
      UIFontTextStyle.headline: "Marvel-Bold",
      UIFontTextStyle.subheadline: "Marvel-Regular",
      UIFontTextStyle.body: "Marvel-Regular",
      UIFontTextStyle.caption1: "Marvel-Regular",
      UIFontTextStyle.caption2: "Marvel-Regular",
      UIFontTextStyle.footnote: "Marvel-Regular"
    ]
    
    Static.fontSizeTable = [
      UIFontTextStyle.headline: [
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 26,
        UIContentSizeCategory.accessibilityExtraExtraLarge: 25,
        UIContentSizeCategory.accessibilityExtraLarge: 24,
        UIContentSizeCategory.accessibilityLarge: 24,
        UIContentSizeCategory.accessibilityMedium: 23,
        UIContentSizeCategory.extraExtraExtraLarge: 23,
        UIContentSizeCategory.extraExtraLarge: 22,
        UIContentSizeCategory.extraLarge: 21,
        UIContentSizeCategory.large: 20,
        UIContentSizeCategory.medium: 19,
        UIContentSizeCategory.small: 18,
        UIContentSizeCategory.extraSmall: 17
      ],
      UIFontTextStyle.subheadline: [
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 26,
        UIContentSizeCategory.accessibilityExtraExtraLarge: 25,
        UIContentSizeCategory.accessibilityExtraLarge: 24,
        UIContentSizeCategory.accessibilityLarge: 24,
        UIContentSizeCategory.accessibilityMedium: 23,
        UIContentSizeCategory.extraExtraExtraLarge: 23,
        UIContentSizeCategory.extraExtraLarge: 22,
        UIContentSizeCategory.extraLarge: 21,
        UIContentSizeCategory.large: 20,
        UIContentSizeCategory.medium: 19,
        UIContentSizeCategory.small: 18,
        UIContentSizeCategory.extraSmall: 17
      ],
      UIFontTextStyle.body: [
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 24,
        UIContentSizeCategory.accessibilityExtraExtraLarge: 23,
        UIContentSizeCategory.accessibilityExtraLarge: 22,
        UIContentSizeCategory.accessibilityLarge: 22,
        UIContentSizeCategory.accessibilityMedium: 21,
        UIContentSizeCategory.extraExtraExtraLarge: 21,
        UIContentSizeCategory.extraExtraLarge: 20,
        UIContentSizeCategory.extraLarge: 19,
        UIContentSizeCategory.large: 18,
        UIContentSizeCategory.medium: 17,
        UIContentSizeCategory.small: 16,
        UIContentSizeCategory.extraSmall: 15
      ],
      UIFontTextStyle.caption1: [
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 19,
        UIContentSizeCategory.accessibilityExtraExtraLarge: 18,
        UIContentSizeCategory.accessibilityExtraLarge: 17,
        UIContentSizeCategory.accessibilityLarge: 17,
        UIContentSizeCategory.accessibilityMedium: 16,
        UIContentSizeCategory.extraExtraExtraLarge: 16,
        UIContentSizeCategory.extraExtraLarge: 16,
        UIContentSizeCategory.extraLarge: 15,
        UIContentSizeCategory.large: 14,
        UIContentSizeCategory.medium: 13,
        UIContentSizeCategory.small: 12,
        UIContentSizeCategory.extraSmall: 12
      ],
      UIFontTextStyle.caption2: [
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 18,
        UIContentSizeCategory.accessibilityExtraExtraLarge: 17,
        UIContentSizeCategory.accessibilityExtraLarge: 16,
        UIContentSizeCategory.accessibilityLarge: 16,
        UIContentSizeCategory.accessibilityMedium: 15,
        UIContentSizeCategory.extraExtraExtraLarge: 15,
        UIContentSizeCategory.extraExtraLarge: 14,
        UIContentSizeCategory.extraLarge: 14,
        UIContentSizeCategory.large: 13,
        UIContentSizeCategory.medium: 12,
        UIContentSizeCategory.small: 12,
        UIContentSizeCategory.extraSmall: 11
      ],
      UIFontTextStyle.footnote: [
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 16,
        UIContentSizeCategory.accessibilityExtraExtraLarge: 15,
        UIContentSizeCategory.accessibilityExtraLarge: 14,
        UIContentSizeCategory.accessibilityLarge: 14,
        UIContentSizeCategory.accessibilityMedium: 13,
        UIContentSizeCategory.extraExtraExtraLarge: 13,
        UIContentSizeCategory.extraExtraLarge: 12,
        UIContentSizeCategory.extraLarge: 12,
        UIContentSizeCategory.large: 11,
        UIContentSizeCategory.medium: 11,
        UIContentSizeCategory.small: 10,
        UIContentSizeCategory.extraSmall: 10
      ]
    ]
    
    let contentSize = UIApplication.shared.preferredContentSizeCategory
    
    let size = Static.fontSizeTable[textStyle] as! NSDictionary
    let font = Static.fontNameTable[textStyle] as! String
    
    let fontDescriptor = UIFontDescriptor(name: font, size: CGFloat((size[contentSize] as! NSNumber).floatValue))
    
    return fontDescriptor
  }
  
}
