//
//  SplitViewController.swift
//  GitHubProject
//
//  Created by Brian Mendez on 10/20/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import UIKit

class SplitViewContainerController: UIViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let splitVC = childViewControllers.first as UISplitViewController
        splitVC.delegate = self
        
        if NSUserDefaults.standardUserDefaults().objectForKey("OAuth") == nil {
            NetworkController.sharedInstance.requestOAuthAccess()
        }
        
    }
    
    //chooses with tableview shows up first. True reveals the container that was EMBEDDED first.
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
    }

}