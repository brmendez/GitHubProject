//
//  ReposViewController.swift
//  GitHubProject
//
//  Created by Brian Mendez on 10/20/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import UIKit

class ReposViewController: UIViewController {
    
    @IBOutlet weak var repoLabel: UILabel!
    
    var repoArray = [Repo]()
    var test: String?
    var networkController = NetworkController()

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = "http://localhost:3000"
        let url = NSURL(string: urlString)
        self.networkController.fetchGitHubRepo(url!, completionHandler: { (errorDescription, repos) -> (Void) in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if errorDescription == nil {
                    self.repoLabel.text = self.repoArray[0].name
                } else {
                    println("there was an error")
                }
            })
        })
//        self.repoLabel.text = repoArray[0].name
        // println(self.repoArray[0].name)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}