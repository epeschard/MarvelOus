//
//  ComicCell.swift
//  PruebaWallapop
//
//  Created by Eugène Peschard on 06/05/2017.
//  Copyright © 2017 PeschApps. All rights reserved.
//

import UIKit
import Alamofire

class ComicCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var iconImageView: UIImageView!
  
  // MARK: - Stored properties for protocols
  
  // MARK: Realm Cell protocol
  
  typealias Entity = Comic
  
  var object: Entity? {
    didSet {
      updateUI()
    }
  }
  
  // MARK: Searchable Cell protocol
  
  var query = ""
}

// MARK: - Realm Cell Extension

extension ComicCell: RealmCell {
  
  func updateUI() {
    // reset any existing information
    clearOutlets()
    setFonts()
    tintColor = UIColor.white
    backgroundColor = UIColor.black
    
    // load new information (if any)
    if let comic = object,
      let title = comic.title {
      
      if query != "" {
        grayoutLabels()
        let tint: [String: AnyObject] = [NSForegroundColorAttributeName : marvelRed]
        titleLabel.attributedText = highlighted(query, in: title, with: tint)
      } else {
        titleLabel.text = comic.title
      }
      descriptionLabel.text = comic.format
      
      if let nsData = comic.thumbnail?.data {
        iconImageView.image = UIImage(data: nsData as Data)
      } else if let thumbnail = comic.thumbnail {
        iconImageView.image = UIImage(named: "placeholder")
        // Fetch Images
        MarvelAPI().getData(for: thumbnail, from: thumbnail.path, completionHandler: {
          [weak weakSelf = self]
          response in
          switch response.result {
          case .success:
            do {
              let data = try response.result.unwrap()
              weakSelf?.iconImageView.image = UIImage(data: data)
            } catch {
              print(error.localizedDescription)
            }
          case .failure(let error):
            print(error.localizedDescription)
          }
        })
      }
    }
  }
  
  func setFonts() {
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
  }
  
  func clearOutlets() {
    titleLabel.text = nil
    descriptionLabel.text = nil
  }

  func grayoutLabels() {
    titleLabel.textColor = UIColor.lightGray
    descriptionLabel.textColor = UIColor.gray
  }
  
}

// MARK: - NibLoadableView Cell Extension

extension ComicCell: NibLoadableView { }

// MARK: - Reusable View Extension

extension ComicCell: ReusableView { }

// MARK: - Searchable Cell protocol

extension ComicCell: SearchableCell {
  
  func highlighted(_ query:String, in string:String, with attributes: [String: AnyObject]) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: string)
    if query != "" {
      let queryWords = query.components(separatedBy: " ") as [String]
      for queryWord in queryWords {
        if let range = string.range(of: queryWord, options: .caseInsensitive, range: nil, locale: .current) {
          let nsRange = string.nsRange(from: range)
          attributedString.setAttributes(attributes, range: nsRange)
        }
      }
    }
    return attributedString
  }
  
}

