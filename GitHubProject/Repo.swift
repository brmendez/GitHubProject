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
    
    init (name: String) {
        self.name = name
    }
    
    
    class func parseJSONDataIntoRepo(rawJSONData : NSData) -> [Repo] {
        var error : NSError?
        
        var repoArray = [Repo]()

        if let JSONDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSDictionary {

            
            if let itemsArray = JSONDictionary["items"] as? NSArray{
            
                for objectInArray in itemsArray {
                    
                    var tempName = objectInArray["name"] as String
                    var newRepoObject = Repo(name: tempName)
                    repoArray.append(newRepoObject)
                }
                
            }
        }
        return repoArray
    }
}