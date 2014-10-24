//
//  UsersViewController.swift
//  GitHubProject
//
//  Created by Brian Mendez on 10/22/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    var origin : CGRect?
    var imageView : UIImageView?
    var networkController : NetworkController!
    
    var userArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        self.navigationController?.delegate = appDelegate
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        searchBar.showsScopeBar = true
        searchBar.delegate = self
        
    }
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.delegate = self
//
//    }
    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.delegate = nil
//    }
    
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
                if let imageForCell = self.collectionView.cellForItemAtIndexPath(indexPath) as? UserCell {
                    imageForCell.imageView.image = image
                }
            })
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedUser = self.userArray[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserDetailViewController") as UserDetailViewController
        let attributes = collectionView.layoutAttributesForItemAtIndexPath(indexPath)
        let origin = self.view.convertRect(attributes!.frame, fromView: collectionView)
        self.origin = origin
        viewController.image = selectedUser.image
        viewController.reverseOrigin = self.origin!

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //FINISH MAKING SEARCHBAR WORK
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var userSearch = searchBar.text

        
        NetworkController.sharedInstance.fetchGitHub(userSearch, type: FetchType.Users) { (errorDescription, returnedArray) -> (Void) in
            self.userArray = returnedArray as [User]
            self.collectionView.reloadData()
        }
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return text.validateString()
    }
    
}