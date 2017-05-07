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
  
}

// MARK: - Realm Cell Extension

extension ComicCell: RealmCell {
  
  func updateUI() {
    // reset any existing information
    clearOutlets()
    tintColor = UIColor.white
    backgroundColor = UIColor.black
    
    // load new information (if any)
    if let comic = object{
      titleLabel.text = comic.title
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
  
  func clearOutlets() {
    titleLabel.text = nil
    descriptionLabel.text = nil
  }

}

// MARK: - NibLoadableView Cell Extension

extension ComicCell: NibLoadableView { }

