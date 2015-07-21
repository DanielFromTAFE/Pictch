//
//  SearchUserCell.swift
//  ChatRoom
//
//  Created by WAI MING CHOI on 27/04/2015.
//  Copyright (c) 2015 WAI MING CHOI. All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell {

    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        let theWidth = UIScreen.mainScreen().bounds.width
        
        profilePic.layer.cornerRadius = profilePic.frame.size.width/2
        profilePic.clipsToBounds = true
        btnFollow.layer.cornerRadius = 5
        btnFollow.layer.borderWidth = 0.5
        btnFollow.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func btnFollow(sender: AnyObject)
    {
        let title = btnFollow.titleForState(.Normal)
        
        if title == "Follow"
        {
            
            var followObj = PFObject(className: "Follow")
            
            followObj["user"] = PFUser.currentUser()!.username
            followObj["userToFollow"] = lblUsername.text
            
            followObj.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                if error == nil
                {
                    self.btnFollow.setTitle("Following", forState: UIControlState.Normal)
                    
                }
                else
                {
                    println("error")
                }
            })
            
            
            
        }
        else
        {
            
            var query = PFQuery(className: "Follow")
            
            query.whereKey("user", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("userToFollow", equalTo: lblUsername.text!)
            
            query.findObjectsInBackgroundWithBlock({ (objects:[AnyObject]?, error:NSError?) -> Void in
                
                for object in objects!{
                    object.delete()
                }
                
            })
            
            btnFollow.setTitle("Follow", forState: UIControlState.Normal)
            
        }

    }
}
