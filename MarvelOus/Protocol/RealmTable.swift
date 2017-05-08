//
//  RealmTable.swift
//  Gourmi.es
//
//  Created by Eugène Peschard on 01/04/2017.
//

import UIKit
import RealmSwift

protocol RealmTable: UITableViewDataSource, UITableViewDelegate {
  
  associatedtype TableCell: RealmCell, ReusableView
  
  var objects: Results<TableCell.Entity> { get }
  
}

extension RealmTable where Self: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return objects.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> TableCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.reuseIdentifier, for: indexPath) as! TableCell
    
    cell.object = objects[indexPath.row]

    return cell
  }
}

//extension RealmTable {
//
//  // DeletableRow
//  
//  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//    // Return false if you do not want the specified item to be editable.
//    return true
//  }
//  
//  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//    if editingStyle == .delete {
//      deleteRow(at: indexPath, in: tableView)
//    } else if editingStyle == .insert {
//      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//  }
//  
//  func deleteRow(at indexPath: IndexPath, in tableView: UITableView) {
//    let realm = try! Realm()
//    do {
//      realm.beginWrite()
//      realm.delete(objects[indexPath.row])
//      try realm.commitWrite()
//      tableView.deleteRows(at: [indexPath], with: .fade)
//    } catch {
//      print(error.localizedDescription)
//    }
//  }
//  
//}
