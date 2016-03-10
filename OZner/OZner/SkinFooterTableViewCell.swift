//
//  SkinFooterTableViewCell.swift
//  OZner
//
//  Created by 赵兵 on 16/3/10.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class SkinFooterTableViewCell: UITableViewCell {

    
    @IBOutlet weak var widthOfButtonBG1: NSLayoutConstraint!
    @IBOutlet weak var widthOfButtonBG2: NSLayoutConstraint!
    @IBOutlet weak var widthOfButtonBG3: NSLayoutConstraint!
    @IBOutlet weak var widthOfButtonBG4: NSLayoutConstraint!
    @IBOutlet weak var widthOfButtonBG5: NSLayoutConstraint!
    private let buttonContainWidth=(375-24)*Screen_Width/375
    override func awakeFromNib() {
        super.awakeFromNib()
        widthOfButtonBG1.constant=0
        widthOfButtonBG2.constant=buttonContainWidth/4
        widthOfButtonBG3.constant=buttonContainWidth/4
        widthOfButtonBG4.constant=buttonContainWidth/4
        widthOfButtonBG5.constant=buttonContainWidth/4
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
