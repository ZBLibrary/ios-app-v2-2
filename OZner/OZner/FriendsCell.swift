//
//  FriendsCell.swift
//  My
//
//  Created by test on 15/11/25.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {

    @IBOutlet var LiuyanLabel: UILabel!
    @IBOutlet var headImg: UIImageView!
    @IBOutlet var Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        LiuyanLabel.text=loadLanguage("条留言")
        
        headImg.layer.cornerRadius=17
        headImg.layer.masksToBounds=true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
