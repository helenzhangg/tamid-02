//
//  ViewController.swift
//  tamidShowcase
//
//  Created by H on 5/24/16.
//  Copyright © 2016 H. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

 
    //@IBOutlet weak var Email: MaterialTextField!
    @IBOutlet weak var emailField: UITextField!
    
    //@IBOutlet weak var Password: MaterialTextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    @IBAction func CreateAccount(sender: AnyObject) {
        
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            
            // if the fields are filled in, try to login or create new account
                print("User Created!")
                login()
                    
        } else {
            
        // if the email field or password field are empty
            
    self.showErrorAlert("Email and Password Required", msg: "You must enter an email and password")
    
        }
    }

    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func login() {
        
            FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text!, completion: {
            
                user, error in
            
                if error != nil {
                    
                    print(error)
                    print(error!.code)
                    
                    if error!.code == STATUS_WRONG_PASSWORD {
                        
                        self.showErrorAlert("Could not login", msg: "Please check your username or password")
                        
                    }
                    
                    if error!.code == STATUS_ACCOUNT_NONEXIST {
                        
                        self.createNewUser()
                    }
                
                    print("Incorrect")
                
                }
            else {
                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                NSUserDefaults.standardUserDefaults().setValue(KEY_UID, forKey: KEY_UID)
                print("Huzzah!")
            }
            
        })
    }
    
    func createNewUser() {
        FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!, completion: {
            
            user, error in
            
            // if email was invalid, try again
            if error != nil {
                
                self.showErrorAlert("Could not create account", msg: "Problem creating account, try again")
                
            } else {
                
                // if new user was created, sign in
                self.login()
                NSUserDefaults.standardUserDefaults().setValue(KEY_UID, forKey: KEY_UID)
            }
            
        })
    }

}
