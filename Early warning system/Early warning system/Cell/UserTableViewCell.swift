//
//  UserTableViewCell.swift
//  Early warning system
//
//  Created by Dustin Tong on 4/11/19.
//  Copyright © 2019 Dustin Tong. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    override func awakeFromNib() {
        
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        
        super.setSelected(selected, animated: animated)
    
        
    }

}
