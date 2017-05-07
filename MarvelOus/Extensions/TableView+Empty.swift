//
//  TableView+Empty.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 07/05/2017.
//  Copyright © 2017 Wallapop. All rights reserved.
//

import UIKit

extension UITableViewController {
  
  func blankView(with text: String) {
    //create a lable size to fit the Table View
    let messageLbl = UILabel(frame: CGRect(x: 0, y: 0,
                                           width: tableView.bounds.size.width,
                                           height: tableView.bounds.size.height))
    
    //set the message
    messageLbl.text = text
    
    messageLbl.font = UIFont.systemFont(ofSize: 19)
    messageLbl.textColor = UIColor.gray
    
    // Attributed Text
//    messageLbl.attributedText =
    
    //center the text
    messageLbl.textAlignment = .center
    //multiple lines
    messageLbl.numberOfLines = 0
    
    //auto size the text
    messageLbl.sizeToFit()
    
    //set back to label view
    tableView.backgroundView = messageLbl
    
    //no separator
    tableView.separatorStyle = .none
  }
  
  func removeBlankView() {
    tableView.backgroundView = nil
    tableView.separatorStyle = .singleLine
    tableView.reloadData()
  }
  
}
