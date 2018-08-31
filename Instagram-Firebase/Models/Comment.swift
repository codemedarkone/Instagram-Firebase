//
//  Comment.swift
//  Instagram-Firebase
//
//  Created by chris  on 8/31/18.
//  Copyright © 2018 kuronuma studios. All rights reserved.
//

import Foundation

struct Comment {
    
    var user: User
    
    let text: String
    let uid: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
