//
//  Post.swift
//  tamidShowcase
//
//  Created by H on 6/14/16.
//  Copyright © 2016 H. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _username: String!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    
    
    // var without a '?' at the end assumes there is an existing value
    
    var postDescription: String {
        return _postDescription
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var username: String {
        return _username
    }
    
    var postKey: String {
        return _postKey
    }
    
    // dictionary for new posts
    
    init(description: String, imageUrl: String?, likes: String, username: String) {
        self._postDescription = description
        self._imageUrl = imageUrl
        self._username = username
    }
    
    // dictionary for downloading data from Firebase
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let imgUrl = dictionary["imageUrl"] as? String {
            self._imageUrl = imgUrl
        }
        
        if let desc = dictionary["description"] as? String {
            self._postDescription = desc
        }
        
        self._postRef = DataService.ds.REF_POSTS.child(self._postKey)
    }
    
    func adjustLikes(addLike: Bool) {
        
        if addLike {
            
            _likes = _likes + 1
            
        } else {
            
            _likes = _likes - 1
        }
        
        // grabbing current likes value and replacing it with new likes value 
        
        _postRef.child("likes").setValue(_likes)
    }
    
}
