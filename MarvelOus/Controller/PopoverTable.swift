//
//  PopoverTable.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 07/05/2017.
//  Copyright © 2017 Wallapop. All rights reserved.
//

import UIKit

class PopoverTable: UITableViewController {
  
  var objects = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.reloadData()
  }
  
  // MARK: - TableView DataSource
  
  override  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return objects.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "popoverCell", for: indexPath)
    
    cell.textLabel?.text = objects[indexPath.row]
    cell.textLabel?.textColor = UIColor.white
    cell.backgroundColor = UIColor.black
    cell.selectionStyle = .none
    
    return cell
  }
  
  override var preferredContentSize: CGSize {
    get {
      let height = (CGFloat(44) * CGFloat(objects.count)) + CGFloat(60)
      return CGSize(width: super.preferredContentSize.width, height: height)
    }
    set { super.preferredContentSize = newValue }
  }
  
}

extension PopoverTable: Identifiable {}
