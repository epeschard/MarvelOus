//
//  ComicResult.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 07/05/2017.
//

import UIKit
import RealmSwift

class ComicResult: UITableViewController, ResultTable {
  
  typealias TableCell = ComicCell
  
  let realm = try! Realm()
  var objects = try! Realm().objects(TableCell.Entity.self) {
    didSet {
      tableView.reloadData()
    }
  }
  
  let cellHeight = CGFloat(63.0)
  
  // MARK: - ResultTable Protocol
  
  var query = ""
  let textForEmptyLabel = "No Comic matching search"
  
  //MARK: RunLoop
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupStyle()
  }
  
  // MARK: - Style
  
  func setupStyle() {
    // Register Cells
    tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.reuseIdentifier)
    tableView.register(UINib(nibName: TableCell.nibName, bundle: Bundle.main), forCellReuseIdentifier: TableCell.reuseIdentifier)
    
    // Table Variable Row Heights
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = cellHeight
    
    // Set dark theme
    tableView.backgroundColor = UIColor.black
    tableView.separatorColor = UIColor(white: 1.0, alpha: 0.2)
    tableView.indicatorStyle = .white
  }
  
  // MARK: - Table View Data Source
  
  override  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let rowCount = objects.count
    
    // When no data insert centered label
    if rowCount == 0 {
      blankView(with: textForEmptyLabel)
    } else {
      // Remove empty table label
      tableView.backgroundView = nil
      tableView.separatorStyle = .singleLine
    }
    
    return rowCount
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> TableCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.reuseIdentifier, for: indexPath) as! TableCell
    
    cell.query = query
    cell.object = objects[indexPath.row]
    
    // Chenge selected color
    let bgColorView = UIView()
    bgColorView.backgroundColor = UIColor.darkGray
    cell.selectedBackgroundView = bgColorView
    
    return cell
  }
  
}
