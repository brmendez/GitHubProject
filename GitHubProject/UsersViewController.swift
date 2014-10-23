//
//  UsersViewController.swift
//  GitHubProject
//
//  Created by Brian Mendez on 10/22/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    var userArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        searchBar.showsScopeBar = true
        searchBar.delegate = self
        
//        NetworkController.sharedInstance.fetchGitHub(searchString, type: FetchType.Users) { (errorDescription, returnedArray) -> (Void) in
//            println("In users VC!")
//            println(returnedArray)
//        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
            let selectedUser = self.userArray[indexPath.row]
        cell.githubNameLabel.text = selectedUser.name
        
        if selectedUser.image != nil {
            
        } else {
            NetworkController.sharedInstance.downloadUserImage(selectedUser, completionHandler: { (image) -> (Void) in
                let imageForCell = self.collectionView.cellForItemAtIndexPath(indexPath) as UserCell
                imageForCell.imageView.image = image
            })
        }
        
        return cell
    }
    
    //FINISH MAKING SEARCHBAR WORK
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var userSearch = searchBar.text
        
        NetworkController.sharedInstance.fetchGitHub(userSearch, type: FetchType.Users) { (errorDescription, returnedArray) -> (Void) in
            self.userArray = returnedArray as [User]
            self.collectionView.reloadData()
        }
    }
    
}