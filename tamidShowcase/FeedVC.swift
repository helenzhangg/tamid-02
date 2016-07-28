//
//  FeedVC.swift
//  tamidShowcase
//
//  Created by H on 5/31/16.
//  Copyright © 2016 H. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    var posts = [Post]()
    var imageSelected = false
    var imagePicker: UIImagePickerController!
    
    static var imageCache = NSCache() // creates only one instance of the post as static var
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 355
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // anytime data is changed or added app will sync automatically
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: {snapshot in
            print(snapshot.value)
            
            self.posts = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData() //reload anytime there is new data
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row] // for each post let there be another cell
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            cell.request?.cancel() // if user scrolls past cell, cancel image request for the
            // previous image and request img for the new cell
            
            var img: UIImage?
            
            if let url = post.imageUrl { // if img already exists in cache, get its key (url)
                
                img = FeedVC.imageCache.objectForKey(url) as? UIImage
                // not "self.imageCache" since it is a public static variable
            }
            
            cell.configureCell(post, img: img)
            return cell // grab post and return it in cell
            
        } else {
            return PostCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = posts[indexPath.row]
        
        if post.imageUrl == nil { // if there is no image with the post, make cell shorter
            
            return 170
            
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelectorImage.image = image
        imageSelected = true
    }
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postPressed(sender: AnyObject) {
        
        if let text = postField.text where text != "" {
            
            let cameraImage = UIImage(named:"camera")
            
            if let img = imageSelectorImage.image where imageSelected == true{
            
            //img != cameraImage
                
                // convert image to data and compress
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                
                // use current time to give unique image ID
                let imgPath = "\(NSDate.timeIntervalSinceReferenceDate())"
                
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpg"
                
                DataService.ds.REF_IMAGES.child(imgPath).putData(imgData, metadata: metadata, completion: {metadata, error in
                    
                    if error != nil {
                        print("Error uploading image")
                    }
                    
                    else {
                        if let meta = metadata {
                            if let imgLink = meta.downloadURL()?.absoluteString {
                                print("Image uploaded successfully! Link: \(imgLink)")
                                
                               // let values = ["text":text, "imageURL":imgLink]
                                //self.register
                                
                                self.postToFirebase(imgLink)
                            }
                        }
                    }
                    
                })
                
            }
            
        }
    }

    func postToFirebase(imgUrl: String?) {
        
        var post: Dictionary<String, AnyObject> = [
        
            "description": postField.text!,
            "likes": 0
        ]
        
        if imgUrl != nil {
            post["imageUrl"] = imgUrl!
            
        }
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        postField.text = ""
        imageSelectorImage.image = UIImage(named: "camera")
        imageSelected = false
        
        tableView.reloadData()
        
    }

}
