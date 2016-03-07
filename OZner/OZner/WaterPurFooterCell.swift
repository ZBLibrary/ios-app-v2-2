//
//  WaterPurFooterCell.swift
//  OZner
//
//  Created by 赵兵 on 16/2/18.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class WaterPurFooterCell: UITableViewCell {

    //电源 0,3 ：0关，3开
    @IBOutlet var powerLabel: UILabel!
    @IBOutlet var powerImg: UIImageView!
    @IBOutlet var powerButton: UIButton!
    //制冷 1,4
    @IBOutlet var coolLabel: UILabel!
    @IBOutlet var coolImg: UIImageView!
    @IBOutlet var coolButton: UIButton!
    //加热 2,5
    @IBOutlet var hotLabel: UILabel!
    @IBOutlet var hotImg: UIImageView!
    @IBOutlet var hotButton: UIButton!
    
    let color_normol=UIColor(red: 177.0/255.0, green: 178.0/255.0, blue: 179.0/255.0, alpha: 1)
    let color_select=UIColor(red: 63.0/255.0, green: 135.0/255.0, blue: 237.0/255.0, alpha: 1)
    var waterDevice:WaterPurifier?
    var ishaveCoolAblity=true
    var ishaveHotAblity=true
    func updateSwitchState()
    {
        if waterDevice==nil
        {
            return
        }
        powerLabel.textColor=waterDevice?.status.power==false ? color_normol:color_select
        powerImg.image=UIImage(named: waterDevice?.status.power==false ? "icon_power_normal.png":"icon_power.png")
        if ishaveCoolAblity==true&&waterDevice?.status.power==true
        {
            coolLabel.textColor=waterDevice?.status.cool==false ? color_normol:color_select
            coolImg.image=UIImage(named: waterDevice?.status.cool==false ? "icon_zhileng_normal.png":"icon_zhileng.png")
        }else{
            coolLabel.textColor=color_normol
            coolImg.image=UIImage(named:"icon_zhileng_normal.png")
        }
        
        if ishaveHotAblity==true&&waterDevice?.status.power==true
        {
            hotLabel.textColor=waterDevice?.status.hot==false ? color_normol:color_select
            hotImg.image=UIImage(named: waterDevice?.status.hot==false ? "icon_jiare_normal.png":"icon_jiare.png")
        }else
        {
            hotLabel.textColor=color_normol
            hotImg.image=UIImage(named:"icon_jiare_normal.png")
        }
        
        
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        powerButton.tag=0
        coolButton.tag=1
        hotButton.tag=2
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
