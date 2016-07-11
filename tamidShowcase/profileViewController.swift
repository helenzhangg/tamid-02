//
//  profileViewController.swift
//  tamidShowcase
//
//  Created by Kai Munechika on 6/11/16.
//  Copyright © 2016 H. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class profileViewController: UIViewController {
    
    let usersRef = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userPosition: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userTeam: UILabel!
    @IBOutlet weak var userBranch: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //if user has set up his/her account,
        // image = image from database if we store it there?
        let nameRef = usersRef.child("name")
        nameRef.observeEventType(.Value) { (snap:FIRDataSnapshot) in self.userFullName.text = snap.value?.description
        }
        
        let positionRef = usersRef.child("position")
        positionRef.observeEventType(.Value) { (snap:FIRDataSnapshot) in self.userPosition.text = snap.value?.description
        }
        
        let emailRef = usersRef.child("email")
        emailRef.observeEventType(.Value) { (snap:FIRDataSnapshot) in self.userEmail.text = snap.value?.description
        }
        
        let phoneRef = usersRef.child("phone")
        phoneRef.observeEventType(.Value) { (snap:FIRDataSnapshot) in self.userPhone.text = snap.value?.description
        }
        
        let teamRef = usersRef.child("team")
        teamRef.observeEventType(.Value) { (snap:FIRDataSnapshot) in self.userTeam.text = snap.value?.description
        }
        
        let branchRef = usersRef.child("city")
        branchRef.observeEventType(.Value) { (snap:FIRDataSnapshot) in self.userBranch.text = snap.value?.description
        }
        
        image.layer.borderWidth = 2.0
        image.layer.masksToBounds = false
        
        //couldnt decide on a color
        image.layer.borderColor = UIColor(red:38/255.0, green:203/255.0, blue:191/255.0, alpha: 1.0).CGColor
        
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    
    //}
    
    
}



