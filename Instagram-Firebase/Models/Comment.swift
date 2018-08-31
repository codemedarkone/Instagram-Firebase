//
//  Comment.swift
//  Instagram-Firebase
//
//  Created by chris  on 8/31/18.
//  Copyright © 2018 kuronuma studios. All rights reserved.
//

import Foundation

struct Comment {
    
    let text: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
