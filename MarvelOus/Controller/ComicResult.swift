//
//  ComicResult.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 07/05/2017.
//  Copyright © 2017 Wallapop. All rights reserved.
//

import UIKit
import RealmSwift

class ComicResult: UITableViewController {
  
  //MARK: RunLoop
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadLocalComics()
    
    showRealmFileLocation()
  }
  
  func loadLocalComics() {
    if let path = Bundle.main.path(forResource: "Comics", ofType: "json") {
      do {
        let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        if let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] {
          try Comic.create(from: jsonResult)
        }
      } catch { print(error.localizedDescription) }
    }
  }
  
  func showRealmFileLocation() {
    let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
    print(defaultURL)
  }
  
}
