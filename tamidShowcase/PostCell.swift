//
//  PostCell.swift
//  tamidShowcase
//
//  Created by H on 5/31/16.
//  Copyright © 2016 H. All rights reserved.
//

import UIKit
import Alamofire //error (ignore), build succeeds

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    var request: Request?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func drawRect(rect: CGRect) {
        
        // after profile image has frame and size, make it circular
        
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        
        // keep the profile img and showcase img encased within borders
        
        profileImg.clipsToBounds = true
        showcaseImg.clipsToBounds  = true
        
    }
    
    func configureCell(post: Post, img: UIImage?) {
        
        self.post = post
        self.descriptionText.text = post.postDescription
        self.likesLbl.text = "\(post.likes)"
        
        // error handling
        
        if post.imageUrl != nil {
            
            if img != nil { // load img from cache if it already exists there
                self.showcaseImg.image = img
            } else { // if not, grab it from the imgUrl
                
                request = Alamofire.request(.GET, post.imageUrl!).response(completionHandler: { request, response, data, err in
                    
                    if err == nil { // if data (img) is received w/o issue, load it in showcaseImg
                        
                        let img = UIImage(data: data!)!
                        self.showcaseImg.image = img
                        FeedVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
                    }
                })
            }
        }
        else { // if there is no img uploaded for the post, hide the showcaseImg
            
            self.showcaseImg.hidden = true
        }
    }
    
}
