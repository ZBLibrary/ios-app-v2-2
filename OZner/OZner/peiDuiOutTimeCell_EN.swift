//
//  peiDuiOutTimeCell.swift
//  OZner
//
//  Created by 赵兵 on 16/1/25.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class peiDuiOutTimeCell_EN: UITableViewCell {

    var isBlueToothDevice:Bool=false
        {
        didSet{
            stateLabel.text=isBlueToothDevice==true ? loadLanguage("您可以检查蓝牙连接状态后再进行配对"):loadLanguage("您可以检查WIFI连接状态后再进行配对")
        }
    }
    @IBOutlet var Back: UIButton!
    @IBOutlet var ReSetPeiDuiButton: UIButton!
    @IBOutlet var stateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
