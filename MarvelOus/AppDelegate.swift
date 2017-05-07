//
//  AppDelegate.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 05/05/2017.
//  Copyright © 2017 Wallapop. All rights reserved.
//

import UIKit

let marvelRed = UIColor(red:0.93, green:0.10, blue:0.16, alpha:1.00)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
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
    //    if topAsDetailController.locations.count == 0 {
    //      // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
    //      return false
    //    }
    //    return true
    
    // Never segue automatically to DetailView
    return true
  }
  
}
