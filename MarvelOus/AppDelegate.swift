//
//  AppDelegate.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 05/05/2017.
//

import UIKit

// convenient global variable for app's tintColor
let marvelRed = UIColor(red:0.93, green:0.10, blue:0.16, alpha:1.00)

// Cutom Fonts
let headlineFont = UIFont(descriptor: UIFontDescriptor.preferredCustomFontDesciptor(for: .headline), size: 0)
let subheadlineFont = UIFont(descriptor: UIFontDescriptor.preferredCustomFontDesciptor(for: .subheadline), size: 0)
let bodyFont = UIFont(descriptor: UIFontDescriptor.preferredCustomFontDesciptor(for: .body), size: 0)
let footnoteFont = UIFont(descriptor: UIFontDescriptor.preferredCustomFontDesciptor(for: .footnote), size: 0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  // Add displayMode button as left barButton item
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    // Change Navigation bar font
    let navigationBarAppearace = UINavigationBar.appearance()
    navigationBarAppearace.titleTextAttributes = [NSFontAttributeName: subheadlineFont]
    let barButtonsAppearance = UIBarButtonItem.appearance()
    barButtonsAppearance.setTitleTextAttributes([NSFontAttributeName: subheadlineFont], for: .normal)
    // Change Search field font
    if #available(iOS 9.0, *) {
      UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSFontAttributeName: UIFont(name: "Marvel-Regular", size: 15)!]
    } else {
      // Fallback on earlier versions
    }
    
    // Customize SplitViewController
    let splitViewController = self.window!.rootViewController as! UISplitViewController
    let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
    navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
    return true
  }

}

// MARK: - Split View Controller Delegate

extension AppDelegate: UISplitViewControllerDelegate {
  
  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
//    guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
//    guard let topAsDetailController = secondaryAsNavController.topViewController as? ComicDetails else { return true }
//    if topAsDetailController.object != nil {
//      // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
//      return false
//    }
//    return true
    
    // Never segue automatically to DetailView
    return true
  }
  
}
