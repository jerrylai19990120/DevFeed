//
//  FeedCell.swift
//  DevFeed
//
//  Created by Jerry Lai on 2021-02-03.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    func configureCell(profileImg: UIImage, email: String, content: String){
        self.profileImg.image = profileImg
        self.emailLbl.text = email
        self.content.text = content
    }
}
