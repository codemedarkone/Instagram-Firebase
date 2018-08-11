//
//  UserProfileController.swift
//  Instagram-Firebase
//
//  Created by chris  on 8/11/18.
//  Copyright © 2018 kuronuma studios. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class UserProfileController: UICollectionViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        navigationItem.title = Auth.auth().currentUser?.uid
        
        fetchUser()
    }
    
    
    fileprivate func fetchUser() {

        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let dbRef = Database.database().reference()
        dbRef.child("users").child(uid).observe(.value, with: { (snapshot) in
            print(snapshot.value ?? "")
            
            guard let dictionary = snapshot.value  as? [String: Any] else { return }
            
            let username = dictionary["username"] as? String
            self.navigationItem.title = username
            
        }) { (error) in
            
            print("Failed to fetch user:", error)
        }
        
    }
    
    
}
