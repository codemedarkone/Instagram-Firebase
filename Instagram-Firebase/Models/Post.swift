//
//  Post.swift
//  Instagram-Firebase
//
//  Created by chris  on 8/19/18.
//  Copyright © 2018 kuronuma studios. All rights reserved.
//

import Foundation

struct Post {
    
    let imageUrl: String
    
    init(dictionary: [String: Any]) {
        
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}


