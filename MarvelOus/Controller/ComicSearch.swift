//
//  ComicSearch.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 07/05/2017.
//  Copyright © 2017 Wallapop. All rights reserved.
//

import UIKit
import RealmSwift

class ComicSearch: UITableViewController, SearchTable {
  
  typealias TableCell = ComicCell
  typealias DetailVC = ComicDetails
  var detailView: DetailVC?
  
  let cellHeight = CGFloat(100.0)
  
  // MARK: - RealmTable protocol
  //  @IBOutlet tableView: UITableView!
  
  var objects = try! Realm().objects(TableCell.Entity.self) {
    didSet {
      tableView.reloadData()
    }
  }
  
  // MARK: - SearchTable protocol
  
  typealias ResultVC = ComicResult
  var searchKeyPaths = ["title"]
  var searchController: UISearchController!
  var resultController: ResultVC?
  
  // MARK: - RunLoop
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Load local copy first for better UX
    MarvelAPI.loadLocalComics()
    // Download comics from MARVEL
    MarvelAPI().download(.comics, first: 100, startingFrom: 0) {
      [weak weakSelf = self]
      response in
      
      switch response.result {
      case .success:
        weakSelf?.tableView.reloadData()
      case .failure(let error):
        let alert = UIAlertController(title: "Download Failed",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let defaultButton = UIAlertAction(title: "OK",
                                          style: .default) {(_) in
                                            // your defaultButton action goes here
        }
        
        alert.addAction(defaultButton)
        weakSelf?.present(alert, animated: true)
      }
      
    }
    
    setupStyle()
    
    // Search Results
    resultController = ResultVC()
    setupSearchControllerWith(resultController!)
    if #available(iOS 9.0, *) {
      searchController?.loadViewIfNeeded()
    } else {
      // Fallback on earlier versions
    }
    
    // Split View Controller
    if let split = self.splitViewController {
      let controllers = split.viewControllers
      detailView = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailVC
      
      split.navigationItem.leftBarButtonItem = split.displayModeButtonItem
      split.delegate = self
      split.preferredDisplayMode = .allVisible
    }
    
    // Avoid haing ComicDetail with no selection
    if splitViewController?.displayMode == .allVisible {
//    if UIDevice.current.userInterfaceIdiom == .pad {
      let firstIndexPath = IndexPath(row: 0, section: 0)
      self.tableView.selectRow(at: firstIndexPath, animated: true, scrollPosition: .none)
      select(rowAt: firstIndexPath)
    }
  }
  
  // MARK: - Style
  
  func setupStyle() {
    tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.reuseIdentifier)
    tableView.register(UINib(nibName: TableCell.nibName, bundle: Bundle.main), forCellReuseIdentifier: TableCell.reuseIdentifier)
    
    // Table Variable Row Heights
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = cellHeight
    
    // Set image as navigation bar title
    let imageView = UIImageView(image: UIImage(named: "MarvelHeader"))
    imageView.contentMode = .scaleAspectFit
    navigationItem.titleView = imageView
    
    // Set dark theme
    tableView.backgroundView = UIView()
    tableView.backgroundColor = UIColor.black
    tableView.separatorColor = UIColor(white: 1.0, alpha: 0.2)
    tableView.indicatorStyle = .white
    
    UIApplication.shared.statusBarStyle = .lightContent
  }
  
  // MARK: - TableView DataSource
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return objects.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> TableCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "\(TableCell.self)") as! TableCell
    cell.object = objects[indexPath.row]
    
    // Chenge selected color
    let bgColorView = UIView()
    bgColorView.backgroundColor = UIColor.darkGray
    cell.selectedBackgroundView = bgColorView
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    select(rowAt: indexPath)
  }
  
  func select(rowAt indexPath: IndexPath) {
    if splitViewController?.viewControllers.count == 1 {
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    if tableView == resultController?.tableView {
      performSegue(withIdentifier: DetailVC.identifier, sender: resultController?.objects[indexPath.row])
    } else {
      performSegue(withIdentifier: DetailVC.identifier, sender: objects[indexPath.row])
    }
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == DetailVC.identifier,
      let object = sender as? TableCell.Entity {
      let controller = (segue.destination as! UINavigationController).topViewController as! DetailVC
      controller.object = object
      controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
      controller.navigationItem.leftItemsSupplementBackButton = true
    }
  }
  
}

// MARK: - UISearchResultsUpdating

extension ComicSearch: UISearchResultsUpdating,
  UISearchControllerDelegate,
  UISearchBarDelegate   {
  
  
  func updateSearchResults(for searchController: UISearchController) {
    
    // Strip out all the leading and trailing spaces.
    let whitespaceCharacterSet = CharacterSet.whitespaces
    let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
    let searchItems = strippedString.components(separatedBy: " ") as [String]
    
    // Build all the "OR" expressions for each value in the searchString.
    var orMatchPredicates = [NSPredicate]()
    
    for searchString in searchItems {
      var searchItemsPredicate = [NSPredicate]()
      if searchString != "" {
        // Name field matching
        for searchKeyPath in searchKeyPaths {
          let lhs = NSExpression(forKeyPath: searchKeyPath)
          let rhs = NSExpression(forConstantValue: searchString)
          let finalPredicate = NSComparisonPredicate(
            leftExpression: lhs,
            rightExpression: rhs,
            modifier: .direct,
            type: .contains,
            options: .caseInsensitive)
          searchItemsPredicate.append(finalPredicate)
        }
      }
      // Add this OR predicate to our master predicate.
      let orSearchItemsPredicates = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
      orMatchPredicates.append(orSearchItemsPredicates)
    }
    
    // Match up the fields of the Product object.
    let finalCompoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates:orMatchPredicates)
    
    let resultsTable = searchController.searchResultsController as! ResultVC
    resultsTable.query = searchController.searchBar.text!
    resultsTable.objects = objects.filter(finalCompoundPredicate)
  }
  
  func setupSearchControllerWith(_ results: ResultVC) {
    // Register Cells
    results.tableView.register(TableCell.self, forCellReuseIdentifier: "\(TableCell.self)")
    results.tableView.register(UINib(nibName: "\(TableCell.self)", bundle: Bundle.main), forCellReuseIdentifier: "\(TableCell.self)")
    
    // Cell Height
    results.tableView.estimatedRowHeight = cellHeight
    results.tableView.rowHeight = UITableViewAutomaticDimension
//    results.textForEmptyLabel = textForEmptyLabel
    
    // We want to be the delegate for our filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
    results.tableView.delegate = self
    
    searchController = UISearchController(searchResultsController: results)
    
    // Set Scope Bar Buttons
    searchController.searchBar.scopeButtonTitles = ["Comics", "All"]
    
    // Set Search Bar
    searchController.searchResultsUpdater = self
    searchController.searchBar.sizeToFit()
    tableView.tableHeaderView = searchController.searchBar
    
    // Set delegates
    searchController.delegate = self
    searchController.searchBar.delegate = self    // so we can monitor text changes + others
    
    // Configure Interface
    searchController.dimsBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = true
    if #available(iOS 9.1, *) {
      searchController.obscuresBackgroundDuringPresentation = false
    }
    searchController.searchBar.tintColor = marvelRed
    searchController.searchBar.barTintColor = UIColor.black
    searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.dark
    
    // Search is now just presenting a view controller. As such, normal view controller
    // presentation semantics apply. Namely that presentation will walk up the view controller
    // hierarchy until it finds the root view controller or one that defines a presentation context.
    definesPresentationContext = true
  }

}

// MARK: - Split View Controller Delegate

extension ComicSearch: UISplitViewControllerDelegate {
  
  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
    guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
    guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailVC else { return false }
    if topAsDetailController.object == nil {
      // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
      return true
    }
    return false
  }
  
}
