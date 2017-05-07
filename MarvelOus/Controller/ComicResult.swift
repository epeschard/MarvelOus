//
//  ComicResult.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 07/05/2017.
//  Copyright © 2017 Wallapop. All rights reserved.
//

import UIKit
import RealmSwift

class ComicResult: UITableViewController, RealmTable {
  
  typealias TableCell = ComicCell
  
  let realm = try! Realm()
  var objects = try! Realm().objects(TableCell.Entity.self) {
    didSet {
      tableView.reloadData()
    }
  }
  
  //MARK: RunLoop
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadLocalComics()

    showRealmFileLocation()
    
    setupStyle()
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
  
  // MARK: - Style
  
  func setupStyle() {
    // Register Cells
    tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.reuseIdentifier)
    tableView.register(UINib(nibName: TableCell.nibName, bundle: Bundle.main), forCellReuseIdentifier: TableCell.reuseIdentifier)
  }
  
  // MARK: - Table View Data Source
  
  override  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return objects.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> TableCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.reuseIdentifier, for: indexPath) as! TableCell
    
    cell.object = objects[indexPath.row]
    
    return cell
  }
  
}
