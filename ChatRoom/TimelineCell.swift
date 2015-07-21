//
//  TimelineCell.swift
//  ChatRoom
//
//  Created by WAI MING CHOI on 28/04/2015.
//  Copyright (c) 2015 WAI MING CHOI. All rights reserved.
//

import UIKit

class TimelineCell: UITableViewCell {
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profileName: UIButton!
    @IBOutlet weak var Img: UIImageView!
    
    @IBOutlet weak var lblTimeTamp: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
       
        profilePic.layer.cornerRadius = profilePic.frame.size.width/2
        profilePic.clipsToBounds = true
        Img.clipsToBounds = true
        btnStop.hidden = true
        profileName.backgroundColor = UIColor.clearColor()
     
        profileName.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#DDDDE3", alpha: 0.5)), forState: .Highlighted)
        profileName.titleLabel?.adjustsFontSizeToFitWidth = true

    }
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
    }
    
}
