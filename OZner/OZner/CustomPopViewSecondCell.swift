//
//  CustomPopViewSecondCell.swift
//  OZner
//
//  Created by Mac Mini 1 on 15/12/8.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class CustomPopViewSecondCell: UITableViewCell {

    @IBOutlet weak var chooseEquipment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chooseEquipment.text = loadLanguage("选择智能设备")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
