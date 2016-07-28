//
//  PostCell.swift
//  tamidShowcase
//
//  Created by H on 5/31/16.
//  Copyright © 2016 H. All rights reserved.
//

import UIKit
import Alamofire //error (ignore), build succeeds
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var post: Post!
    var request: Request?
    var likeRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.userInteractionEnabled = true
        
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
        likeRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
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
        
       // let likeRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let doesNotExist = snapshot.value as? NSNull {
                
                //NSNull = Firebase indication of no data in .Value (i.e. no likes)
                // This means we have not liked this specific post
                
                self.likeImage.image = UIImage(named: "heart-empty")
            } else {
                
                self.likeImage.image = UIImage(named: "heart-full")
            }
        })
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let doesNotExist = snapshot.value as? NSNull {
                
                self.likeImage.image = UIImage(named: "heart-full")
                self.post.adjustLikes(true)
                self.likeRef.setValue(true) // add to Firebase likes
                
            } else {
                
                self.likeImage.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(false)
                self.likeRef.removeValue() // remove entry from Firebase likes
            }
        })
    }
    
}
