
//
//  ProfileCell.swift
//  ChatRoom
//
//  Created by WAI MING CHOI on 27/05/2015.
//  Copyright (c) 2015 WAI MING CHOI. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var count: UILabel!

    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()

        userImg.layer.cornerRadius = userImg.frame.size.width/2
        userImg.clipsToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }

}
