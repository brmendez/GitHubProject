//
//  UserDetailViewController.swift
//  GitHubProject
//
//  Created by Brian Mendez on 10/23/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    //needed to create this to catch the imageview from UsersViewController
    var image : UIImage?
    var reverseOrigin : CGRect?
    
    @IBOutlet var imageView: UIImageView!
    
    //outlets aren't instantiated until VIEWDIDLOAD. If set prior, will crash
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
