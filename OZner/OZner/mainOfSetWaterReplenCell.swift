//
//  mainOfSetWaterReplenCell.swift
//  OZner
//
//  Created by 赵兵 on 16/3/7.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class mainOfSetWaterReplenCell: UITableViewCell {

    @IBOutlet weak var tixing: UILabel!
    @IBOutlet weak var sexLb: UILabel!
    @IBOutlet weak var water: UILabel!
    @IBOutlet var NameAndAdress: UILabel!
    @IBOutlet var Sex: UILabel!
    @IBOutlet var toSetNameAndDressButton: UIButton!
    @IBOutlet var toSetSexButton: UIButton!
    @IBOutlet var toSetTimeRemind: UIButton!
    @IBOutlet weak var toBugEssence: UIButton!
    @IBOutlet var toInstructions: UIButton!
    @IBOutlet var toOperation: UIButton!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet weak var timelb: UILabel!
    @IBOutlet weak var sugesst: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        water.text = loadLanguage("智能补水仪")
        sexLb.text = loadLanguage("性别")
        tixing.text = loadLanguage("补水提醒")
        timelb.text = loadLanguage("补水提醒时间")
        sugesst.text = loadLanguage("建议每天补水2-3次")
        
        clearButton.setTitle(loadLanguage("删除此设备"), forState: UIControlState.Normal)
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
