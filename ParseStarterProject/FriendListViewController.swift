//
//  FriendListViewController.swift
//  SnapchatClone
//
//  Created by Eric Vandenberg on 9/23/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class FriendListViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var usernames = [String]()
    var recipientUsername = ""
    
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    func checkForMessage() {
        
        if PFUser.currentUser() != nil {
        
            var query = PFQuery(className: "Images")
            query.whereKey("recipientUsername", equalTo: PFUser.currentUser()!.username!)
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                
                if error != nil {
                    
                    print(error)
                    
                }
                
                if let pfobjects = objects {
                    
                    if pfobjects.count > 0 {
                    
                        var imageView: PFImageView = PFImageView()
                        imageView.file = pfobjects[0]["photoFile"] as? PFFile
                        imageView.loadInBackground({ (photo, error) -> Void in
                            
                            if error == nil {
                                
                                var sentUsername = "Unknown Username"
                                
                                if let username = pfobjects[0]["senderUsername"] as? String {
                                    
                                    sentUsername = username
                                    
                                    self.displayAlert("Incoming!", message: "Message from " + sentUsername)
                                    
                                }
                                
                            }
                            
                        })
                    
                    }
                    
                }
                
            }
            
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("checkForMessage"), userInfo: nil, repeats: true)
        
        
        
        

        var query = PFUser.query()!
        query.whereKey("username", notEqualTo: (PFUser.currentUser()!.username)!)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if error != nil {
                
                print(error)
                
            }
            
            if let users = objects {
                
                for user in users as! [PFUser] {
            
                    self.usernames.append(user.username!)
                    
                }
                
            }
            
            self.tableView.reloadData()
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = usernames[indexPath.row]
        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        recipientUsername = usernames[indexPath.row]
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        var imageToSend = PFObject(className: "Images")
        
        imageToSend["photoFile"] = PFFile(name: "photo.jpg", data: UIImageJPEGRepresentation(image, 0.5)!)
        imageToSend["senderUsername"] = PFUser.currentUser()?.username
        imageToSend["recipientUsername"] = recipientUsername
        imageToSend.saveInBackground()
        
        displayAlert("Success", message: "Image sent!")
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "logoutUser" {
        
            PFUser.logOut()
            
        }
        
    }

}
