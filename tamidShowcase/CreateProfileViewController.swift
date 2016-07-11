//
//  createprofileViewController.swift
//  createprofile2
//
//  Created by Kai Munechika on 6/6/16.
//  Copyright © 2016 Kai Munechika. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class createProfileViewController: UIViewController {
    
    let rootRef = FIRDatabase.database().reference()
    let userUID = FIRAuth.auth()?.currentUser?.uid
    
    @IBOutlet weak var nameText: TextField!
    @IBOutlet weak var emailText: TextField!
    @IBOutlet weak var phonenumberText: TextField!
    @IBOutlet weak var cityText: TextField!
    @IBOutlet weak var teamText: TextField!
    @IBOutlet weak var positionText: TextField!

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    override func viewDidLoad() {
        emailText.text = FIRAuth.auth()?.currentUser?.email
    
    }

    
    @IBAction func cancelDidTouch(sender: rounded_buttons) {
        self.navigationController?.popViewControllerAnimated(true)
       
    }
    @IBAction func saveDidTouch(sender: UIButton) {

        if nameText.text == Optional("") || emailText.text == Optional("") || phonenumberText.text == Optional("") || cityText.text == Optional("") || teamText.text == Optional("") || positionText.text == Optional(""){
            
            let alert = UIAlertController(title: "Alert", message: "One or more textfields have been left blank, complete them to save.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            let name = nameText.text!
            let email = emailText.text!
            let phone = phonenumberText.text!
            let city = cityText.text!
            let team = teamText.text!
            let position = positionText.text!
            
            rootRef.child("users").child(userUID!).setValue(["name": name, "email": email, "phone": phone, "city": city, "team": team, "position": position])
            performSegueWithIdentifier("createToProfileSeg", sender: nil)

            
        }
    
    }
}




