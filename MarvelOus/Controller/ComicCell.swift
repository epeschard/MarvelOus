//
//  ComicCell.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 06/05/2017.
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
      
      // greyout labels and highlight query during search
      if query != "" {
        grayoutLabels()
        let tint: [String: AnyObject] = [NSForegroundColorAttributeName : marvelRed]
        titleLabel.attributedText = highlighted(query, in: title, with: tint)
      } else {
        titleLabel.text = comic.title
      }
      descriptionLabel.text = comic.format
      
      // images are added and stored in Realm after first JSON download
      if let nsData = comic.thumbnail?.data {
        iconImageView.image = UIImage(data: nsData as Data)
      } else if let thumbnail = comic.thumbnail {
        // we haven't sored the image's data so use placeholder while we fetch it
        iconImageView.image = UIImage(named: "placeholder")
        // Fetch Image from MARVAL's api
        MarvelAPI().getData(for: thumbnail, from: thumbnail.path, completionHandler: {
          // avoid memory cycles using weak self in closures
          [weak weakSelf = self]
          response in
          switch response.result {
          case .success:
            do {
              let data = try response.result.unwrap()
              // update the cell's image with the data
              weakSelf?.iconImageView.image = UIImage(data: data)
              // store data in Realm for next time
              comic.thumbnail?.data = data as NSData
            } catch {
              print(error.localizedDescription)
            }
          case .failure(let error):
            // no need to interrupt user if we fail to get image, we have the placeholder
            print(error.localizedDescription)
          }
        })
      }
    }
  }
  
  func setFonts() {
    // this will be used for custom fonts
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
  }
  
  func clearOutlets() {
    // avoid having unclean data for reused cells
    titleLabel.text = nil
    descriptionLabel.text = nil
  }

  func grayoutLabels() {
    // change colors to dim everything that's not highlightes during search
    titleLabel.textColor = UIColor.lightGray
    descriptionLabel.textColor = UIColor.gray
  }
  
}

// protocol extensions are used to add properties for Xib, Cell and segue identifiers
// MARK: - NibLoadableView Cell Extension

extension ComicCell: NibLoadableView { }

// MARK: - Reusable View Extension

extension ComicCell: ReusableView { }

// MARK: - Searchable Cell protocol

extension ComicCell: SearchableCell {
  
  // convenience function to highlight query during search
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

