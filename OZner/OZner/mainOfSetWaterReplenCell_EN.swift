//
//  mainOfSetWaterReplenCell_EN.swift
//  OZner
//
//  Created by 赵兵 on 16/3/7.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class mainOfSetWaterReplenCell_EN: UITableViewCell {

    @IBOutlet var NameAndAdress: UILabel!
    @IBOutlet var Sex: UILabel!
    @IBOutlet var toSetNameAndDressButton: UIButton!
    @IBOutlet var toSetSexButton: UIButton!
    @IBOutlet var toSetTimeRemind: UIButton!
    @IBOutlet weak var toBugEssence: UIButton!
    @IBOutlet var toInstructions: UIButton!
    @IBOutlet var toOperation: UIButton!
    @IBOutlet var clearButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        clearButton.layer.borderColor=UIColor.redColor().CGColor
        clearButton.layer.borderWidth=1
        clearButton.layer.cornerRadius=20
        clearButton.layer.masksToBounds=true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
