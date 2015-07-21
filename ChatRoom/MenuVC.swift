//
//  MenuVC.swift
//  ChatRoom
//
//  Created by WAI MING CHOI on 24/05/2015.
//  Copyright (c) 2015 WAI MING CHOI. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {
    

    @IBOutlet weak var ProfileIcon: UIImageView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ProfileIcon.layer.cornerRadius = 5.0
        ProfileIcon.layer.cornerRadius = ProfileIcon.frame.size.width/2
        ProfileIcon.clipsToBounds = true
        
        var query = PFUser.query()
        query!.whereKey("username", equalTo: PFUser.currentUser()!.username!)

        query!.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error:NSError?) -> Void in
            if error == nil
            {
                let imageObjects = objects as! [PFObject]
                
                for object in imageObjects{
                    
                    let data = object["photo"] as? PFFile
                    
                    data?.getDataInBackgroundWithBlock({ (photoData:NSData?, error:NSError?) -> Void in
                        let image = UIImage(data: photoData!)
                        
                        self.ProfileIcon.image = image
                        
                    })
                }
                
            }
        }

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func Search(sender: AnyObject)
    {
        
    }
    @IBAction func Logout(sender: AnyObject)
    {
        
        var alert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                println("default")
                PFUser.logOutInBackgroundWithBlock { (error:NSError?) -> Void in
                    
                    var currentUser = PFUser.currentUser() // this will now be nil
                    
                }
                println("Logout successfully")
                
                var storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                var vc:LoginVC = storyboard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
                self.presentViewController(vc, animated: true, completion: nil)
                

            case .Cancel:
                println("cancel")
                
            case .Destructive:
                println("destructive")
            }
        }))
    }
    @IBAction func ViewProfile(sender: AnyObject)
    {
        
        var storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var vc:UINavigationController = storyboard.instantiateViewControllerWithIdentifier("ProfileVC_Nav") as! UINavigationController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
}
