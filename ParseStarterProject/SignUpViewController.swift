//
//  SignUpViewController.swift
//  SnapchatClone
//
//  Created by Eric Vandenberg on 9/9/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    func isValidEmail(testStr:String) -> Bool {

        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    @IBAction func signUpUser(sender: AnyObject) {
        
        if username.text == "" || password.text == "" {
            
            displayAlert("Missing Field(s)", message: "Username and Password are required")
            
        } else {
            
            var query = PFUser.query()!
            
            query.whereKey("username", equalTo: username.text!)
            
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                
                if error == nil {
                    
                    if let objects = objects {
                        
                        if objects.count > 0 {
                            
                            self.displayAlert("Username taken", message: "please choose a new one")
                            
                        } else {
                            
                            
                            if self.isValidEmail(self.email.text!) {
                                
                                var user = PFUser()
                                
                                user.email = self.email.text
                                user.username = self.username.text
                                user.password = self.password.text
                                
                                user.signUpInBackgroundWithBlock { (success, error) -> Void in
                                    
                                    if let error = error {
                                        
                                        if let errorString = error.userInfo["error"] as? String {
                                            
                                            self.displayAlert("Sign Up Failed", message: errorString)
                                            
                                        }
                                        
                                    } else {
                                        
                                        print("user signed up")
                                        
                                        self.displayAlert("Signed Up!", message: "Welcome :)")
                                        
                                    }
                                    
                                }
                                
                            } else {
                                
                                self.displayAlert("Invalid Email", message: "Please try again")
                                
                            }
                            
                        }
                        
                    }
                    
                } else {
                    
                    print(error)
                    
                }
                
            }
            
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.email.becomeFirstResponder()
        signUpButton.alpha = 0
        
        self.email.delegate = self
        self.username.delegate = self
        self.password.delegate = self
        
        
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if username.text != "" && email.text != "" {
            
            signUpButton.alpha = 1
            
        } else {
            
            signUpButton.alpha = 0
            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
