////
////  NetworkController.swift
////  GitHubProject
////
////  Created by Brian Mendez on 10/20/14.
////  Copyright (c) 2014 Brian Mendez. All rights reserved.


//test
import Foundation
import UIKit


enum FetchType {
    case Repos, Users, MyProfile
}


class NetworkController {
    
    var mySession : NSURLSession?
    var accessToken : String?
    let clientID = "client_id=90540d88c4b7fd51e6bb"
    let clientSecret = "client_secret=1d20b4db83c3603def8e69d49fe7697c7e0dd75f"
    let githubOAuthURL = "https://github.com/login/oauth/authorize?"
    let scope = "scope=user,repo"
    let redirectURL = "redirect_uri=GitHubProject://test"
    let githubPOSTURL = "https://github.com/login/oauth/access_token"
//    let repoGrabURL = "https://api.github.com/search/users?q="
    
    var imageQueue = NSOperationQueue()
    
    
    init (){
        if self.mySession == nil {
            if let tokenValue = NSUserDefaults.standardUserDefaults().valueForKey("MyKey") as? String {
                self.accessToken = tokenValue
                var sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                var HTTPAdditionalHeaders = ["Authorization" : "token \(self.accessToken!)"]
                sessionConfiguration.HTTPAdditionalHeaders = HTTPAdditionalHeaders
                self.mySession = NSURLSession(configuration: sessionConfiguration)
            }
        }
        
    }
    
    class var sharedInstance: NetworkController {
        struct Static {
            static var instance: NetworkController?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = NetworkController()
        }
        return Static.instance!
    }
    
    //pops out of App and directs to GitHub
    func requestOAuthAccess() {
        let url = githubOAuthURL + clientID + "&" + redirectURL + "&" + scope
        //needs UIKit
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    
    //parses token received from GitHub
    func handleOAuthURL(callbackURL : NSURL) {
        let query = callbackURL.query
        let components = query?.componentsSeparatedByString("code=")
        let code = components?.last
        
        let urlQuery = clientID + "&" + clientSecret + "&" + query!
        
        var request = NSMutableURLRequest(URL: NSURL(string: githubPOSTURL)!)
        request.HTTPMethod = "POST"
        var postData = urlQuery.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        let length = postData?.length
        request.setValue("\(length)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        
        //makes call
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println("You have an error")
            } else {
                let httpResponse = response as NSHTTPURLResponse
                switch httpResponse.statusCode {
                case 200...204:
                    var tokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
                    let response = tokenResponse as String
                    let token = response.componentsSeparatedByString("&").first?.componentsSeparatedByString("=").last
                    
                    var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                    configuration.HTTPAdditionalHeaders = ["Authorization": "token accessToken"]
                    self.mySession = NSURLSession(configuration: configuration)
                    
                    
                    NSUserDefaults.standardUserDefaults().setObject(NSString(string: token!), forKey: "OAuth")
                    NSUserDefaults.standardUserDefaults().synchronize()
                case 400...499:
                    println("Something wrong on our end")
                case 500...599:
                    println("GitHub Server Error")
                default:
                    println("Something is wrong wrong wrong")
                    
                }
            }
        })
        dataTask.resume()
    }

    func fetchGitHub(searchString: String?, type: FetchType, completionHandler: (errorDescription: String?, returnedArray: [AnyObject]) -> (Void)) {
        let session = NSURLSession.sharedSession()
        
        
        //implemented
        let searchUserURL =  "https://api.github.com/search/users?q="
        //implemented
        let searchReposURL = "https://api.github.com/search/repositories?q="
        let myProfileURL = "https://api.github.com/user"
        var cleanString : String?
        
        if searchString != nil {
            cleanString = searchString!.stringByReplacingOccurrencesOfString(" ", withString: "+", options: nil, range: nil)
        }
        var url : NSURL?
        
        switch type {
        case .Users:
            url = NSURL(string: (searchUserURL + cleanString!))?
        case .Repos:
            url = NSURL(string: (searchReposURL + cleanString!))?
        case .MyProfile:
            url = NSURL(string: "https://api.github.com/user")
        default:
            println("Wrong search type")
        }
        
        let request = NSMutableURLRequest(URL: url!)
        let token = NSUserDefaults.standardUserDefaults().objectForKey("OAuth") as String
        
        request.setValue("token " + token, forHTTPHeaderField: "Authorization")
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299:
                println("In the 200's!")
                var returnedArray : [AnyObject]?
                switch type {
                case .Repos:
                    returnedArray = Repo.parseJSONDataIntoRepo(data)
                case .Users:
                    println("in users case: \(returnedArray)")
                    returnedArray = User.parseJSONDataIntoUser(data)
                    println(data)
                default:
                    println("No parsed info returned")
                }
                //moved from outside of connection numbers
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completionHandler(errorDescription: nil, returnedArray: returnedArray!)
                })
                //we are then put on to a background queue
                
                case 400...499:
                println("This is the clients fault")
                case 500...599:
                println("This is the servers fault")
                
                default:
                println("Something bad happened")
                
                }
            }
        })
        dataTask.resume()
    }
    
    
    func downloadUserImage(selectedUser : User, completionHandler: (image : UIImage) -> (Void)) {
        self.imageQueue.addOperationWithBlock { () -> Void in
            var avatarImage : UIImage?
            
            let url = NSURL(string: selectedUser.imageURL!)
            let imageData = NSData(contentsOfURL: url!)
            avatarImage = UIImage(data: imageData!)
            selectedUser.image = avatarImage
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(image: avatarImage!)
            })
        }
    }
    
}