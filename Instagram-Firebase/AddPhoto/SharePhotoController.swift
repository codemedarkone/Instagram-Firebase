//
//  SharePhotoController.swift
//  Instagram-Firebase
//
//  Created by chris  on 8/17/18.
//  Copyright © 2018 kuronuma studios. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextViews()
    }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    fileprivate func setupImageAndTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 100)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leadingAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.trailingAnchor, bottom: containerView.bottomAnchor, right: containerView.trailingAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    @objc func handleShare() {
        
        guard let caption = textView.text, !caption.isEmpty  else { return }
        guard let image = selectedImage else { return }
        guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }

        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = UUID().uuidString
        
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
            
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                
                print("Failed to upload post image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to retrieve downloadURL:", err)
                    return
                }
                guard let imageUrl = downloadURL?.absoluteString else { return }
                
                print("Successfully uploaded post image:", imageUrl)
                
                self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
                
            })
        }
    }
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImage = selectedImage else { return }
        guard let caption = textView.text else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        
        let ref = userPostRef.childByAutoId()
        
        let values = ["caption": caption, "imageWidth": postImage.size.width, "imageheight": postImage.size.height, "creationDate": Date().timeIntervalSince1970, "imageUrl": imageUrl] as [String : Any]
        
        ref.updateChildValues(values) { (error, ref) in
            
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to database", error)
                return
            }
            
            print("Successfully saved post to DB")
            self.dismiss(animated: true, completion: nil)
            
            //auto refresh feed when sent to database
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
