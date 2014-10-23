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
    
    var userArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println()
        
        
        
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.navigationController?.delegate = self
        
        searchBar.showsScopeBar = true
        searchBar.delegate = self
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.delegate = nil
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
//            self.splitViewController?.showDetailViewController(viewController, sender: self)
    }
    
    //FINISH MAKING SEARCHBAR WORK
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var userSearch = searchBar.text
        
        NetworkController.sharedInstance.fetchGitHub(userSearch, type: FetchType.Users) { (errorDescription, returnedArray) -> (Void) in
            self.userArray = returnedArray as [User]
            self.collectionView.reloadData()
        }
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // This is called whenever during all navigation operations
        
        // Only return a custom animator for two view controller types
        if let mainViewController = fromVC as? UsersViewController {
            let animator = ShowImageAnimator()
            animator.origin = mainViewController.origin
            
            return animator
        }
        else if let imageViewController = fromVC as? UserDetailViewController {
            let animator = HideImageAnimator()
            animator.origin = imageViewController.reverseOrigin
            
            return animator
        }
        
        // All other types use default transition
        return nil
    }
    
}