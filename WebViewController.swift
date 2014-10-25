//
//  WebViewController.swift
//  GitHubProject
//
//  Created by Brian Mendez on 10/24/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    let webView = WKWebView()
    var repo : Repo?
    
    
    override func loadView() {
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "\(self.repo!.userReposURL)" )!))
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}