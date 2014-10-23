//
//  User.swift
//  GitHubProject
//
//  Created by Brian Mendez on 10/22/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var name : String?
    var imageURL : String?
    var image : UIImage?
    
    init (name: String, imageURL: String) {
        self.name = name
        self.imageURL = imageURL
    }
    
    class func parseJSONDataIntoUser(rawJSONData : NSData) -> [User]? {
        var error : NSError?
        
        var userArray = [User]()
        
        if let JSONDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSDictionary {
            
            if let itemsArray = JSONDictionary["items"] as? NSArray {
                
                for objectInArray in itemsArray {
                    if let userDictionary = objectInArray as? NSDictionary {
                        
                        var userName = objectInArray["login"] as String
                        var userImage = objectInArray["avatar_url"] as String
        
                        var newUserObject = User(name: userName, imageURL: userImage)
                        userArray.append(newUserObject)
                    }
                }
            }
            return userArray
        }
        return nil
    }
}


