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


        let splitVC = childViewControllers[0] as UISplitViewController
        splitVC.delegate = self
    }

    
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
