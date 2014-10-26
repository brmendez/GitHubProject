//
//  ProfileViewController.swift
//  GitHubProject
//
//  Created by Brian Mendez on 10/25/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var image : UIImage?
    var returnUser : User!
    var myProfile : User?
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NetworkController.sharedInstance.fetchGitHub(nil, type: FetchType.MyProfile) { (errorDescription, returnedArray) -> (Void) in
            self.returnUser = returnedArray[0] as User
            self.imageView.image = self.returnUser.image
        }

        // Do any additional setup after loading the view.
    }

}
