//
//  LoginVC.swift
//  ChatRoom
//
//  Created by WAI MING CHOI on 12/04/2015.
//  Copyright (c) 2015 WAI MING CHOI. All rights reserved.
//

import UIKit

class LoginVC: ResponsiveTextFieldViewController,UITextFieldDelegate ,UINavigationControllerDelegate
    {

    @IBOutlet weak var fogotPassword: UIButton!
    @IBOutlet weak var icon: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    var audioPlayer:AVAudioPlayer!


    @IBOutlet weak var FBLoginView: FBSDKLoginButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        

        btnLogin.backgroundColor = UIColor.clearColor()
        btnLogin.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#f28d28")), forState: .Normal)
        btnLogin.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#f28d28", alpha: 0.5)), forState: .Highlighted)
        btnLogin.layer.cornerRadius = 5
        btnLogin.layer.borderColor = UIColor.whiteColor().CGColor
        btnLogin.layer.borderWidth = 1
        btnLogin.clipsToBounds = true
        
        btnSignUp.backgroundColor = UIColor.clearColor()
        btnSignUp.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#f28d28", alpha: 0.5)), forState: .Highlighted)
        
        fogotPassword.layer.cornerRadius = fogotPassword.frame.size.width/2
        fogotPassword.layer.borderColor = UIColor.whiteColor().CGColor
        fogotPassword.layer.borderWidth = 0.5
        fogotPassword.clipsToBounds = true
        fogotPassword.backgroundColor = UIColor.whiteColor()
        fogotPassword.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#f28d28", alpha: 0.5)), forState: .Highlighted)
        
        let button:FBSDKButton = FBLoginView
        button.titleLabel?.font = UIFont(name: "American Typewriter", size: 16)
        button.layer.cornerRadius = 5
        
    
        FBLoginView.readPermissions = ["public_profile", "email", "user_friends"]
    }

    override func viewWillAppear(animated: Bool)
    {

        icon.alpha = 0.0
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        
        UIView.animateWithDuration(5.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.icon.alpha = 1
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }
    
        
    @IBAction func loginFB(sender: AnyObject)
    {
        let permissions = ["public_profile", "email", "user_friends"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: { (user:PFUser?, error:NSError?) -> Void in
            if ((error) != nil)
            {
                // Process error
            }
            else if let user = user
            {
                if user.isNew
                {
                    println("User signed up and logged in through Facebook! \(user)")
                    var followObj = PFObject(className: "Follow")
                    
                    followObj["user"] = PFUser.currentUser()!.username
                    followObj["userToFollow"] = PFUser.currentUser()!.username
                    
                    followObj.save()
                    self.performSegueWithIdentifier("goToHome", sender: self)
                }
                    
                else
                {
                    
                    println("User logged in through Facebook! \(user)")
                    self.performSegueWithIdentifier("goToHome", sender: self)
                    
                }
            }
            println("Login FB error")

        })

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnLogin_click(sender: AnyObject)
    {
        btnLogin.enabled = false
   
        
   
                    PFUser.logInWithUsernameInBackground(self.txtEmail.text, password: self.txtPassword.text, block: { (user:PFUser?, error:NSError?) -> Void in
                        if user != nil
                        {
                            
                            self.performSegueWithIdentifier("goTimeline", sender: self)
                            
                        }
                        else
                        {
                            var alert = UIAlertController(title: "Username or password worng", message: "Try again", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                            println("User doesn't Exist")
                            self.btnLogin.enabled = true

                        }
                   })
    
    }
    @IBAction func btnSignup(sender: AnyObject)
    {
        
        var storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var vc:UINavigationController = storyboard.instantiateViewControllerWithIdentifier("SignUpVC_Nav") as! UINavigationController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func btnIcon(sender: AnyObject)
    {


    }
    
    @IBAction func forgotPass(sender: AnyObject)
    {
        var alert = UIAlertController(title: "Forgot your password?", message: "Enter your password", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = "Email@email.com"
        })
        alert.addAction(UIAlertAction(title: "Submit",
            style: UIAlertActionStyle.Default,
            handler: {[weak self]
                (paramAction:UIAlertAction!) in
                
                if let textFields = alert.textFields{
                    let theTextFields = textFields as! [UITextField]
                    let enteredText = theTextFields[0].text
                    if (enteredText.isEmpty)
                    {
                        alert = UIAlertController(title: "Forgot your email?", message: "Try again", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:nil))
                        self?.presentViewController(alert, animated: true, completion: nil)
                        
                    }else
                    {
                        alert = UIAlertController(title: "Email send already", message: "You can check your email now", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Thank you", style: UIAlertActionStyle.Default, handler:nil))
                        self?.presentViewController(alert, animated: true, completion: nil)
                        PFUser.requestPasswordResetForEmailInBackground(enteredText)
                        println(enteredText)
                    }
                }
            }))
        self.presentViewController(alert,
            animated: true,
            completion: nil)
    }

    
    }


