////
////  NetworkController.swift
////  GitHubProject
////
////  Created by Brian Mendez on 10/20/14.
////  Copyright (c) 2014 Brian Mendez. All rights reserved.


import Foundation

class NetworkController {
    
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
    
    func fetchGitHubRepo(url: NSURL, completionHandler: (errorDescription: String?, repos: [Repo]?) -> (Void)) {
        let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
//            println(data)
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299:
                    //returns an array of Repo objects from parseJSONData
                let parsedArray = Repo.parseJSONDataIntoRepo(data)
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completionHandler(errorDescription: nil, repos: parsedArray)
                    //println("InFetchedGitHUbRepo \(parsedArray![0].name)")
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
}