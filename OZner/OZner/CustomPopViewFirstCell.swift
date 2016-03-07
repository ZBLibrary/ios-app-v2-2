//
//  CustomPopViewFirstCell.swift
//  OZner
//
//  Created by sunlinlin on 15/12/7.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class CustomPopViewFirstCell: UITableViewCell {

    @IBOutlet var deviceStateImgView: UIImageView!
    @IBOutlet var connectImgView: UIImageView!
    @IBOutlet var connectStateLabel: UILabel!
    @IBOutlet var deviceNameLabel: UILabel!
    @IBOutlet var deviceFromLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func layCustomPopViewFirstCell(device:OznerDevice,isSlected:Bool)
    {
        if CupManager.isCup(device.type) == true
        {
            //智能水杯
            self.deviceStateImgView.image = UIImage(named: "device_cup_normal_state.png")
            self.connectImgView.image = UIImage(named: "device_icon_blutooth.png")
            self.connectImgView.frame = CGRectMake(self.deviceStateImgView.frame.size.width+self.deviceStateImgView.frame.origin.x+14, 21, 7.5, 12.5)
        }
        else if TapManager.isTap(device.type) == true
        {
            //水探头
            self.deviceStateImgView.image = UIImage(named: "device_tan_tou_noamrl_state.png")
            
            self.connectImgView.image = UIImage(named: "device_icon_blutooth.png")
            self.connectImgView.frame = CGRectMake(self.deviceStateImgView.frame.size.width+self.deviceStateImgView.frame.origin.x+14, 21, 7.5, 12.5)
        }
        else if WaterPurifierManager.isWaterPurifier(device.type) == true
        {
            //净水器
            self.deviceStateImgView.image = UIImage(named: "device_jin_shui_qi_normal.png")
            self.deviceStateImgView.image = UIImage(named: "device_jin_shui_qi_normal.png")
            self.connectImgView.image = UIImage(named: "device_icon_wifi.png")
            self.connectImgView.frame = CGRectMake(self.deviceStateImgView.frame.size.width+self.deviceStateImgView.frame.origin.x+14, 21, 15.5, 11)
        }
        else if AirPurifierManager.isBluetoothAirPurifier(device.type)
        {
            //台式空气净化器
            self.deviceStateImgView.image = UIImage(named: "device_jin_smallair_normal.png")
            self.connectImgView.image = UIImage(named: "device_icon_blutooth.png")
            self.connectImgView.frame = CGRectMake(self.deviceStateImgView.frame.size.width+self.deviceStateImgView.frame.origin.x+14, 21, 7.5, 12.5)
        }
        else if AirPurifierManager.isMXChipAirPurifier(device.type)
        {
            //立式空气净化器
            self.deviceStateImgView.image = UIImage(named: "device_jin_bigair_normal.png")
            self.connectImgView.image = UIImage(named: "device_icon_wifi.png")
            self.connectImgView.frame = CGRectMake(self.deviceStateImgView.frame.size.width+self.deviceStateImgView.frame.origin.x+14, 21, 15.5, 11)
        }
        switch device.connectStatus()
        {
        case Connecting:
            self.connectStateLabel.text="连接中"
            break
        case Connected:
            self.connectStateLabel.text="已连接"
            break
        default:
            self.connectStateLabel.text="已断开"
            break
        }
        self.connectStateLabel.frame = CGRectMake(self.connectImgView.frame.origin.x+self.connectImgView.frame.size.width+3, 21, self.connectStateLabel.frame.size.width, self.connectStateLabel.frame.size.height)
        self.deviceNameLabel.frame = CGRectMake(self.connectImgView.frame.origin.x, self.connectStateLabel.frame.origin.y+self.connectStateLabel.frame.size.height+4, self.deviceNameLabel.frame.size.width, self.deviceNameLabel.frame.size.height)
        self.deviceFromLabel.frame = CGRectMake(self.connectImgView.frame.origin.x, self.deviceNameLabel.frame.origin.y+self.deviceNameLabel.frame.size.height+3, self.deviceFromLabel.frame.size.width, self.deviceFromLabel.frame.size.height)
        self.deviceNameLabel.text = device.settings.name
        self.deviceFromLabel.text = device.settings.get("type", `default`:"type") as? String
    }
    
}
