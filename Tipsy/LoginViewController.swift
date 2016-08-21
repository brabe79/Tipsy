//
//  LoginViewController.swift
//  Tipsy
//
//  Created by Brian Rabe on 8/16/16.
//  Copyright © 2016 Tipsy. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase



class LoginViewController: UIViewController, FBSDKLoginButtonDelegate  {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func LoginBtnPressed(sender: UIButton) {
        let email = txtEmail.text as String!
        let pwd = txtPwd.text as String!
        
        if self.txtEmail.text == "" || self.txtPwd.text == ""
            {
                let alertController = UIAlertController(title: "Oops!", message: "Please enter an email and password!", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            
            //Create account
        }
        
        //Need to check if user has account other wise create account
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
            } else {
                // No user is signed in.
                FIRAuth.auth()?.signInWithEmail(email, password: pwd) { (user, error) in
                    // ...
                }
            }
        }
       
        FIRAuth.auth()?.createUserWithEmail(email, password: pwd) { (user, error) in
            // ...
        }    }
    private let dataURL = "https://tipsy-5bda3.firebaseio.com/"
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view, typically from a nib.
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller
            self.performSegueWithIdentifier("ShowTab", sender: self)
            returnUserData()
                    }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
    }
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                
                returnUserData()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        FBSDKAccessToken.setCurrentAccessToken(nil)
        FBSDKProfile.setCurrentProfile(nil)
        print("User Logged Out")
            }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userID = result.valueForKey("id") as! NSString
                let facebookProfileUrl = NSURL(string: "https://graph.facebook.com/\(userID)/picture?type=large")
                
                if let data = NSData(contentsOfURL: facebookProfileUrl!) {
                    
                    let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                    FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                        // ...
                        self.performSegueWithIdentifier("ShowTab", sender: self)
                    }
                }
                
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
