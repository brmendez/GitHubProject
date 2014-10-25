//
//  Repo.swift
//  GitHubProject
//
//  Created by Brian Mendez on 10/20/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import Foundation
import UIKit

class Repo {
    
    var name : String
    var userReposURL : String
    
    init (name: String, userRepoURL: String) {
        self.name = name
        self.userReposURL = userRepoURL
    }
    
    class func parseJSONDataIntoRepo(rawJSONData : NSData) -> [Repo] {
        var error : NSError?
        
        var repoArray = [Repo]()

        if let JSONDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSDictionary {

            
            if let itemsArray = JSONDictionary["items"] as? NSArray{
            
                for objectInArray in itemsArray {
                    
                    var tempName = objectInArray["name"] as String
                    var repoURL = objectInArray["html_url"] as String
                    println(repoURL)
                    var newRepoObject = Repo(name: tempName, userRepoURL: repoURL)
                    repoArray.append(newRepoObject)
                }
                
            }
        }
        return repoArray
    }
    
//    class func parseJSONDataForWebview(rawJSONData : NSData) -> [Repo] {
//        var error : NSError?
//        
//        var repoArray = [Repo]()
//        
//        if let itemsArray = JSONDictionary["items"] as? NSArray {
//            
//            for objectInArray in itemsArray["repos_url"] as String
//            var newRepoObject = Repo(name: NSURL(string: <#String#>))
//        }
//    }
    
    
}