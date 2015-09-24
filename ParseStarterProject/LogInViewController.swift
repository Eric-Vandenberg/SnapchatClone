//
//  LogInViewController.swift
//  SnapchatClone
//
//  Created by Eric Vandenberg on 9/9/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func logInUser(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) { (user: PFUser?, error: NSError?) -> Void in
            
            if let user = user {
                
                print("user logged in")
                
                self.performSegueWithIdentifier("showTableView", sender: self)
                
            } else {
                
                if let errorMessage = error?.userInfo["error"] as? String {
                    
                    self.displayAlert("Log in failed", message: errorMessage)
                    
                }
                
            }
            
        }
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        logInButton.alpha = 0
        self.username.becomeFirstResponder()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.username.delegate = self
        self.password.delegate = self
        
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if username.text != "" {
            
            logInButton.alpha = 1
            
        } else {
            
            logInButton.alpha = 0
        }
        
    }

    
    func DismissKeyboard() {
        
        view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser()?.username != nil {
            self.performSegueWithIdentifier("showTableView", sender: self)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
