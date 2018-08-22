//
//  User.swift
//  Instagram-Firebase
//
//  Created by chris  on 8/21/18.
//  Copyright © 2018 kuronuma studios. All rights reserved.
//

import Foundation


struct User {
    
    let uid: String
    let username:String
    let profileImageUrl:String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileUrl"] as? String ?? ""
    }
}
