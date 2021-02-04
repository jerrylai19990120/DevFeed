//
//  UserCell.swift
//  DevFeed
//
//  Created by Jerry Lai on 2021-02-03.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var checkMark: UIImageView!
    
    @IBOutlet weak var emailLbl: UILabel!
    
    var showing = false
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            checkMark.isHidden = false
        } else {
            checkMark.isHidden = true
        }
        // Configure the view for the selected state
    }
    
    func configureCell(email: String, profileImg: UIImage, isSelected: Bool){
        self.emailLbl.text = email
        self.profileImg.image = profileImg
        if isSelected {
            self.checkMark.isHidden = false
            showing = true
        } else {
            self.checkMark.isHidden = true
            showing = false
        }
    }
    
    

}
