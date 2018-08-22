//
//  FirebaseUtils.swift
//  Instagram-Firebase
//
//  Created by chris  on 8/22/18.
//  Copyright © 2018 kuronuma studios. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    static func fetchUserWithUid(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
            
            //            self.fetchPostsWithUser(user: user)
            
        }) { (err) in
            print("failed to fetch user:", err)
        }
        
    }
}
