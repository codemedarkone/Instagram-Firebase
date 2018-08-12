//
//  UserProfileHeader.swift
//  Instagram-Firebase
//
//  Created by chris  on 8/11/18.
//  Copyright © 2018 kuronuma studios. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet {
            setupProfileImage()
            
            usernameLabel.text = user?.username
        }
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        label.text = "11\nposts"
        label.textAlignment = .center
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "11\nposts"
        label.textAlignment = .center
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.text = "11\nposts"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    

        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leadingAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
     
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        
        setupBottomToolbar()
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leadingAnchor, bottom: gridButton.topAnchor, right: trailingAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: -12, width: 0, height: 0)
        
        setupUserStatsView()
    }
    
    fileprivate func setupUserStatsView() {
    
        let stackView = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileImageView.trailingAnchor, bottom: nil, right: trailingAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: -12, width: 0, height: 50)
    }
    
    fileprivate func setupBottomToolbar(){
        let stackview = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        
        
        addSubview(stackview)
        stackview.anchor(top: nil, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
    }
    

    
    fileprivate func setupProfileImage() {
        
        guard let profileUrl = user?.profileUrl else { return }
        guard let url = URL(string: profileUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            //check for error then construct image using data
            if let error = error {
                print("Failed to fetch profile Image:", error)
                return
            }
            
            // perhaps check response status of 200 (HTTP OK)
            
            guard let data = data else { return }
            let image = UIImage(data: data)
            
            //need to get back onto the main UI thread to show UI update
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
            
            
            }.resume()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
