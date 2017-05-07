//
//  ComicDetails.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 07/05/2017.
//  Copyright © 2017 Wallapop. All rights reserved.
//

import UIKit
import RealmSwift

class ComicDetails: UITableViewController {
  
  let realm = try! Realm()
  var object: Comic? {
    willSet {
      if view != nil {
        if let venue = newValue {
          updateLabels(with: venue)
        }
//        tableView.reloadData()
      }
    }
  }
  let formatter = NumberFormatter()
  
  // MARK: - Labels & Image Outlets
  
  @IBOutlet weak var thumbnail: UIImageView!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var formatLabel: UILabel!
  @IBOutlet weak var priceType: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var characterLabel: UILabel!
  @IBOutlet weak var creatorLabel: UILabel!
  @IBOutlet weak var variantsLabel: UILabel!
  @IBOutlet weak var datesLabel: UILabel!
  @IBOutlet weak var pagesLabel: UILabel!
  @IBOutlet weak var issueNumberLabel: UILabel!
  @IBOutlet weak var eanLabel: UILabel!
  @IBOutlet weak var upcLabel: UILabel!
  
  // MARK: - TableViewCell Heights
  
  var charactersHeight = UITableViewAutomaticDimension
  var creatorsHeight = UITableViewAutomaticDimension
  var variantsHeight = UITableViewAutomaticDimension
  var datesHeight = UITableViewAutomaticDimension
  var priceHeight = UITableViewAutomaticDimension
  var formatHeight = UITableViewAutomaticDimension
  var issueHeight = UITableViewAutomaticDimension
  var pagesHeight = UITableViewAutomaticDimension
  var eanHeight = UITableViewAutomaticDimension
  var upcHeight = UITableViewAutomaticDimension
  
  // MARK: - Run Loop
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupStyle()
  }
  
  func updateLabels(with object: Comic) {
    
    if let nsData = object.thumbnail?.bigData {
      thumbnail.image = UIImage(data: nsData as Data)
    } else {
      thumbnail.image = UIImage(named: "placeholder")
    }
    
    if let title = object.title {
      titleLabel.text = title
    }
    
    if let description = object.desc {
      descriptionLabel.text = description
    }
    
    if let charactersCount = object.characters?.returned {
      characterLabel.text = String(describing: charactersCount)
      if charactersCount == 0 {
        charactersHeight = CGFloat(0)
      }
    }
    
    if let creatorsCount = object.creators?.returned {
      creatorLabel.text = String(describing: creatorsCount)
      if creatorsCount == 0 {
        creatorsHeight = CGFloat(0)
      }
    }
    
    variantsLabel.text = String(describing: object.variants.count)
    if object.variants.count == 0 {
      variantsHeight = CGFloat(0)
    }
    
    datesLabel.text = String(describing: object.dates.count)
    if object.dates.count == 0 {
      datesHeight = CGFloat(0)
    }
    
    for tag in Array(object.prices) {
      priceType.text = tag.type
      let price = NSNumber(value: tag.price)
      priceLabel.text = formatter.string(from: price)
    }
    
    if let format = object.format {
      formatLabel.text = format
    } else { formatHeight = CGFloat(0) }
    
    issueNumberLabel.text = String(describing: object.issueNumber)
    if object.issueNumber == 0 {
      issueHeight = CGFloat(0)
    }
    
    pagesLabel.text = String(describing: object.pageCount)
    if object.pageCount == 0 {
      pagesHeight = CGFloat(0)
    }
    
    if let ean = object.ean,
      ean != "" {
      eanLabel.text = ean
    } else { eanHeight = CGFloat(0) }
    
    if let upc = object.upc,
      upc != "" {
      upcLabel.text = upc
    } else { upcHeight = CGFloat(0) }
    
  }
  
  // MARK: - Style
  
  func setupStyle() {
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.view.backgroundColor = .clear
    
    // Table Variable Row Heights
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 240
    
    // Set dark theme
    tableView.backgroundColor = UIColor.black
    tableView.separatorColor = UIColor(white: 1.0, alpha: 0.2)
    tableView.indicatorStyle = .white
    
    // Price formatter
    formatter.numberStyle = .currency
    formatter.currencyCode = "USD"
  }
  
  // MARK: - TableView Delegate
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    switch indexPath.row {
    case 0: // Image
      return CGFloat(450)
    case 1: // Title
      return UITableViewAutomaticDimension
    case 2: // Description
      return UITableViewAutomaticDimension
      
    case 3: // Characters
      return charactersHeight
    case 4: // Creators
      return creatorsHeight
    case 5: // Variants
      return variantsHeight
    case 6: // Dates
      return datesHeight
      
    case 7: // Price
      return priceHeight
    case 8: // Format
      return formatHeight
    case 9: // Issue
      return issueHeight
    case 10: // Pages
      return pagesHeight
    case 11: // EAN
      return eanHeight
    case 12: // UPC
      return upcHeight
      
    default:
      return UITableViewAutomaticDimension
    }
  }
}

// Make ComicDetails comply to Identifiable protocol to get class name as segueId
extension ComicDetails: Identifiable { }
