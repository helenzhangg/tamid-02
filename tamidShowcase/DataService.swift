//
//  DataService.swift
//  tamidShowcase
//
//  Created by H on 5/24/16.
//  Copyright © 2016 H. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

// make reference to root of real time database

let rootRef = FIRDatabase.database().reference()
let URL_STORAGE = FIRStorage.storage().reference()

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = rootRef
    
    private var _REF_POSTS = rootRef.child("posts")
    private var _REF_USERS = rootRef.child("users")
    private var _REF_IMAGES = URL_STORAGE.child("images")
  //  private var _USER_UID = rootRef.child("users").child(userID)
    
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_IMAGES: FIRStorageReference {
        return _REF_IMAGES
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        
        //let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        //let user = rootRef.child("users").child(uid)
        //return user
        
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = _REF_USERS.child(userID!)
        return user
    }
    
    func getCurrentUser() {
        
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
    }
    
    //func createFirebaseUser(uid: String, user: Dictionary<String, String >) {
      //  REF_USERS.child(uid).setValue(user)
  //  }
}