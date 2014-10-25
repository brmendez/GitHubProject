//
//  ReposViewController.swift
//  GitHubProject
//
//  Created by Brian Mendez on 10/20/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import UIKit

class ReposViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var networkController = NetworkController()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var url : NSURL?
    
    var repoArray = [Repo]()
    var test: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.showsScopeBar = true
        searchBar.delegate = self
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repoArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("REPO_CELL", forIndexPath: indexPath) as UITableViewCell
        let repo = self.repoArray[indexPath.row]
        cell.textLabel?.text = repo.name
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let webViewController = self.storyboard?.instantiateViewControllerWithIdentifier("WEB_VIEW") as WebViewController
        let cell = tableView.dequeueReusableCellWithIdentifier("REPO_CELL", forIndexPath: indexPath) as UITableViewCell
//        let selectedRepo = self.repoArray[indexPath.row]
        webViewController.repo = self.repoArray[indexPath.row]
        
        
        
        self.navigationController?.pushViewController(webViewController, animated: true)
        
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var userSearch = searchBar.text
        
        NetworkController.sharedInstance.fetchGitHub(userSearch, type: FetchType.Repos) { (errorDescription, returnedArray) -> (Void) in
            println("In repos VC!")
            self.repoArray = returnedArray as [Repo]
            self.tableView.reloadData()
        }
        
//        NetworkController.sharedInstance.fetchGitHub(userSearch) { (errorDescription, repos) -> (Void) in
//            self.repoArray = repos
//            self.tableView.reloadData()
//        }
    }
}
