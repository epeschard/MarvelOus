//
//  ResultTable.swift
//  PruebaWallapop
//
//  Created by Eugène Peschard on 06/05/2017.
//  Copyright © 2017 PeschApps. All rights reserved.
//

import UIKit

protocol ResultTable: RealmTable {
  
  // SearchableCell protocol adds the query property
  associatedtype TableCell: RealmCell, ReusableView
  var query: String { get set }
  
}

extension ResultTable where Self: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> TableCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.reuseIdentifier, for: indexPath) as! TableCell
    
    cell.object = objects[indexPath.row]

    return cell
  }
  
}

//extension ResultTable where Self: UITableViewDelegate {
//
//  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let selectedObject = objects[indexPath.row]
//    performSegue(withIdentifier: DetailVC.identifier, sender: selectedObject)
//  }
//  
//}
