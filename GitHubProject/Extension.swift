//
//  Extension.swift
//  GitHubProject
//
//  Created by Brian Mendez on 10/24/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import Foundation

extension String {
    
    func validateString () -> Bool {
        
        let regex = NSRegularExpression(pattern: "[^0-9a-zA-Z\n]", options: nil, error: nil)
        let match = regex?.numberOfMatchesInString(self, options: nil, range: NSRange(location: 0, length: countElements(self)))
        if match > 0 {
            return false
        }
        return true
    }
}