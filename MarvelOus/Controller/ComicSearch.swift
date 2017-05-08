//
//  ComicSearch.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 07/05/2017.
//

import UIKit
import RealmSwift

class ComicSearch: UITableViewController, SearchTable {
  
  typealias TableCell = ComicCell
  typealias DetailVC = ComicDetails
  var detailView: DetailVC?
  
  let cellHeight = CGFloat(100.0)
  
  // MARK: - RealmTable protocol
  
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
    
    // Only load JSON on first launch
    if !UserDefaults.standard.bool(forKey: "savedLocal") {
      // Load local copy first for better UX
      MarvelAPI.loadLocalComics()
      
      // Download comics from MARVEL
      MarvelAPI().download(.comics, first: 100, startingFrom: 0) {
        // avoid memory cycles using weak self in closures
        [weak weakSelf = self]
        response in
        
        switch response.result {
        case .success:
          weakSelf?.tableView.reloadData()
        case .failure(let error):
          // we will notify the user that we failed to get new data from MARVEL
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
    }
    
    setupStyle()
    
    // Search Results
    resultController = ResultVC()
    setupSearchControllerWith(resultController!)
    if #available(iOS 9.0, *) {
      searchController?.loadViewIfNeeded()
    } else {
      // Include fallback for earlier versions
    }
    
    // Add displayMode as left bar button item on detailView
    if let split = self.splitViewController {
      let controllers = split.viewControllers
      detailView = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailVC
      
      split.navigationItem.leftBarButtonItem = split.displayModeButtonItem
      split.delegate = self
      // avoid closing master on iPad portrait for example
      split.preferredDisplayMode = .allVisible
    }
    
    // Avoid having ComicDetail with no selection
    if splitViewController?.displayMode == .allVisible {
      let firstIndexPath = IndexPath(row: 0, section: 0)
      self.tableView.selectRow(at: firstIndexPath, animated: true, scrollPosition: .none)
      select(rowAt: firstIndexPath)
    }
  }
  
  // MARK: - Style
  
  func setupStyle() {
    // register Comic cell from nib to use it on both Search & Result's tables
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
    
    // Change selected color default is too light
    let bgColorView = UIView()
    bgColorView.backgroundColor = UIColor.darkGray
    cell.selectedBackgroundView = bgColorView
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    select(rowAt: indexPath)
  }
  
  // function to be used by tableView:didSelectRowAt & auto selection
  func select(rowAt indexPath: IndexPath) {
    if splitViewController?.viewControllers.count == 1 {
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // handle selection for both search and resuls tebles
    if tableView == resultController?.tableView {
      performSegue(withIdentifier: DetailVC.identifier, sender: resultController?.objects[indexPath.row])
    } else {
      performSegue(withIdentifier: DetailVC.identifier, sender: objects[indexPath.row])
    }
  }
  
  // MARK: - Table View Delegate
  // No real need to delete rows since these will regenerate from MARVEL fetch
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      deleteRow(at: indexPath)
    } else if editingStyle == .insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
  }
  
  func deleteRow(at indexPath: IndexPath)
  {
    do {
      let realm = try! Realm()
      realm.beginWrite()
      realm.delete(objects[indexPath.row])
      try realm.commitWrite()
      tableView.deleteRows(at: [indexPath], with: .fade)
    } catch {
      print(error.localizedDescription)
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
  
  // unwind segue from attribution with animated card UI
  @IBAction func closeCard(segue:UIStoryboardSegue) {
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
    
    // Use scope buttons to change the search results
//    resultsTable.objects = objects.filter(finalCompoundPredicate)
    switch searchController.searchBar.selectedScopeButtonIndex {
    case 0: // Search Comics only
      objects = objects.filter("format == %@", "Comic")
      resultsTable.objects = objects.filter(finalCompoundPredicate)
    case 1: // Search all, digital and Infinite too
      resultsTable.objects = try! Realm().objects(TableCell.Entity.self).filter(finalCompoundPredicate)
    default:
      resultsTable.objects = try! Realm().objects(TableCell.Entity.self).filter(finalCompoundPredicate)
    }
    resultsTable.tableView.reloadData()
  }
  
  func setupSearchControllerWith(_ results: ResultVC) {
    // Register Cells
    results.tableView.register(TableCell.self, forCellReuseIdentifier: "\(TableCell.self)")
    results.tableView.register(UINib(nibName: "\(TableCell.self)", bundle: Bundle.main), forCellReuseIdentifier: "\(TableCell.self)")
    
    // Cell Height
    results.tableView.estimatedRowHeight = cellHeight
    results.tableView.rowHeight = UITableViewAutomaticDimension
    
    // We want to be the delegate for our filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
    results.tableView.delegate = self
    
    searchController = UISearchController(searchResultsController: results)
    
    // Set Scope Bar Buttons
    searchController.searchBar.scopeButtonTitles = ["Comics only", "Digital too"]
    
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
  
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    updateSearchResults(for: searchController)
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
