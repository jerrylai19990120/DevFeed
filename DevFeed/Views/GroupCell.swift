//
//  GroupCell.swift
//  DevFeed
//
//  Created by Jerry Lai on 2021-02-03.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    
    @IBOutlet weak var groupTitle: UILabel!
    
    @IBOutlet weak var groupDesc: UILabel!
    
    @IBOutlet weak var membersLbl: UILabel!
    
    func configureCell(title: String, description: String, members: Int){
        self.groupTitle.text = title
        self.groupDesc.text = description
        self.membersLbl.text = "\(members) members."
        
    }
}

