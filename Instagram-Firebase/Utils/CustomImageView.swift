//
//  CustomImageView.swift
//  Instagram-Firebase
//
//  Created by chris  on 8/21/18.
//  Copyright © 2018 kuronuma studios. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    var lastUrlUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        print("laoding image")
        
        lastUrlUsedToLoadImage = urlString
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("failed to fetch the image:", error)
                return
            }
            
//          //iamges load from incorrect urls----This prevents duplicate images on the cells
            if url.absoluteString != self.lastUrlUsedToLoadImage  {
                return
            }
            
            guard let imageData = data else { return }
            
            let photoImage = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            }.resume()
    }
}
