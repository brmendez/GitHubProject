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
        cell.textLabel?.text = self.repoArray[indexPath.row].name
        
        return cell
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var userSearch = searchBar.text
        NetworkController.sharedInstance.fetchGitHubRepo(userSearch) { (errorDescription, repos) -> (Void) in
            self.repoArray = repos
            self.tableView.reloadData()
        }
    }
    
}
