//
//  SignUpVC.swift
//  ChatRoom
//
//  Created by WAI MING CHOI on 12/04/2015.
//  Copyright (c) 2015 WAI MING CHOI. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController , UINavigationControllerDelegate ,UIImagePickerControllerDelegate ,UITextFieldDelegate {
   
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var txtProfileName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnAddImg: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 3.0, options: nil, animations: {
          
        self.view.layoutIfNeeded()
            
        }, completion: nil)

        btnSignup.layer.cornerRadius = 5.0
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        
        Activity.stopAnimating()
        

    }


    override func viewWillAppear(animated: Bool)
    {

        profileImg.alpha = 0.0
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        UIView.animateWithDuration(5.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.profileImg.alpha = 1
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAddImage_click(sender: AnyObject)
    {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        profileImg.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }

   
    @IBAction func btnSignup_click(sender: AnyObject)
    {
        //self.Activity.startAnimating()
        SwiftSpinner.show("Connecting to Cloud")
        var user =  PFUser()
        user.username = txtEmail.text
        user.password = txtPassword.text
        user.email = txtEmail.text
        user["profileName"] = txtProfileName.text
        
        let imageData = UIImagePNGRepresentation(self.profileImg.image)
        let imageFile = PFFile(name: "profileIcon.png", data: imageData)
        user["photo"] = imageFile

        user.signUpInBackgroundWithBlock { (successed:Bool, signUpError:NSError?) -> Void in
            if  signUpError == nil
                        {
                            var followObj = PFObject(className: "Follow")
                            
                            followObj.saveInBackgroundWithBlock({ (bool:Bool, error:NSError?) -> Void in
                                
                                followObj["user"] = PFUser.currentUser()!.username
                                followObj["userToFollow"] = PFUser.currentUser()!.username
                                
                            })
                            println("signup successed")

                            var storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            var vc:SWRevealViewController = storyboard.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
                            self.presentViewController(vc, animated: true, completion: nil)
                        }
                        else
                        {
                            SwiftSpinner.show("Failed to connect, waiting...", animated: false)
                            println("error")
                        }
        }
        
        
    }
    @IBAction func btnBack(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
