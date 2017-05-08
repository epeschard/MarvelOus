//
//  SearchTable.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 06/05/2017.
//

import UIKit

protocol SearchTable: RealmTable {
  
  associatedtype ResultVC: ResultTable
  
  //  var query: String { get set }
  var searchKeyPaths: [String] { get }
  var searchController: UISearchController! { get }
  var resultController: ResultVC? { get }
  
}

//extension SearchTable where Self: UITableViewDelegate {
//  
//  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////    if splitViewController?.viewControllers.count == 1 {
////      tableView.deselectRow(at: indexPath, animated: true)
////    }
//    
//    if tableView == resultController?.tableView {
//      performSegue(withIdentifier: "\(DetailVC.self)", sender: resultController?.objects[indexPath.row])
//    } else {
//      performSegue(withIdentifier: "\(DetailVC.self)", sender: objects[indexPath.row])
//    }
//  }
//  
//}
