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
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String >) {
        REF_USERS.child(uid).setValue(user)
    }
}